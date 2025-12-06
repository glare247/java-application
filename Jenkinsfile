pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage ('RunsonarCloudAnalysis'){
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]){
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_TOKEN -Dsonar.organization=glare247-org -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=glare247-org_my-java-app'

                }

            }

        }


        stage('Build Java Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t glare247/my-java-app:v1 .'
            }
        }

        stage('Snyk Scan') {
            tools {
                jdk 'jdk17'
                maven 'maven3'
            }
            environment{
                SNYK_TOKEN = credentials('SNYK_TOKEN')
            }
            steps {
                dir("${WORKSPACE}") {
                    sh """

                        curl -Lo https://static.snyk.io/cli/latest/snyk-linux
                        chmod +x snyk
                        ./snyk auth --auth-type=token $SNYK_TOKEN
            



                        chmod +x mvnw
                        ./mvnw dependency:tree -DoutputType=dot
                        snyk test --all-projects --severity-threshold=medium
                    
                    """

                }

            }
    
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_LOGIN',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push glare247/my-java-app:v1
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and Docker image-push successful'
        }
        failure {
            echo '❌ Build failed. Check the logs for details.'
        }
    }

}











