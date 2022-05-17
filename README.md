[![minh1302](https://circleci.com/gh/minh1302/project-ml-microservice-kubernetes.svg?style=svg)](https://app.circleci.com/pipelines/github/minh1302/project-ml-microservice-kubernetes)

## Project Overview

In this project, you will apply the skills you have acquired in this course to operationalize a Machine Learning Microservice API. 

You are given a pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, 
such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. 
You can read more about the data, which was initially taken from Kaggle, 
on [the data source site](https://www.kaggle.com/c/boston-housing). 

This project tests your ability to operationalize a Python flask app—in a provided file, 
`app.py`—that serves out predictions (inference) about housing prices through API calls. 

This project could be extended to any pre-trained machine learning model, 
such as those for image recognition and data labeling.


This project will apply the skills and knowledge of AWS Cloud DevOps . These include:

Working in AWS
Using Circle CI to implement Continuous Integration and Continuous Deployment
Building pipelines
Working with Ansible and CloudFormation to deploy clusters
Building Kubernetes clusters
Building Docker containers in pipelines


Continuous Deployment will include:

Pushing the built Docker container(s) to the Docker repository (AWS ECR, create custom Registry within cluster) ; 
and
Deploying these Docker container(s) to a small Kubernetes cluster (AWS Kubernetes as a Service). 
To deploy your Kubernetes cluster, use either Ansible / Cloudformation. 

Run Continuous Deployment from Circle CI as an independent pipeline.

### Project Goal

The Project goal is to operationalize this working, 
machine learning microservice using [kubernetes](https://kubernetes.io/), 

which is an open-source system for automating the management of containerized applications. 

In this project I will:
* Test  project code using linting
* Complete a Dockerfile to containerize this application
* Deploy containerized application using Docker and make a prediction
* Improve the log statements in the source code for this application
* Configure Kubernetes and create a Kubernetes cluster
* Deploy a container using Kubernetes and make a prediction
* Upload a complete Github repo with CircleCI to indicate that code has been tested


---

## Setup the Environment

* Create a virtualenv with Python 3.7 and activate it. Refer to this link for help on specifying the Python version in the virtualenv. 
```bash
python3 -m pip install --user virtualenv
# You should have Python 3.7 available in your host. 
# Check the Python path using `which python3`
# Use a command similar to this one:
python3 -m virtualenv --python=<path-to-Python3.7> .devops
source .devops/bin/activate
```
* Run `make install` to install the necessary dependencies

### Running `app.py`

1. Standalone:  `python app.py`
2. Run in Docker:  `./run_docker.sh`
3. Run in Kubernetes:  `./run_kubernetes.sh`

### Kubernetes Steps

* Setup and Configure Docker locally
You will need to use Docker to build and upload a containerized application. If you already have this installed and created a docker account, you may skip this step.

1. You’ll need to [create a free docker account](https://hub.docker.com/signup), where you’ll choose a unique username and link your email to a docker account. 
Your username is your unique docker ID.

2. To install the latest version of docker, choose the Community Edition (CE) for your operating system, on [docker’s installation site](https://docs.docker.com/v17.12/install/).
It is also recommended that you install the latest, stable release:

3. After installation, you can verify that you’ve successfully installed docker by printing its version in your terminal: 
```bash
docker --version

* Setup and Configure Kubernetes locally
To run a Kubernetes cluster locally, for testing and project purposes, you need the Kubernetes package, Minikube. 

This operates in a virtual machine and so you will need to download two things: 
    A virtual machine (aka a hypervisor) then minikube. 
    
Thorough installation instructions can be found here. 
Here is how I installed minikube:

1. Install VirtualBox:
    For Mac & Linux:
```bash
brew cask install virtualbox
```
For Windows, I recommend using a [Windows host](https://www.virtualbox.org/wiki/Downloads).

2. Install minikube:
    For Mac & Linux:
```bash
brew cask install minikube
```
For Windows, I recommend using the [Windows installer](https://kubernetes.io/docs/tasks/tools/install-minikube/).

3. Configure Kubernetes to Run Locally

You should have a virtual machine like VirtualBox and minikube installed, 
as per the project environmet instructions. To start a local cluster, type the terminal command: 
```bash
minikube start.
```

After minikube starts, a cluster should be running locally. 
You can check that you have one cluster running by typing ```kubectl config view``` where you should see at least one cluster with a certificate-authority and server.

This is a short task, but it may take some time to configure Kubernetes, and so this deserves its own task number.

### Create Flask app in Container

Complete the following steps to get Docker running locally

1. Step 1: Build image and add a descriptive tag
docker build -t minh1302/udacity-project-3 .

2. Step 2:  List docker images
docker image ls

3. Step 3:  Run flask app
docker run -p 8000:80 minh1302/udacity-project-3

### Run via kubectl

#### Deploy with Kubernetes and Save Output Logs

Now that you’ve uploaded a docker image and configured Kubernetes so that a cluster is running, 
you’ll be able to deploy your application on the Kubernetes cluster. 

This involves running your containerized application using kubectl, 
which is a command line interface for interacting with Kubernetes clusters.
```run_kubernetes.sh```

To deploy this application using kubectl, 
open and complete the file, run_kubernetes.sh:

The steps will be somewhat similar to what you did in both run_docker.sh and upload_docker.sh 
but specific to kubernetes clusters. 
Within run_kubernetes.sh, complete the following steps:


#### Define a dockerpath which will be “/path”
this should be the same name as your uploaded repository (the same as in upload_docker.sh)

#### Run the docker container with kubectl; 
you’ll have to specify the container and the port

#### List the kubernetes pods
Forward the container port to a host port, using the same ports as before
After completing the code, call the script ./run_kubernetes.sh. 
This assumes you have a local cluster configured and running. 
This script should create a pod with a name you specify and you may get an initial output 

#### Initially, your pod may be in the process of being created, 
as indicated by STATUS: ContainerCreating, 
but you just have to wait a few minutes until the pod is ready, then you can run the script again.

#### Waiting: You can check on your pod’s status with a call 
to kubectl get pod and you should see the status change to Running. 
Then you can run the full ./run_kuberenets.sh script again.

#### Make a prediction
After you’ve called run_kubernetes.sh, and a pod is up and running, make a prediction using a separate terminal tab, 
and a call to ./make_prediction.sh, as you did before.
