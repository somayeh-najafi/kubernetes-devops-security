pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later//
            }
        } 
       stage('Unit Test') {
            steps {
              sh "mvn test"
            }
        } 
        stage('build and push docker image') {
            steps {
              withDockerRegistry(credentialsId: 'dockerhub', url: '') {
              sh "printenv"
              sh 'docker build -t smyhus/numeric_app:""$GIT_COMMIT"" .'
              sh 'docker push smyhus/numeric_app:""$GIT_COMMIT"" '
            }
            }
        } 

        stage ('SonarQube - SAST') {

          steps {
             sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=numeric_app -Dsonar.host.url=http://35.188.59.120:9000 -Dsonar.login=7457eb96d00373e0db3b445f94dd1dd5282e29b9'
          }
        }

        stage('Kubernetes deployment-Dev Env') {
            steps {
              withKubeConfig(credentialsId: 'kubeconfig') {
              sh "sed -i 's,replace,smyhus/numeric_app:${GIT_COMMIT},g' k8s_deployment_service.yaml"
              sh 'kubectl apply -f k8s_deployment_service.yaml'
            }
            }
        }

    }
}