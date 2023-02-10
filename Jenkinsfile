pipeline {
  agent any
  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName =  "smyhus/numeric_app:${GIT_COMMIT}"
    applicationURL =  "http://35.188.59.120:32170/"
    applicationURI =  "/increment/99"

  }
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
    }


        stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"}
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
                parallel (
                  "dependency Scan": { 
                    sh "mvn dependency-check:check"
              },
                  "Trivy Scan": {                  
                     sh "bash trivy-docker-image-scan.sh"
              },
                  "OPA-Conftest-Scan": {
                   // sh "HERE=\$(pwd)"
                    sh 'docker run --rm -v "\$(pwd):/project" openpolicyagent/conftest test --policy opa-dockerfile-security.rego Dockerfile'
                  }
              )
              } 
            }
   
        stage('build and push docker image') {
            steps {
              withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                sh "printenv"
                sh 'docker build -t smyhus/numeric_app:""$GIT_COMMIT"" .'
                sh 'docker push smyhus/numeric_app:""$GIT_COMMIT""'
            }
            }
        } 

        stage ('Vulnerability Scan - Kubernetes') {
            steps {
                    sh 'docker run --rm -v "\$(pwd):/project" openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
                        }
                          }


        stage('Kubernetes deployment-Dev Env') {
            steps {
              parallel (
                "Deployment": {
                    withKubeConfig(credentialsId: 'kubeconfig') {
                      sh "bash k8s-deployment.sh"
                   }
                }
                ,
                "Rollout Status": {
                  withKubeConfig(credentialsId: 'kubeconfig') {
                      sh "bash k8s-deployment-rollout-status.sh"
                   }
                }
                  
              )
              
            }
        }

    }
    post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern:'target/jacoco.exec'
          pitmutation mutationStatsFile:'**/target/pit-reports/**/mutations.xml'
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
          
          }
        // success {}
        // failure {}  
      }
}