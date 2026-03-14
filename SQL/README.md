# SQL

This subdirectory contains the required SQL files that are needed for setting
up and updating a SQL database connected to the game. For nearly all
local development a database isn't necessary, but some of the game's features
require it.

Database management and/or development is a whole field on its own. If you have
trouble, don't hesitate to ask a developer for assistance, specifically the
people listed as code owners for the SQL directory.

## Prerequisite

The production database is a MariaDB. Feature parity is no longer guaranteed for
other SQL servers and requires that all SQL is tested on a MariaDB instance.
If this is not done, migrations could fail and result in data loss or corruption.

For applying migrations [Flyway by Redgate](https://github.com/flyway/flyway)
is used. It's a tool to automatically apply SQL scripts to a database server
while keeping track of the already applied migrations.

In order to develop for the database you will require a
[MariaDB server instance](https://mariadb.org/download/) and Flyway.

>[!TIP]
>Users proficient with Docker can look further down: MariaDB and Flyway both
>offer container solutions alleviating the need to install either locally.
>*Note: The usage of docker is too complex to be covered in this document.*
>Refer to the official documentation of Docker, MariaDB and Flyway.

## Migrations

### Compacted Migrations

To decrease the runtime of the migration unit test, the database migrations
will be compacted into a single migration on a regular basis. In order to do so,
a new `migrate-<year>` subfolder is created.
The initial migration in these subfolders is always a migration with the current
db-schema as of the current PR.

In addition the `flyway.conf` file in the root of the project is updated to
use the new migration folder and create a new schema history table
(that tracks the applied migrations).

#### Usage of compacted migrations

If you set up a new database: Make sure to use the latest migration folder, it
will contain everything needed to create a "fresh" database.

If you have an existing database: Update to the latest migration in the
migration folder that you have used so far.
Then switch to the next migration folder (and a new schema version table)
You should use flyway with `-baselineVersion="1" baseline` instead of the usual
migrate for the initial migration.

As usual, always make sure that you have a backup and
test it first on a non-production copy.

### Creating migrations

Creating migrations is relatively easy. Migrations are based on the previous
ones and allow you to focus on the new changes you would like to implement.

First, figure out the changes you need to make. From table alteration and
creation commands, to simply update and insert statements.
This is the usual SQL writing for any database.

Place your `.sql` files in the `SQL/migrate-<highest version>` folder, in a
valid order of execution. Name the file in the following format:

```txt
Vxxx__Description.sql
```

Where `xxx` is the next version number from the last existing file
(include the 0s) and the description is a short description for the migration,
with spaces replaced by underscores. You can orientate yourself on the already
existing migrations.

Pushing these new files is all that is needed, *testing aside*.

>[!WARNING]
>You cannot edit migrations files that have been merged to the master branch.
>These files will not be run again and will cause issue when setting up a
>new database.

### Initial database setup

In the root project directory, run the following:

```sh
path/to/flyway migrate
    -user=USER
    -password=PASSWORD
    -url=jdbc:mysql://HOST/DATABASE
```

Where `USER` is your database username, `PASSWORD` is your SQL password,
`HOST` is the hostname of the SQL instance and `DATABASE` is the actual
database you like to use on your SQL server instance.

### Applying newly added migrations

Applying newly added migrations by yourself or others is very simple.

Just run the exact same command you ran above, fancy isn't it?

Flyway will automatically skip already applied migrations and only add those
that are not yet existent in the database. This is also the underlaying reason
applied migrations are written in stone and cannot be edited after they have
been merged into the master branch.

### Using a pre-Flyway database

>[!CAUTION]
>This approach has issues due to improper versioning. Start with a fresh
>database and empty schema if possible.

The alternative is to make sure your database structure matches the V001 file
within the migrate folder by manually modifying the structure to avoid data loss
and then doing the steps described below.

If you're using a database since before we moved to Flyway,
it's a bit more involved to get migrations working.

In the root project directory, run:

```sh
path/to/flyway baseline -user=USER -password=PASSWORD
    -url=jdbc:mysql://HOST/DATABASE
    -baselineVersion=001
    -baselineDescription="Initial schema"
```

From there, you can run migrations as normal.

### Flyway config file

Instead of putting -user, -password and -url in the command line every time
you execute flyway, you can use a config file. An example can be found in the
repositories root directory, called `flyway.conf`:

```sh
flyway.url=jdbc:mysql://HOST/DATABASE
flyway.user=USER
flyway.password=PASSWORD
```

Now you can just run `flyway migrate -configFile=flyway.conf`
and the settings will be loaded from config.

### Misc tables

We included a set of miscellaneous tables in the misc folder.
These are primarily used for debugging and are not meant to be pushed
into production. As such, they're not included in the migration folder.

Ignoring or implementing them should not cause issues with the system.

### Docker

Docker allows you to setup a database and Flyway without installing additional
components locally. This setup is for directed at advanced users proficient
with Linux/Bash and Docker. Provided is a jumpstart example, refer to the
individual documentations: [MariaDB docker](https://hub.docker.com/_/mariadb) and
[Flyway docker](https://hub.docker.com/r/flyway/flyway/).

Advantages: No installation of additional components, easy to spin up/remove
and changes are stored in volumes.

```yaml
services:
    flyway:
        image: flyway/flyway
        command: -url=jdbc:mysql://db -user=root -password=P@ssw0rd -workingDirectory="project" migrate
        volumes:
            - ./SQL/migrate-VERSION:/flyway/project # Pathing!
        depends_on:
            - db
    db:
        image: mariadb
        environment:
            MARIADB_ROOT_PASSWORD: Pssw0rd
        volumes:
            - aurora:/var/lib/mysql:Z
        ports:
        - 3306:3306
```
