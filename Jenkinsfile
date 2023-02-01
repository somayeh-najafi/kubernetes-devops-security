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
              sh "printenv"
              sh 'docker build -t smyhus/numeric_app:""$GIT_COMMIT"" .'
              sh 'docker push smyhus/numeric_app:""$GIT_COMMIT"" '
            }
        } 

    }
}