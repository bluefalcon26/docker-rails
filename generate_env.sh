#!/bin/bash

# generate_env - generates local .env file for docker-compose

set -e

# USAGE
function usage
{
  echo "TODO"
}

# 0. SET ARGUMENTS

arg_http_proxy=
arg_local_user_id=
arg_local_group_id=
arg_rails_name=
arg_rails_external_port=
arg_rails_run_env=
arg_rails_secret_key_base=
while [ -n "$1" ]; do
  case $1 in
    -p | --http-proxy )     shift
                            arg_http_proxy=$1
                            ;;
    -u | --user )           shift
                            arg_local_user_id=$1
                            ;;
    -g | --group )          shift
                            arg_local_group_id=$1
                            ;;
    -n | --name )           shift
                            arg_rails_name=$1
                            ;;
    -p | --port )           shift
                            arg_rails_external_port=$1
                            ;;
    -e | --environment )    shift
                            arg_rails_run_env=$1
                            ;;
    -s | --secret )         shift
                            arg_rails_secret_key_base=$1
                            ;;
    -h | --help )           usage
                            exit
                            ;;
    * )                     usage
                            exit 1
  esac
  shift
done

# WARNING: WILL OVERWRITE
if [ -f .env ]; then
  read -r -n 1 -p "Overwrite existing .env file? " REPLY
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    : # pass through
  else
    echo "aborting"
    exit 1 || return 1
  fi
fi

# 1. HTTP_PROXY
# Default: blank
if [ -n "$arg_http_proxy" ]; then
  echo "HTTP_PROXY=$arg_http_proxy" > .env
  echo "HTTPS_PROXY=$arg_http_proxy" >> .env
elif [ ! $HTTP_PROXY = "" ]; then
  echo "HTTP_PROXY=$HTTP_PROXY" > .env
  echo "HTTPS_PROXY=$HTTPS_PROXY" >> .env
elif [ ! $http_proxy = "" ]; then
  echo "HTTP_PROXY=$http_proxy" > .env
  echo "HTTPS_PROXY=$https_proxy" >> .env
else
  echo "HTTP_PROXY=" > .env
  echo "HTTPS_PROXY=" >> .env
fi

# 2. LOCAL_USER_ID
# Default: *current user id
if [ -n "$arg_local_user_id" ]; then
  echo "LOCAL_USER_ID=$arg_local_user_id" >> .env
elif [ ! $LOCAL_USER_ID = "" ]; then
  echo "LOCAL_USER_ID=$LOCAL_USER_ID" >> .env
else
  echo "LOCAL_USER_ID=$(id -u)" >> .env
fi

# 3. LOCAL_GROUP_ID
# Default: *current group id
if [ -n "$arg_local_group_id" ]; then
  echo "LOCAL_GROUP_ID=$arg_local_group_id" >> .env
elif [ ! $LOCAL_GROUP_ID = "" ]; then
  echo "LOCAL_GROUP_ID=$LOCAL_GROUP_ID" >> .env
else
  echo "LOCAL_GROUP_ID=$(id -g)" >> .env
fi

# 4. RAILS_NAME
# Default: *current directory name
if [ -n "$arg_rails_name" ]; then
  echo "RAILS_NAME=$arg_rails_name" >> .env
elif [ ! $RAILS_NAME = "" ]; then
  echo "RAILS_NAME=$RAILS_NAME" >> .env
else
  echo "RAILS_NAME=rails_${PWD##*/}" >> .env
fi

# 5. RAILS_EXTERNAL_PORT
# Default: 3000
if [ -n "$arg_rails_external_port" ]; then
  echo "RAILS_EXTERNAL_PORT=$arg_rails_external_port" >> .env
elif [ ! $RAILS_EXTERNAL_PORT = "" ]; then
  echo "RAILS_EXTERNAL_PORT=$RAILS_EXTERNAL_PORT" >> .env
else
  echo "RAILS_EXTERNAL_PORT=3000" >> .env
fi

# 6. RAILS_RUN_ENV
# Default: development
if [ -n "$arg_rails_run_env" ]; then
  echo "RAILS_RUN_ENV=$arg_rails_run_env" >> .env
elif [ ! $RAILS_RUN_ENV = "" ]; then
  echo "RAILS_RUN_ENV=$RAILS_RUN_ENV" >> .env
else
  echo "RAILS_RUN_ENV=development" >> .env
fi

# 7. RAILS_SECRET_KEY_BASE
# Default: *generate new secret with \rake secret\
if [ -n "$arg_rails_secret_key_base" ]; then
  echo "RAILS_SECRET_KEY_BASE=$arg_rails_secret_key_base" >> .env
elif [ ! $RAILS_SECRET_KEY_BASE = "" ]; then
  echo "RAILS_SECRET_KEY_BASE=$RAILS_SECRET_KEY_BASE" >> .env
elif [ $(command -v ruby) ]; then
  echo "RAILS_SECRET_KEY_BASE=$(ruby -e 'require "securerandom"' -e 'puts SecureRandom.hex 64')" >> .env
else
  echo "RAILS_SECRET_KEY_BASE=" >> .env
fi

exit 0
