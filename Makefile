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
# 	brew install minikube
	
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
	docker container run -it minh1302/aws-devops-capstone /bin/bash
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