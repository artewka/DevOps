#!/bin/bash
install_packages() {
   sudo apt update
   sudo apt upgrade
   sudo apt install nginx -y
   sudo apt install curl
   echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
   sudo apt install php-fpm -y
   }
restart_services() {
   sudo systemctl enable nginx
   sudo systemctl restart nginx
   }
install_packages
restart_services