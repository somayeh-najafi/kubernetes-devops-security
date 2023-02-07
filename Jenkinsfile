pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later//
            }
        } 
       stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"}
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern:'target/jacoco.exec'}
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
             sh 'mvn sonar:sonar -Dsonar.projectKey=numeric -Dsonar.host.url=http://35.188.59.120:9000'
            }
            timeout(time: 2, unit: 'MINUTES') {
                    script {
                     waitForQualityGate abortPipeline: true
                    }
                }
          }
        }
        stage ('Vulnerability Scan - Docker') {
            steps {
              sh "mvn dependency-check:check"
            }
            post {
              always {
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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