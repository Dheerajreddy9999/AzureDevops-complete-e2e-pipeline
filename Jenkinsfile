pipeline {
    agent any
    stages {
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'SONAR4.7', credentialsId: 'MySonarToken') {
                    sh 'chmod +x gradlew'
                    sh './gradlew sonarqube'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
    }
}