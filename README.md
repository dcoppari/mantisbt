# MantisBT

`MantisBT` is an open source issue tracker that provides a delicate balance between simplicity and power.

## Setup

You can build the image using this commands:

```bash
docker build -t mantisbt .
```

## Customize

You can pass build arguments for TimeZone and also set PHP upload size:

```bash
docker build -t mantisbt . --build-arg MANTIS_TIMEZONE="America/Argentina/Buenos_Aires"
```

## Setup

### Configuration file

Check the documentation at https://www.mantisbt.org/documentation.php in order to get more information.

Alternatively you can create a config_inc.php file using your database settings and also the smtp configuration:

```
<?php
$g_hostname = 'localhost';
$g_db_type = 'mysqli';
$g_database_name = 'bugtracker';
$g_db_username = 'mantisbt';
$g_db_password = '********';
$g_default_timezone = 'UTC';
$g_crypto_master_salt = 'somerandomsaltstring';

$g_phpMailer_method = PHPMAILER_METHOD_SMTP;
$g_administrator_email = 'admin@example.org';
$g_webmaster_email = 'webmaster@example.org';
$g_return_path_email = 'mantisbt@example.org';
$g_from_email = 'mantisbt@example.org';
$g_smtp_host = 'smtp.example.org';
$g_smtp_port = 25;
$g_smtp_connection_mode = 'tls';
$g_smtp_username = 'mantisbt';
$g_smtp_password = '********';
?>
```

### Start the container and run the installer:

```bash
docker run --rm -v "$(pwd):/config" --network host --name mantisbt mantisbt
```

Once the container is running, point the browser to http://localhost/admin/install.php then
login using the default credentials.

User: Administrator
Password: root

## Running a Docker compose stack:

A docker-compose.yml file is include in order to up a running sample stack.

```bash
docker-compose up -d
```
