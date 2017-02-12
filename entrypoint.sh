# entrypoint.sh

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn -c /home/modoboa/mailadmin/gunicorn.conf.py mailadmin.wsgi:application
# exec gunicorn mail.wsgi:application \
#     --bind 0.0.0.0:8000 \
#     --workers 3