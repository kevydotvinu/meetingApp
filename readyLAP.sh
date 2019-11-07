echo 1 | sudo tee /proc/sys/net/ipv6/conf/all/disable_ipv6
sudo cp config/apache2.conf /etc/apache2/apache2.conf 
sudo cp config/meeting.com.conf /etc/apache2/sites-available/
sudo cp config/sshd_config /etc/ssh/sshd_config
sudo cp config/sysctl.conf /etc/sysctl.conf
sudo sysctl -p
sudo cp config/ports.conf /etc/apache2/ports.conf
sudo a2dissite 000-default.conf 
sudo a2ensite meeting.com.conf 
sudo systemctl restart apache2
sudo systemctl restart sshd
sudo iptables -t nat -A PREROUTING -m mac --mac-source 00:6f:64:f6:e2:3f -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 80  -j REDIRECT --to-port 8080
