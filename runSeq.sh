#!/bin/bash

source vars.sh

./deploy.sh

parallel-scp -h hosts.txt myCA.pem /home/tamal/

parallel-ssh -h hosts.txt -I < client.sh 'bash -s'


