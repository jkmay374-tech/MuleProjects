FROM mulesoft/mule:4.8.0-java17
WORKDIR /opt/mule/apps
COPY target/*.jar /opt/mule/apps/
EXPOSE 8081