s/^Listen 443/Listen 0.0.0.0:8443/
s/^<VirtualHost _default_:443>/<VirtualHost _default_:8443>/
s%^ErrorLog "logs/ssl_error_log"%ErrorLog "|/usr/bin/cat"%
s%TransferLog "logs/ssl_access_log"%TransferLog "|/usr/bin/cat"%

