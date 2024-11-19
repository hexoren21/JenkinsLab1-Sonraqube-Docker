pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    writeFile file: 'Dockerfile', text: '''
                    FROM ubuntu:20.04
                    RUN apt update && apt install apache2 wget unzip -y && \\
                        wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip && \\
                        unzip 2135_mini_finance.zip && \\
                        cp -r 2135_mini_finance/* /var/www/html/ && \\
                        systemctl restart apache2
                    CMD ["apachectl", "-D", "FOREGROUND"]
                    '''
                }
                sh 'docker build -t test-apache .'
            }
        }
        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 8080:80 --name test-apache test-apache'
            }
        }
        stage('Test Application') {
            steps {
                script {
                    def status = sh(script: 'curl -o /dev/null -s -w "%{http_code}" http://localhost:8080', returnStdout: true).trim()
                    if (status != '200') {
                        error "Application is not working as expected! HTTP Status: ${status}"
                    } else {
                        echo "Application is running successfully!"
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Cleaning up resources..."
            sh 'docker stop test-apache || true'
            sh 'docker rm test-apache || true'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
