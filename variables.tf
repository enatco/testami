# Creds and default location
variable "credentials" { default = "account.json" } // Change with you service account .json file
variable "project"     { default = "your_project_id" } // Your GCP Project ID
variable "region"      { default = "us-east1-b" }
variable "zone"        { default = "us-east1-b" }
#

variable "network" { default = "default" }

variable "dockername" { default = '$DOCKER_HUB_USER' }
variable "domainname" { default = '$DOMAIN_NAME' )


variable "sourceimageweb" { default =  "$DOCKER_HUB_USER/nginx:test1" } 
variable "sourceimageapp" { default =  "$DOCKER_HUB_USER/app:0.1" } 
