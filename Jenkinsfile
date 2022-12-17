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
                dir('kube-manifest/') {
                    withEnv(['DATREE_TOKEN=32b9a231-0c92-4724-ad9a-3f4a50fdae66']) {
                    sh 'helm datree test spring-app/'
                    }
                  }
                }
            }
        }

        stage('Push Helm Charts to Nexus') {
            steps {
                script {
                    dir('kube-manifest/') {
                        withCredentials([string(credentialsId: 'nexusPass', variable: 'NexusCred')]) {
                            sh '''
                                chartversion=$( helm show chart spring-app | grep version | cut -d: -f 2 | tr -d ' ' )
                                tar -czvf spring-app-$chartversion.tgz spring-app
                                curl -u admin:$NexusCred http://10.182.0.8:8081/repository/helm-hosted/ --upload-file spring-app-$chartversion.tgz -v
                            '''
                        }
                    } 
                }
            }
        }

        stage('Deploy to GKE with Helm'){
            steps {
                script {
                        withCredentials([file(credentialsId: 'K8CONFIG', variable: 'KubeConfig')]) {
                            dir('kube-manifest/') {
                          sh 'helm upgrade --install k8tutorial --set image.repository="${dockerRepoName}" --set image.tag="V${BUILD_NUMBER}" spring-app/'
                        }
                    }
                }
            }
        }


    }
}

