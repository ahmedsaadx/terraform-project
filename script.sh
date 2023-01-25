sudo apt update -y
sudo apt install -y nginx
echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://'$1'; \n  } \n}' > default
sudo mv default /etc/nginx/sites-enabled/default
sudo systemctl stop nginx
sudo systemctl start nginx