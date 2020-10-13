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

1. Change directory using ` cd azure-vote`

1. Run `docker-compose up -d` to create the container image, download the Redis image and start the application.

1. You can run `docker images` command to see created image.

1. Run `docker ps` command to see all the running containers

1. To test the application enter `http://localhost:8080` in browser.

1. Run command `docker-compose down` to stop and remove the running container. You will still have container image.

#### Task 2: Create an Azure Container registry (ACR)

1. Create a resource group in azure using command `az group create --name az104-aks-demo-rg --location eastus`

1. Create an Azure Container Registry using command `az acr create --resource-group az104-aks-demo-rg --name <acrName> --sku Basic`
1. Login to ACR instance using command `az acr login --name <acrName>`

1. Now to see the docker image created in previous task run command `docker images`
1. To upload the local docker image to ACR you need login server address of ACR. To get the login server address, use the command `az acr list --resource-group az104-aks-demo-rg --query "[].{acrLoginServer:loginServer}" --output table`
1. Now tag your local azure-vote-front image with acrLoginServer address of the container registry using command `az acr list --resource-group az104-aks-demo-rg --query "[].{acrLoginServer:loginServer}" --output table`
1. To verify the tags run command `$ docker images`
1. Now push the docker image to ACR instance using command `docker push <acrLoginServer>/azure-vote-front:v1`
1. It will take sometime to push the image. Once image is pushed, run command `az acr repository list --name <acrName> --output table` to list the images in the ACR instance.

#### Task 3: Create an Azure Kubernetes Cluster (AKS)

1. Now we will create an Azure Kubernetes Cluster(AKS) cluster using command `az aks create
    --resource-group az104-aks-demo-rg
    --name myAKSCluster
    --node-count 2
    --generate-ssh-keys
    --attach-acr <acrName>`
1. Install kubectl using command `az aks install-cli`
1. Connect to AKS Cluster using command `az aks get-credentials --resource-group az104-aks-demo-rg --name myAKSCluster`
1. After connecting to ALS cluster, run command `kubectl get nodes` to list all the nodes of the AKS cluster.

#### Task 4: Run your containerized application on AKS

1. Get the ACR login server name using command `az acr list --resource-group az104-aks-demo-rg --query "[].{acrLoginServer:loginServer}" --output table`
1. Oped the file `azure-vote.yaml` in a code editor such Visual Studio Code or notepad.
1. Replace microsoft with your ACR login server name.

```yaml
containers:
- name: azure-vote-front
  image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
```

```yaml
containers:
- name: azure-vote-front
  image: <acrName>.azurecr.io/azure-vote-front:v1
```
1. After making changes run command `kubectl apply -f azure-vote-all-in-one-redis.yaml` to deploy the application to AKS

1. To monitor the progress, run command ` kubectl get service azure-vote-front --watch`
1. Initially the EXTERNAL-IP for th eazure-vote-front service is pending.

1. When the EXTERNAL-IP address changes from pending to an actual IP address, CTRL-C to stop kubetcl watch process.
1. To open the application in a browser, copy EXTERNAL-IP and open it in a browser.

#### Task 5 : Cleanup
1. To delete the resources deployed in Azure during this lab run command `az group delete --name az104-aks-demo-rg --yes --no-wait`