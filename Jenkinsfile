pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'jdk17'
        // Remove the sonarQube line if it still causes issues
    }

    environment {
        DOCKERHUB_USERNAME = 'laxminarayandev'  // Set this directly to your Docker Hub username
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/webapp:latest"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/laxminarayan183/Jenkins-Sonarqube-Docker.git'
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('Sonar Analysis') {
              steps {
                withSonarQubeEnv(credentialsId: 'sonar-token',installationName:'sonar') {
                    sh '''
                         mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=webapp \
                        -Dsonar.host.url=http://192.168.200.128:9000 \
                        -Dsonar.login=sqp_f50b45b3e3f164a08d1ca8aa6dab240369792cc4
                   '''
                    }
                }
        }

        stage('Build') {
            steps {
                sh "mvn package"
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Building Docker Image
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    // Stop any existing container with the same name
                    sh "docker stop webapp || true && docker rm webapp || true"
                    
                    // Running the container
                    sh "docker run -d --name webapp -p 5555:5555 $DOCKER_IMAGE"
                }
            }
        }

        stage('Docker Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-token', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        echo "Docker Hub Username: ${DOCKERHUB_USERNAME}"  // Check the username
                        echo "Docker Image: ${DOCKER_IMAGE}"  // Check the image
                        sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }

        
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()  // Clean up the workspace after the build
        }
    }
}

