---
lab:
    title: 'Implement Docker containers with AKS'
    module: 'Azure Kubernetes Service'
---

# Lab 09a - Implement Docker containers with AKS
# Student lab manual

**Pre-requisites:** Make sure you have AZ-CLI and Docker Desktop is installed on your computer.
1. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. [Install Docker Desktop](https://docs.docker.com/docker-for-windows/install/)
## Lab scenario

You need to containerized an existing web application. You need to run it locally and then push it to a container registry such as ACR. You will pull this application image from ACR and then deploy to Azure Kubernetes Cluster in Azure.

## Objectives

In this lab, you will:
  
+ Task 1: Create and run Container images locally
+ Task 2: Create an Azure Container registry (ACR) and push the local container image to ACR instance
+ Task 3: Create an Azure Kubernetes Service cluster
+ Task 4: Deploy the container images from ACR to AKS
+ Task 5: Cleanup

## Estimated timing: 60 minutes

#### Task 1: Create container image

1. Clone the code repository using command `git clone git clone https://github.com/Azure-Samples/azure-voting-app-redis.git`

1. Change directory using ` cd azure-voting-app-redis`

1. Run `docker-compose up -d` to create the container image, download the Redis image and start the application.

1. You can run `docker images` command to see created image.

1. Run `docker ps` command to see all the running containers

1. To test the application enter `http://localhost:8080` in browser.

1. Run command `docker-compose down` to stop and remove the running container. You will still have container image.

#### Task 2: Create an Azure Container registry (ACR)

1. Create a resource group in azure using command `az group create --name az104-aks-demo-rg --location eastus`

1. Create an Azure Container Registry using command `az acr create --resource-group az104-aks-demo-rg --name <acrName> --sku Basic`
1. Login to ACR instance using command az acr login --name <acrName>

1. Now to see the docker image created in previous task run command `docker images`
1. To upload the local docker image to ACR you need login server address of ACR. To get the login server address, use the command `az acr list --resource-group az104-aks-demo-rg --query "[].{acrLoginServer:loginServer}" --output table`
1. Now tag your local azure-vote-front image with acrLoginServer address of the container registry using command `az acr list --resource-group az104-aks-demo-rg --query "[].{acrLoginServer:loginServer}" --output table`
1. To verify the tags run command `$ docker images`
1. Now push the docker image to ACR instance using command `docker push <acrLoginServer>/azure-vote-front:v1`
1. It will take sometime to push the image. Once image is pushed, run command `az acr repository list --name <acrName> --output table` to list the images in the ACR instance.

#### Task 3: Create an Azure Kubernetes Cluster (AKS)

1.