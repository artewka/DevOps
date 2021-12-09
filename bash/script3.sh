#!/bin/bash

echo -e "Choose options:\nnginx status(1)\nnginx maintaining(2)"
read choose

if [[ $choose == "1" ]]; then
  systemctl status nginx
elif [[ $choose == "2" ]]; then

echo "Start nginx maintaining....."


backup_cfg() {

  nginx -t &> /dev/null
  if [ $?  -eq 0 ]; then
    cp -r /etc/nginx/* /var/backups/nginx
    echo "Start backup..."
  else
    echo "wrong nginx configuration!"
  fi

 }


nginx_restart() {

    systemctl restart nginx
    echo "nginx is restarted...."

 }

nginx_check() {

RUN="$(systemctl is-active nginx.service)"

    if [ "${RUN}" == "active" ]; then
        echo "Restoring....."
        cp -a /var/backups/nginx/* /etc/nginx/
        echo "Restart nginx...."
        nginx_restart
      else
        echo "Try to start nginx...."
        nginx_restart
        sleep 60
        nginx_check
     fi

}


fi

cron() {

 sudo /bin/bash -c 'echo "5 0 * * * root /home/artem.yakymchuk/script3.sh" >> /etc/crontab'

}

backup_cfg
nginx_check
cron

echo "Nginx active..."

