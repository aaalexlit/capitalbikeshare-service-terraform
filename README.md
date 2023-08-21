# Local development
to make localstack work with terraform we need to use `terraform-local`
more info here
https://docs.localstack.cloud/user-guide/integrations/terraform/

Also, for convenience we'll install `awslocal` command  
https://docs.localstack.cloud/user-guide/integrations/aws-cli/

Conda environment created in the [main repo](https://github.com/aaalexlit/capitalbikeshare-mlops) needs to be activated (eg it has pipenv already installed and uses a proper python version):

```shell
conda activate capitalbikeshare-mlops
```

To have both `tflocal` and `awslocal` available:
```shell
pipenv install
pipenv shell
```

To test everything locally you can just run 
**Important**
For this to run you need to have a docker image `capitalbikeshare-service-prediction-service:latest` defined in the [service repo](https://github.com/aaalexlit/capitalbikeshare-service) built locally  
Also make sure that the port 80 is available

```shell
./test-infra.sh
```

It will execute all the following steps:

To be able to use localstack-pro image that supports ECR and ECS one needs to sign up for
localstack free trial and have an environment variable `LOCALSTACK_API_KEY` set.
On Mac/Linux:
```shell
export LOCALSTACK_API_KEY=<your_localstack_api_key>
```
Then we need to spin up container with localstack

```shell
docker compose up -d
```

First we need to make a bucket manually to hold the tfstate

Make bucket
```shell
awslocal s3 mb s3://terraform-state-mlops-zoomcamp
```

Check that the bucket is there just in case
```shell
awslocal s3 ls
```

Export environment name that we wish to work with. For instance, `stg`

```shell
export TF_ENV="stg"
```
To init tflocal with the corresponding s3 backend configuration (for staging/prod)
Eg the following will do the init with the staging backend
```shell
tflocal init -reconfigure -backend-config=environments/${TF_ENV}/backend.config
```

First we need to create only ECR repo to be able to push an image
```shell
tflocal plan -target=aws_ecr_repository.prediction_service_ecr_repo -var-file="environments/${TF_ENV}/environment.tfvars" -out=ecr_repo.tfplan
tflocal apply ecr_repo.tfplan
```


Tag existing image (built in the other repo) and push to the ECR
```shell
image_name_with_tag="$(tflocal output -raw ecr_repository_url):latest"
docker tag capitalbikeshare-service-prediction-service:latest $image_name_with_tag
docker push $image_name_with_tag
```

See the plan
```shell
tflocal plan -var-file="environments/${TF_ENV}/environment.tfvars"
```

Apply (needs confirmation)

```shell
tflocal apply -var-file="environments/${TF_ENV}/environment.tfvars"
```

Run healthcheck
```shell
curl http://localhost/healthcheck
```

Run prediction
```shell
curl -X POST http://localhost/predict -H "Content-Type: application/json" -d '{"start_station_id": "31205","end_station_id": "31239","rideable_type": "docked_bike","member_casual": "member","started_at": "2020-04-06 07:54:59"}'

```

Destroy (needs confirmation)

```shell
tflocal destroy -var-file="environments/${TF_ENV}/environment.tfvars"
```

# Deploy on AWS

Follow the [create-aws-infra.sh](create-aws-infra.sh) script