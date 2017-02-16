Dockerized mail environment

 To do:

   - Permit modoboa user to have permission on volume maildata:/var/mail
   - Set up the following envs in production file: MYSQL_RANDOM_ROOT_PASSWORD=yes
   - Add "condition: service_healthy" in the mysql container, in depends_on section
   - Cross-compare provided dovecot and postfix files with the injected ones, for compatibility with postgrey, etc
   - Create mysql amavis database and add it to the dburl in modoboa-admin.py deploy command
   - Include rrdtools to install pdfcredentials and stats

Configurator container image: 

Run this with passed parameters to generate config files for the whole mail ecosystem 
 
   - Create container that builds from alpine takes variables from yaml generator script
     and replaces them on the config folder in the corresponding container vars:
     - dovecot:
       - dovecot-sql.conf.ext:
         - check all variables depending on configured driver in http://modoboa.readthedocs.io/en/latest/manual_installation/dovecot.html
         - {{driver}} : mysql
         - {{connect}} : host=mysql dbname=modoboa user=modouser password=modopasswd
         - {{password_query}} : as config file states 
         - {{user_query}}: as config file states
         - {{iterate_query}}: as config file states
       - 20-lmtp.conf:
         - {{domain}} : domain.com
       - dovecot.conf:
         - {{driver}}: mysql
       - dovecot-dict-sql-conf.ext:
         - {{connect}}: host=mysql dbname=modoboa user=modouser password=modopasswd
       - 10-ssl.conf:
         - {{ssl_cert}}
         - {{ssl_key}}
     - postfix:
       - main.cf
         - {{myhostname}}: domain.com
         - {{smtpd_tls_key_file}} 
         - {{smtpd_tls_cert_file}} 
         - {{smtpd_tls_CAfile}}
         - {{relayhost}}
         - {{smtp_sasl_password_maps}}
         - {{smtpd_tls_CAfile}}
         - {{smtp_tls_CAfile}}
