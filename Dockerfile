FROM maven:3.8.6-openjdk-8-slim as BUILD
WORKDIR /app
COPY . .
RUN mvn package -DskipTests


FROM tomcat:8-jre8-alpine
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
WORKDIR /usr/local/tomcat/
EXPOSE 8080
CMD ["catalina.sh","run"]