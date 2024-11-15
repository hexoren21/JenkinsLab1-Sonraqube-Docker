pipeline {
    agent any
        stage('Build') {
            steps{
                sh 'echo "build completed."'
            }
        }
}