# Dockerfile for modoboa web admin
# Based on manual installation instructions from default documentation
# https://modoboa.readthedocs.io/en/latest/manual_installation/modoboa.html

# Default python image
FROM python:2-onbuild

# Add mobodoa user
RUN useradd -ms /bin/bash modoboa
USER modoboa
WORKDIR /home/modoboa

# Setup modoboa installation
RUN virtualenv env
RUN source env/bin/activate
RUN pip install --no-cache-dir modoboa psycopg2

# Need to run these commands in the postgres container
# We assume that the database, user and password are previously created
# modoboa-admin.py deploy instance --collectstatic \
         #--domain <hostname of your server> --dburl default:database-url 
# Database url format: postgres://[user:pass@][host:port]/dbname

# Setup and run
COPY entrypoint.sh /entrypoint.sh
EXPOSE 8000
CMD ["/entrypoint.sh"]