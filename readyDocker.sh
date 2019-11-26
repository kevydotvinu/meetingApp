cp config/apache2.conf /etc/apache2/apache2.conf
cp config/meeting.com.conf /etc/apache2/sites-available/
cp config/ports.conf /etc/apache2/ports.conf
a2dissite 000-default.conf
a2ensite meeting.com.conf
service apache2 restart
iptables -t nat -D PREROUTING -m mac --mac-source 00:6f:64:f6:e2:3f -j ACCEPT
iptables -t nat -A PREROUTING -m mac --mac-source 00:6f:64:f6:e2:3f -j ACCEPT
iptables -t nat -D PREROUTING -p tcp --dport 80  -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -p tcp --dport 80  -j REDIRECT --to-port 8080
