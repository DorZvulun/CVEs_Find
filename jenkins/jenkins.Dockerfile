FROM jenkins/jenkins:lts
USER root
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null
RUN apt update && apt install -y gh libarchive-tools wget jq
#RUN usermod -aG docker jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV GITHUB_TOKEN ${GITHUB_TOKEN}

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

USER jenkins