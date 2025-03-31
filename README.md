# DF Demo Code

There are 4 demo code samples in this repo.

1. Docker Demo
    * [Dockerfile](https://github.com/mangomagic/df-demo/blob/main/docker/Dockerfile) for a sample Python Flask application.
    * See also the [Makefile](https://github.com/mangomagic/df-demo/blob/main/docker/Makefile) and the [cointainer structure tests](https://github.com/mangomagic/df-demo/blob/main/docker/container-structure-test.yaml).

2. CI/CD Pipeline Demo
    * [Jenkinsfile](https://github.com/mangomagic/df-demo/blob/main/jenkins/Jenkinsfile) for a .NET project with stages for build, test and deploy.
    * Sample docker [Jenkins server](https://github.com/mangomagic/df-demo/tree/main/jenkins) to test the pipeline.

3. Infrastructure Provisioning Demo with Terraform
    * Sample [Terraform](https://github.com/mangomagic/df-demo/tree/main/terraform) code to create various S3 buckets


4. Architectural Diagram for a Monolithic .NET Framework Web Application on AWS
    * [Architectural Diagram](https://github.com/mangomagic/df-demo/blob/main/diagram/dotnet-architecture.png)
    * [Diagram Code](https://github.com/mangomagic/df-demo/blob/main/diagram/dotnet-architecture.eraserdiagram) (for [eraser.io](https://www.eraser.io/))