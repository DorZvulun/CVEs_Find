FROM jenkins/jenkins:lts
USER root
RUN apt update && apt install -y docker.io docker-compose
RUN usermod -aG docker jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

USER jenkins