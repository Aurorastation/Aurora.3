/*
 * A proc for dynamically loading a character from the database.
 * See the category items for procs on what pieces are given.
 *
 * Each query is cached as well, after generation. Only things recompiled are the arguments and the finalized query text (with arguments in it).
 */
/datum/category_group/player_setup_category/proc/handle_sql_loading(var/role_type)
	var/static/list/query_cache

	// We aren't loading this category. Bye.
	if (role_type && sql_role != role_type)
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
				query += "[arg_names[i]] = :[arg_names[i]]"
				arg_names[i] = ":[arg_names[i]]"

				if (i != count)
					query += " AND "
				else
					query += ";"

			// Save it.
			query_cache[type][query] = var_names

	// Need to typecast due to reasons.
	var/datum/category_collection/player_setup_collection/cc = collection

	// Actually utilize the queries.
	var/list/arg_list = gather_load_parameters()
	for (var/query_text in query_cache[type])
		var/DBQuery/query = dbcon.NewQuery(query_text)
		query.Execute(arg_list, 1)
		if (query.ErrorMsg())
			error("Error loading character from SQL: [query.ErrorMsg()]")

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
					error("Error loading character from SQL: [e.name]")
					log_debug("SQL Saves: [e.name]")
					log_debug("SQL Saves: [e.desc]")

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
	if (role_type && sql_role != role_type)
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
				arg_names += ":[variable]"

			query += "[jointext(arg_names, ", ")]) ON DUPLICATE KEY UPDATE"

			var/i = 1
			for (var/variable in var_names)
				if (isnull(var_names[variable]))
					query += " [variable] = [arg_names[i]]"
				if (i < var_names.len)
					query += ", "

				i++

			// Save it.
			query_cache[type] += query

	// Actually utilize the queries.
	var/list/arg_list = gather_save_parameters()

	// Typecast the collection so we can access its preferences var.
	var/datum/category_collection/player_setup_collection/cc = collection
	for (var/query_text in query_cache[type])
		var/DBQuery/query = dbcon.NewQuery(query_text)
		query.Execute(arg_list, 1)

		if (query.ErrorMsg())
			error("Error saving character to SQL: [query.ErrorMsg()]")

		if (role_type == SQL_CHARACTER && !cc.preferences.current_character)
			// No current character, means we're doing insert queries.
			// Quickly nab the new ID and substitute it within the args.
			query = dbcon.NewQuery("SELECT LAST_INSERT_ID() AS new_id")
			query.Execute()

			if (query.NextRow())
				arg_list[":id"] = text2num(query.item[1])
				arg_list[":char_id"] = text2num(query.item[1])
				cc.preferences.current_character = text2num(query.item[1])
			else
				error("Error inserting character to SQL: New ID was not recovered.")
				if (query.ErrorMsg())
					error("Error retreiving new character ID: [query.ErrorMsg()]")

/datum/category_group/player_setup_category/proc/gather_save_parameters()
	var/list/arg_list = list()
	for (var/datum/category_item/player_setup_item/PI in items)
		arg_list |= PI.gather_save_parameters()

	return arg_list
