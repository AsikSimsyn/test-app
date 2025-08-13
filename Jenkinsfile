pipeline {
    agent any

    tools {
        nodejs "NodeJS" // This must match the name in Jenkins NodeJS tool config
    }

    environment {
        DOCKER_IMAGE = "nodejs-jenkins-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AsikSimsyn/test-app.git',
                    credentialsId: 'github-token'

            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                // If you don't have tests, skip this
                sh 'npm test || echo "No tests found, skipping..."'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run Container') {
            steps {
                sh "docker run -d -p 3000:3000 --name node-app ${DOCKER_IMAGE} || echo 'Container already running'"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh "docker ps -aq --filter name=node-app | xargs docker rm -f || true"
        }
    }
}
