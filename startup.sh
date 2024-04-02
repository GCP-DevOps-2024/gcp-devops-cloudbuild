#!/bin/sh
sudo apt-get update && sudo apt -y install nginx


echo '<!doctype html><html><body><h1>This webserver was deployed on GCP with Terraform!</h1></body></html>' | sudo tee /var/www/html/index.html
