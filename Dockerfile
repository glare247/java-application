#BUILD
FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

COPY . .

RUN mvn clean package

#run stage

FROM openjdk:17-slim

WORKDIR /app

COPY --from=build /app/target/*.jar /app

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/tech365-0.0.1-SNAPSHOT.jar"]

