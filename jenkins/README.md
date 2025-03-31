# Demo .NET Jenkins Pipeline

The task was outlined as follows:

### CI/CD Pipeline
* Create a Jenkinsfile for a dotnet project
* The pipeline should include stages for build, test and deploy.
* Use a sample application or script for demonstration purposes.
    * https://github.com/dodyg/practical-aspnetcore/tree/net6.0/projects/testing/nunit-1

The pipeline definition is in the file `Jenkinsfile` and can be run in a test Jenkins environment as follows:

```
$ cd test
$ docker compose up --build -d
``` 

You can then open a preconfigured Jenkins test environment by visiting http://localhost:8080/

Run the job DotNetPipeline and it will pull the Jenkinsfile on the main branch of this repo and execute the pipeline.

To stop the Jenkins test environment:

```
$ docker compose down -v
```
