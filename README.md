#Note: #Tested to Run on a Centos7 Machine.   Bare metal or VM
       #Installation of components is taken care by intialization script.
       # account.json file required for GCP account.

#Tools Used :   

#			   Terraform
#               docker
#               Kubernetes
#               Cloud Provider : GCP 
#               ant #for Genration of WAR
#               gulp #for minification of xml and css and gulp.js included
               

Step 1 : Extract the zipped folder.
Step 2:  cd "extracted folder"  Run initialize.sh  to initiazlie env vars required for other tools  and Deploy through terraform
#Generation of .war is manual assuming will be handled in Jenkins UI . 
       #1.) Cloning git repo ;
       #2.) generating artifacts and 
       #3.) uploading to nexus/Jfrog Artifactory
#Downloading from that artifactory and adding to Dockerfile for the Build of containers.
#.war and .zip have already been placed Have been downloaded by Dockerfile 
### In Prod :  jenkins can directly deploy .war and zip static to Tomcat Apache Server
Step 3: TO check status of cluster Run :
        gcloud container clusters get-credentials  "testcluster"
Step 4: kubectl get services  
