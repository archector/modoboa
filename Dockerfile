# Dockerfile for modoboa web admin
# Based on manual installation instructions from default documentation
# https://modoboa.readthedocs.io/en/latest/manual_installation/modoboa.html
# This file will be generated from the alpine generator image
#	- Container vars to be replaced: 
# 		- instance_name
#		- dburl
#		- domain
#		- lang
#		- timezone
#		- extensions
#		- admin-username
#		- postfix_dir

# Default python image
FROM python:2

MAINTAINER Hector Goncalves

ENV MODOBOA_SRC=mailadmin
ENV MODOBOA_SRVHOME=/srv
ENV MODOBOA_SRVPROJ=/srv/mailadmin
# Add mobodoa user
#RUN useradd -ms /bin/bash modoboa
#RUN adduser -S modoboa
#USER modoboa
#WORKDIR /home/modoboa

# Setup modoboa installation
#RUN virtualenv env
#RUN . /home/modoboa/env/bin/activate
RUN pip install --no-cache-dir modoboa
RUN pip install --no-cache-dir MySQL-Python
RUN echo  "Deploying Modoboa"
WORKDIR $MODOBOA_SRVHOME
RUN modoboa-admin.py deploy mailadmin --collectstatic \
         --domain domain.com --dburl default:mysql://[modouser:modopasswd@][mysql:3306]/modoboa \
         --lang es --timezone America/Caracas --extensions modoboa-amavis modoboa-dmarc \ 
          modoboa-imap-migration modoboa-postfix-autoreply modoboa-radicale modoboa-sievefilters \
         --admin-username modoadmin


# Add custom logo here

# Change DOVECOT_LOOKUP_PATH variable in settings.py to /ext_dovecot here 

# Generate postfix maps and store them on known dir
#RUN python manage.py generate_postfix_maps --destdir {{postfix_dir}}

# Setup and run
COPY ./config/gunicorn.conf.py $MODOBOA_SRVPROJ/
COPY ./entrypoint.sh /
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
