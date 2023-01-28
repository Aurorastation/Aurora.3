// Set this to 1 if you want to debug the SQL saves.
// I got tired as hell from writing these debug lines and deleting them later.

/*
 * A proc for dynamically loading a character from the database.
 * See the category items for procs on what pieces are given.
 *
 * Each query is cached as well, after generation. Only things recompiled are the arguments and the finalized query text (with arguments in it).
 */
/datum/category_group/player_setup_category/proc/handle_sql_loading(var/role_type)
	var/static/list/query_cache

	// We aren't loading this category. Bye.
	if (role_type && !(sql_role & role_type))
#ifdef SQL_PREF_DEBUG
		log_debug("SQL CHARACTER LOAD: Bad role_type, returned. Looking for: [role_type], had: [sql_role]. Conjunction: [sql_role & role_type].")
#endif
		return

	if (isnull(query_cache))
		query_cache = list()

	// This handles the generation of queries. One per category, total of 5 UNLESS one category wants to query more than one table.
	// It uses like, 3+ levels of lists. But it works, and is only run once per category in the global sense. So technically, efficient!
	// :D - Skull132
	if (!query_cache.len || isnull(query_cache[type]))
		query_cache[type] = list()
		var/list/tables = list()

		// First, consolidate the different lists into one.
		for (var/datum/category_item/player_setup_item/PI in items)
			var/list/pi_tables = PI.gather_load_query()
			// Expected layout: list("table A name" = list("vars" = list("column name" = "var name"), "args" = list()),
			//						"table B name" = list("vars" = list(), "args" = list()))

			for (var/table in pi_tables)
				var/list/A = pi_tables[table]
				if (isnull(tables[table]))
					tables[table] = list("vars" = list(), "args" = list())

				tables[table]["vars"] |= A["vars"]
				tables[table]["args"] |= A["args"]

		// Second, create the queries and save them.
		for (var/table in tables)
			var/query = "SELECT "
			var/list/var_names = tables[table]["vars"]
			var/count = var_names.len

			// Process the variables and rows we want.
			var/i = 1
			for (var/name in var_names)
				query += name

				if (!isnull(var_names[name]))
					var/new_name = var_names[name]
					var_names.Remove(name)
					var_names.Insert(i, new_name)

				if (i != count)
					query += ", "
				else
					query += " "

				i++

			query += "FROM [table] WHERE "

			// Process the args.
			var/list/arg_names = tables[table]["args"]
			count = arg_names.len
			for (i = 1, i <= count, i++)
				query += "[arg_names[i]] = :[arg_names[i]]:"

				if (i != count)
					query += " AND "
				else
					query += ";"

#ifdef SQL_PREF_DEBUG
			log_debug("SQL CHARACTER LOAD: Cached query [query] with variables [json_encode(var_names)]")
#endif
			// Save it.
			query_cache[type][query] = var_names

	// Need to typecast due to reasons.
	var/datum/category_collection/player_setup_collection/cc = collection

	// Actually utilize the queries.
	var/list/arg_list = gather_load_parameters()

#ifdef SQL_PREF_DEBUG
	log_debug("SQL CHARACTER LOAD: Started loading with arguments: [json_encode(arg_list)]. Role type: [role_type]")
#endif

	for (var/query_text in query_cache[type])
		var/DBQuery/query = dbcon.NewQuery(query_text)
		query.Execute(arg_list)
		if (query.ErrorMsg())
			log_error("SQL CHARACTER LOAD: SQL query error: [query.ErrorMsg()]")
			log_debug("SQL CHARACTER LOAD: query args: [json_encode(arg_list)]")

			continue

#ifdef SQL_PREF_DEBUG
		else
			log_debug("SQL CHARACTER LOAD: Successfully executed query: [query_text]")
#endif

		// Each query should only return exactly 1 row.
		var/list/var_names = query_cache[type][query_text]
		if (query.NextRow())
			for (var/i = 1, i <= var_names.len, i++)
				var/list/layers = splittext(var_names[i], "/")
				try
					if (layers.len == 1)
						cc.preferences.vars[var_names[i]] = query.item[i]
					else
						cc.preferences.vars[layers[1]][layers[2]] = query.item[i]
				catch(var/exception/e)
					log_error("SQL CHARACTER LOAD: bad variable name: [e.name]")
					log_debug("SQL CHARACTER LOAD: var name: [var_names[i]]")

/datum/category_group/player_setup_category/proc/gather_load_parameters()
	var/list/arg_list = list()
	for (var/datum/category_item/player_setup_item/PI in items)
		arg_list |= PI.gather_load_parameters()

	return arg_list

