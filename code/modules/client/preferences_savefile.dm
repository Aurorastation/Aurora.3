#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	12

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	var/savefile/S
	if (!config.sql_saves)
		if (!path)
			return 0
		if (!fexists(path))
			return 0
		S = new /savefile(path)
		if (!S)
			return 0
		S.cd = "/"

		S["version"] >> savefile_version

	player_setup.load_preferences(S)

	if (!config.sql_saves)
		loaded_preferences = S

	return 1

/datum/preferences/proc/save_preferences()
	var/savefile/S
	if (!config.sql_saves)
		if(!path)
			return 0
		S = new /savefile(path)
		if(!S)
			return 0
		S.cd = "/"

		S["version"] << SAVEFILE_VERSION_MAX

	player_setup.save_preferences(S)

	if (!config.sql_saves)
		loaded_preferences = S

	return 1

/datum/preferences/proc/load_character(slot)
	var/savefile/S
	var/mob/abstract/new_player/NP = src.client.mob
	var/readied
	if(istype(NP) && NP.ready)
		readied = TRUE
		SSticker.update_ready_list(NP, force_urdy=TRUE)

	if (!config.sql_saves)
		if (!path)
			return 0
		if (!fexists(path))
			return 0
		S = new /savefile(path)
		if (!S)
			return 0
		S.cd = "/"
		if (!slot)
			slot = default_slot
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
		S.cd = "/character[slot]"
	else if (slot)
		current_character = slot

	player_setup.load_character(S)
	clear_character_previews() // Recalculate them on next show

	if (!config.sql_saves)
		loaded_character = S
	else
		save_preferences()

	if(istype(NP) && readied)
		SSticker.update_ready_list(NP)

	return 1

/datum/preferences/proc/save_character()
	var/savefile/S
	if (!config.sql_saves)
		if(!path)
			return 0
		S = new /savefile(path)
		if(!S)
			return 0
		S.cd = "/character[default_slot]"

		S["version"] << SAVEFILE_VERSION_MAX

	player_setup.save_character(S)

	if (!config.sql_saves)
		loaded_character = S

	return S

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup(config.sql_saves)
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences || !character)
		return 0
	return player_setup.update_setup(preferences, character)

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
