pipeline {
    agent any
    environment {
        dockerRepoName = "asia.gcr.io/hypnotic-camp-371708/spring-app"
        registryCredential = "gcr:hypnotic-camp-371708"
        registryUrl = "http://asia.gcr.io"
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
                    dockerImage = docker.build dockerRepoName + ":V$BUILD_NUMBER"
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry(registryUrl,registryCredential) {
                        dockerImage.push("V$BUILD_NUMBER")
                    }
                }
            }
        }

        stage('Remove Unused Images') {
            steps {
                sh 'docker rmi $dockerRepoName:V$BUILD_NUMBER'
            }
        }

        stage('Datree Validation') {
            steps {
                script {
                dir('kube-manifest') {
                    withEnv(['DATREE_TOKEN=32b9a231-0c92-4724-ad9a-3f4a50fdae66']) {
                    sh 'helm datree test spring-app/'
                    }
                  }
                }
            }
        }


    }
}

