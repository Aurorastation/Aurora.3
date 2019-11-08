/datum/antagonist/proc/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)

	if(!add_antagonist_mind(player, ignore_role))
		return 0

	//do this again, just in case
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
	player.special_role = role_text

	if(istype(player.current, /mob/abstract))
		create_default(player.current)
	else
		create_antagonist(player, move_to_spawn, do_not_announce, preserve_appearance)
		if(!do_not_equip)
			equip(player.current)

	player.current.faction = faction

	return 1

/datum/antagonist/proc/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg)
	if(!istype(player))
		return 0
	if(!player.current)
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player, ignore_role))
		return 0
	current_antagonists |= player

	if(faction_verb && player.current)
		player.current.verbs |= faction_verb

	player.current.client.verbs += /client/proc/aooc

	player.current << "<span class='notice'>Once you decide on a goal to pursue, you can optionally display it to \
	everyone at the end of the shift with the <b>Set Ambition</b> verb, located in the IC tab.  You can change this at any time, \
	and it otherwise has no bearing on your round.</span>"
	player.current.verbs += /mob/living/proc/write_ambition

	// Handle only adding a mind and not bothering with gear etc.
	if(nonstandard_role_type)
		faction_members |= player
		player.current << "<span class='danger'><font size=3>You are \a [nonstandard_role_type]!</font></span>"
		player.special_role = nonstandard_role_type
		if(nonstandard_role_msg)
			player.current << "<span class='notice'>[nonstandard_role_msg]</span>"
		update_icons_added(player)

	// Log it
	log_antagonist_add(player)
	return 1

/datum/antagonist/proc/remove_antagonist(var/datum/mind/player, var/show_message = TRUE, var/implanted)
	if(!istype(player))
		return 0

	if(player.current && faction_verb)
		player.current.verbs -= faction_verb

	if(player in current_antagonists)
		log_antagonist_remove()
		if (show_message)
			player.current << "<span class='danger'><font size = 3>You are no longer a [role_text]!</font></span>"
		current_antagonists -= player
		faction_members -= player
		player.special_role = null
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)

		if (!is_special_character(player) && !check_rights(R_ADMIN|R_MOD|R_CCIAA, 0, player.current))
			player.current.client.verbs -= /client/proc/aooc

		if(!is_special_character(player))
			player.current.verbs -= /mob/living/proc/write_ambition
			player.ambitions = ""
		return 1

	return 0


/datum/antagonist/proc/log_antagonist_add(var/datum/mind/player)
	if(!config.sql_enabled)
		return

	if(!establish_db_connection(dbcon))
		log_debug("AntagLog: SQL ERROR - Failed to connect.")
		return
	
	//Try to get the char id
	var/char_id = null
	if(player.current.character_id) //To make sure char_id is null and not 0
		char_id = player.current.character_id

	//Run the query to insert the antagonist into the db
	var/DBQuery/new_log = dbcon.NewQuery("INSERT INTO ss13_antag_log ( ckey, char_id, game_id, char_name, special_role_name, special_role_added) VALUES ( :ckey:, :char_id:, :game_id:, :char_name:, :special_role_name:, :special_role_added:)")
	new_log.Execute(list("ckey" = ckey(player.key) , "char_id" = char_id, "game_id" = game_id, "char_name" = player.current.name, "special_role_name"=role_text,"special_role_added" = "[get_round_duration_formatted()]:00"))

	//Run the query to get the inserted id
	var/DBQuery/log_id = dbcon.NewQuery("SELECT LAST_INSERT_ID() AS log_id")
	log_id.Execute()

	//Save the inserted it to the antagonist datum
	if (log_id.NextRow())
		db_log_id = text2num(log_id.item[1])
	
	return

/datum/antagonist/proc/log_antagonist_remove(var/datum/mind/player)
	if(!config.sql_enabled)
		return

	if(!establish_db_connection(dbcon))
		log_debug("AntagLog: SQL ERROR - Failed to connect.")
		return
	
	if(!db_log_id)
		return
	
	//Run the query to update the db entry with the removal time
	var/DBQuery/update_query = dbcon.NewQuery("UPDATE ss13_antag_log SET special_role_removed = :special_role_removed: WHERE id = :id:")
	update_query.Execute(list("id"=db_log_id,"special_role_removed"="[get_round_duration_formatted()]:00"))