#!/bin/bash

openssl genrsa -out certs/server.key 2048
openssl rsa -in certs/server.key -out certs/server.key
openssl req -sha256 -new -key certs/server.key -out certs/server.csr -subj '/CN=localhost'
openssl x509 -req -sha256 -days 365 -in certs/server.csr -signkey certs/server.key -out certs/server.crt

if ! pip list | grep  webssh ;
then
   pip install webssh -y
fi

sudo apt-get update

sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties -y

sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev -y

#https://github.com/rvm/ubuntu_rvm
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s stable --rails

rvm install 2.2.4

rvm use 2.2.4

gem install bundler:1.16.1 --force

gem install builder

bundle install

rails db:migrate

rails db:seed