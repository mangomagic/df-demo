# Use official Jenkins LTS image as base
FROM jenkins/jenkins:lts

# Switch to root to install dependencies
USER root

# Install prerequisites and update package lists
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK with architecture detection
# Use Microsoft's official script for flexibility across architectures
# See:
# https://github.com/dotnet/install-scripts
# https://dotnet.microsoft.com/en-us/download/dotnet/6.0
ARG DOTNET_VERSION="6.0.428"
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --version ${DOTNET_VERSION} --install-dir /usr/share/dotnet \
    && rm dotnet-install.sh \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Copy setup files into the image
COPY plugins.yaml /tmp/plugins.yaml
COPY job_config.xml /var/jenkins_home/jobs/DotNetPipeline/config.xml

# Create a minimal placeholder Jenkinsfile
RUN echo "pipeline { agent any; stages { stage('Placeholder') { steps { echo 'Placeholder' } } } }" > /var/jenkins_home/Jenkinsfile

# Set ownership to jenkins user
RUN chown -R jenkins:jenkins /var/jenkins_home

# Install Jenkins Plugin Manager Tool
ARG PLUGIN_MANAGER_VERSION="2.13.2"
ARG PLUGIN_MANAGER_SHA256="98cdd261c64a4f51fbbf161287be77c9dbd0acb0c58b1916fdbc9dce03b47f9c"
ARG PLUGIN_MANAGER_PATH="/usr/share/jenkins/jenkins-plugin-manager.jar"
RUN wget -O ${PLUGIN_MANAGER_PATH} "https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${PLUGIN_MANAGER_VERSION}/jenkins-plugin-manager-${PLUGIN_MANAGER_VERSION}.jar" \
    && echo "${PLUGIN_MANAGER_SHA256} ${PLUGIN_MANAGER_PATH}" | sha256sum -c

# Install plugins using the plugin manager
RUN java -jar ${PLUGIN_MANAGER_PATH} \
    --war /usr/share/jenkins/jenkins.war \
    --plugin-file /tmp/plugins.yaml \
    --plugin-download-directory /usr/share/jenkins/ref/plugins \
    --verbose

# Seed the job using Job DSL (requires Jenkins to be temporarily started)
# RUN mkdir -p /var/jenkins_home/jobs/DotNetPipeline \
#     && echo "java -jar /usr/share/jenkins/jenkins.war" > /tmp/start-jenkins.sh \
#     && chmod +x /tmp/start-jenkins.sh \
#     && /tmp/start-jenkins.sh & \
#     sleep 30 \
#     && wget -O /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar \
#     && java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -webSocket -auth admin:$(cat /var/jenkins_home/secrets/initialAdminPassword) groovy /tmp/seed.groovy \
#     && pkill -f "java -jar /usr/share/jenkins/jenkins.war"

# RUN mkdir -p /var/jenkins_home/jobs/DotNetPipeline \
#     && echo "java -Djenkins.install.runSetupWizard=false -jar /usr/share/jenkins/jenkins.war" > /tmp/start-jenkins.sh \
#     && chmod +x /tmp/start-jenkins.sh \
#     && /tmp/start-jenkins.sh & \
#     sleep 30 \
#     && wget -O /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar \
#     && java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -webSocket who-am-i || echo "CLI debug failed" \
#     && java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -webSocket groovy /tmp/seed.groovy \
#     && pkill -f "java -jar /usr/share/jenkins/jenkins.war"

# RUN mkdir -p /var/jenkins_home/jobs/DotNetPipeline \
#     && echo "java -jar /usr/share/jenkins/jenkins.war -Djenkins.install.runSetupWizard=false" > /tmp/start-jenkins.sh \
#     && chmod +x /tmp/start-jenkins.sh \
#     && /tmp/start-jenkins.sh & \
#     sleep 60 \
#     && wget -O /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar \
#     && java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -webSocket -auth admin:$(cat /var/jenkins_home/secrets/initialAdminPassword) groovy /tmp/seed.groovy \
#     && pkill -f "java -jar /usr/share/jenkins/jenkins.war"

# RUN mkdir -p /var/jenkins_home/jobs/DotNetPipeline \
#     && echo "java -jar /usr/share/jenkins/jenkins.war -Djenkins.install.runSetupWizard=false" > /tmp/start-jenkins.sh \
#     && chmod +x /tmp/start-jenkins.sh \
#     && /tmp/start-jenkins.sh & \
#     sleep 30 \
#     && wget -O /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar \
#     && java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -webSocket -auth admin:password123 groovy /tmp/seed.groovy \
#     && pkill -f "java -jar /usr/share/jenkins/jenkins.war"

# Clean up
RUN rm -rf /tmp/*

# Verify installations
RUN dotnet --version
RUN git --version

# Switch back to Jenkins user and set default dir
USER jenkins
WORKDIR /var/jenkins_home

# Expose Jenkins port
EXPOSE 8080