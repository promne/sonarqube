# Upgrading Plugins Manually

If it becomes necessary to manually install a plugin tha is not bundled with the SonarQube image, or an updated version of an existing pluging is required,
after downloading the plugin's JAR file execute the following command to copy it to the pod's plugin directory:

```oc cp ./my-sonar-plugin.jar my-openshift-namespace/sonarqube-pod-name:/opt/sonarqube/extensions/plugins```

A restart of the pod will be required after copying a new/updated plugin.

# References
- [SonarQube: Installing Plugin](https://docs.sonarqube.org/latest/setup/install-plugin/)
