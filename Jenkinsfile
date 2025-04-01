pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = "docker_hub"
        SONARQUBE_URL = "http://52.54.25.234:9000"
        SONARQUBE_CREDENTIALS_ID = "sonar_qube"
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner-5.0.1.3006-linux/bin
                    sonar-scanner \
                        -Dsonar.projectKey=my-nodejs-project \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONARQUBE_URL \
                        -Dsonar.exclusions=node_modules/**,tests/**
                    '''
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') { // Increased timeout to 10 minutes
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Vulnerability Scan') {
            steps {
                sh '''
                dependency-check.sh --project "My Project" --scan . --format HTML --out reports/
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/*.html', fingerprint: true
                }
                failure {
                    echo "Vulnerability scan failed. Check the report in Jenkins artifacts."
                }
            }
        }

        stage('Security Scan - Trivy') {
            steps {
                sh '''
                docker pull aquasec/trivy
                trivy fs --scanners vuln,config,secret --format json -o trivy-report.json .
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-report.json', fingerprint: true
                }
                failure {
                    echo "Security scan detected vulnerabilities. Review the Trivy report."
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
        stage('Deploy to Node.js Server') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS'), sshUserPrivateKey(credentialsId: 'ssh-agent', keyFileVariable: 'KEY_FILE')]) {
                    sshagent(['ssh-agent']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@35.172.0.92 '
                                echo "\$DOCKER_PASS" | docker login --username "\$DOCKER_USER" --password-stdin \n
                                docker pull naman211/fins:latest \n
                                docker run -d -p 3000:3000 --name backend naman211/fins:latest \n
                                /home/ubuntu/deploy.sh
                                echo "Deployment successful" \n
                            '
                        """
                    }
                }
            }
        }
    }
}
