GLOBAL_REAL(logger, /datum/log_holder)

/**
 * Main datum to manage structured logging actions.
 */
/datum/log_holder
	/// Round ID, if set, that logging is initialized for.
	var/round_id
	/// Timestamp when the log holder initialized.
	var/logging_start_timestamp
	/// category string -> /datum/log_category.
	var/list/datum/log_category/log_categories
	/// set of category strings that exist but are disabled by config
	var/list/disabled_categories
	/// Master category typepath -> list of subcategory typepaths.
	var/list/category_group_tree
	/// List of log arg lists waiting for processing pending log initialization.
	var/list/waiting_log_calls
	/// Whether human-readable text logs are enabled.
	var/human_readable_enabled = FALSE
	/// Cached ui_data payload.
	var/list/data_cache = list()
	/// Last world.time the ui_data payload was refreshed.
	var/last_data_update = 0
	var/initialized = FALSE
	var/shutdown = FALSE

GENERAL_PROTECT_DATUM(/datum/log_holder)

/datum/log_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "LogViewer", "View Round Logs", 720, 720)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/log_holder/ui_state(mob/user)
	return GLOB.admin_state

/datum/log_holder/ui_static_data(mob/user)
	var/list/data = list(
		"round_id" = GLOB.round_id,
		"logging_start_timestamp" = logging_start_timestamp,
	)

	var/list/tree = list()
	data["tree"] = tree

	var/list/enabled = list()
	if(log_categories)
		for(var/category in log_categories)
			enabled += category
	tree["enabled"] = enabled

	var/list/disabled = list()
	if(disabled_categories)
		for(var/category in disabled_categories)
			disabled += category
	tree["disabled"] = disabled

	return data

/datum/log_holder/ui_data(mob/user)
	if(!last_data_update || (world.time - last_data_update) > LOG_UPDATE_TIMEOUT)
		cache_ui_data()
	return data_cache

/datum/log_holder/proc/cache_ui_data()
	var/list/category_map = list()
	if(log_categories)
		for(var/category_name in log_categories)
			var/datum/log_category/category = log_categories[category_name]
			var/list/category_data = list()

			var/list/entries = list()
			for(var/datum/log_entry/entry as anything in category.entries)
				entries += list(list(
					"id" = entry.id,
					"message" = entry.message,
					"timestamp" = entry.timestamp,
					"data" = entry.data,
					"semver" = entry.semver_store,
				))
			category_data["entries"] = entries
			category_data["entry_count"] = category.entry_count

			category_map[category.category] = category_data

	data_cache.Cut()
	last_data_update = world.time

	data_cache["categories"] = category_map
	data_cache["last_data_update"] = last_data_update

/datum/log_holder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("refresh")
			cache_ui_data()
			SStgui.update_uis(src)
			return TRUE
		else
			stack_trace("Unknown ui_act action [action] for [type]")

