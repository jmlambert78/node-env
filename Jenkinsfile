#!/usr/bin/groovy

def organisation = ""
try {
  organisation = ORGANISATION
} catch (Throwable e) {
  organisation = "fabric8io"
}

def envStage = "${env.JOB_NAME}-staging"
def envProd = "${env.JOB_NAME}-production"

node ('kubernetes'){

  git 'https://github.com/jmlambert78/node-env'

  def newVersion = getNewVersion{}
  def clusterImageName = "${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${organisation}/${env.JOB_NAME}:${newVersion}"
  def clusterImageNameWithoutTag = "${env.FABRIC8_DOCKER_REGISTRY_SERVICE_HOST}:${env.FABRIC8_DOCKER_REGISTRY_SERVICE_PORT}/${organisation}/${env.JOB_NAME}"
  def dockerhubImageName = "docker.io/${organisation}/${env.JOB_NAME}:${newVersion}"

  stage 'canary release'

    if (!fileExists ('Dockerfile')) {
      writeFile file: 'Dockerfile', text: 'FROM node:5.3-onbuild'
    }

    kubernetes.image().withName(clusterImageName).build().fromPath(".")
    kubernetes.image().withName(clusterImageNameWithoutTag).push().withTag(newVersion).toRegistry()

    // gitTag{
    //   releaseVersion = newVersion
    // }

    def rc = getKubernetesJson {
      port = 8080
      label = 'node'
      icon = 'https://cdn.rawgit.com/fabric8io/fabric8/dc05040/website/src/images/logos/nodejs.svg'
      version = newVersion
      imageName = clusterImageName
    }

    sh 'echo "commit:" `git rev-parse HEAD` >> git.yml && echo "branch:" `git rev-parse --abbrev-ref HEAD` >> git.yml'

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
