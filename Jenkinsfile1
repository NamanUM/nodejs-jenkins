pipeline{
    agent any
    tools {nodejs "node"}
    stages{
         stage("GitHub git cloning") {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_CREDENTIAL', url: 'https://github.com/clement2019/nodejs-jenkins.git']])
                   
                }
            }
        }
        stage('intialising npm installation.......') {
            steps {
                sh 'npm install'
  
       
            }
        }
        stage("Build docker on going again"){
            steps{
                sh 'printenv'
                sh 'git version'
                sh 'docker build . -t good777lord/imag2.0'
            }
        }
         stage("push image to DockerHub"){
            steps{

               script {
                  
                 withCredentials([string(credentialsId: 'dockerID', variable: 'dockerID')]) {
                    sh 'docker login -u good777lord -p ${dockerID}'
            }
              sh 'docker push good777lord/imag2.0:latest'
            }
        }
    }
    }
}

    
