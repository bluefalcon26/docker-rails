# docker-rails

These script provide the basis for building a portable Ruby-on-Rails docker machine and running it through docker-compose.

# Features
* Dockerfile always builds image with latest stable ruby and rails version
* File docker-compose.yml allows the machine to be controlled with docker compose, providing all necessary env variables
* Script to auto-generate the .env file for docker-compose
* Mounts local railsApp folder as a volume, meaning you can check logs on the host machine without accessing the docker machine, etc.
* The docker machine is not privileged, and rails runs as as user "rails" with minimal permissions, for maximum security.

# Dependencies
* git
* docker
* docker-compose

# Usage
1. mkdir 'yourRailsApp' && cd 'yourRailsApp'
1. git clone https://github.com/bluefalcon26/docker-rails.git ./
2. (optional, to build images with latest stable ruby/rails)
    docker build [--build-arg http_proxy=$http_proxy] [--build-arg https_proxy=$https_proxy] -t daprejean/rails:latest .
3. git clone <yourRailsApp> ./railsApp
4. ./generate_env.sh [-p http_proxy] [-u local_user_id] [-g local_group_id] [-n container_name] [-p external_port] [-e rails_env] [-s secret_key_base]
5. docker-compose up
6. If rails starts sucessfully, ctl+c and run docker-compose start
