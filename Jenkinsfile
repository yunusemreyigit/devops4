pipeline {
    agent none
    environment{
    DOCKERHUB_CREDENTIALS = credentials("DockerHub")
    }
    triggers{
    pollSCM '*/5 * * * *'
    }
    stages {
        stage('Pull') {
            agent any
            steps {
                echo 'Clone project..'
                git 'https://github.com/yunusemreyigit/devops4.git'
            }
        }
        stage('Build') {
            agent any
            steps {
                echo 'Building..'
                sh './mvnw clean package'
            }
        }
        stage('Docker Image') {
            agent any
            steps {
                sh 'docker --version'
                echo 'Creating image....'
                sh 'docker build -t yunusemreyigit/app .'
            }
        }
        stage('Login DockerHub') {
            agent any
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                echo 'Logged in'
            }
        }
        stage('Push Image') {
            agent any
            steps {
                sh 'docker push yunusemreyigit/app'
                echo 'Image is pushed!'
            }
        }
        stage('K8s Deployment') {
            agent {
                kubernetes {
                  label 'kubectl-agent'
                  defaultContainer 'jnlp'
                  yaml """
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      namespace: jenkins
                      labels:
                        some-label: kubectl
                    spec:
                      containers:
                      - name: kubectl
                        image: rancher/kubectl
                        command:
                        - cat
                        tty: true
                    """
                  retries 2
                }
            }
            steps {
               container('kubectl'){
                sh 'kubectl apply -f devops4-deploy.yml'
               }
            }
        }
        stage('K8s Service') {
            agent {
                kubernetes {
                  label 'kubectl-agent'
                  defaultContainer 'jnlp'
                  yaml """
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      namespace: jenkins
                      labels:
                        some-label: kubectl
                    spec:
                      containers:
                      - name: kubectl
                        image: rancher/kubectl
                        command:
                        - cat
                        tty: true
                    """
                  retries 2
                }
            }
            steps {
               container('kubectl'){
                sh 'kubectl apply -f devops4-service.yml'
               }
            }
        }
    }
}
