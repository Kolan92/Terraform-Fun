# Terraform Fun

Project to learn a bit about terraform and digital ocean

Steps to run:

1. `terraform init` - installs necessary plugin
2. `terraform plan -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa"` - shows what resources will be deployed
3. `terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa"` - deploys resources
4. `terraform plan -destroy -out=terraform.tfplan -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa"` - creates plan to destroy resources
5. `terraform apply terraform.tfplan` - applies plan (with destroy for example)

## [Droplet](./droplet)

Based on: https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean

## [Kubernetes](./kubernetes)

Based on: https://www.padok.fr/en/blog/digitalocean-kubernetes

## [Kubernetes single node pool](./kubernetes-single-node-pool)
Based on: https://www.padok.fr/en/blog/digitalocean-kubernetes, but with only single node

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%202.svg)](https://www.digitalocean.com/?refcode=535e301fb388&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)