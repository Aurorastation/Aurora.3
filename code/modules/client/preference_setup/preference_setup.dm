#define TOPIC_NOACTION       0
#define TOPIC_HANDLED        1
#define TOPIC_REFRESH        2
#define TOPIC_UPDATE_PREVIEW 4
#define TOPIC_REFRESH_UPDATE_PREVIEW (TOPIC_UPDATE_PREVIEW|TOPIC_REFRESH)

// These are bitflags. Use wisely.
#define SQL_CHARACTER	0x1
#define SQL_PREFERENCES	0x2

// A bit of a hack to allow unit testing of category items.
#ifdef UNIT_TEST
#	define PREF_CLIENT_CKEY ""
#else
#	define PREF_CLIENT_CKEY pref.client.ckey
#endif

/datum/category_group/player_setup_category/general_preferences
	name = "General"
	sort_order = 1
	category_item_type = /datum/category_item/player_setup_item/general

/datum/category_group/player_setup_category/origin
	name = "Origin"
	sort_order = 2
	category_item_type = /datum/category_item/player_setup_item/origin

/datum/category_group/player_setup_category/skill_preferences
	name = "Skills"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/skills

/datum/category_group/player_setup_category/occupation_preferences
	name = "Occupation"
	sort_order = 4
	category_item_type = /datum/category_item/player_setup_item/occupation

/datum/category_group/player_setup_category/appearance_preferences
	name = "Roles"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/antagonism

/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 6
	category_item_type = /datum/category_item/player_setup_item/loadout

/datum/category_group/player_setup_category/global_preferences
	name = "Global"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/player_global
	sql_role = SQL_PREFERENCES

/datum/category_group/player_setup_category/other_preferences
	name = "Other"
	sort_order = 8
	category_item_type = /datum/category_item/player_setup_item/other

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

/datum/category_collection/player_setup_collection/proc/sanitize_setup(sql_load = FALSE)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup(sql_load)

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

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && (category in categories))
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.ShowChoices(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0
	var/sql_role = SQL_CHARACTER
	var/modified = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup(sql_load = FALSE)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences(sql_load)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character(sql_load)

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	if (!GLOB.config.sql_saves || !establish_db_connection(GLOB.dbcon))
		for(var/datum/category_item/player_setup_item/PI in items)
			PI.load_character(S)
	else
		// Load every category minus the global
		handle_sql_loading(SQL_CHARACTER)

	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_character_special(S)
		PI.sanitize_character(GLOB.config.sql_saves)

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for (var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

	var/db_available = GLOB.config.sql_saves && establish_db_connection(GLOB.dbcon)

	for (var/datum/category_item/player_setup_item/PI in items)
		PI.save_character_special(S)
		if(!db_available)
			PI.save_character(S)

	if (db_available && modified)
		// No save here, because this is only called from the menu and needs to save /everything/.
		handle_sql_saving(SQL_CHARACTER)
		modified = 0

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	if (!GLOB.config.sql_saves || !establish_db_connection(GLOB.dbcon))
		for (var/datum/category_item/player_setup_item/PI in items)
			PI.load_preferences(S)
	else
		handle_sql_loading(SQL_PREFERENCES)

	for (var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences(GLOB.config.sql_saves)

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for (var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()

	if (!GLOB.config.sql_saves || !establish_db_connection(GLOB.dbcon))
		for (var/datum/category_item/player_setup_item/PI in items)
			PI.save_preferences(S)
	else
		handle_sql_saving(SQL_PREFERENCES)

/datum/category_group/player_setup_category/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_item/player_setup_item/PI in items)
		. = . || PI.update_setup(preferences, character)

/datum/category_group/player_setup_category/ui_data(var/mob/user)
	. = list()
	for(var/datum/category_item/player_setup_item/PI in items)
		var/list/item_data = PI.ui_data(user)
		if(length(item_data))
			. += list(item_data)

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

/datum/category_item/player_setup_item/proc/to_client_chat(str)
	if (pref && pref.client)
		to_chat(pref.client, str)

/*
* Called when the item is asked to load per character settings - Only called when sql saves are disabled or unavailable
*/
/datum/category_item/player_setup_item/proc/load_character(var/savefile/S)
	return

/*
* Called no matter if sql saves are enabled or disabled (After load_character)
*/
/datum/category_item/player_setup_item/proc/load_character_special(var/savefile/S)
	return

/*
* Called when the item is asked to save per character settings - Only called when sql saves are disabled or unavailable
*/
/datum/category_item/player_setup_item/proc/save_character(var/savefile/S)
	return

/*
* Called no matter if sql saves are enabled or disabled (Before save_character / handle_sql_saving)
*/
/datum/category_item/player_setup_item/proc/save_character_special(var/savefile/S)
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
* Called when the owner category is composing its insert query
*/
/datum/category_item/player_setup_item/proc/gather_save_query()
	return list()

/*
* Called when the owner category is composing its query parameters for loading.
*/
/datum/category_item/player_setup_item/proc/gather_load_parameters()
	return list()

/*
* Called when the owner category is composing its query parameters for inserting a new record.
*/
/datum/category_item/player_setup_item/proc/gather_save_parameters()
	return list()

/datum/category_item/player_setup_item/ui_data(var/mob/user)
	return list(
		"kind" = "notice",
		"name" = name,
		"ref" = REF(src),
		"message" = "This preference section has no TGUI renderer."
	)

/datum/category_item/player_setup_item/proc/sanitize_character(var/sql_load = 0)
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences(var/sql_load = 0)
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if (!user.client)
		return 1

	. = OnTopic(href, href_list, user)
	if (. != TOPIC_NOACTION)
		var/datum/category_group/player_setup_category/cat = category
		cat.modified = 1
	if (. & TOPIC_REFRESH)
		user.client.prefs.ShowChoices(user)
	if(. & TOPIC_UPDATE_PREVIEW)
		user.client.prefs.update_preview_icon()

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/handle_ui_topic(var/list/topic, var/mob/user)
	var/result = OnTopic(null, topic, user)
	if(result == TOPIC_NOACTION)
		return FALSE
	var/datum/category_group/player_setup_category/cat = category
	cat.modified = TRUE
	if(result & TOPIC_UPDATE_PREVIEW)
		pref.update_preview_icon()
	return TRUE

/datum/category_item/player_setup_item/proc/preference_mob()
	if(pref && pref.client && pref.client.mob)
		return pref.client.mob
