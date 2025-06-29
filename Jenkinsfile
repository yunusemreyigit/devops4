pipeline {
    agent any
    environment{
    DOCKERHUB_CREDENTIALS = credentials("DockerHub")
    KUBECONFIG='/var/lib/jenkins/config'
    }
    triggers{
    pollSCM '* * * * *'
    }
    stages {
        stage('Pull') {
            steps {
                echo 'Clone project..'
                git 'https://github.com/yunusemreyigit/devops4.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh './mvnw clean package'
            }
        }
        stage('Docker Image') {
            steps {
                sh 'docker --version'
                echo 'Creating image....'
                sh 'docker build -t yunusemreyigit/app .'
            }
        }
        stage('Login DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                echo 'Logged in'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push yunusemreyigit/app'
                echo 'Image is pushed!'
            }
        }
        stage('K8s Deployment') {
                        steps {
                sh 'kubectl apply -f devops4-deploy.yml'
                sh 'kubectl apply -f devops4-service.yml'
            }
        }
    }
}
