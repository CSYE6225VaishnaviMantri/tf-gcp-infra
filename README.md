# tf-gcp-infra

# Infrastructure as Code with Terraform on Google Cloud Platform:

This repository contains Terraform configuration files for setting up networking resources on Google Cloud Platform (GCP). The objective is to create a Terraform configuration that allows the creation of multiple Virtual Private Clouds (VPCs) along with their associated resources in the same GCP project and region.

## Steps:


1. **Install and Set Up gcloud CLI:**

   Make sure you have the gcloud command-line tool installed and configured with the appropriate credentials.
   1.gcloud auth login
   2.gcloud auth application-default login
   3.gcloud config set project

2. **Install and Set Up Terraform:**
      
   1.To set up Terraform on Windows using Chocolatey, you can follow these steps:
   Install Chocolatey (if not already installed):
   Open a PowerShell prompt with administrative privileges and run the following command to install Chocolatey:
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
   
   2.Install Terraform using Chocolatey:
   Once Chocolatey is installed, run the following command to install Terraform:
   choco install terraform -y 
   This command installs the latest version of Terraform available on Chocolatey.
   
   3.Verify Terraform Installation:
   To verify that Terraform has been successfully installed, open a new PowerShell window and run:
   terraform version 
   This command should display the installed Terraform version.
   
   4.Updating Terraform:
   To update Terraform to the latest version, you can use the following Chocolatey command:
   choco update terraform -y 
   
   5.Checking Version of Terraform and Chocolatey on Windows Terminal:
   choco --version
   terraform --version

3. **Terraform:Confirguation Files**
   
    main.tf: Main Terraform configuration file defining networking resources.
    variables.tf: Declare variables used in the configuration.
    terraform.tfvars: Store variable values. Note: Do not commit this file to version control.

4. **Commands to Run Terraform Confirguation Files**

    1.Initialize Terraform: terraform init
    2.Plan the Infrastructure: terraform plan
    3.Apply the Infrastructure: terraform apply
    4.Confirm the changes by typing yes when prompted.
    5.Destroy the Infrastructure (cleanup): terraform destroy
    Confirm the destruction by typing yes when prompted.
