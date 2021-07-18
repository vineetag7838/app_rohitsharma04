FROM openjdk:8-jdk-alpine
EXPOSE 8080
COPY target/SpringBootHelloWorld-0.0.1-SNAPSHOT.jar  SpringBootHelloWorld-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/SpringBootHelloWorld-0.0.1-SNAPSHOT.jar"]