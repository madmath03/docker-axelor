#!/bin/bash
set -e

if [ ! -d /srv/axelor/upload ]; then
	mkdir -p /srv/axelor/upload
fi
if [ ! -d /srv/axelor/reports ]; then
	mkdir -p /srv/axelor/reports
fi
if [ ! -d /srv/axelor/reports-gen ]; then
	mkdir -p /srv/axelor/reports-gen
fi
if [ ! -d /srv/axelor/templates ]; then
	mkdir -p /srv/axelor/templates
fi
if [ ! -d /srv/axelor/data-export ]; then
	mkdir -p /srv/axelor/data-export
fi
if [ ! -d /srv/axelor/logs ]; then
	mkdir -p /srv/axelor/logs
fi

# If no config provided in volume, setup a default config
if [ ! -f /srv/axelor/config/application.properties ]; then
	echo "Setting up initial Axelor config"
	cp "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties.template" /srv/axelor/config/application.properties

	sed -i "s|db.default.dialect = .*|db.default.dialect = ${DB_DIALECT}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.driver = .*|db.default.driver = ${DB_DRIVER}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.url =.*|db.default.url =jdbc:${DB_URL}|g" /srv/axelor/config/application.properties
	sed -i "s|db.default.user =.*|db.default.user =${DB_USER}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.password =.*|db.default.password =${DB_PASSWORD}|" /srv/axelor/config/application.properties

	sed -i "s|application.home = .*|application.home = ${HOME}|" /srv/axelor/config/application.properties

	sed -i "s|application.locale = .*|application.locale = ${LOCALE}|" /srv/axelor/config/application.properties

	sed -i "s|application.theme = .*|application.theme = ${THEME}|" /srv/axelor/config/application.properties

	sed -i "s|application.mode = .*|application.mode = ${MODE}|" /srv/axelor/config/application.properties

	sed -i "s|data.import.demo-data = .*|data.import.demo-data = ${DEMO}|" /srv/axelor/config/application.properties

	sed -i "s|date.format = .*|date.format = ${DATE_FORMAT}|" /srv/axelor/config/application.properties

	sed -i "s|date.timezone = .*|date.timezone = ${TIMEZONE}|" /srv/axelor/config/application.properties

	sed -i "s|file.upload.dir = .*|file.upload.dir = /srv/axelor/upload|" /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# Other settings" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "reports.design.dir = /srv/axelor/reports" >>  /srv/axelor/config/application.properties
	echo "reports.output.dir = /srv/axelor/reports-gen" >>  /srv/axelor/config/application.properties
	echo "template.search.dir = /srv/axelor/templates" >>  /srv/axelor/config/application.properties
	echo "data.export.dir = /srv/axelor/data-export" >>  /srv/axelor/config/application.properties
	echo "logging.path = /srv/axelor/logs" >>  /srv/axelor/config/application.properties


	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# DEMO Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# disable demo data import" >>  /srv/axelor/config/application.properties
	echo "data.import.demo-data = false" >>  /srv/axelor/config/application.properties


	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# CORS Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# CORS settings to allow cross origin requests" >>  /srv/axelor/config/application.properties

	echo "# regular expression to test allowed origin or * to allow all (not recommended)" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.origin = *" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.credentials = true" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.methods = GET,PUT,POST,DELETE,HEAD,OPTIONS" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.headers = Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers" >>  /srv/axelor/config/application.properties


	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# LDAP Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# something like 'ldap://localhost:389'" >>  /srv/axelor/config/application.properties
	echo "ldap.server.url = ${LDAP_URL}" >>  /srv/axelor/config/application.properties

	echo "# can be 'simple' or 'CRAM-MD5'" >>  /srv/axelor/config/application.properties
	echo "ldap.auth.type = ${LDAP_AUTH_TYPE}" >>  /srv/axelor/config/application.properties

	echo "ldap.system.user = ${LDAP_ADMIN_LOGIN}" >>  /srv/axelor/config/application.properties
	echo "ldap.system.password = ${LDAP_ADMIN_PASS}" >>  /srv/axelor/config/application.properties

	echo "# user search base" >>  /srv/axelor/config/application.properties
	echo "ldap.user.base = ${LDAP_USER_BASE}" >>  /srv/axelor/config/application.properties

	echo "# a template to search user by user login id" >>  /srv/axelor/config/application.properties
	echo "ldap.user.filter = ${LDAP_USER_FILTER}" >>  /srv/axelor/config/application.properties

	echo "# group search base" >>  /srv/axelor/config/application.properties
	echo "ldap.group.base = ${LDAP_GROUP_BASE}" >>  /srv/axelor/config/application.properties

	echo "# a template to search groups by user login id" >>  /srv/axelor/config/application.properties
	echo "ldap.group.filter = ${LDAP_GROUP_FILTER}" >>  /srv/axelor/config/application.properties

	echo "# if set, create groups on ldap server under ldap.group.base" >>  /srv/axelor/config/application.properties
	echo "ldap.group.object.class = ${LDAP_GROUP_CLASS}" >>  /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# Quartz Scheduler" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# Specify whether to enable quartz scheduler" >>  /srv/axelor/config/application.properties
	echo "#quartz.enable = true" >>  /srv/axelor/config/application.properties
	echo "#quartz.threadCount = 5" >>  /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# SMTP Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "mail.smtp.host = ${SMTP_HOST}" >>  /srv/axelor/config/application.properties
	echo "mail.smtp.port = ${SMTP_PORT}" >>  /srv/axelor/config/application.properties
	echo "mail.smtp.channel = ${SMTP_CHANNEL}" >>  /srv/axelor/config/application.properties
	echo "mail.smtp.user = ${SMTP_USER_NAME}" >>  /srv/axelor/config/application.properties
	echo "mail.smtp.pass = ${SMTP_PASSWORD}" >>  /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# IMAP Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# (quartz scheduler should be enabled for fetching stream replies)" >>  /srv/axelor/config/application.properties
	echo "mail.imap.host = ${IMAP_HOST}" >>  /srv/axelor/config/application.properties
	echo "mail.imap.port = ${IMAP_PORT}" >>  /srv/axelor/config/application.properties
	echo "mail.imap.channel = ${IMAP_CHANNEL}" >>  /srv/axelor/config/application.properties
	echo "mail.imap.user = ${IMAP_USER_NAME}" >>  /srv/axelor/config/application.properties
	echo "mail.imap.pass = ${IMAP_PASSWORD}" >>  /srv/axelor/config/application.properties

fi

# Erase existing config with the one in volume
if [ -f /srv/axelor/config/application.properties ]; then
	echo "Updating Axelor config"
	cp /srv/axelor/config/application.properties "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
fi

exec "$@"
