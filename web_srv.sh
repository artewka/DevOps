#!/bin/bash
install_packages() {
   sudo apt update
   sudo apt install nginx -y
   sudo apt install php-fpm -y
   }
restart_services() {
   sudo systemctl enable nginx 
   sudo systemctl restart nginx
   }
install_packages
restart_services
