s/^Listen 443/Listen 0.0.0.0:8443/
s/^<VirtualHost _default_:443>/<VirtualHost _default_:8443>/
s/^#ServerName www.example.com:443/ServerName shib.cloud.las.iastate.edu/
s%^ErrorLog "logs/ssl_error_log"%ErrorLog "|/usr/bin/cat"%
s%TransferLog "logs/ssl_access_log"%TransferLog "|/usr/bin/cat"%
s%SSLCertificateFile /etc/pki/tls/certs/localhost.crt%SSLCertificateFile /opt/app-root/tls/certs/cloud.las.iastate.edu.cer%
s%SSLCertificateKeyFile /etc/pki/tls/private/localhost.key%SSLCertificateKeyFile /opt/app-root/tls/private/cloud.las.iastate.edu.key%
