mkdir .ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./.ssl/selfsigned.key -out .ssl/selfsigned.crt
