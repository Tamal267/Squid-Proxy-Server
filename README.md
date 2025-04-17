Install Packages
```bash
sudo apt update
sudo apt install squid squid-openssl
```

Edit Config File
```bash
sudo vim /etc/squid/squid.conf
```

Paste:
```txt
acl localnet src 192.168.0.0/16  
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src fc00::/7
acl localnet src fe80::/10

http_access allow localhost

http_port 3128 ssl-bump cert=/etc/squid/ssl_cert/myCA.pem key=/etc/squid/ssl_cert/myCA.key

acl cloudflare dstdomain .cloudflare.com .challenges.cloudflare.com
acl cloudflare_url urlpath_regex /cdn-cgi/
ssl_bump splice cloudflare
ssl_bump splice cloudflare_url

acl codeforces dstdomain .codeforces.com
ssl_bump bump codeforces  
ssl_bump bump all       

http_access allow localnet
http_access deny all

forwarded_for transparent
request_header_access User-Agent allow all
request_header_access Accept allow all
request_header_access Accept-Language allow all
request_header_access Cookie allow all

logformat full_url_log %{%Y-%m-%d %H:%M:%S}tl %6tr %>a %Ss/%03>Hs %<st %rm %>ru %[un %Sh/%<a %mt
access_log /var/log/squid/access.log full_url_log

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
echo "" | sudo tee /var/log/squid/access.log
sudo tail -f /var/log/squid/access.log | grep -P '(codeforces\.com/(contest|problemset|blog|data/submitSource)|atcoder\.jp/contests|google\.com/search\?|chatgpt\.com/|deepseek\.com/|github\.com/|vjudge\.net/problem/(?!description)|vjudge\.net/group|vjudge\.net/user/solveDetail/|vjudge\.net/problem/leaderBoard)'
```
