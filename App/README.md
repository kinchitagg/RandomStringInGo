# Code

Simple code in Go that runs a http server at port 8081. The response server return one string from selecting from the 4 values in map. 

# Dockerfile

I have created a multistage build to reduce the size of image. The first stage is builder stage that build a randomstring exec file and later passed to production stage that runs the exec file and exposes the port 8081.


## To Build

Clone the respository and make the relevant changes to Dockerfile.

```bash
  docker build -t ImageName .
```
## To push to ECR

1. Retrieve an authentication token and authenticate your   Docker client to your registry.
Use the AWS CLI: 

Change the account URL to yours

```bash
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 654654309397.dkr.ecr.us-east-1.amazonaws.com
```

2. tag your image so you can push the image to this repository:
```bash
  docker build -t ImageName 654654309397.dkr.ecr.us-east-1.amazonaws.com/ImageName:latest
```
3. Push the image to ECR
```bash
  docker push 654654309397.dkr.ecr.us-east-1.amazonaws.com/ImageName:latest
```

