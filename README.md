# SonarQube on OpenShift
This repo contains all of the resources required to deploy SonarQube at bcgov OpenShift pathfinder.

It is inspired by the OpenShift Demos SonarQube for OpenShift:
https://github.com/OpenShiftDemos/sonarqube-openshift-docker

# Docker Hub

The SonarQube image is available on the OpenShift Pathfinder Hub.
The DockerFile in this directory has been used to build that image. **You do not have to repeat this!**
If you are the one that needs to install the image, execute the following on an oc-enabled machine after you have logged in to your project:

    oc new-build https://github.com/BCDevOps/sonarqube --name=sonarqube --to=sonarqube:6.7.1

# Deploy on OpenShift
Use the provided template with postgresql database to deploy SonarQube on 
OpenShift. This template will create all the necessary components (storage, postgresql, pods, services, route and secrets etc.) and will start SonarQube.

SonarQube with PostgreSQL Database:

    oc new-app -f sonarqube-postgresql-template.yaml --param=SONARQUBE_VERSION=6.7.1
 
## Attention: ##

After you have established that SonarQube is up and running to have to run the update script in the provisioning directory. This script will use the randomly generated SonarQube Admin password from the secret and update the SonarQube admin password.

To run this script, you need to have the [oc client tools installed](https://www.openshift.org/download.html) and you should be able to run bash scripts.
