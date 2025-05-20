pipeline {
    agent any
    enviroment{
    DOCKERHUB_CREDENTIALS = credentials("DockerHub")
    }
    stages {
        stage('Pull the project from Github') {
            steps {
                echo 'getting project..'
                git 'https://github.com/yunusemreyigit/devops4'
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'mvn clean package'
            }
        }
        stage('Docker Image') {
            steps {
                echo 'Creating image....'
                sh 'docker build -t yunusemreyigit/app .'
            }
        }
        stage('Login DockerHub') {
            steps {
                sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR --password $DOCKERHUB_CREDENTIALS_USR'
                echo 'Logged in'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push yunusemreyigit/app'
                echo 'Image is pushed!'
            }
        }

    }
}