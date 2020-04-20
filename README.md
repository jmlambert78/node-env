# Node.js ENV 

A simple demo that prints the server's environment variables.

## Local development

    node server.js

## Deploying to SUSE Cloud Application Platform
    git clone
    cf push 
## Deploying to SUSE CaaS Platform 4 with Tekton Pipeline
* You need to have a SUSE CaaSP Kubernetes running and access with kubectl.
### Install the tekton CRDs on the cluster
* https://github.com/tektoncd/pipeline/blob/master/docs/install.md#installing-tekton-pipelines-on-kubernetes
### Files used by this project for Tekton pipeline:
* Dockerfile : to make the build
* deploy.yaml : to deploy svc & pod by tekton
### Tekton files organisation
* Tekton works with Tasks & Pipelines.
* Pipelines are made of a set of Tasks orchestrated.
* Resources are needed to provide elements to tasks running (git, docker url, ...)
### Tekton files & resources
* docker-creds.yaml
  * a secret with your url, login, password for the docker registry
* service-account.yaml
  * This file refers a the above secret to reach docker.io registry
* git-resource-nodeenv.yaml  
  * url of the repo to build (this one here)
* task-build-src.yaml
  * Tekton task to build from source
* task-deploy.yaml
  * Tekton task to deploy from the built & pushed image  
* pipeline.yaml        
  * Tekton pipeline definition, making use of the 2 tasks above
* pipeline-run.yaml          
  * actual pipeline parameters
* launch-pipeline.sh
  * tkn script to launch the pipeline with online params (for example to easily change teh tag versions)

### Deployment of your tekton resources
* on your CLI, apply the following commands
```bash
kubectl apply -f docker-creds.yaml           
kubectl apply -f service-account.yaml  
kubectl apply -f git-resource-nodeenv.yaml  
kubectl apply -f task-deploy.yaml
kubectl apply -f task-build-src.yaml
kubectl apply -f pipeline.yaml      
# either apply the yaml or the tkn cli script
kubectl apply -f pipeline-run.yaml  
or
./launch-pipeline.sh <tag>
```
### Check the running pipeline with tkn
* install the tkn CLI if you need
  * ```tkn pr logs application-pipeline-run``` : see logs
  * ```tkn t ls``` : list the tasks
  * ```tkn p ls``` : list the pipelines
  * ```tkn pr ls``` : list the pipelines-runs
  
### Check the elements deployed
* ```kubectl get pod app``` :pod of the application
* ```kubectl get svc app``` :Service of the application
* You  may curl the svc on the nodeport defined 
* you may get the Application logs with
* ```kubectl logs app-xxx```

### If you make a change in your code, remove the pr
* Use another tag for the image revision in the pipeline-run
  * ./launch-pipeline.sh <tag>
### to clean up all your project
```bash
kubectl delete -f service-account.yaml  
kubectl delete -f git-resource-nodeenv.yaml  
kubectl delete -f task-deploy.yaml
kubectl delete -f task-build-src.yaml
kubectl delete -f pipeline.yaml      
kubectl delete -f pipeline-run.yaml  
```
### to clean up all your tekton elements
```bash
tkn pr rm --all
tkn tr rm --all
```



    
