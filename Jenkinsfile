pipeline{
    agent any
    stages{
         stage("GitHub checkout") {
            steps {
                script {
 
                    git branch: 'master', url: 'https://github.com/clement2019/nodejs-jenkins.git' 
                }
            }
        }
        stage("Remove all old images"){
            steps{
                sh 'printenv'
                sh 'git version'
                sh 'docker ps'
                sh 'docker images'
                sh  'docker image prune'
            
            input(message: "Are you sure to proceed?", ok: "Proceed")
            }
        
        }
        stage("build docker images"){
            steps{
               
            sh 'docker images'
            sh 'docker build . -t good777lord/diamindimg'
           }
        }
        
        stage("push image to DockerHub"){
            steps{

               script {
                  
                 withCredentials([string(credentialsId: 'dockerID', variable: 'dockerID')]) {
                    sh 'docker login -u good777lord -p ${dockerID}'
            }
              sh 'docker push good777lord/diamindimg:latest'
            }
        }
    }
    }
}

    
