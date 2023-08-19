### Prerequisites

The server connects to a mysql-compatible server (mysql, mariadb, percona), so you'll need one of those with a database and user/password pair ready.

We use [flyway](https://flywaydb.org/) to manage database migrations. To set up the database, you'll need to [download flyway](https://flywaydb.org/getstarted/download.html).

You'll also need some proficiency with the command line.

----

### Attribution

Credit to Mloc from Baystation12 for the initial readme.

---

### Creating migrations

As a coder, creating migrations is relatively easy. And they're a lot more flexible than just updating the initial schema would be.

First, figure out the changes you need to make. From table alteration and creation commands, to simply update and insert statements.

Write them into a .sql file in the SQL/migrate folder, in a valid order of execution. Name the file in the following format:

    Vxxx__Description_goes_here.sql

Where `xxx` is the next version number from the last existing file (include the 0s), and the descrption is a short description for the migration, with spaces replaced by underscores.

Push this to your branch, and you're done!

---

### Initial setup

In the root project directory, run:

    path/to/flyway migrate -user=USER -password=PASSWORD -url=jdbc:mysql://HOST/DATABASE

Where USER is your mysql username, PASSWORD is your mysql password, HOST is the hostname of the mysql server and DATABASE is the database to use.

---

### Migrating

Use the same command as above. Handy, isn't it?

---

### Using a pre-flyway database

**Note that this is not recommended!**
You may run into issues with some migrations, due to improper versioning. The best way to utilize this system is to set everything up on an empty schema.
The next alternative is to make sure your database structure matches the V001 file within the migrate folder by manually modifying the structure to avoid dataloss, and then doing the steps described below.

If you're using a database since before we moved to flyway, it's a bit more involved to get migrations working.

In the root project directory, run:

    path/to/flyway baseline -user=USER -password=PASSWORD -url=jdbc:mysql://HOST/DATABASE -baselineVersion=001 -baselineDescription="Initial schema"

From there, you can run migrations as normal.

---

### Configuration file

Instead of putting -user, -password and -url in the command line every time you execute flyway, you can use a config file. Create it somewhere in the root of your project (we're calling it 'db.conf'):

    flyway.url=jdbc:mysql://HOST/DATABASE
    flyway.user=USER
    flyway.password=PASSWORD

Now you can just run `flyway migrate -configFile=db.conf`, and the settings will be loaded from config.

---

### Misc tables

We included a set of miscellanious tables in the misc folder. These are primarily used for debugging and are not meant to be pushed into production. As such, they're not included in the migration folder.

Ignoring or implementing them should not cause issues with the system.
