## The Makefile includes instructions on environment setup and lint tests

# setup-hadolint:
# 	sudo apt install linuxbrew-wrapper
# 	brew install hadolint
# 	export PATH="/home/${USER}/.linuxbrew/bin:${PATH}"
# 	. ~/.bashrc

# setup-virtualbox:
# 	sudo apt-get update
# 	sudo apt-get install virtualbox

# setup-minikube:
#     wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
#     cp minikube-linux-amd64 /usr/local/bin/minikube
#     chmod 755 /usr/local/bin/minikube
#     minikube version

# setup-kubectl:
#     curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
#     chmod +x ./kubectl
#     mv ./kubectl /usr/local/bin/kubectl
#     kubectl version -o json
	
install:
	# This should be run from inside a virtualenv
	pip3 install --upgrade pip
	sudo apt install nodejs npm
	cd ./backend
	sudo npm install -g n
	sudo npm install pm2 -g
	sudo wget -O /bin/hadolint "https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64" &&\
	sudo chmod +x /bin/hadolint

test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	hadolint Dockerfile
	
	# # lint frontend
	# cd ./frontend
	# npm install
	# npm run lint
	
	# # lint backend
	# cd ./backend
	# npm install
	# npm run lint

build-backend:
	cd ./backend
	npm install
	npm run lint
	npm run build

build-frontend:
	cd ./frontend
	npm install
	npm run lint
	npm run build

build: build-backend build-frontend

all: install lint build test

docker-build:
	# Build image and add a descriptive tag
	docker build -t minh1302/aws-devops-capstone .

docker-run:
	# List docker images
	docker image ls
	
	# Run backend
	docker run -p 3030:3030 minh1302/aws-devops-capstone

docker-run-it:
	docker container run -it minh1302/aws-devops-capstone /bin/sh
	# Remote backend to check backend status
	# pm2 list
	# pm2 logs npm
	# sudo apt install net-tools
	#  netstat -na | grep 3030

docker-upload:
	dockerpath=minh1302/aws-devops-capstone
	
	# Step 2:  
	# Authenticate & tag
    # docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
	docker login
	echo "Docker ID and Image: $dockerpath"
	
	# Step 3:
	# Push image to a docker repository
	docker push "$dockerpath"
	
minikube-start:
	# To start a local cluster, type the terminal command:

	minikube start
	
	# After minikube starts, a cluster should be running locally. 
	# You can check that you have one cluster running by typing kubectl config view 
	# where you should see at least one cluster with a certificate-authority and server.
	kubectl config view
	
minikube-deploy:
	# This is your Docker ID/path
	dockerpath=minh1302/aws-devops-capstone
	
	# Step 2
	# Run the Docker Hub container with kubernetes
	kubectl get nodes
	kubectl create deploy aws-devops-capstone --image=minh1302/aws-devops-capstone
	
	# Step 3:
	# List kubernetes pods
	kubectl get deploy,rs,svc,pods
	
minikube-status:
	kubectl get deploy,rs,svc,pods
	
minikube-forward:	
	# Forward the container port to a host
	kubectl port-forward deployment/aws-devops-capstone --address 0.0.0.0 3030:3030

minikube-bash:
	kubectl exec --stdin --tty deployment/aws-devops-capstone -- /bin/bash

minikube-delete-pod:
	kubectl delete deployment/aws-devops-capstone
minikube-delete:
	minikube delete