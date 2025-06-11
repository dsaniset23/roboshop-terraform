default:
	rm -rf .terraform
	terraform init -backend-config=env-$(env)/state.tfvars
	terraform $(action) -auto-approve -var-file=env-$(env)/main.tfvars

dev-apply:
	rm -rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars

dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy -auto-approve -var-file=env-dev/main.tfvars

terraform-install:
	sudo curl -L -o /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	sudo yum -y install terraform
