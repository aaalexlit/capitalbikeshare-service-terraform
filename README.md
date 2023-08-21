# Local development
to make localstack work with terraform we need to use `terraform-local`
more info here
https://docs.localstack.cloud/user-guide/integrations/terraform/

Conda environment created in the [main repo](https://github.com/aaalexlit/capitalbikeshare-mlops) needs to be activated (eg it has pipenv already installed and uses a proper python version):

```shell
conda activate capitalbikeshare-mlops
```

```shell
pipenv install
```

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
aws --endpoint-url=http://localhost:4566 s3 mb s3://terraform-state-mlops-zoomcamp
```

Check that the bucket is there just in case
```shell
aws --endpoint-url=http://localhost:4566 s3 ls
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

See the plan
```shell
tflocal plan -var-file="environments/${TF_ENV}/environment.tfvars"
```

Apply 

```shell
tflocal apply -var-file="environments/${TF_ENV}/environment.tfvars"
```

Destroy

```shell
tflocal destroy -var-file="environments/${TF_ENV}/environment.tfvars"
```
