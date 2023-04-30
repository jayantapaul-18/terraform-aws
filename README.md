[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://gitlab.com/ai-cicd/api-project)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.1.1-yellow.svg?style=flat-square)](https://conventionalcommits.org)
[![Terraform](https://img.shields.io/badge/terraform-1.3.7-purple.svg?style=flat-square)](https://github.com/hashicorp/terraform)

# Terraform AWS Development

Installed terraform in local

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

```bash
git remote add terraform-aws git@github.com:jayantapaul-18/terraform-aws.git
git clone https://github.com/jayantapaul-18/terraform-aws.git
cd terraform-aws

```

# Terraform command

Here are the command terraform `init` , `validate`, `plan` ,`apply` & `destroy`. which will create the AWS resources .

```bash
terraform init
terraform validate
terraform plan
terraform state list
terraform apply -refresh-only
terraform apply -auto-approve
terraform destroy
```

# Terraform import

```bash
terraform import aws_instance.demoinstance i-09a55e81b0b8b3cea
terraform import aws_key_pair.aws_deployer_key aws-deployer-key
```

# TF import Response

```javascript
aws_instance.demoinstance: Importing from ID "i-09a55e81b0b8b3cea"...
aws_instance.demoinstance: Import prepared!
  Prepared aws_instance for import
aws_instance.demoinstance: Refreshing state... [id=i-09a55e81b0b8b3cea]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

# public key in Terraform for AWS

To set up a public key in Terraform for AWS, we need to use the aws_key_pair resource. Here are the steps to follow:

Create an SSH key pair using the ssh-keygen command. For example, to create a key pair named aws-developer-key-pair, run the following command:

```bash
ssh-keygen -t rsa -b 4096 -C "aws-developer-key" -f aws-developer-key

```

- This will create two files in the current directory: `aws-developer-key` (private key) and `aws-developer-key.pub` (public key).

- Now setup our Terraform code, define an `aws_key_pair` resource with the name of the key pair, and the public key file as the `public_key` attribute. Here is an example: `aws_developer_key`

```javascript

resource "aws_key_pair" "aws_deployer_key" {
  key_name   = var.key_name
  public_key = file("${path.module}/aws-developer-key.pub")
}

```

- This will create a new key pair with the name `aws-developer-key` in our AWS account, and associate the public key file with it.
- This will launch a new instance with the specified AMI and instance type, and associate the aws-developer-key pair with it. Now we can use this private key file to SSH into the instance.

## Running pre-commit checks

[pre-commit](https://pre-commit.com) installs git hooks configured in [.pre-commit-config.yaml](.pre-commit-config.yaml)

Install `pre-commit` and `commitizen` to use

```bash
brew install commitizen
brew install pre-commit

pre-commit install
pre-commit install --hook-type commit-msg
pre-commit run --all-files

git add .
git status
pre-commit run --all-files
cz c
git commit -m 'feat: terraform aws resources'
git push origin master --force
```
