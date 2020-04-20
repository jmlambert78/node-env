tagVersion=${1:-0.1}
tkn pipeline start \
  --param=pathToContext="." \
  --param=pathToYamlFile="deploy.yaml" \
  --param=imageUrl="jmlambert78/nodeenv" \
  --param=imageTag="$tagVersion" \
  --serviceaccount="service-account" \
  application-pipeline

