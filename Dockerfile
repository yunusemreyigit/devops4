FROM openjdk:17-alphine
COPY target/devops4-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]