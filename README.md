# Welcome to Terraform-Boilerplate Project!

Hi! We are DevOps Team. As per name suggest , this goal of this project is to create Terraform Boilerplate to quick start of our upcoming projects. Any query Regarding anything, please feel free to contact use. 

**Thanks!!**


# AWS Resources

Our Goal is to create AWS resources. The Folders are named accordingly (e.g. S3, API Gateway etc.).
>**Important** : The file & folder structure was set for simplicity & we recommend to follow the same structure.
>For example, There should be a **main.tf** in root folder. The file can be renamed with any name , but for standard practice , we recommend you follow the same process. 
##  Necessary Information
For deploying infrastructure using Terraform, We need to have main.tf (can be renamed)  file in root folder. The file will contain a **terraform** block & **provider** block, which are important. These block will contain information of provider, organization etc.  You can make a separate file for this. 
There is also a file called **variables.tf**. This file will contain various variables & default values , which we can set in locally , or as secret in pipelines.

## _S3_
For creating S3 bucket, Please follow the S3 folder. This folder contains 2 file. For consistency purpose, we have named these file **main.tf**, **variables.tf**. As name suggest , **main.tf** will contain code for creating S3 bucket, **variables.tf** will contain different variables for S3 bucket.


## _Cognito_
For creating Cognito user pool, please follow the cognito folder. This folder contains 3 files. For consistency purpose, we have named these file **main.tf**, **variables.tf**, **iam.tf**. As name suggest , **main.tf** will contain code for creating cognito, **variables.tf** will contain different variables for cognito. **iam.tf** contains iam role for SNS. 
For creating federate identity, we need to add the commented code with proper IAM role.