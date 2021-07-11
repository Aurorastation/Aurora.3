/proc/cmp_sql_migration_versions(datum/sql_migration/a, datum/sql_migration/b)
	return a.version - b.version

/datum/sql_migration
	var/version = -1 /// Version number. Should be sequential and > 0.
	var/migration_data /// Can be a string or a list of strings. Will be executed in proc/up().

/datum/sql_migration/proc/up()
	if (islist(migration_data))
		for (var/to_run in migration_data)
			_execute_sql(to_run)
	else if (istext(migration_data))
		_execute_sql(migration_data)
	else
		throw EXCEPTION("Invalid migration_data variable.")

/datum/sql_migration/proc/down()
	return


