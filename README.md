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
* ruby

# Usage
1. `mkdir 'yourRailsApp' && cd 'yourRailsApp'`
1. `git clone https://github.com/bluefalcon26/docker-rails.git ./`
2. (optional, to build images with latest stable ruby/rails)

    `docker build [--build-arg http_proxy=$http_proxy] [--build-arg https_proxy=$https_proxy] -t daprejean/rails:latest .`
3. `git clone <yourRailsApp> ./railsApp`
4. `./generate_env.sh [-p http_proxy] [-u local_user_id] [-g local_group_id] [-n container_name] [-p external_port] [-e rails_env] [-s secret_key_base]`
5. Edit .env as necessary
6. `docker-compose up`
7. If rails starts sucessfully, ctl+c and run
    
    `docker-compose start`
8. To restart the server, use `docker-compose restart` or stop/start.

    This will run `bundle` and `assets:precompile` before starting the rails server.

# Setting up a new rails instance
You may want to do some initial setup if this is the first time your using the database, etc. In this case you can run

`docker ps`

to find the name of your container if it is running, or

`docker ps -a`

to find the name of your container if it is stopped.
Then, use

`docker exec -it <containerName> bash`

to access the machine and do things like

`rake db:seed`

Note, you will have root access on the machine this way, so be careful! If you change the ownership of critical files to root, the rails user will fail!

# Checking the docker logs
Use `docker-compose logs -f` to attach to the machine's output.
Then ctl+c to detach without stopping the machine.

# Non-root setup
You don't need root for any of this setup, as long as your user is a member of group "docker".
For more info, see http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
