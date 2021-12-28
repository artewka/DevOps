#!/bin/bash
install_packages() {
   sudo apt update
   sudo apt upgrade
   sudo apt install nginx -y
   sudo apt install curl
   echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
   sudo apt install php-fpm -y
   sudo apt install mariadb-server -y
   sudo apt install phpmyadmin -y
   sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
   }
restart_services() {
   sudo systemctl enable nginx
   sudo systemctl restart nginx
   }
install_packages
restart_services