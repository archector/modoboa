# entrypoint.sh

# Start Gunicorn processes
#exec gunicorn -c /home/modoboa/mailadmin/gunicorn.conf.py mailadmin.wsgi:application
# Prepare log files and start outputting logs to stdout
touch /srv/logs/gunicorn.log
touch /srv/logs/access.log
tail -n 0 -f /srv/logs/*.log &

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn mailadmin.wsgi:application \
    --name mailadmin \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level=info \
    --log-file=/srv/logs/gunicorn.log \
    --access-logfile=/srv/logs/access.log \
    "$@"
# exec gunicorn mail.wsgi:application \
#     --bind 0.0.0.0:8000 \
#     --workers 3
