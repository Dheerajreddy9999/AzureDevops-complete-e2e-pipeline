FROM eclipse-temurin:11-alpine as base 
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew build

FROM gcr.io/distroless/java11-debian11:latest
WORKDIR /app
COPY --from=base /app/build/libs/Jhooq-docker-demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
