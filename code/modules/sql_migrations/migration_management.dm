
/proc/migrate_main_db()
	if (world.params["no_migrations"])
		log_debug("Skipping migrations due to commandline args.")
		return

	var/DBConnection/conn = initialize_database_object("config/dbconfig_migration.txt")
	ASSERT(conn)

	if (!setup_database_connection(conn))
#ifdef UNIT_TEST
		crash_with("Failed to estbalish migration database connection.")
#else
		error("Failed to estbalish migration database connection.")
#endif
		return

	var/datum/sql_migration_manager/manager = new(conn)

	manager.migrate_to(-1)

/datum/sql_migration_manager
	var/current_version = -1
	var/last_migration_successful = TRUE
	var/can_migrate = TRUE
	var/DBConnection/conn

/datum/sql_migration_manager/New(DBConnection/new_conn)
	ASSERT(new_conn != null)

	conn = new_conn

	if (!_get_db_version())
		can_migrate = FALSE

/**
 * Updates the database to the specified version.
 *
 * @pre _get_db_version() needs to have been called.
 *
 * @param migration_target -1 to update to the latest version, otherwise specify
 * the highest inclusive bound to migrate to.
 */
/datum/sql_migration_manager/proc/migrate_to(migration_target = -1)
	if (!last_migration_successful)
		error("SQL migration: migrations aborted due to the last migration having failed.")
		return
	else if (!can_migrate)
		error("SQL migration: migrations skipped due to bad manager state.")
		return

	var/list/migrations = _get_migrations()

	try
		for (var/datum/sql_migration/m in migrations)
			if (m.version > current_version && (m.version <= migration_target || migration_target == -1))
				_migration_up(m)
	catch (var/exception/e)
#ifdef UNIT_TEST
		crash_with("SQL migration error: [e]")
#else
		error("SQL migration error: [e]")
#endif

/datum/sql_migration_manager/proc/_get_db_version()
	var/DBQuery/query = conn.NewQuery("SHOW TABLES LIKE 'ss13_migrations'")
	query.Execute()

	if (query.ErrorMsg())
		error("SQL migration: Error checking for ss13_migrations table: [query.ErrorMsg()]")
		return FALSE

	if (!query.NextRow())
		current_version = 0
		last_migration_successful = TRUE
		log_debug("SQL migration: ss13_migrations table missing. Resetting to baseline.")
	else
		query = conn.NewQuery("SELECT version_number, is_successful FROM ss13_migrations ORDER BY version_number DESC LIMIT 1")
		query.Execute()

		if (query.ErrorMsg())
			error("Error querying latest migration from ss13_migrations table: [query.ErrorMsg()]")
			return FALSE
		else if (!query.NextRow())
			error("Querying ss13_migrations table did not yield any results but it exists. This is a nonsense state.")
			return FALSE

		current_version = text2num(query.item[1])
		last_migration_successful = text2num(query.item[2])
		log_debug("SQL migration: found latest migration as version [current_version] with success state [last_migration_successful].")

	return TRUE

/datum/sql_migration_manager/proc/_get_migrations()
	var/list/migrations = list()

	for (var/T in subtypesof(/datum/sql_migration))
		var/datum/sql_migration/m = new T
		ASSERT(m.version > 0)

		migrations += m

	sortTim(migrations, /proc/cmp_sql_migration_versions)

	return migrations

/datum/sql_migration_manager/proc/_migration_up(datum/sql_migration/m)
	var/DBQuery/log_query = conn.NewQuery("INSERT INTO ss13_migrations (version_number, is_successful) VALUES (:version:, :success:)")

	try
		log_debug("SQL migration: running migration [m.version].")
		m.up(conn)
		log_query.Execute(list("version" = m.version, "success" = 1))
		log_debug("SQL migration: migration [m.version] successful.")
	catch (var/exception/e)
		log_query.Execute(list("version" = m.version, "success" = 0))

		throw e
