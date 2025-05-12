#!/bin/bash

# Variables passed in
REGUSER=$1
REGPASSWORD=$2

# Docker Registry: Auth, TLS, Compose config
sudo mkdir -p /opt/docker-registry/auth
sudo chown -R 1000:1000 /opt/docker-registry/auth
sudo chmod -R 755 /opt/docker-registry/auth

# Generate htpasswd file
sudo docker run --rm --entrypoint htpasswd httpd:2 -Bbn "$REGUSER" "$REGPASSWORD" | sudo tee /opt/docker-registry/auth/htpasswd

# Write nginx.conf
cat <<NGINX_CONF | sudo tee /opt/docker-registry/nginx.conf
events {}

http {
  client_max_body_size 100M;

  server {
    listen 5000;

    location / {
      proxy_pass http://registry:5000;

      auth_basic "Registry Realm";
      auth_basic_user_file /auth/htpasswd;

      add_header 'Access-Control-Allow-Origin' 'http://localhost:30003' always;
      add_header 'Access-Control-Allow-Methods' 'GET, HEAD, OPTIONS' always;
      add_header 'Access-Control-Allow-Headers' 'Authorization, Accept, Origin, Content-Type' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;

      if (\$request_method = OPTIONS) {
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
      }
    }
  }
}
NGINX_CONF

# Write docker-compose.yml with credential envs
cat <<EOF | sudo tee /opt/docker-registry/docker-compose.yml
services:
  registry:
    image: registry:2
    container_name: registry
    restart: always
    environment:
      - REGISTRY_AUTH=htpasswd
      - REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm
      - REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd
    volumes:
      - registry-data:/var/lib/registry
      - ./auth:/auth
    networks:
      - regnet

  nginx:
    image: nginx:alpine
    container_name: registry-proxy
    restart: always
    ports:
      - "5000:5000"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./auth:/auth
    depends_on:
      - registry
    networks:
      - regnet

  registry-ui:
    image: joxit/docker-registry-ui:2.5.7
    container_name: registry-ui
    restart: always
    ports:
      - "5080:80"
    environment:
      - REGISTRY_TITLE=Local Docker Registry
      - REGISTRY_URL=http://nginx:5000
      - DELETE_IMAGES=true
      - SHOW_CATALOG_NB_TAGS=true
      - SINGLE_REGISTRY=true
      - BASIC_AUTH=true
      - REGISTRY_USER=$REGUSER
      - REGISTRY_PASS=$REGPASSWORD
    depends_on:
      - nginx
    networks:
      - regnet

volumes:
  registry-data:

networks:
  regnet:
EOF

# Deploy Docker Registry Stack
cd /opt/docker-registry
sudo docker compose down || true
sudo docker compose up -d
