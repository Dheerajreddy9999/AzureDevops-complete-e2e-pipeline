pipeline {
    agent any
    stages {
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'SONAR4.7', credentialsId: 'MySonarToken') {
                    sh 'chmod +x gradlew'
                    sh './gradle sonarqube'
                }
            }
        }
    }
}