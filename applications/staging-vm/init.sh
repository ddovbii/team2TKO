#!/usr/bin/env bash

set -e  # Stop Script on Error

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

apt-get update -y

echo '==> Install nginx'
apt-get install nginx -y

if [ "$TENANT" != "none" ]  # if not 'none' configure NGINX
then
    echo '==> Configure nginx'
    cd /etc/nginx/sites-available/
    cp default default.backup  # backup default config

    cat << EOF > ./default
server {
    listen 444;
    server_name _;
    return 200;

}
EOF
    # restart nginx
    echo '==> Restart nginx'
    systemctl restart nginx
fi

    # location = / {
    #     return 302 https://$TENANT.$Domain/InformRMS/;
    # }
    # location / {
    #     return 302 https://$TENANT.$Domain\$request_uri;
    # }