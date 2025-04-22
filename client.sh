# Install packages
echo "ic@lab" | sudo -S apt update
sudo apt install -y vim-gtk3 xclip

echo "$USER:ic@lab" | sudo chpasswd 2>/dev/null

# Create user if doesn't exist (suppress error if exists)
sudo useradd -m mcc 2>/dev/null || true

# Set password (ignore weak password warning)
echo "mcc:mcc" | sudo chpasswd 2>/dev/null

# Set shell
sudo chsh -s /bin/bash mcc

sudo chattr -i /home/mcc/.profile 2>/dev/null || true

# Create proxy settings file with correct permissions
sudo bash -c 'cat > /home/mcc/.profile <<EOF
export http_proxy="http://192.168.0.122:3128"
export https_proxy="http://192.168.0.122:3128"
EOF'

sudo chown mcc:mcc /home/mcc/.profile
sudo chmod 644 /home/mcc/.profile
sudo chattr +i /home/mcc/.profile 2>/dev/null || true

# Copy CA cert
sudo bash -c 'cat > /home/mcc/myCA.pem << EOF
-----BEGIN CERTIFICATE-----
MIIFizCCA3OgAwIBAgIUZ+xvqHG3LZd+B1M6c35CSXtDLT8wDQYJKoZIhvcNAQEL
BQAwVTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDEOMAwGA1UEAwwFdGFtYWwwHhcNMjUw
NDE0MTE0MzQ4WhcNMjYwNDE0MTE0MzQ4WjBVMQswCQYDVQQGEwJBVTETMBEGA1UE
CAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRk
MQ4wDAYDVQQDDAV0YW1hbDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
AMGI0KzgX8A5kvvDs+sKgbupLuUsjlNw5MUl3eDSMlJ79Ml3fhaQW8872RJytTvL
AK1XowMmImZ/iymlHm9aHeb9S8vZYo88Z3pS88l88Hp7abXUeJuQUvmfEGfNTu1o
m/yL0mXpdslQQo51Nd6axg7PBVzFshVuExRws0rOxJgHu00qR9OJHG4epuXuQRg3
P3xDWO4xQT784q4L0gDObeoM9Cyr5V5SQCkN99iHzKpmovzeiUIS7g9k50irXUR9
zMx1ckJyIipMd2s1pu+IhTiY4Fr+r/AITZw87x7ftUSHbk49UI7YTzrAWWts/evf
gRoV6CtVzm7S7S7pQClFL+12E2nAYod4gX3yo21syqlTHeaXdCszuWbaRJRs5Bt4
oeVdWaG9DaCP1e3wR3EAUXpxvw3ELB4CMq+HH5rmfE1hTNhXVG5LlJgd71UOMgSk
lJy2QIcnTX97W8RpRMIMxshb7tajI2VmkqSnJWORgPdimd+YcVo3I6cPaeGddBvF
XXPfZpe9xiWSuGY4k/fwn/y9YHOhCrcrT9H4qfH4SuJY7BfBpXpYdr/TmrrFgDIL
lf5CspXSvf/S47Sj6f2C4+LJpsXetx9yLDKvwlVUUxHe/dLECYiYfl5uQl6eCuZ4
d0d/WpDWdCf3QQR9RKQ0BzSrRy3OR5pKjXasRp0npjNHAgMBAAGjUzBRMB0GA1Ud
DgQWBBQOybE1AyL2QESlFE+E6gvYNyZm6TAfBgNVHSMEGDAWgBQOybE1AyL2QESl
FE+E6gvYNyZm6TAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4ICAQAu
aZ6o3lWMMV5YvBV4EEYafw4EY+2/X28vZBMHRvZ6T96QPNM44QIE+CH2rciiXHss
1rerXsFIB1ASwLxoec94MxEoAcxj607RHgO9i8wA6RGfI05FOcl1tLQeu/XfH0ty
9oHQFRIXVIZV0CBagxMdAfnrA7hawW1bsNTdLxfNAwm+GY4BZnGHZQ0gn+HaLxZs
pbYkwG5Y+HucS1iyexG52/jNUd1hBO3FYg0aB19GGkoxfIKPj9RZ8UFI3MIWB6sM
0SEwrelza1h3efjHVaMcFysftwFA4iu+NHOUDsj+6lNoTStIsdH4fFIsfhikc1BM
sGHToQJuLXjc269duK6/JjavJCHV/iCOVOeps3fEReVn15WUpPg6dZ+9fGGnRtUk
k4kYqfDKxcC9+GJIUArayXFI4B2qUHXvsAAwTEAak1GmOg9YNjxmZQ0gvAPlz/VA
hJVzOFAzvKOLwFkoc1AJNI2TM8TtJAus2FHNlpBhOGsovPfx9r6pdu18pbDNwkrI
3Mb/js1oE665Diuh3ATK5ktgy29UABXIJOMDvWOL/hj0RNJ6+jgb/Gfa9tFP09JC
D536qut4jhFafKhHaFJ66AYV3WZLEKHvnLGOUOVxtmKUpA1195AahNhkgefWQwlH
1huMn9EaoFUFeeXzYrfc3ZjBNl5XJmOpgLW5ZgDsug==
-----END CERTIFICATE-----
EOF'


sudo chown mcc:mcc /home/mcc/myCA.pem


# Clean up vimrc
echo "" | sudo tee /usr/share/vim/vimrc >/dev/null

sudo shutdown -r now
