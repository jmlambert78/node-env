tkn pipeline start \
  --param=pathToContext="." \
  --param=pathToYamlFile="deploy.yaml" \
  --param=imageUrl="jmlambert78/nodeenv" \
  --param=imageTag="0.1" \
  --serviceaccount="service-account" \
  application-pipeline

