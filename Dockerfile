FROM openjdk:8-jdk-alpine
COPY target/*.jar  SpringBootHelloWorld-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/ SpringBootHelloWorld-0.0.1-SNAPSHOT.jar"]