#!/bin/bash

#Author : Saurabh Tiwari
#these variables can also be managed in terraform variables.tf 
export COUNTRY=IN
export COMPANY_NAME=worksLimited
export DOMAIN_NAME=test.com
export DOCKER_HUB_USER="xyz"
export DOCKER_HUB_EMAIL="xyz@abc.com"
export Compute_zone="us-east1"
export Compute_region="us-east1-b"


#Initial Installtions
sudo yum install ant npm  unzip

sudo wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
sudo unzip terraform_0.11.7_linux_amd64.zip
sudo mkdir -p /opt/packages/
sudo mv terraform /opt/packages
ln -s /opt/packages/terraform  /usr/bin/terraform
export PATH=$PATH:/usr/bin

sudo npm install -g gulp

sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

sudo yum install google-cloud-sdk kubectl

#Creation of Self Signed certificate
sudo openssl req -subj ‘/CN=$DOMAIN_NAME/O=$COMPANY_NAME/C=$COUNTRY’ -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt

sudo cp -r server.* webapp/
#Docker login 
sudo docker login --username=$DOCKER_HUB_USER --email=$DOCKER_HUB_EMAIL

#This part will be handled in Jenkins UI  generating artifacts and uploading to jenkins .
mkdir -p ~/projects/java/
cd ~/projects/java/
git clone https://github.com/ferdynice/helloworld-war.git
cd helloworld-war/
ant


#Gcloud intialization Can be skipped if gcloud init has been run as interactive
gcloud auth activate-service-account --key-file account.json
gcloud config set compute/zone us-east1
gcloud config set compute/region us-east1-b


##Dockerbuild for pulling when deploying :
 # 1. Nginx container : with .zip static files after gulp execution 
 # 2. App Container   : App generating .war file helloworld app.  Let it run on port 8030


cd app/   && docker build -t appimage .   && docker tag appimage $DOCKER_HUB_USER/app:0.1  && docker push $DOCKER_HUB_USER/app:0.1
cd webapp/  && docker build -t webimage .   && docker tag webimage $DOCKER_HUB_USER/nginx:test1  && docker push $DOCKER_HUB_USER/nginx:test1


### Infra Provisioning Terraform Execution

terraform init && terraform plan && terraform apply
