pipeline {
  agent any

  environment {
    REPOSITORY_TAG      = "${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}"
    PRIVATE_REPO_TAG    = "371129761102.dkr.ecr.eu-west-1.amazonaws.com"
    PRIVATE_APP_NAME    = "awsprime1"
    VERSION             = "${BUILD_ID}"
    
  }

  stages {

    stage ('Print ENVs') {
        steps {
          sh 'printenv'
        }
      }
      
    stage ('Publish to Private ECR') {
      steps {
         withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]) {
           sh 'aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${PRIVATE_REPO_TAG}'
           sh 'docker build -t ${PRIVATE_APP_NAME}:${VERSION} .'
           sh 'docker tag ${PRIVATE_APP_NAME}:${VERSION} ${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}'
           sh 'docker push ${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}'
         }
       }
    }
    
    stage ("Install kubectl"){
            steps {
                sh 'curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl'
                sh 'chmod +x ./kubectl'
                sh './kubectl version --client'
            }
        }
        
    stage ('Deploy to Cluster') {
            steps {
                sh 'aws eks update-kubeconfig --region eu-north-1 --name ekscluster'
                sh 'envsubst < ${WORKSPACE}/deploy.yaml | ./kubectl apply -f -'
            }
    }
    
    stage ('Delete Images') {
      steps {
        sh 'docker rmi -f $(docker images -qa)'
      }
    }
  }
}
