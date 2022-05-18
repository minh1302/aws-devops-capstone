FROM python:3.7.3-stretch

## Step 1:
# Create a working directory
WORKDIR /app

## Step 2:
# Copy source code to working directory
COPY . app.py /app/

## Step 3:
# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip &&\
    pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

## Step 4:
# Expose port 80
EXPOSE 80

## Step 5:
# Run app.py at container launch
CMD ["python", "app.py"]


---
- name: "upgrade packages"
  become: true
  apt:
    upgrade: "yes"    

- name: "install dependencies"
  become: true
  apt:
    name: ["nodejs", "npm"]
    state: latest
    update_cache: yes
    
- name: "install pm2"
  become: true
  npm:
    name: pm2
    global: yes
    production: yes
    state: present

- name: create folders & install
  become: yes
  shell: |
    cd /home/{{ ansible_user }}
    rm -rf   /home/{{ ansible_user }}/*

    mkdir -p compressed
    mkdir -p extracted

- name: Copy files before extracting
  copy:
    src: "/tmp/artifact.tar.gz"
    dest: "/home/{{ ansible_user }}/compressed/artifact.tar.gz"

- name: Extract found files into destination
  unarchive:
    src: "/home/{{ ansible_user }}/compressed/artifact.tar.gz"
    dest: "/home/{{ ansible_user }}/extracted/"
    remote_src: yes
    
- name: npm install
  become: true
  command: npm install
  args:
    chdir: /home/{{ ansible_user }}/extracted/backend

    
- name: Use pm2 to run backend
  become: true
  command: pm2 start dist/main.js --name "npm" -i max
  args:
    chdir: /home/{{ ansible_user }}/extracted/backend