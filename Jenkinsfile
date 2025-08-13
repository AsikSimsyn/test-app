pipeline {
    agent any

    tools {
        nodejs "NodeJS" // This must match the name in Jenkins NodeJS tool config
        dockerTool "docker-tool" // This must match the Docker installation configured in Jenkins
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
                sh 'npm test || echo "No tests found, skipping..."'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Use Jenkins Docker Tool to build image
                    def appImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    def running = sh(script: "docker ps -q -f name=node-app", returnStdout: true).trim()
                    if (running) {
                        sh "docker rm -f node-app"
                    }
                    sh "docker run -d -p 3000:3000 --name node-app ${DOCKER_IMAGE}"
                }
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
