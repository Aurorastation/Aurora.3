/*
 * The method by which player saves are migrated to the SQL database from savefile oriented storage.
 */

/datum/preferences/proc/handle_saves_migration(var/client/C)
	if (!C || !C.need_saves_migrated)
		return 1

	if (!path)
		load_path(C.ckey)
		if (!path)
			return 0

	if (!migrate_client_preferences(C))
		testing("Returned here.")
		return 0

	testing("Saves now.")
	if (!migrate_client_characters(C))
		testing("AAAH!")
		return 0

	return 1

/*
 * Handles the migration of preferences.
 * Loads the prefs to the datum, then saves them to SQL.
 */
/datum/preferences/proc/migrate_client_preferences(var/client/C)
	load_preferences()

	return SavePrefData(C.ckey)

/*
 * Handles the migration of characters.
 * Finds all of your saved characters, loads them into the datum, and saves them onto the SQL.
 */
/datum/preferences/proc/migrate_client_characters(var/client/C)
	var/savefile/S = new /savefile(path)
	if (!S)
		testing("No save file. RIP in pasta.")
		return 0

	S.cd = "/"
	var/list/character_slots = list()

	for (var/a in S.dir)
		if (findtext(a, "character"))
			var/slot_id = replacetext(a, "character", "")
			character_slots += slot_id
			testing("Found slot [slot_id]")

	if (!character_slots.len)
		return 1

	for (var/slot in character_slots)
		load_character(slot)
		testing("Migrating slot [slot]")

		if (!skills || !skills.len)
			ZeroSkills(1)

		if (!SQLsave_character(slot, C.ckey))
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

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_player SET migration_status = '0' WHERE ckey = :ckey")
	query.Execute(list(":ckey" = C.ckey))
