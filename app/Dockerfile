FROM openjdk:8-jre
ADD ~/projects/java/helloworld-war/build/helloworld-0.1-dev.war app.war
EXPOSE 8030

ENTRYPOINT ["java","-jar","jetty-runner.jar","/app.war"]
