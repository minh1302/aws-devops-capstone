# FROM python:3.7-alpine3.11

# # hadolint ignore=DL3002
# USER root
# # Create a working directory
# WORKDIR /app

# # Copy source code to working directory
# COPY . backend /app/

# WORKDIR /app/backend

# # Install dependencies
# # hadolint ignore=DL3018,DL3013
# RUN pip install --no-cache-dir --upgrade pip &&\
# # hadolint ignore=DL3018
#     apk add --no-cache --update nodejs npm curl
# # hadolint ignore=DL3016
# RUN npm install &&\
#     npm install pm2 -g

# # Build backend
# RUN npm run lint &&\
#     npm run build

# # Expose port 3030
# EXPOSE 3030

# ENTRYPOINT ["pm2", "start", "dist/main.js", "--name", "npm", "-i", "max"]


FROM ubuntu:20.04

# hadolint ignore=DL3002
USER root
# Create a working directory
WORKDIR /app

# Copy source code to working directory
COPY . backend /app/

WORKDIR /app/backend

# Install dependencies
# hadolint ignore=DL3018,DL3013,DL3008,DL3009,DL3015
RUN apt-get update && \
    apt-get install -y tzdata && \
    # hadolint ignore=DL3018
    apt-get -y install python3-pip && \
    pip3 --version
    
# hadolint ignore=DL3008,DL3015
RUN apt-get -y install nodejs npm

# hadolint ignore=DL3016
RUN npm install &&\
    npm install pm2 -g

# Build backend
RUN npm run lint &&\
    npm run build

# Expose port 3030
EXPOSE 3030

RUN pm2 startup &&\
    pm2 start dist/main.js --name "npm" -i max &&\
    pm2 save &&\
    pm2 ls

ENTRYPOINT ["pm2", "start", "dist/main.js", "--name", "npm", "-i", "max"]