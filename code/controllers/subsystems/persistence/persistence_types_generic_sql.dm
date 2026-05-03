/**
 * Runs a cleanup query on generics that have expired.
 */
/datum/controller/subsystem/persistence/proc/genericDatabaseCleanup()
	PRIVATE_PROC(TRUE)
	if(!databaseCheckConnection("genericDatabaseCleanup"))
		return 0

	var/datum/db_query/query = SSdbcore.NewQuery(
		"DELETE FROM ss13_persistent_generics WHERE expires_at < NOW()"
	)
	query.Execute()

	databaseCheckQueryResult(query, "genericDatabaseCleanup")
	qdel(query)
