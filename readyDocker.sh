cp config/apache2.conf /etc/apache2/apache2.conf
cp config/meeting.com.conf /etc/apache2/sites-available/
cp config/ports.conf /etc/apache2/ports.conf
a2dissite 000-default.conf
a2ensite meeting.com.conf
