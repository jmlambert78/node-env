#!/usr/bin/groovy
def envStage = "${env.JOB_NAME}-staging"
def envProd = "${env.JOB_NAME}-production"
def outside = "${env.DOCKER_REGISTRY_SERVICE_HOST}:${env.DOCKER_REGISTRY_SERVICE_PORT}"
node{
    echo "defined outside " + outside
    
    def inside = "${env.DOCKER_REGISTRY_SERVICE_HOST}:${env.DOCKER_REGISTRY_SERVICE_PORT}"
    echo "defined inside " + inside

}
node ('kubernetes'){

  git 'https://github.com/jmlambert78/node-env'

  stage 'canary release'
    if (!fileExists ('Dockerfile')) {
      writeFile file: 'Dockerfile', text: 'FROM node:5.3-onbuild'
    }

    def newVersion = performCanaryRelease {}

    def rc = getKubernetesJson {
      port = 8080
      label = 'node'
      icon = 'https://cdn.rawgit.com/fabric8io/fabric8/dc05040/website/src/images/logos/nodejs.svg'
      version = newVersion
      imageName = clusterImageName
    }

  stage 'Rolling upgrade Staging'
    kubernetesApply(file: rc, environment: envStage)

  approve{
    room = null
    version = canaryVersion
    console = fabric8Console
    environment = envStage
  }

  stage 'Rolling upgrade Production'
    kubernetesApply(file: rc, environment: envProd)

}
