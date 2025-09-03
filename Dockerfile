FROM openjdk:17-jdk-slim
WORKDIR /app
COPY  target/webapp-1.0.0.jar /app/webapp.jar
EXPOSE 5555
ENTRYPOINT ["java", "-jar", "webapp.jar"]
