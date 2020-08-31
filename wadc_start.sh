#!/bin/bash

kill $(ps -aux | grep wssh | awk '{print $2}' )

wssh  --certfile='certs/server.crt' --keyfile='certs/server.key' --address='127.0.0.1' --port=54321 --sslport=65432 --log-file-prefix='public/log/wssh.log' --xheaders=False &

rails server



