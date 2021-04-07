# Preparations
Use `.envrc.dist` file to prepare env variables used in this case. Dont mess with your local shell, check this tool https://direnv.net/

# Infrastructure
Created new VPC, with three subnets. Applications is using ECR repository.
# K8s cluster
Cluster was created as EKS service, with `t3.medium` instances. Created autoscaling to use as many resources as needed at this point. Moreover there are spot instances instead of on-demand type. Ingress service for application is steering from `k8s/ingress-service.yml` file.
# App
Simply application with nginx configured to respond 200 code and `Pong` text. Deployed with Helm charts. In values replicas are set as 8 by deafult. 