@Library('slack') _
pipeline {
  agent any
  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "smyhus/numeric_app:${GIT_COMMIT}"
    applicationURL = "http://35.188.59.120"
    applicationURI = "increment/99"

  }
  stages {
    //   stage('Build Artifact') {
    //         steps {
    //           sh "mvn clean package -DskipTests=true"
    //           archive 'target/*.jar' //so that they can be downloaded later//
    //         }
    //     } 
    //    stage('Unit Tests - JUnit and Jacoco') {
    //   steps {
    //     sh "mvn test"}
    // }
    //     stage('Mutation Tests - PIT') {
    //   steps {
    //     sh "mvn org.pitest:pitest-maven:mutationCoverage"}
    //     } 

    //     stage ('SonarQube - SAST') {
          
    //       steps {
    //         withSonarQubeEnv('SonarQube') {
    //          sh 'mvn sonar:sonar -Dsonar.projectKey=numeric -Dsonar.host.url=http://35.188.59.120:9000'
    //         }
    //         timeout(time: 2, unit: 'MINUTES') {
    //                 script {
    //                  waitForQualityGate abortPipeline: true
    //                 }
    //             }
    //       }
    //     }
    //     stage ('Vulnerability Scan - Docker') {
    //         steps {
    //             parallel (
    //               "dependency Scan": { 
    //                 sh "mvn dependency-check:check"
    //           },
    //               "Trivy Scan": {                  
    //                  sh "bash trivy-docker-image-scan.sh"
    //           },
    //               "OPA-Conftest-Scan": {
    //                // sh "HERE=\$(pwd)"
    //                 sh 'docker run --rm -v "\$(pwd):/project" openpolicyagent/conftest test --policy opa-dockerfile-security.rego Dockerfile'
    //               }
    //           )
    //           } 
    //         }
   
    //     stage('build and push docker image') {
    //         steps {
    //           withDockerRegistry(credentialsId: 'dockerhub', url: '') {
    //             sh "printenv"
    //             sh 'docker build -t smyhus/numeric_app:""$GIT_COMMIT"" .'
    //             sh 'docker push smyhus/numeric_app:""$GIT_COMMIT""'
    //         }
    //         }
    //     } 

    //     stage ('Vulnerability Scan - Kubernetes') {
    //         steps {
    //           parallel (
    //             "OPA Scan": {
    //                 sh 'docker run --rm -v "\$(pwd):/project" openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
    //             },
    //             "Kubesec Scan": {
    //                 sh "bash kubesec-scan.sh"
    //             },
    //             "Trivy Scan": {
    //               sh "bash trivy-k8s-scan.sh"
    //             }
    //           )  
    //                     }
    //                       }

    //     stage('Kubernetes deployment-Dev Env') {
    //         steps {
    //           parallel (
    //             "Deployment": {
    //                 withKubeConfig(credentialsId: 'kubeconfig') {
    //                   sh "bash k8s-deployment.sh"
    //                }
    //             },
    //             "Rollout Status": {
    //               withKubeConfig(credentialsId: 'kubeconfig') {
    //                   sh "bash k8s-deployment-rollout-status.sh"
    //                }
    //             }
    //           )
    //         }
    //     }
    //     stage('Integration Test'){
    //       steps {
    //         script {
    //           try {
    //             withKubeConfig(credentialsId: 'kubeconfig') {
    //                   sh "bash integration-test.sh"
    //                }
    //           }
    //           catch (e) {
    //              withKubeConfig(credentialsId: 'kubeconfig') {
    //                   sh "kubectl -n default rollout undo deployment ${deploymentName} "
    //                }
    //              throw e 
    //             }
    //           }
    //         }
    //       }
        
    //     stage('OWASP ZAP - DAST') {
    //       steps {
    //             withKubeConfig(credentialsId: 'kubeconfig') {
    //                   sh "bash zap.sh"
    //                }
    //       }
    //     }
        stage('Deploy to Prod?') {
          steps {
            timeout(time: 2,unit: 'DAYS') {
              input ("Do you want to deploy to production?")
            }
          }
        }
            // stage('slack test') {
            //   steps {
            //     sh "exit 1"
            //   }
            // }   
        stage('K8s CIS Benchmark') {
          steps {
            script {
               parallel (
                  "Master": {
                      sh "bash cis-master.sh"
                  },
                  "Etcd": {
                      sh "bash cis-etcd.sh"
                  },
                  "Kubelet": {
                      sh "bash cis-kubelet.sh"
                  }

              )
            } 
          }
        }      
    }


    post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern:'target/jacoco.exec'
          pitmutation mutationStatsFile:'**/target/pit-reports/**/mutations.xml'
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
          publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'ZAP HTML REPORT', reportTitles: 'ZAP HTML REPORT', useWrapperFileDirectly: true])
          sendNotification currentBuild.result
          }
        // success {}
        // failure {}  
      }
}