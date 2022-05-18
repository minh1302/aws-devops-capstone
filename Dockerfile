FROM circleci/node:13.8.0

# hadolint ignore=DL3002
USER root
# Create a working directory
WORKDIR /app

# Copy source code to working directory
COPY . backend /app/

WORKDIR "/app/backend"

# Install dependencies
# hadolint ignore=DL3016
RUN npm install &&\
    npm run lint &&\
    npm install pm2 -g

# Build backend
RUN npm run lint &&\
    run build

# Expose port 3030
EXPOSE 3030

# Run backend
RUN pm2 start dist/main.js --name "npm" -i max