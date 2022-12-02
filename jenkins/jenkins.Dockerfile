FROM jenkins/jenkins:lts
USER root
RUN apt update && apt install docker.io -y && docker-compose -y
RUN usermod -aG docker jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins