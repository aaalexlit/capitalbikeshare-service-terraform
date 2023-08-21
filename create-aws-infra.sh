terraform init -reconfigure -backend-config=environments/${TF_ENV}/backend.config

terraform plan -target=aws_ecr_repository.prediction_service_ecr_repo -var-file="environments/${TF_ENV}/environment.tfvars" -out=ecr_repo.tfplan
terraform apply ecr_repo.tfplan

image_name_with_tag=$(terraform output -raw ecr_repository_url)
docker tag capitalbikeshare-service-prediction-service:latest $image_name_with_tag

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-west-2.amazonaws.com"

docker push $image_name_with_tag

terraform apply -var-file="environments/${TF_ENV}/environment.tfvars"

sleep 60

# test the service
app_url="http://$(terraform output -raw app_url)"
curl "${app_url}/healthcheck"
curl -X POST "${app_url}/predict" -H "Content-Type: application/json" -d '{"start_station_id": "31205","end_station_id": "31239","rideable_type": "docked_bike","member_casual": "member","started_at": "2020-04-06 07:54:59"}'

# destroy everything

terraform destroy -var-file="environments/${TF_ENV}/environment.tfvars"
