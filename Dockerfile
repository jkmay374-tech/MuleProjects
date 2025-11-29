# Use Eclipse Temurin (recommended OpenJDK distribution)
FROM eclipse-temurin:17-jre-jammy

# Install Mule Runtime 4.8.0
ENV MULE_HOME=/opt/mule \
    MULE_VERSION=4.8.0 \
    PATH=$PATH:/opt/mule/bin

# Install dependencies and Mule
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    wget https://repository.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.zip && \
    unzip mule-standalone-${MULE_VERSION}.zip -d /opt/ && \
    mv /opt/mule-standalone-${MULE_VERSION} ${MULE_HOME} && \
    rm mule-standalone-${MULE_VERSION}.zip && \
    apt-get purge -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR ${MULE_HOME}

# Copy the built application JAR
COPY target/*.jar ${MULE_HOME}/apps/

# Expose the HTTP listener port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8081/sayhello || exit 1

# Start Mule runtime
CMD ["mule"]