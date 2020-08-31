# WADC

Se trata de un proyecto de Software Libre que tiene como principal objetivo la configuración de dispositivos independiente del Sistema Operativo. Para ello hace, uso de una estructura de datos llamada Macro, que nos permitirá la automatización de tareas de una forma sencilla e intuitiva basado en el concepto de las funciones de los lenguajes de programación.

 https://wadc.es 


## Installation

Para instalar WADC en la raíz del proyecto (install.sh):

```bash

mkdir certs

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
```

## Usage
 https://wadc.es/blog
 
 Para comenzar a usarlo con el servidor de desarrollo:
```bash

wssh  --certfile='certs/server.crt' --keyfile='certs/server.key' --address='127.0.0.1' --port=54321 --sslport=65432 --log-file-prefix='public/log/wssh.log' --policy=reject

rails server
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
