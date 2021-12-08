#!/bin/bash

#Password generator with command-line parameters


len=10
symb=N

get_password () {
 
 if [[ $symb == "Y" ]]; then
    tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c $len;
  elif [[ $symb == "N" ]]; then
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c $len; 
  else 
    echo " wrong instruction "
  fi

}

echo -e "Your password is:\n$(get_password) "
