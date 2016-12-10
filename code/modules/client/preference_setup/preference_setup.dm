// These are not flags, binary operations not intended
#define TOPIC_NOACTION 0
#define TOPIC_HANDLED 1
#define TOPIC_REFRESH 2

/datum/category_group/player_setup_category/general_preferences
	name = "General"
	sort_order = 1
	category_item_type = /datum/category_item/player_setup_item/general

/datum/category_group/player_setup_category/skill_preferences
	name = "Skills"
	sort_order = 2
	category_item_type = /datum/category_item/player_setup_item/skills

/datum/category_group/player_setup_category/occupation_preferences
	name = "Occupation"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/occupation

/datum/category_group/player_setup_category/appearance_preferences
	name = "Roles"
	sort_order = 4
	category_item_type = /datum/category_item/player_setup_item/antagonism

/datum/category_group/player_setup_category/global_preferences
	name = "Global"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/player_global

/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(S)

/datum/category_collection/player_setup_collection/proc/save_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(S)

/datum/category_collection/player_setup_collection/proc/load_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(S)

/datum/category_collection/player_setup_collection/proc/save_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(S)

/datum/category_collection/player_setup_collection/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_group/player_setup_category/PS in categories)
		. = . || PS.update_setup(preferences, character)

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && category in categories)
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.ShowChoices(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	if (!config.sql_saves && !establish_db_connection(dbcon))
		for(var/datum/category_item/player_setup_item/PI in items)
			PI.load_character(S)
	else
		src.load_character_sql()

	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character(config.sql_saves)

/*
 * A proc for dynamically loading a character from the database.
 * See the category items for procs on what pieces are given.
 *
 * Each query is cached as well, after generation. Only things recompiled are the arguments and the finalized query text (with arguments in it).
 */
/datum/category_group/player_setup_category/proc/load_character_sql()
	var/static/list/query_cache

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

		// Each query should only return exactly 1 row.
		var/list/var_names = query_cache[type][query_text]
		if (query.NextRow())
			for (var/i = 1, i <= var_names.len, i++)
				var/list/layers = splittext(var_names[i], "/")
				if (layers.len == 1)
					cc.preferences.vars[var_names[i]] = query.item[i]
				else
					cc.preferences.vars[layers[1]][layers[2]] = query.item[i]

/datum/category_group/player_setup_category/proc/gather_load_parameters()
	var/list/arg_list = list()
	for (var/datum/category_item/player_setup_item/PI in items)
		arg_list |= PI.gather_load_parameters()

	return arg_list

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_preferences(S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_preferences(S)

/datum/category_group/player_setup_category/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_item/player_setup_item/PI in items)
		. = . || PI.update_setup(preferences, character)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/halfway = items.len / 2
	for(var/datum/category_item/player_setup_item/PI in items)
		if(halfway && current++ >= halfway)
			halfway = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[PI.content(user)]<br>"
	. += "</td></tr></table>"

/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/PI in items)
		. += "[PI.content(user)]<br>"

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/dd_SortValue()
	return sort_order

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(var/savefile/S)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(var/savefile/S)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to update user/global settings
*/
/datum/category_item/player_setup_item/proc/update_setup(var/savefile/preferences, var/savefile/character)
	return 0

/*
* Called when the owner category is composing its load query
*/
/datum/category_item/player_setup_item/proc/gather_load_query()
	return list()

/*
* Called when the owner category is composing its query parameters for loading.
*/
/datum/category_item/player_setup_item/proc/gather_load_parameters()
	return list()

/datum/category_item/player_setup_item/proc/content()
	return

/datum/category_item/player_setup_item/proc/sanitize_character(var/sql_load = 0)
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences(var/sql_load = 0)
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	. = OnTopic(href, href_list, user)
	if(. == TOPIC_REFRESH)
		user.client.prefs.ShowChoices(user)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(pref && pref.client && pref.client.mob)
		return pref.client.mob
