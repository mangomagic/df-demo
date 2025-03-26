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