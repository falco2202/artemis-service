# Artemis service full automation setup

## File structure
```
.
├── .github
|    ├── workflows                   
|    |      ├── artemis.yml               
|    |      ├── build.yml                 
|    |      ├── setup.yml                
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

## Usage guide
Create or update the secret key in GitHub repository
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` of AWS your account
- `GH_TOKEN`, you create with github cli by command `gh auth token`.
- `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `GITLAB_USERNAME`, `GITLAB_PASSWORD`, `JENKINS_USERNAME` and `JENKINS_PASSWORD`
- `GITLAB_URL` and `JENKINS_URL`. Example: `example.com`
-  Create `private key` and `public key` using `ssh-keygen`. After that, update in secret key `PRIVATE_KEY` and `PUBLIC_KEY`

* Note: Repository setup auto setup when change in `main` branch. You can set it up in repository by manually when you click in Actions `build.yml`
