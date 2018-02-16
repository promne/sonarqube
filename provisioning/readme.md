# Important: Run this script after your new SonarQube is up and running #

Login with oc, connect to your project and then:
Run the

    updatesqadminpw.sh 

script on Linux or Mac with OC Client Tools installed.

This will change the default password for admin (which is admin) to the one generated and place in the **sonarqube-admin-password** secret.

To login as admin in your SonarQube install go to the **sonarqube-admin-password** secret in your OpenShift project, reveal the password and use that to login.
