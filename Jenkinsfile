pipeline{
    agent any
    stages{
         stage("GitHub checkout") {
            steps {
                script {
 
                    git branch: 'master', url: 'https://github.com/NamanUM/nodejs-jenkins.git' 
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
        stage("build docker images"){
            steps{
               
            sh 'docker images'
            sh 'docker build -t naman211/fins:latest .'
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
    }
}

    
