# SonarQube on OpenShift
This repository contains all of the resources required to deploy a SonarQube server instance into a BCGov OpenShift pathfinder environment, and integrate SonarQube scanning into your Jenkins pipeline.

This work was inspired by the OpenShift Demos SonarQube for OpenShift:
https://github.com/OpenShiftDemos/sonarqube-openshift-docker

There are two parts to SonarQube, the server, and the scanner.  You deploy the server once and it analyses and hosts the scanning results posted by the scanner.  You integrate the scanner into your builds/pipelines to perform code analysis and then post the results to the server.  The server then provides summaries and live drill down reports of the results.

These instructions assume:
* You have Git and the OpenShift CLI installed on your system, and they are functioning correctly.  The recommended approach is to use either [Homebrew](https://brew.sh/) (MAC) or [Chocolatey](https://chocolatey.org/) (Windows) to install the required packages.
* You have forked and cloned a local working copy of the project source code.
* You are using a reasonable shell.  A "reasonable shell" is obvious on Linux and Mac, and is assumed to be the git-bash shell on Windows.

# SonarQube Server

## Docker Build
The SonarQube server image (`openshift/sonarqube:6.7.1`) is already available in the OpenShift Pathfinder image repository, so **you do not have to repeat this step** unless you are building a customized or updated version of the SonarQube Server.

Logon to your `tools` project and run the following command:

    oc new-build https://github.com/BCDevOps/sonarqube --name=sonarqube --to=sonarqube:6.7.1

## Deploy on OpenShift
The [sonarqube-postgresql-template](./sonarqube-postgresql-template.yaml) has been provided to allow you to quickly and easily deploy a fully functional instance of the SonarQube server, complete with persistent storage, into your `tools` project.  The template will create all of the necessary resources for you.

Logon to your `tools` project and run the following command:

    oc new-app -f sonarqube-postgresql-template.yaml --param=SONARQUBE_VERSION=6.7.1
 
## Change the Default Admin Password
When the SonarQube server is first deployed it is using a default `admin` password.  For security, it is **highly** recommended you change it.  The [UpdateSqAdminPw](./provisioning/updatesqadminpw.sh) script has been provided to make this easy.  The script will generate a random password, store it in an OpenShift secret named `sonarqube-admin-password`, and update the admin password of the SonarQube server instance.

Logon to your `tools` project and run the following command from the [provisioning](./provisioning) directory:

    updatesqadminpw.sh 

To login to your SonarQube server as admin, browse to the **sonarqube-admin-password** secret in your OpenShift `tools` project, reveal the password and use it to login.

## Congratulations - You now have a running SonarQube server instance
You can now browse your SonarQube server site.  To find the link, browse to the overview of your `tools` project using the OpenShift console and click on the url for the **SonarQube Application**.

## Optional GitHub Authentication

The GitHub authentication plug-in requirements are:

* SonarQube must be publicly accessible through HTTPS only
* The property 'sonar.core.serverBaseURL' must be set to this public HTTPS URL
* In the GitHub profile for the org, you need to create a Developer Application for which the 'Authorization callback URL' must be set to '/oauth2/callback'.

*The settings can be found under Administration -> Configuration -> General Settings -> GitHub)*

