# Artemis service full automation setup

## File structure
```
.               
├── artemis                               # Artemis service
|    ├── main.tf
|    ├── variables.tf
|    ├── terraform.tfvars
|    └── ...
├── module
|   ├── iam
|   ├── acm
|   ├── alb
|   ├── ec2                          
|   ├── efs
|   ├── ecs
|   ├── vpc
|   └── route53
├── play-wright                            # Automation by playwright Jenkins and Gitlab
├── task-definitions
├── volume-config                  
├── services                               # Jenkins and Gitlab service
|    ├── main.tf
|    ├── variables.tf
|    ├── terraform.tfvars
|    └── ...   
├── .gitignore                   
└── README.md
```

Current, I setting up this service in Azure DevOps.... 
