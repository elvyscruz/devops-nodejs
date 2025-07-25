# Demo Devops NodeJs

[![CI/CD Pipeline](https://github.com/elvyscruz/devops-nodejs/actions/workflows/ci.yml/badge.svg)](https://github.com/elvyscruz/devops-nodejs/actions/workflows/ci.yml)
[![codecov](https://codecov.io/github/elvyscruz/devops-nodejs/graph/badge.svg?token=980105DUIE)](https://codecov.io/github/elvyscruz/devops-nodejs)
[![SonarCloud](https://sonarcloud.io/api/project_badges/measure?project=elvyscruz_devops-nodejs&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=elvyscruz_devops-nodejs)

---

This is a simple application to be used in the technical test of DevOps.

## Getting Started

### Prerequisites

- Node.js 18.15.0

### Installation

Clone this repo.

```bash
git clone https://bitbucket.org/devsu/demo-devops-nodejs.git
```

Install dependencies.

```bash
npm i
```

### Database

The database is generated as a file in the main path when the project is first run, and its name is `dev.sqlite`.

Consider giving access permissions to the file for proper functioning.

## Usage

To run tests you can use this command.

```bash
npm run test
```

To run locally the project you can use this command.

```bash
npm run start
```

Open http://localhost:8000/api/users with your browser to see the result.

### Running with Docker

You can also build and run this application using Docker.

First, build the Docker image:

```bash
docker build -t devops-nodejs-app .
```

Then, run the container:

```bash
docker run -p 8000:8000 -d --name my-app --env-file .env my-app
```

### Local Kubernetes Deployment

Preqrequisites:

- Docker Desktop with Kubernetes installed
- Kubectl
- Ngrok installed and configured

Follow these steps:

a) Create a namespace

```bash
kubectl create namespace github-actions
```

b) Create a service account:

```bash
kubectl create sa github-actions-sa -n github-actions

```

c) Asign permissions to the service account:

```bash
kubectl create role deploy-role \
  --namespace=github-actions \
  --verb=create,get,list,update,delete \
  --resource=deployments,services,pods,configmaps,secrets

kubectl create rolebinding github-actions-binding \
  --namespace=github-actions \
  --role=deploy-role \
  --serviceaccount=github-actions:github-actions-sa
```

d) Create a Secret Token

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: github-actions-token
  namespace: github-actions
  annotations:
    kubernetes.io/service-account.name: github-actions-sa
type: kubernetes.io/service-account-token
EOF

```

e) Extract token

```bash
kubectl get secret github-actions-token -n github-actions -o jsonpath='{.data.token}' | base64 --decode
```

f) Expose local kubernetes api using Ngrok

```bash
ngrok tcp 6443
```

g) Setup kubeconfig for remote access

```bash
kubectl config set-cluster local --server=<ngrok-url> --insecure-skip-tls-verify
kubectl config set-credentials github-actions --token=<SERVICE_ACCOUNT-TOKEN>
kubectl config set-context local --cluster=local --user=github-actions-user
kubectl config use-context local
```

h) Verifiy context:

```bash
kubectl --context=local get pods
```

i) Create secret KUBE_CONFIG in github actions with ~/.kube/config file content and run github actions pipeline

### Terraform AWS Deployment

Preqrequisites:

- Terraform installed
- AWS CLI installed

```bash
    cd terraform
    aws configure
    terraform init
    terraform plan
    terraform apply
```

### Features

These services can perform the following features:

- User listing – Get a list of all users.
- User details – View specific user information by ID.
- User creation – Add new users to the system.
- User update – Modify existing user data.
- User deletion – Remove users from the system.
- JSON format – Input and output data is in JSON.

#### Create User

To create a user, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: POST
```

```json
{
  "dni": "dni",
  "name": "name"
}
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
  "id": 1,
  "dni": "dni",
  "name": "name"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
  "error": "error"
}
```

#### Get Users

To get all users, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
[
  {
    "id": 1,
    "dni": "dni",
    "name": "name"
  }
]
```

#### Get User

To get an user, the endpoint **/api/users/<id>** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
  "id": 1,
  "dni": "dni",
  "name": "name"
}
```

If the user id does not exist, we will receive status 404 and the following message:

```json
{
  "error": "User not found: <id>"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
  "errors": ["error"]
}
```

## License

Copyright © 2023 Devsu. All rights reserved.
