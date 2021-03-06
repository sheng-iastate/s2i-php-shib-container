FROM centos/s2i-base-centos7

# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443


ENV PHP_VERSION=7.0 \
    PATH=$PATH:/opt/rh/rh-php70/root/usr/bin

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as docker container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$SUMMARY" \
      io.k8s.display-name="Apache 2.4 with PHP 7.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,php,php70,rh-php70" \
      name="centos/php-70-centos7" \
      com.redhat.component="rh-php70-docker" \
      version="7.0" \
      release="1" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# Install Apache httpd and PHP
# add ssl
RUN yum install -y centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-php70 rh-php70-php rh-php70-php-mysqlnd rh-php70-php-pgsql rh-php70-php-bcmath \
                  rh-php70-php-gd rh-php70-php-intl rh-php70-php-ldap rh-php70-php-mbstring rh-php70-php-pdo \
                  rh-php70-php-process rh-php70-php-soap rh-php70-php-opcache rh-php70-php-xml \
                  httpd24-mod_ssl  \
                  rh-php70-php-gmp" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y


# Install Shibboleth
RUN curl http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -o /etc/yum.repos.d/shibboleth.repo && \
    yum install -y shibboleth && \
    yum clean all -y


# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    sed -i '/php_value session.save_path/d' /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php70-php.conf && \
    head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    mkdir /tmp/sessions && \
    chown -R 1001:0 /opt/app-root /tmp/sessions && \
    chmod -R a+rwx /tmp/sessions && \
    chmod -R ug+rwx /opt/app-root && \
    chmod -R a+rwx /etc/opt/rh/rh-php70 && \
    chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd && \
    sed -i -f /opt/app-root/etc/conf.d/sslconf.sed /opt/rh/httpd24/root/etc/httpd/conf.d/ssl.conf && \
    echo "UseCanonicalName On" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    chmod -R a+rwx /var/log/httpd24 && \
    chmod -R a+rwx /opt/rh/httpd24/root/etc/httpd && \
    ln -s /etc/httpd/conf.d/shib.conf /opt/rh/httpd24/root/etc/httpd/conf.d/shib.conf && \
    chown -R 1001 /etc/shibboleth && \
    chmod -R a+rwx /etc/shibboleth && \
    chmod -R a+rwx /var/run/shibboleth && \
    chmod -R a+rwx /var/log/shibboleth && \
    chmod -R a+rwx /var/log/shibboleth-www && \
    chmod -R a+rwx /var/cache/shibboleth

	# temp use sed to disable the ssl module so see if that is the problems
	#mv /opt/rh/httpd24/root/etc/httpd/conf.d/ssl.conf /opt/rh/httpd24/root/etc/httpd/conf.d/ssl.disabled && \
	#sed -i -f /opt/app-root/etc/conf.modules.d/00-ssl.sed /opt/rh/httpd24/root/etc/httpd/conf.modules.d/00-ssl.conf && \	
	# copying the real certs through
	#chmod a+r /etc/pki/tls/certs/localhost.crt && \
	#chmod a+r /etc/pki/tls/private/localhost.key && \
	
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
