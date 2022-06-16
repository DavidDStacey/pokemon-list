# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

To start run

`npm i` or `npm install`

In the project directory, you can run:

`npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

# General Info:

React app that displays a list of pokemon 20 per page pulled from [pokeapi](https://pokeapi.co/api/v2/pokemon) turned into a docker image which is also located on [docker hub](https://hub.docker.com/repository/docker/daviddstacey/pokemon-list-react-app) and then deploy on aks using github actions

# Technologies:

Created with:
* JavaScript
* react
* HTML
* Github Actions
* Azure Container Registry
* AKS

# Build and Run Image Locally

### Build Image 

``` bash
docker build -t pokemon:web .
```
### Run Container

``` bash
docker run -d -it -p 3001:3000 --name pokemon-list pokemon:web
```

# Use Azure

login to Azure

``` bash
az login
```

## Terraform

Create infrastructure on Azure - in this example a sevice principal was used in an ignored file
``` bash
az ad sp create-for-rbac --skip-assignment
```
![image](https://user-images.githubusercontent.com/54081993/174159008-afe9a0b5-1129-46f7-9fd7-077e67795783.png) <br/>

``` terraform 
terraform init 
terraform validate 
terraform apply
```
This creates:
* Resource group
* AKS
* ACR

## Github Actions

ACR credentials
``` bash
az acr credential show -n <ACRNAME>
```
This will give you the secrete variables for REGISTRY_USERNAME and REGISTRY_PASSWORD <br/>

Service principal for secrets <br/>
``` bash
az ad sp create-for-rbac --name <APPNAME> --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> --sdk-auth
```
This gives a JSON object that is used is secret variable AZURE_CREDENTIALS
Additional secret vairables: 
* SERVICE_PRINCIPAL (SP in this repo) 
* SERVICE_PRINCIPAL_PASSWORD (sp_password in this repo) 
* TENANT (sp_tenant in this repo) 
* REGISTRY 
* REPOSITORY

#### Logs into ACR and Builds Docker Image

``` yml
- name: Azure Container Registry Build
      uses: Azure/acr-build@v1
      with:
        branch: main
        service_principal: ${{ secrets.SP }}
        service_principal_password: ${{ secrets.SP_PASSWORD }}
        tenant: ${{ secrets.SP_TENANT }}
        registry: ${{ secrets.REGISTRY }}
        repository: ${{ secrets.REPOSITORY }}
        image: image
        tag: ${{ github.sha }}
        folder: ./
        dockerfile: ./dockerfile
```

#### Sets Target AKS Cluster

``` yml
- uses: azure/aks-set-context@v1
      with:
        creds: '${{ secrets.AZURE_CREDENTIALS }}'
        cluster-name: ${{ env.CLUSTER_NAME }}
        resource-group: ${{ env.CLUSTER_RESOURCE_GROUP }}
```

#### Creates Secret

``` yml
- uses: azure/k8s-create-secret@v1
      with:
        container-registry-url: ${{ env.REGISTRY_NAME }}
        container-registry-username: ${{ secrets.REGISTRY_USERNAME }}
        container-registry-password: ${{ secrets.REGISTRY_PASSWORD }}
        secret-name: ${{ env.REGISTRY_NAME }}-registry-connection
        namespace: ${{ env.NAMESPACE }}
```

#### Deploy to AKS

``` yml
- uses: azure/k8s-deploy@v1
      with:
        manifests: |
          deploy.yml
        images: |
          ${{ env.REGISTRY_NAME }}/pokemon/image:${{ github.sha }}
        imagepullsecrets: |
          ${{ env.REGISTRY_NAME }}-registry-connection
        namespace: ${{ env.NAMESPACE }}
```

![image](https://user-images.githubusercontent.com/54081993/174166698-e9e592b0-41b5-4c79-b2b6-eb94f95a69b7.png)![image](https://user-images.githubusercontent.com/54081993/174166925-541e7aa6-beee-4912-9ca1-39be260a6cf9.png)


