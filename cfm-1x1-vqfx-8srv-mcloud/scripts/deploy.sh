#!/bin/sh
#
# Copyright (c) 2016 Juniper Networks, Inc.
#
# author - Sanju Abraham
#        - Damian Rakowski
#
# This is a simple one click deploy option for deploying
# contrail in a multicloud environment. contrail-multicloud-gw
# provides secure connectivity to contrail cluster deployed
# across regions in the provider network, across provider
# networks and securely connecting it to onprem contrail
# clusters
#
# Please make sure to have the topology ans secrect yaml files
# populated as per the guidelines in the wiki for contrail-multi-cloud
#
#*** This script MUST be run from one-click-deployer directory ***#

_MULTICLOUD_BASE=$(dirname "$PWD")
_TFSTATE="terraform.tfstate"
_INVFILE="inventories/inventory.yml"
_LOG="/var/log/ansible.log"
_ONE_CLICK_DEP="one-click-deployer"

curdir=$(basename "$PWD")
if [ "$curdir" != "$_ONE_CLICK_DEP" ]; then
   echo "########### INFO: Please run deploy.sh from one-click-deployer directory. ###########"
   echo "########### Usage: cd one-click-deployer; ./deploy.sh ###########"
   exit 1
fi

# change to directory of contrail-multi-cloud
cd $_MULTICLOUD_BASE

status=`./transform/generate_topology.py -t topology.yml -s secret.yml`
if printf -- '%s' "$status" | egrep -q -- "Successfully"; then
   echo "$status"
   tinitstatus=`terraform init`
   echo "++++++++++++++++++++++"
   echo "Initialized terraform"
   echo "++++++++++++++++++++++"
   if printf -- '%s' "$tinitstatus" | egrep -q -- "initialized"  && [ ! -f "$_TFSTATE" ]; then
      terraform apply -auto-approve
      echo "++++++++++++++++++++++"
      echo "Applied topology "
      echo "++++++++++++++++++++++"

   fi
else
   echo "ERROR: Please check the topology and re-run after resolving issues"
fi

function checkplay() {
   if grep -Fq "failed=1" $_LOG || grep -Fq "unreachable=1" $_LOG; then
      echo "################################################################################"
      echo "ERROR: Please check the failed play and re-run play after resolving the failures"
      echo "Report issue if not resolvable"
      echo "################################################################################"
      exit 1
  fi
}

if [ -f "$_TFSTATE" ]; then
   ./transform/generate_inventories.py -t topology.yml -s secret.yml
   if [ -f "$_INVFILE" ]; then
      # make way for the new run
      if [ -f "$_LOG" ]; then
         mv "$_LOG" "$_LOG.back"
      fi
      echo "++++++++++++++++++++++++++++++++"
      echo "Deploying contrail-multicloud-GW"
      echo "++++++++++++++++++++++++++++++++"
      ansible-playbook -i inventories/inventory.yml ansible/gateway/playbooks/deploy_and_run_all.yml
      checkplay
      echo "++++++++++++++++++++++++++++"
      echo "Configure Contrail instances"
      echo "++++++++++++++++++++++++++++"
      ansible-playbook -e orchestrator=openstack -i inventories/inventory.yml ansible/contrail/playbooks/configure.yml
      checkplay
      echo "+++++++++++++++++++++++++++++++"
      echo "Setup Orchestrator for Contrail"
      echo "+++++++++++++++++++++++++++++++"
      ansible-playbook -e orchestrator=openstack -i inventories/inventory.yml ansible/contrail/playbooks/orchestrator.yml
      checkplay
      echo "++++++++++++++++++"
      echo "Deploying Contrail"
      echo "++++++++++++++++++"
      ansible-playbook -e orchestrator=openstack -i inventories/inventory.yml ansible/contrail/playbooks/deploy.yml
      checkplay
      echo "++++++++++++++++++++++++++"
      echo "Setting up Contrail routes"
      echo "++++++++++++++++++++++++++"
      ansible-playbook -i inventories/inventory.yml ansible/contrail/playbooks/vrouter_interface_route.yml
      checkplay
   else
     echo "ERROR: Please check the generated inventory file."
   fi
else
   echo "ERROR: Terraform topology not created. Please check $_TFSTATE file"
fi
