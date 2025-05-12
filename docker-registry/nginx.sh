#!/bin/bash
# Docker Registry: Auth, TLS, Compose config

# Ensure necessary directories and files are created
sudo mkdir -p /opt/docker-registry/auth
sudo chown -R 1000:1000 /opt/docker-registry/auth
sudo chmod -R 755 /opt/docker-registry/auth

# Generate htpasswd file
sudo docker run --rm --entrypoint htpasswd httpd:2 -Bbn "$REG_USER" "$REG_PASS" | sudo tee /opt/docker-registry/auth/htpasswd

# Write nginx.conf with proper CORS and body size settings
cat <<EOF | sudo tee /opt/docker-registry/nginx.conf
events {}

http {
  client_max_body_size 100M;

  server {
    listen 5000;

    location / {
      proxy_pass http://registry:5000;

      add_header 'Access-Control-Allow-Origin' 'http://localhost:30003' always;
      add_header 'Access-Control-Allow-Methods' 'GET, HEAD, OPTIONS' always;
      add_header 'Access-Control-Allow-Headers' 'Authorization, Accept, Origin' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;

      if (\$request_method = OPTIONS ) {
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
      }
    }
  }
}
EOF

# Write docker-compose.yml for Docker Registry, Nginx, and UI
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
      - REGISTRY_USER=${REG_USER}
      - REGISTRY_PASS=${REG_PASS}
    depends_on:
      - nginx
    networks:
      - regnet

volumes:
  registry-data:

networks:
  regnet:
EOF

# Deploy the Docker registry stack
cd /opt/docker-registry
sudo docker compose down || true
sudo docker compose up -d
