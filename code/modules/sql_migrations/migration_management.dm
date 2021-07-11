
/datum/sql_migration_manager
	var/current_version = -1
	var/database_initialized = FALSE
	var/DBConnection/conn

/datum/sql_migration_manager/New(DBConnection/new_conn)
	ASSERT(new_conn != null)

	conn = new_conn

	_get_db_version()

/**
 * Updates the database to the specified version.
 *
 * @param migration_target -1 to update to the latest version, otherwise specify
 * the highest inclusive bound to migrate to.
 */
/datum/sql_migration_manager/proc/migrate_to(migration_target = -1)
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
	var/DBQuery/query = conn.NewQuery("")

/datum/sql_migration_manager/proc/_get_migrations()
	var/list/migrations = list()

	for (var/T in subtypesof(/datum/sql_migration))
		var/datum/sql_migration/m = new T
		ASSERT(m.version > 0)

		migrations += m

	sortTim(migrations, cmp_sql_migration_versions)

	return migrations
