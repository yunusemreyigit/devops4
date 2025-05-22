pipeline {
    agent any
    environment{
    DOCKERHUB_CREDENTIALS = credentials("DockerHub")
    }
    triggers{
    pollSCM '*/5 * * * *'
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
                withCredentials([string(credentialsId: 'sa-k8s-token', variable: 'KUBE_TOKEN')]) {
                    sh '''
                    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"
                    chmod u+x ./kubectl
                    export KUBECONFIG=$(mktemp)
                    ./kubectl config set-cluster do-fra1-ibb-tech --server=https://192.168.49.2:8443 --insecure-skip-tls-verify=true
                    ./kubectl config set-credentials jenkins --token=${KUBE_TOKEN}
                    ./kubectl config set-context default --cluster=minikube --user=jenkins --namespace=jenkins
                    ./kubectl config use-context default
                    ./kubectl get nodes
                    ./kubectl apply -f devops4-service.yaml
                    ./kubectl apply -f devops4-deployment.yaml
                    '''
                }
            }
        }
    }
}
