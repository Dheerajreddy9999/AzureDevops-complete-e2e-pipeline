pipeline {
    agent any
    environment {
        registry= "asia.gcr.io/hypnotic-camp-371708/spring-app"
    }
    stages {
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'SONAR4.7', credentialsId: 'MySonarToken') {
                    sh '''
                        chmod +x gradlew
                        ./gradlew sonarqube
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build registry + ":V$BUILD_NUMBER"
                }
            }
        }

    }
}