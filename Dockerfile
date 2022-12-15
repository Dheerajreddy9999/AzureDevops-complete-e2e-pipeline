FROM openjdk:11 as base 
WORKDIR /usr/src/myapp
COPY . .
RUN chmod +x gradlew && ./gradlew build

FROM openjdk:11
WORKDIR /usr/src/myapp
COPY --from=base /usr/src/app/build/libs/Jhooq-docker-demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]