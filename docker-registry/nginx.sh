events {}

http {
  log_format main '$proxy_protocol_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

  access_log /var/log/nginx/access.log main;

  client_max_body_size 100M;

  server {
    listen 5000;

    location / {
      proxy_pass http://registry:5000;

      add_header 'Access-Control-Allow-Origin' 'http://localhost:30003' always;
      add_header 'Access-Control-Allow-Methods' 'GET, HEAD, OPTIONS' always;
      add_header 'Access-Control-Allow-Headers' 'Authorization, Accept, Origin' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;

      if ($request_method = OPTIONS ) {
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
      }
    }

    location /v2/ {
      proxy_pass http://registry:5000;
    }
  }
}
