/datum/config_entry
	abstract_type = /datum/config_entry
	var/name
	var/config_entry_value
	var/default
	var/protection = NONE

/datum/config_entry/New()
	if(type == abstract_type)
		CRASH("Abstract config entry [type] instantiated!")

	var/type_name = "[type]"
	var/last_slash = findlasttext(type_name, "/")
	name = lowertext(copytext(type_name, last_slash + 1))
	set_default()

/datum/config_entry/proc/set_default()
	if(islist(default))
		var/list/default_list = default
		config_entry_value = default_list.Copy()
	else
		config_entry_value = default

/datum/config_entry/proc/ValidateAndSet(str_val)
	CRASH("Invalid config entry type [type]!")

/datum/config_entry/flag
	abstract_type = /datum/config_entry/flag
	default = FALSE

/datum/config_entry/flag/ValidateAndSet(str_val)
	config_entry_value = text2num(trim("[str_val]")) != 0
	return TRUE

/datum/configuration
	var/list/config_entries
	var/list/config_entries_by_type

/datum/configuration/proc/init_config_entries()
	if(config_entries)
		return

	config_entries = list()
	config_entries_by_type = list()

	for(var/config_entry_type in subtypesof(/datum/config_entry))
		var/datum/config_entry/config_entry = config_entry_type
		if(initial(config_entry.abstract_type) == config_entry_type)
			continue

		config_entry = new config_entry_type
		if(config_entries[config_entry.name])
			log_config("Duplicate config entry name '[config_entry.name]' for [config_entry.type].")
			qdel(config_entry)
			continue

		config_entries[config_entry.name] = config_entry
		config_entries_by_type[config_entry_type] = config_entry

/datum/configuration/proc/Get(entry_type)
	if(!config_entries_by_type)
		init_config_entries()

	var/datum/config_entry/config_entry = config_entries_by_type[entry_type]
	if(!config_entry)
		CRASH("Missing config entry for [entry_type]!")

	return config_entry.config_entry_value

/datum/configuration/proc/Set(entry_type, new_val, force = FALSE)
	if(!config_entries_by_type)
		init_config_entries()

	var/datum/config_entry/config_entry = config_entries_by_type[entry_type]
	if(!config_entry)
		CRASH("Missing config entry for [entry_type]!")
	if(!force && (config_entry.protection & CONFIG_ENTRY_LOCKED))
		return FALSE

	. = config_entry.ValidateAndSet("[new_val]")
	if(. && istype(config_entry, /datum/config_entry/flag) && (config_entry.name in logsettings))
		logsettings[config_entry.name] = config_entry.config_entry_value

/datum/configuration/proc/sync_logging_config_entries()
	if(!config_entries)
		init_config_entries()

	for(var/entry_name in config_entries)
		if(!istext(entry_name) || (findtext(entry_name, "log_") != 1 && findtext(entry_name, "logging_") != 1))
			continue

		var/datum/config_entry/flag/config_entry = config_entries[entry_name]
		if(istype(config_entry) && !(entry_name in logsettings))
			logsettings[entry_name] = config_entry.config_entry_value

	for(var/setting in logsettings)
		sync_logging_config_entry(setting)

/datum/configuration/proc/sync_logging_config_entry(setting)
	if(!config_entries)
		init_config_entries()

	var/datum/config_entry/flag/config_entry = config_entries[setting]
	if(!istype(config_entry))
		return

	config_entry.config_entry_value = !!logsettings[setting]
