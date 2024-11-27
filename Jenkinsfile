pipeline {
    agent any
    stages {
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
                JAVA_HOME = "/usr/lib/jvm/java-1.11.0-openjdk-amd64"
                PATH = "${JAVA_HOME}/bin:${env.PATH}"
            }
            steps {
                withSonarQubeEnv('sonar-pro') {
                        sh '''
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=my-html-css-project-v2\
                        -Dsonar.projectName=HTML-CSS-Project-v2 \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=2135_mini_finance/ \
                        -Dsonar.language=web \
                        -Dsonar.sourceEncoding=UTF-8
                        '''
                }
            }
        }
        stage('Check Quality Gate') {
            steps {
                script {
                    echo 'Waiting for SonarQube to process the Quality Gate...'
                    sleep(time: 30, unit: 'SECONDS')

                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status == 'ERROR' || qualityGate.status == 'FAILED') {
                        error "Pipeline failed: Quality Gate status is ${qualityGate.status}"
                    } else if (qualityGate.status == 'OK') {
                        echo 'Quality Gate passed successfully!'
                    } else {
                        echo "Quality Gate status: ${qualityGate.status}. Proceeding..."
                    }
                }
            }
        }
        stage('Build Docker Image') {
            // agent { label 'master' }
            steps {
                script {
                    echo "Building Docker image from Dockerfile"
                    sh 'docker build -t test-apache2 .'
                }
            }
        }
        stage('Run Docker Container') {
            // agent { label 'master' }
            steps {
                // Stop and remove existing container if it exists
                sh 'docker stop test-apache2 || true'
                sh 'docker rm test-apache2 || true'
                sh 'docker run -d -p 80:80 --name test-apache2 test-apache2'
            }
        }
        stage('Test Application') {
            steps {
                script {
                    def status = sh(script: 'curl -o /dev/null -s -w "%{http_code}" http://localhost:80', returnStdout: true).trim()
                    if (status != '200') {
                        error "Application is not working as expected! HTTP Status: ${status}"
                    } else {
                        echo 'Application is running successfully!'
                    }
                }
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-hub') {
                        sh 'docker build -t heoxren/ci-cd-integration:latest .'
                        sh "docker push heoxren/ci-cd-integration:latest"
                    }
                }
            }
        }
        stage('Triger CD Pipeline') {
            steps {
                build job: "Docker-jenkins-sonarqube-v3-Cd"
            }
        }
    }
// post {
//     always {
//         echo "Cleaning up resources..."
//         sh 'docker stop test-apache || true'
//         sh 'docker rm test-apache || true'
//     }
//     success {
//         echo 'Pipeline completed successfully!'
//     }
//     failure {
//         echo 'Pipeline failed!'
//     }
// }
}
