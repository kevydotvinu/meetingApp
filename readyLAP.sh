sudo cp config/apache2.conf /etc/apache2/apache2.conf 
sudo cp config/meeting.com.conf /etc/apache2/sites-available/
sudo a2dissite 000-default.conf 
sudo a2ensite meeting.com.conf 
sudo systemctl restart apache2
