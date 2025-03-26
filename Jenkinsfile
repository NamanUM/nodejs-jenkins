pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = "docker_hub"
    }
    
    stages{
         stage("GitHub checkout") {
            steps {
                script {
                    withCredentials([string(credentialsId: 'git-token', variable: 'GITHUB_TOKEN')]) {
                        sh 'git pull https://$GITHUB_TOKEN@github.com/NamanUM/nodejs-jenkins.git'
                    }
                }
            }
        }
        stage("Remove all old images"){
            steps{
                sh 'printenv'
                sh 'git version'
                sh 'docker ps'
                sh 'docker images'
                sh  'docker image prune -f'
                
                script {
                    input(message: "Are you sure you want to continue?", ok: "y")
                }
            }
        }
        stage("Build and Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub') {
                        sh 'docker build -t naman211/my-image:latest .'
                        sh 'docker push naman211/my-image:latest'
                    }
                }
            }
        }
        
        stage("push image to DockerHub"){
            steps{ 
                script {
                    docker.withRegistry('', 'docker-hub') {
                     sh 'docker push naman211/fins:latest'
                    }
                }
            }
        }
        stage("deploy"){
             steps{
                 withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                     sh './deploy.sh'
                }
             }
         }
    }
}
