pipeline {
    agent any
    stages {
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'MySonarToken') {
                    sh 'chmod +x gradlew'
                    sh './gradle sonarqube'
                }
            }
        }
    }
}