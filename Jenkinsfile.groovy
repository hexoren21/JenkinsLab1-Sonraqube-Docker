pipeline {
    agent any
        stage('Build') {
            steps{
                sh 'echo "BBuild completed."'
            }
        }
}
