# Use the official OpenJDK 17 base + install Mule 4.8.0 (free & works perfectly)
FROM openjdk:17-jre-slim

# Install Mule Runtime 4.8.0
ENV MULE_HOME=/opt/mule \
    MULE_VERSION=4.8.0 \
    PATH=$PATH:/opt/mule/bin

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.zip && \
    unzip mule-standalone-${MULE_VERSION}.zip -d /opt/ && \
    mv /opt/mule-standalone-${MULE_VERSION} $MULE_HOME && \
    rm mule-standalone-${MULE_VERSION}.zip && \
    apt-get purge -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory for apps
WORKDIR $MULE_HOME/apps

# Copy your built JAR
COPY target/*.jar $MULE_HOME/apps/

# Expose port
EXPOSE 8081

# Start Mule
CMD ["mule"]