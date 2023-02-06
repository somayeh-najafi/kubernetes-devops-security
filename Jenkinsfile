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

        stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"}
      post {
        always {
          pitmutation mutationStatsFile:'**/target/pit-reports/**/mutations.xml'}
          }
        } 

        stage ('SonarQube - SAST') {
          
          steps {
            withSonarQubeEnv('SonarQube') {
             sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=numeric_app -Dsonar.host.url=http://35.188.59.120:9000 -Dsonar.login=fa8a8a2298a52971c1f4010811933c03201eed74'
            }
            timeout(time: 2, unit: 'MINUTES') {
                    script {
                     waitForQualityGate abortPipeline: true
                    }
                }
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