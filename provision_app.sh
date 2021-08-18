#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# Env Variable
sudo echo 'export DB_HOST=10.202.2.228:27017/posts' >> ~/.bashrc
source ~/.bashrc

# remove the old file and add our one
# sudo rm ~/etc/nginx/sites-available/default
cd /etc
sudo rm -rf default
sudo echo "server{
        listen 80;
        server_name _;
        location / {
          proxy_pass http://18.203.224.222/:3000;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
}" >> default

# finally, restart the nginx service so the new config takes hold
sudo service nginx restart
sudo systemctl enable nginx

cd ..
cd /home/ubuntu

# Reseeds the database
cd ~/app
node seeds/seed.js
node app.js