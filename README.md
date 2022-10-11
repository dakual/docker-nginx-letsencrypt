## Let's Encrypt using Docker and Nginx

```sh
--dry-run       # Test "renew" or "certonly" without saving any certificates to disk
--force-renewal # If a certificate already exists for the requested domains, renew it now, regardless of whether it is near expiry.
--agree-tos     # Agree to the ACME Subscriber Agreement
--webroot       # Obtain certificates by placing files in a webroot directory.
--staging       # Using this option allows you to test your configuration options and avoid possible domain request limits.
--no-eff-email  # This tells Certbot that you do not wish to share your email with the Electronic Frontier Foundation (EFF).
```

Command is trigger to start the renewal process again.
```sh
docker-compose up certbot 
```

Force nginx to reload the configurations
```sh
docker-compose exec proxy nginx -s reload
```
### cron job 1
```sh
sudo crontab -e
0 5  * * *  docker-compose -f /<path>/docker-compose.yaml up certbot 
10 5 * * *  docker-compose -f /<path>/docker-compose.yaml exec proxy nginx -s reload
```

### cron job 2
```sh
sudo crontab -e
0 23 * * * docker run --rm -it --name certbot -v "/<path>/nginx/letsencrypt:/etc/letsencrypt" -v "/<path>/nginx/certbot:/var/www/certbot" certbot/certbot certonly --webroot --agree-tos --register-unsafely-without-email -w /var/www/certbot -d <domain>
```

```sh
docker run -it --rm \
  -v /<path>/nginx/letsencrypt:/etc/letsencrypt \
  -v /<path>/nginx/certbot:/var/www/certbot \
  certbot/certbot \
  certonly --webroot --agree-tos \
  --register-unsafely-without-email \
  -w /var/www/certbot \
  --force-renewal \
  --email <email> \
  -d <domain>
```