/*
 * A proc for dynamically inserting new character and preference records into the database.
 * See the category items for procs on what pieces are given.
 *
 * Each query is cached as well, after generation. Only things recompiled are the arguments and the finalized query text (with arguments in it).
 */
/datum/category_group/player_setup_category/proc/handle_sql_saving(var/role_type)
	var/static/list/query_cache

	// We aren't loading this category. Bye.
	if (role_type && !(sql_role & role_type))
#ifdef SQL_PREF_DEBUG
		log_debug("SQL CHARACTER SAVE: Bad role_type, returned. Looking for: [role_type], had: [sql_role]. Conjunction: [sql_role & role_type].")
#endif
		return

	if (isnull(query_cache))
		query_cache = list()

	// This handles the generation of queries. One per category, total of 5 UNLESS one category wants to query more than one table.
	// It uses like, 3+ levels of lists. But it works, and is only run once per category in the global sense. So technically, efficient!
	// :D - Skull132
	if (!query_cache.len || isnull(query_cache[type]))
		query_cache[type] = list()
		var/list/tables = list()

		// First, consolidate the different lists into one.
		for (var/datum/category_item/player_setup_item/PI in items)
			var/list/pi_tables = PI.gather_save_query()
			// Expected layout: list("table A name" = list("var1" = 1, "var2" = 0, "var3" = 1),
			//						"table B name" = list("var4" = 0, "var5" = 0, "var6" = 0))

			for (var/table in pi_tables)
				var/list/A = pi_tables[table]
				if (isnull(tables[table]))
					tables[table] = list()

				tables[table] |= A

		// Second, create the queries and save them.
		for (var/table in tables)
			var/query = "INSERT INTO [table] ("
			var/list/var_names = tables[table]

			query += "[jointext(var_names, ", ")]) VALUES ("

			// Process the args.
			var/list/arg_names = list()
			for (var/variable in var_names)
				arg_names += ":[variable]:"

			query += "[jointext(arg_names, ", ")]) ON DUPLICATE KEY UPDATE"

			var/i = 1
			for (var/variable in var_names)
				if (isnull(var_names[variable]))
					query += " [variable] = [arg_names[i]]"

					if (i < var_names.len)
						query += ","

				i++

			// Remove any potentially damaging commas from the end.
			query = replacetext(query, ",", "", length(query) - 1)

#ifdef SQL_PREF_DEBUG
			log_debug("SQL CHARACTER SAVE: Cached query [query].")
#endif

			// Save it.
			query_cache[type] += query

	// Actually utilize the queries.
	var/list/arg_list = gather_save_parameters()

#ifdef SQL_PREF_DEBUG
	log_debug("SQL CHARACTER SAVE: Started saving with arguments: [json_encode(arg_list)]. Role type: [role_type]")
#endif

	// Typecast the collection so we can access its preferences var.
	var/datum/category_collection/player_setup_collection/cc = collection
	for (var/query_text in query_cache[type])
		var/DBQuery/query = dbcon.NewQuery(query_text)
		query.Execute(arg_list)

		if (query.ErrorMsg())
			log_error("SQL CHARACTER SAVE: SQL query error: [query.ErrorMsg()]")
			log_debug("SQL CHARACTER SAVE: query args: [json_encode(arg_list)]")

			continue

#ifdef SQL_PREF_DEBUG
		else
			log_debug("SQL CHARACTER SAVE: Successfully executed query: [query_text]")
#endif

		if ((role_type & SQL_CHARACTER) && !cc.preferences.current_character)
			// No current character, means we're doing insert queries.
			// Quickly nab the new ID and substitute it within the args.
			query = dbcon.NewQuery("SELECT LAST_INSERT_ID() AS new_id")
			query.Execute()

			if (query.NextRow())
				arg_list["id"] = text2num(query.item[1])
				arg_list["char_id"] = text2num(query.item[1])
				cc.preferences.current_character = text2num(query.item[1])

#ifdef SQL_PREF_DEBUG
				log_debug("SQL CHARACTER SAVE: Successfully set character ID to [cc.preferences.current_character]")
#endif

			else
				log_error("SQL CHARACTER SAVE: New ID was not recovered.")
				if (query.ErrorMsg())
					error("SQL CHARACTER SAVE: SQL query error from last_insert_id: [query.ErrorMsg()]")
					log_debug("SQL CHARACTER SAVE: SQL query error from last_insert_id: [query.ErrorMsg()]")

/datum/category_group/player_setup_category/proc/gather_save_parameters()
	var/list/arg_list = list()
	for (var/datum/category_item/player_setup_item/PI in items)
		arg_list |= PI.gather_save_parameters()

	return arg_list
