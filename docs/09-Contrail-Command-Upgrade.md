# How to upgrade Contrail Command from one build to another build?

Starting Contrail 5.0.2 you can upgrading Contrail Command from one build to another build without deleting the SQL database.

Note: Please use 5.0.2 updated "command_servers.yml" moving forward for Contrail Command Installation and upgrade.

***Note*** Reference [New Contrail Command Servers File](https://raw.githubusercontent.com/qarham/cfm-vagrant/master/docs/scripts/5.0.2/command_servers.yml)


```bash
wget https://raw.githubusercontent.com/qarham/cfm-vagrant/master/docs/scripts/5.0.2/command_servers.yml
 ```

## Contrail Command upgrade (With SQL delete)

If you would like upgrading Contrail Command from one build to another build without saving SQL database and would like to provision cluster from scratch please following following steps:

```bash
# Update build number in command_servers.yml and run below commands

# Stop exiting containers and remove all running containers
docker stop contrail_command contrail_mysql
docker rm contrail_command contrail_mysql contrail_command_deployer

# Download Contrail Command Deployer image
docker pull 10.84.5.81:5010/contrail-command-deployer:5.0-319

# Create Contrail Command Deployer container and start loging 
docker run -t --net host -v /opt/command_servers.yml:/command_servers.yml -d --privileged --name contrail_command_deployer 10.84.5.81:5010/contrail-command-deployer:5.0-319

docker logs -f contrail_command_deployer
 ```

## Contrail Command upgrade (Without SQL delete)

If you would like to preserve existing SQL database and would like to upgrade from one build B30X to B30Y please follow these steps:

In this example we are upgrading Contrail Command to B319 without reseting the SQL database.

```bash
# Update build number in command_servers.yml and run below commands

docker rm contrail_command_deployer

docker run -t --net host -v /opt/command_servers.yml:/command_servers.yml -d --privileged --name contrail_command_deployer 10.84.5.81:5010/contrail-command-deployer:5.0-319 ansible-playbook -e delete_sql=no -e config_file=/command_servers.yml -i /contrail-command-deployer/inventory /contrail-command-deployer/playbooks/deploy.yml
 ```