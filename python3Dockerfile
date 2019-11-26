FROM python:3-slim
COPY python3.sh /root/
WORKDIR /vagrant/gCal/
RUN pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib python-dateutil && \
    chmod +x /root/python3.sh
