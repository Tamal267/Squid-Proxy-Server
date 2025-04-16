Install Packages
```bash
sudo apt update
sudo apt install squid
sudo apt install squid-openssl
```

Edit Config File
```bash
sudo vim /etc/squid/squid.conf
```

Paste:
```txt
# Access control - allow all local traffic
acl localnet src 192.168.0.0/16  # Adjust to your local network
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src fc00::/7
acl localnet src fe80::/10

http_access allow localhost
http_access allow localnet
http_access deny all

# Define the SSL bump steps
http_port 3128 ssl-bump cert=/etc/squid/ssl_cert/myCA.pem key=/etc/squid/ssl_cert/myCA.key

acl step1 at_step SslBump1
acl cloudflare dstdomain .cloudflare.com .turnstile.cloudflare.com .captcha.cloudflare.com
ssl_bump splice cloudflare
ssl_bump peek step1
ssl_bump bump all

# Disable forwarding loop detection
forwarded_for delete
request_header_access Allow allow all
request_header_access Authorization allow all
request_header_access WWW-Authenticate allow all
request_header_access Proxy-Authorization allow all
request_header_access Proxy-Authenticate allow all
request_header_access Cache-Control allow all
request_header_access Content-Encoding allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Expires allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all
request_header_access Location allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Content-Language allow all
request_header_access Mime-Version allow all
request_header_access Retry-After allow all
request_header_access Title allow all
request_header_access Connection allow all
request_header_access Proxy-Connection allow all
request_header_access User-Agent allow all
request_header_access Cookie allow all
request_header_access All deny all

sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/ssl_db -M 4MB
sslcrtd_children 5
```

Generate SSL Cert and Key for SSL Bumping (don't skip Common Name)
```bash
sudo mkdir -p /etc/squid/ssl_cert
cd /etc/squid/ssl_cert
sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
  -keyout myCA.key -out myCA.pem
```

Create a certificate database:
```bash
sudo /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
```

Make sure permissions are correct:
```bash
sudo chown -R proxy:proxy /etc/squid/ssl_cert
sudo chown -R proxy:proxy /var/lib/ssl_db
```

Restart
```bash
sudo systemctl restart squid
```

Status
```bash
sudo systemctl status squid
```

Add certificate to target the target pc located in in `/etc/squid/myCA.pem`


Intercepting specific links
```bash
sudo tail -f /var/log/squid/access.log | grep -P 'codeforces\.com/(contest|problemset|blog)|atcoder\.jp/contests|www\.google\.com/search\?|chatgpt\.com/|www\.deepseek\.com/|github\.com/|vjudge\.net/(?!contest/708504|contest/rank/single/708504|cdn-cgi/|contest/rank/merged/|static/bundle/|favicon\.ico|util/serverTime)'
```
