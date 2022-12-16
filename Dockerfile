FROM openjdk:11 as base 
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew build

FROM openjdk:11
WORKDIR /app
COPY --from=base /app/build/libs/spring-demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]