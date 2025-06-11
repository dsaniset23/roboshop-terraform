default:
	rm -rf .terraform
	terraform init -backend-config=env-$(env)/state.tfvars
	terraform $(action) -auto-approve -var=env-$(env)/main.tfvars

dev-apply:
	rm - rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var=env-dev/main.tfvars

dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy - auto-approve