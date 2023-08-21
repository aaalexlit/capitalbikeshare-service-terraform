docker compose up -d

sleep 15

awslocal s3 mb s3://terraform-state-mlops-zoomcamp
export TF_ENV="stg"

tflocal init -reconfigure -backend-config=environments/${TF_ENV}/backend.config

tflocal plan -target=aws_ecr_repository.prediction_service_ecr_repo -var-file="environments/${TF_ENV}/environment.tfvars" -out=ecr_repo.tfplan
tflocal apply ecr_repo.tfplan

image_name_with_tag="$(tflocal output -raw ecr_repository_url):latest"
docker tag capitalbikeshare-service-prediction-service:latest $image_name_with_tag
docker push $image_name_with_tag

# tflocal state rm aws_ecs_task_definition.service_task

tflocal apply -auto-approve -var-file="environments/${TF_ENV}/environment.tfvars"

sleep 15

actual=$(curl http://localhost/healthcheck)
expected='{"status": "ok"}'

if [ ! "$expected" == "$actual" ]; then
    return 1
fi

curl -X POST http://localhost/predict -H "Content-Type: application/json" -d '{"start_station_id": "31205","end_station_id": "31239","rideable_type": "docked_bike","member_casual": "member","started_at": "2020-04-06 07:54:59"}'

tflocal destroy -auto-approve -var-file="environments/${TF_ENV}/environment.tfvars"

docker compose down -v

rm -rf .terraform
rm .terraform.lock.hcl