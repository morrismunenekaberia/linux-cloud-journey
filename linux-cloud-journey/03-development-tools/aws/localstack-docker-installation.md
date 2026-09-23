# Docker and LocalStack Installation

## Purpose

This setup provides a local environment for learning and developing with AWS services without needing to create the resources directly in AWS.

The setup uses:

* **Docker** — runs LocalStack in a container.
* **Docker Compose** — manages Docker-based applications and containers.
* **Node.js/npm** — used to install the LocalStack CLI.
* **LocalStack CLI (`lstk`)** — manages the LocalStack environment.
* **LocalStack** — provides local emulation of AWS services.
* **AWS CLI** — provides terminal commands for interacting with AWS and LocalStack.

---

## 1. Docker

Docker is used to run LocalStack inside a container.

### Verify Docker

```bash
docker --version
```

Check running containers:

```bash
docker ps
```

Docker should be running before starting LocalStack.

---

## 2. Docker Compose

Docker Compose is used to define and manage multi-container Docker applications.

### Verify Docker Compose

```bash
docker compose version
```

Installed version:

```text
Docker Compose v5.5.1
```

---

## 3. LocalStack CLI

The LocalStack CLI is installed using npm.

### Installation

```bash
npm install -g @localstack/lstk
```

### Verify installation

```bash
lstk --version
```

Installed version:

```text
lstk 1.1.0
```

### Purpose

The `lstk` command is used to manage LocalStack from the terminal.

Examples:

```bash
lstk start
```

Starts LocalStack.

```bash
lstk logs --follow
```

Displays LocalStack logs.

---

## 4. Start LocalStack

Start the LocalStack environment:

```bash
lstk start
```

The LocalStack CLI downloads and starts the LocalStack Docker image.

The LocalStack AWS endpoint is:

```text
127.0.0.1:4566
```

LocalStack runs inside Docker and provides local versions of AWS services.

---

## 5. Verify LocalStack

Check the Docker container:

```bash
docker ps
```

The LocalStack container should show a healthy status.

Example:

```text
localstack-aws
```

Check the LocalStack health endpoint:

```bash
curl http://127.0.0.1:4566/_localstack/health
```

This displays the AWS services available through the LocalStack environment.

---

## 6. AWS CLI LocalStack Profile

When LocalStack is started using the CLI, a LocalStack AWS profile is created.

Check the profile:

```bash
aws configure list --profile localstack
```

The profile contains local credentials and configuration used to communicate with LocalStack.

Example:

```text
profile    : localstack
access_key : test
secret_key : test
region     : us-east-1
```

### Using the LocalStack profile

AWS CLI commands can be directed to LocalStack with:

```bash
--profile localstack
```

For example:

```bash
aws --profile localstack s3 ls
```

---

# How the Setup Works

The components work together as follows:

```text
AWS CLI
   │
   │ --profile localstack
   ▼
LocalStack
   │
   │ runs inside
   ▼
Docker Container
   │
   └── Local AWS Services
       ├── S3
       ├── Lambda
       ├── DynamoDB
       ├── SQS
       ├── SNS
       └── Other AWS services
```

## Summary

| Component            | Purpose                                       |
| -------------------- | --------------------------------------------- |
| Docker               | Runs LocalStack in a container                |
| Docker Compose       | Manages Docker applications                   |
| npm                  | Installs the LocalStack CLI                   |
| `lstk`               | Starts and manages LocalStack                 |
| LocalStack           | Provides AWS services locally                 |
| AWS CLI              | Interacts with AWS services from the terminal |
| `localstack` profile | Directs AWS CLI commands to LocalStack        |

## Important Endpoint

LocalStack runs locally on:

```text
http://127.0.0.1:4566
```

This environment is primarily used for **local AWS learning, development, and testing** before working with real AWS resources.
