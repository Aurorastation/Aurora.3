/*
 * The method by which player saves are migrated to the SQL database from savefile oriented storage.
 */

/datum/preferences/proc/handle_saves_migration(var/client/C)
	if (!C || !C.need_saves_migrated)
		return 1

	if (!path)
		load_path(C.ckey)
		if (!path)
			log_debug("Migration of [C.ckey]'s saves failed at attaining path to save file.")
			return 0

	if (!migrate_client_preferences(C))
		log_debug("Migration of [C.ckey]'s saves failed at the uploading of client preferences.")
		return 0

	if (!migrate_client_characters(C))
		log_debug("Migration of [C.ckey]'s saves failed at the uploading of client characters.")
		return 0

	return 1

/*
 * Handles the migration of preferences.
 * Loads the prefs to the datum, then saves them to SQL.
 */
/datum/preferences/proc/migrate_client_preferences(var/client/C)
	load_preferences()

	return insert_preferences_sql(C)

/*
 * Handles the migration of characters.
 * Finds all of your saved characters, loads them into the datum, and saves them onto the SQL.
 */
/datum/preferences/proc/migrate_client_characters(var/client/C)
	var/savefile/S = new /savefile(path)
	if (!S)
		return 1

	S.cd = "/"
	var/list/character_slots = list()

	for (var/a in S.dir)
		if (findtext(a, "character"))
			var/slot_id = replacetext(a, "character", "")
			character_slots.Add(text2num(slot_id))

	if (!character_slots.len)
		return 1

	for (var/slot in character_slots)
		load_character(slot)

		if (!skills || !skills.len)
			ZeroSkills(1)

		if (!insert_character_sql(C))
			log_debug("Character insert error during migration. Client: [C.ckey], character slot: [slot].")
			return 0

	return 1

/*
 * Update's the client's migrate status.
 */
/datum/preferences/proc/update_migrate_status(var/client/C)
	C.need_saves_migrated = 0

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		return

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_player SET migration_status = 0 WHERE ckey = :ckey")
	query.Execute(list(":ckey" = C.ckey))

	var/DBQuery/current_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey ORDER BY id ASC LIMIT 1")
	current_query.Execute(list(":ckey" = C.ckey))

	if (current_query.NextRow())
		current_character = text2num(current_query.item[1])
		load_character_sql(current_character, C)

	return