/datum/log_holder/proc/init_logging()
	if(initialized)
		CRASH("Attempted to call init_logging twice!")

	round_id = GLOB.round_id
	logging_start_timestamp = rustg_unix_timestamp()
	log_categories = list()
	disabled_categories = list()
	human_readable_enabled = CONFIG_GET(flag/log_as_human_readable)

	category_group_tree = assemble_log_category_tree()
	for(var/datum/log_category/master_category as anything in category_group_tree)
		var/list/sub_categories = category_group_tree[master_category]
		sub_categories = sub_categories.Copy()

		for(var/datum/log_category/sub_category as anything in sub_categories)
			var/config_flag = initial(sub_category.config_flag)
			if(config_flag && !config.Get(config_flag))
				disabled_categories[initial(sub_category.category)] = TRUE
				sub_categories -= sub_category

		var/config_flag = initial(master_category.config_flag)
		if(config_flag && !config.Get(config_flag))
			disabled_categories[initial(master_category.category)] = TRUE
			if(!length(sub_categories))
				continue

		init_log_category(master_category, sub_categories)

	initialized = TRUE

	rustg_file_write("", "[GLOB.log_directory]/dd.log")

	for(var/list/arg_list as anything in waiting_log_calls)
		Log(arglist(arg_list))
	waiting_log_calls?.Cut()

	if(GLOB.config_error_log && fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	world._initialize_log_files()

/datum/log_holder/proc/shutdown_logging()
	if(shutdown)
		return

	shutdown = TRUE

/// Iterates over all log category types to assemble them into a master -> subcategory tree.
/datum/log_holder/proc/assemble_log_category_tree()
	var/static/list/category_tree
	if(category_tree)
		return category_tree

	category_tree = list()
	var/list/known_categories = list()
	var/list/sub_categories = list()

	for(var/datum/log_category/category_type as anything in subtypesof(/datum/log_category))
		var/category = initial(category_type.category)
		if(!category)
			stack_trace("log category type '[category_type]' does not define a category, skipping")
			continue

		if(category in known_categories)
			stack_trace("log category type '[category_type]' has duplicate category '[category]', skipping")
			continue
		known_categories[category] = TRUE

		if(!initial(category_type.schema_version))
			stack_trace("log category type '[category_type]' does not have a valid schema version, skipping")
			continue

		var/master_category = initial(category_type.master_category)
		if(master_category)
			if(!sub_categories[master_category])
				sub_categories[master_category] = list()
			sub_categories[master_category] += list(category_type)
			continue

		category_tree[category_type] = list()

	for(var/datum/log_category/master as anything in sub_categories)
		if(!(master in category_tree))
			stack_trace("log category [master] is an invalid master category")
			continue

		for(var/datum/log_category/sub_category as anything in sub_categories[master])
			if(initial(sub_category.secret) != initial(master.secret))
				stack_trace("log category [sub_category] has a secret status that differs from its master category [master]")
			category_tree[master] += sub_category

	return category_tree

/// Gets a recovery file for the given path. Caches the last known recovery path for each path.
/datum/log_holder/proc/get_recovery_file_for(path)
	var/static/list/cache
	if(!cache)
		cache = list()

	var/count = cache[path] || 0
	while(fexists("[path].rec[count]"))
		count++
	cache[path] = count

	return "[path].rec[count]"

/// Sets up the given category's file and header.
/datum/log_holder/proc/init_category_file(datum/log_category/category)
	var/file_path = category.get_output_file(null)
	if(fexists(file_path))
		rustg_file_append("{\"LOG FILE RESET -- THIS IS AN ERROR\"}", file_path)
		fcopy(file_path, get_recovery_file_for(file_path))
	rustg_file_write("[json_encode(category.category_header)]\n", file_path)

	if(config && !CONFIG_GET(flag/log_as_human_readable))
		return

	file_path = category.get_output_file(null, "log")
	if(fexists(file_path))
		rustg_file_append("LOG FILE RESET -- THIS IS AN ERROR", file_path)
		fcopy(file_path, get_recovery_file_for(file_path))
	rustg_file_write("\[[human_readable_timestamp()]\] Starting up round ID [round_id].\n - -------------------------\n", file_path)

/datum/log_holder/proc/recover_category_file(category_name, extension = "log.json")
	if(!initialized || !log_categories)
		return FALSE

	var/datum/log_category/category = log_categories[category_name]
	if(!category)
		return FALSE

	if(category.master_category)
		category = category.master_category

	var/file_path = category.get_output_file(null, extension)
	if(fexists(file_path))
		return TRUE

	if(extension == "log.json")
		rustg_file_write("[json_encode(category.category_header)]\n", file_path)
		return fexists(file_path)

	if(extension == "log")
		if(config && !CONFIG_GET(flag/log_as_human_readable))
			return FALSE
		rustg_file_write("\[[human_readable_timestamp()]\] Recovered log file for round ID [round_id].\n - -------------------------\n", file_path)
		return fexists(file_path)

	return FALSE

/// Initializes the given log category and populates contained categories from the subcategory list
/datum/log_holder/proc/init_log_category(datum/log_category/category_type, list/datum/log_category/sub_categories)
	var/datum/log_category/category_instance = new category_type
	var/list/contained_categories = list()

	for(var/datum/log_category/sub_category as anything in sub_categories)
		sub_category = new sub_category
		var/sub_category_actual = sub_category.category
		sub_category.master_category = category_instance
		log_categories[sub_category_actual] = sub_category

		if(!semver_to_list(sub_category.schema_version))
			stack_trace("log category [sub_category_actual] has an invalid schema version '[sub_category.schema_version]'")
			sub_category.schema_version = LOG_CATEGORY_SCHEMA_VERSION_NOT_SET

		contained_categories += sub_category_actual

	log_categories[category_instance.category] = category_instance

	if(!semver_to_list(category_instance.schema_version))
		stack_trace("log category [category_instance.category] has an invalid schema version '[category_instance.schema_version]'")
		category_instance.schema_version = LOG_CATEGORY_SCHEMA_VERSION_NOT_SET

	contained_categories += category_instance.category

	category_instance.category_header = list(
		LOG_HEADER_INIT_TIMESTAMP = logging_start_timestamp,
		LOG_HEADER_ROUND_ID = GLOB.round_id,
		LOG_HEADER_SECRET = category_instance.secret,
		LOG_HEADER_CATEGORY_LIST = contained_categories,
		LOG_HEADER_CATEGORY = category_instance.category,
	)

	init_category_file(category_instance)

/datum/log_holder/proc/human_readable_timestamp()
	return logging_human_readable_timestamp()

/// Adds an entry to the given category, queueing if logging has not initialized yet
/datum/log_holder/proc/Log(category, message, list/data)
	if(!istext(message))
		message = "[message]"
		stack_trace("Logging with a non-text message")

	if(!category)
		category = LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND
		stack_trace("Logging with a null or empty category")

	if(!isnull(data) && !islist(data))
		data = list("data" = data)
		stack_trace("Logging with data that is not a list")

	if(!initialized)
		if(!waiting_log_calls)
			waiting_log_calls = list()
		waiting_log_calls += list(list(category, message, data))
		return

	if(shutdown)
		return

	if(disabled_categories[category])
		return

	var/datum/log_category/log_category = log_categories[category]
	if(!log_category)
		if(category != LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND && log_categories[LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND])
			Log(LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND, "Attempted to log to a category that does not exist", list(
				"category" = category,
				"message" = message,
			))
		CRASH("Attempted to log to a category that doesn't exist! [category]")

	var/list/semver_store = null
	if(length(data))
		semver_store = list()
		data = recursive_jsonify(data, semver_store)

	log_category.create_entry(message, data, semver_store)

/// Recursively converts an associative list of datums into json-safe lists
/datum/log_holder/proc/recursive_jsonify(list/data_list, list/semvers)
	if(isnull(data_list))
		return null

	var/list/jsonified_list = list()
	for(var/key in data_list)
		var/data = data_list[key]

		if(islist(data))
			data = recursive_jsonify(data, semvers)

		else if(isdatum(data))
			var/list/options_list = list(
				SCHEMA_VERSION = LOG_CATEGORY_SCHEMA_VERSION_NOT_SET,
			)

			var/datum/source = data
			var/list/serialization_data = source.serialize_list(options_list, semvers)
			var/current_semver = semvers[source.type]
			if(!semver_to_list(current_semver))
				stack_trace("serialization of [source.type] had an invalid semver")
				semvers[source.type] = LOG_CATEGORY_SCHEMA_VERSION_NOT_SET

			if(!length(serialization_data))
				stack_trace("serialization data was empty for [source.type]")
				continue

			data = recursive_jsonify(serialization_data, semvers)

		if(islist(data) && !length(data))
			stack_trace("recursive_jsonify got an empty list after serialization")
			continue

		jsonified_list[key] = data

	return jsonified_list
