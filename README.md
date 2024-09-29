# Welcome

This codebase is a sample solution from the book [Mastering Terraform](https://amzn.to/3XNjHhx). This codebase is the solution from Chapter 11 where Soze Enterprises is deploying their solution with Docker and Kubernetes using Azure Kubernetes Service. It includes container configuration with Docker, and both infrastructure and Kubernetes configuration using Terraform.

## Docker Code

The Docker code is stored in two `Dockerfile` files for both the `frontend` and another for the `backend`. As with convention, the `Dockerfile` for the corresponding application code is stored in the root folder of the application code which is stored in `src\dotnet`.

## Terraform Code

The Terraform code is stored in `src\terraform`. However, there are two root modules. One for the Azure infrastructure that leverages the `azurerm` provider in the `src\terraform\infra` folder and another for the Kubernetes configuration that leverages the `kubernetes` and `helm` Terraform providers residing in the `src\terraform\k8s` folder.

### Azure Infrastructure
The Terraform root module that provisions the Azure infrastructure will provision both an Azure Container Registry, an Azure Kubernetes Service (AKS) cluster and all surrounding resources. The Azure Container Registry is required in order to build and publish the Docker images.

You may need to change the `primary_region` input variable value if you wish to deploy to a different region. The default is `westus2`.

You will need to update the input variable value `container_registry_pushers` to include the Application ID for the Entra ID that you setup to publish Docker Images.

You can optionally include your Entra ID User Object ID in both the `keyvault_readers` and `keyvault_admins` to make it easier for you to verify the values stored in Azure KeyVault.

### Kubernetes Configuration

After you build Docker Images you will need to update the input variables `web_app_image` and `web_api_image` to reference the correct Docker image tag.

If you want to provision more than one environment you may need to remove the `environment_name` input variable value and specify an additional environment `tfvar` file.

## GitHub Actions Workflows

### Docker Workflows
There are two GitHub Actions workflows that use Docker to build and push the container images. These need to be executed after Terraform has been used to provision the Azure infrastructure.

### Terraform Workflows
The directory `.github/workflows/` contains GitHub Actions workflows that implement a CI/CD solution using Docker and Terraform. There are individual workflows for the three Terraform core workflow operations `plan`, `apply`, and `destroy`.

# Pre-Requisites

## Entra Setup

In order for GitHub Actions workflows to execute you need to have an identity that they can use to access Azure. Therefore you need to setup a new App Registrations in Entra for both the Terraform and Docker workflows. In addition, for each App Registration you should create a Client Secret to be used to authenticate.

The Entra App Registration's Application ID (i.e., the Client ID) needs to be set as Environment Variables in GitHub.

The App Registration for Docker should have it's Application ID stored in a GitHub environment Variable `DOCKER_ARM_CLIENT_ID` and it's client Secret stored in `DOCKER_ARM_CLIENT_SECRET`.

The App Registration for Terraform should have it's Application ID stored in a GitHub environment Variable `TERRAFORM_ARM_CLIENT_ID` and it's client Secret stored in `TERRAFORM_ARM_CLIENT_SECRET`.

## Azure Setup

### App Registration Subscription Role Assignments

Both of the Entra App Registrations created in the previous step need to be granted `Owner` access to your Azure Subscription.

### Azure Storage Account for Terraform State

Lastly you need to setup an Azure Storage Account that can be used to store Terraform State. You need to create an Azure Resource Group called `rg-terraform-state` and an Azure Storage Account within this resource group called `ststate00000`. replace the five (5) zeros (i.e., `00000`) with a five (5) digit random number. Then inside the Azure Storage Account create a Blob Storage Container called `tfstate`.

The Resource Group Name, the Storage Account Name and the Blob Storage container Name will be used in the GitHub Configuration.

### GitHub Configuration

You need to add the following environment variables:

- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID
- DOCKER_ARM_CLIENT_ID
- TERRAFORM_ARM_CLIENT_ID
- BACKEND_RESOURCE_GROUP_NAME
- BACKEND_STORAGE_ACCOUNT_NAME
- BACKEND_STORAGE_CONTAINER_NAME
- TERRAFORM_WORKING_DIRECTORY

You need to add the following secrets:

- DOCKER_ARM_CLIENT_SECRET
- TERRAFORM_ARM_CLIENT_SECRET