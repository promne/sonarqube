FROM jboss/base-jdk:8

MAINTAINER Erik Jacobs <erikmjacobs@gmail.com>
MAINTAINER Siamak Sadeghianfar <siamaksade@gmail.com>
MAINTAINER Roland Stens (roland.stens@gmail.com)
MAINTAINER Wade Barnes (wade.barnes@shaw.ca)

# Define Plug-in Versions
ARG SONAR_ZAP_PLUGIN_VERSION=1.1.2

ENV SONAR_VERSION=6.7.5 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

ENV SONARQUBE_PLUGIN_DIR=$SONARQUBE_HOME/extensions/plugins/ 

ENV SUMMARY="SonarQube for bcgov OpenShift" \
    DESCRIPTION="This image creates the SonarQube image for use at bcgov/OpenShift"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="sonarqube" \
      io.openshift.expose-services="9000:http" \
      io.openshift.tags="sonarqube" \
      release="$SONAR_VERSION"

USER root
EXPOSE 9000
ADD root /

RUN set -x \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Add Plug-in(s)
ADD https://github.com/Coveros/zap-sonar-plugin/releases/download/sonar-zap-plugin-$SONAR_ZAP_PLUGIN_VERSION/sonar-zap-plugin-$SONAR_ZAP_PLUGIN_VERSION.jar $SONARQUBE_PLUGIN_DIR

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/

RUN useradd -r sonar
RUN /usr/bin/fix-permissions $SONARQUBE_HOME \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonar
ENTRYPOINT ["./bin/run.sh"]
