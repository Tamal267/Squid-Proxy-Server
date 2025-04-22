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
sudo cp myCA.pem /home/mcc/myCA.pem
sudo chown mcc:mcc /home/mcc/myCA.pem


# Clean up vimrc
echo "" | sudo tee /usr/share/vim/vimrc >/dev/null

sudo shutdown -r now
