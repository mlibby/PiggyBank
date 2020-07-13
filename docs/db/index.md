# Database Setup

This guide needs download URLs and commands to run in the terminal on the Pi. 

## Install PostgreSQL

Install the PostgreSQL server on the RPi.

If you're like me, you'll also want to install at least pgadmin4 on your workstation.

## Configure PostgreSQL

* `sudo -u postgres -i`

* If you want to be able to access the database using a client like pgadmin from a machine other than the RPi:
  `sudo nano /etc/postgresql/11/main/postgresql.conf`

  * Find the line that says `listen_addresses` and uncomment and set to `listen_addresses = '*'`

* PgSql restricts access by host. You can either set it up to allow connections from any client, or you can explicitly allow the machines you're going to connect from.

  * Open the `pg_hba.conf` file:  `sudo nano /etc/postgresql/11/main/pg_hba.conf`

  * Add a line at the end like `host all all 192.168.0.16 md5` to enable a specific client machine

  * Add a line at the end like `host all all 0.0.0.0/0 md5` to enable any client

* Restart PgSQL: `sudo systemctl restart postgresql`

## Setup PiggyBank DB

* Create a user "pb_user" with the password "piggybank" (removing the password from the code is a TODO item right now)

  `sudo -u postgres -i`

  `create user pb_user with password 'piggybank'`

* Create a database called "piggybank" owned by pb_user

  `create database piggybank with owner pb_user`
