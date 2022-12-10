//This is the custom items system.
//There are two main modes of operation: database-based and file-based
//The operating mode is decided by the config.sql_enabled parameter
//
/// File
// In File mode the system loads all the custom items from the custom_items.json into the custom_items list at roundstart
// There is also a fallback mode for the DEPRECATED custom_items.txt. This fallback mode will be removed at some point.
// You SHOULD migrate to json file (manually) or the db using the automatic migration feature described in the db section
// When the equip_custom_items() proc is called for a specified mob, the custom_items list is iteraed over to determine which
//  custom items belong to that mob of the player. Afterwards the items are spawned and applied to the mob (if the role matches)
//
/// Database
// In the database mode the custom items are NOT preloaded but fetched on demand based on the character id.
// If the database is empty and one of the configuration files exists the configuration file is loaded into the custom_items list.
// Afterwards a attempt is made to migrate the custom items into the database.
// Once there are entries in the ss13_characters_custom_items table no more attempts to migrate the data are made.
// To make it easier to find the round when that migration occured, the feedback variables
//   custom_item_migration_success and custom_item_migration_error are set.
//
/// Removed Features
// The kits have been removed without replacement
// The icon manipulation features have been removed without replacement
// The required access has been removed without replacement
// The name/desc field have been removed and replaced with the item_data system
//  This allows to modify any (string/int) variable of a existing item via the custom_item system.
//  The key in the item_data list is the name of the variable, and the value is the value of the variable.
//  i.e. `item_data = list("name"="asdf")` would set the name of the item to asdf when its spawned in

/var/list/custom_items = list()

//Loads the custom items from the json file if the db backend is disabled
/hook/pregame_start/proc/load_custom_items()
	var/load_from_file = 0

	if (config.sql_enabled)
		log_debug("Custom Items: Loading from SQL")
		//If we have sql enabled we check if the db is empty. If so we migrate the json file to the db
		//If the db is not empty we dont load the json file
		if(!establish_db_connection(dbcon))
			log_debug("Custom Items: Unable to establish database connection. - Aborting")
			return 1

		var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM ss13_characters_custom_items")
		query.Execute()

		if (!query.NextRow())
			log_debug("Custom Items: Unable to fetch custom item count from database. - Aborting")
			return 1
		var/item_count = text2num(query.item[1])
		if(item_count > 0)
			return 1
		//If there are no items in the db, migrate them
		load_from_file = 2
		log_debug("Custom Items: No items found in the database - attempting migration")
	else
		//If we dont have a db, we need to load the json file
		load_from_file = 1

	if(load_from_file)
		log_debug("Custom Items: Loading from File")
		//Check if the json file exists
		if(fexists("config/custom_items.json"))
			log_debug("Custom Items: Loading from json")
			var/list/loaded_items = list()
			var/item_id = 0
			try
				loaded_items = json_decode(return_file_text("config/custom_items.json"))
			catch(var/exception/e)
				log_debug("Custom Items: Failed to load custom_items.json: [e]")

			for(var/item in loaded_items)
				//TODO: Check for existance of the vars first
				item_id += 1
				var/datum/custom_item/ci = new()
				ci.id = item_id
				ci.usr_ckey = item["ckey"]
				ci.usr_charname = item["character_name"]
				ci.item_path = text2path(item["item_path"])
				if(item["item_data"])
					ci.item_data = item["item_data"]
				if(item["item_name"])
					ci.item_data["name"] = item["item_name"]
				if(item["item_desc"])
					ci.item_data["desc"] = item["item_desc"]
				ci.additional_data = item["additional_data"]
				ci.req_titles = item["req_titles"]
				custom_items.Add(ci)
			log_debug("Custom Items: Loaded [length(custom_items)] custom items")
		else if(fexists("config/custom_items.txt")) //TODO: Retire that at some point down the line
			log_debug("Custom Items: Loading from txt")
			log_and_message_admins("The deprecated custom_items.txt file is used. Migrate to SQL or JSON.")
			//If we dont have the json file, we might have the old file so lets try that
			var/datum/custom_item/current_data
			for(var/line in text2list(file2text("config/custom_items.txt"), "\n"))
				line = trim(line)
				if(line == "" || !line || findtext(line, "#", 1, 2))
					continue

				if(findtext(line, "{", 1, 2) || findtext(line, "}", 1, 2)) // New block!
					if(current_data && current_data.usr_ckey && current_data.usr_charname)
						custom_items.Add(current_data)
					current_data = null

				var/split = findtext(line,":")
				if(!split)
					continue
				var/field = trim(copytext(line,1,split))
				var/field_data = trim(copytext(line,(split+1)))
				if(!field || !field_data)
					continue

				if(!current_data)
					current_data = new()

				switch(field)
					if("ckey")
						current_data.usr_ckey = ckey(field_data)
					if("character_name")
						current_data.usr_charname = lowertext(field_data)
					if("item_path")
						current_data.item_path = text2path(field_data)
					if("item_name")
						current_data.item_data["name"] = field_data
					if("item_icon")
						continue
					if("inherit_inhands")
						continue
					if("item_desc")
						current_data.item_data["desc"] = field_data
					if("req_access")
						continue
					if("req_titles")
						current_data.req_titles = text2list(field_data,", ")
					if("kit_name")
						continue
					if("kit_desc")
						continue
					if("kit_icon")
						continue
					if("additional_data")
						current_data.additional_data = field_data
	if(load_from_file == 2 && length(custom_items)) //insert the item into the db
		log_debug("Custom Items: Migrating custom_items to database")
		var/success_count = 0
		var/error_count = 0
		for(var/item in custom_items)
			var/datum/custom_item/ci = item
			log_debug("Custom Items: Migrating Item for: [ci.usr_ckey] - [ci.usr_charname]")

			if(!ci.item_path || ci.item_path == "")
				log_debug("Custom Items: Invalid Item path")
				error_count += 1
				continue

			//Fetch the character id of the character
			var/DBQuery/char_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey: AND name = :name: AND deleted_at IS NULL ORDER BY id DESC")
			char_query.Execute(list("ckey"=ckey(ci.usr_ckey),"name"=ci.usr_charname))
			if (!char_query.NextRow())
				log_debug("Custom Items: Unable to find matching character for: ckey: [ci.usr_ckey] name: [ci.usr_charname]")
				error_count += 1
				continue
			var/char_id = text2num(char_query.item[1])

			try
				var/DBQuery/item_insert_query = dbcon.NewQuery("INSERT INTO ss13_characters_custom_items (`char_id`, `item_path`, `item_data`, `req_titles`, `additional_data`) VALUES (:char_id:, :item_path:, :item_data:, :req_titles:, :additional_data:)")
				item_insert_query.Execute(list("char_id"=char_id,"item_path"="[ci.item_path]","item_data"=json_encode(ci.item_data),"req_titles"=json_encode(ci.req_titles),"additional_data"=ci.additional_data))
			catch(var/exception/e)
				log_debug("Custom Items: Failed to save item to db: [e]")
				error_count += 1
			success_count += 1

		feedback_set("custom_item_migration_success",success_count)
		feedback_set("custom_item_migration_error",error_count)
	return 1

/datum/custom_item
	var/id
	//the character_id is used with the db setup
	var/character_id
	//the char_name/ckey is used with the disk based setup (and auto-generated from the char id for the db based setup)
	var/usr_ckey
	var/usr_charname

	var/item_path
	var/list/item_data = list()

	var/list/req_titles = list()

	var/additional_data

/datum/custom_item/proc/spawn_item(var/newloc) //TODO: pass mob its spawned for as parameter
	var/obj/item/citem = new item_path(newloc)
	apply_to_item(citem)
	return citem

/datum/custom_item/proc/apply_to_item(var/obj/item/item)
	if(!item)
		return

	//Customize the item with the item_data
	for(var/var_name in item_data)
		try
			item.vars[var_name] = item_data[var_name]
		catch(var/exception/e)
			log_debug("Custom Item: Bad variable name [var_name] in custom item with id [id]: [e]")

	// for snowflake implants
	if(istype(item, /obj/item/implanter/fluff))
		var/obj/item/implanter/fluff/L = item
		L.allowed_ckey = usr_ckey
		L.implant_type = text2path(additional_data)
		L.create_implant()

	return item

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/proc/equip_custom_items(var/mob/living/carbon/human/M)
	//Fetch the custom items for the mob
	if(config.sql_enabled)
		if(!establish_db_connection(dbcon))
			log_debug("Custom Items: Unable to establish database connection while loading item. - Aborting")
			return

		var/DBQuery/char_item_query = dbcon.NewQuery("SELECT ss13_characters_custom_items.id, ss13_characters_custom_items.char_id, ss13_characters.ckey as usr_ckey, ss13_characters.name as usr_charname, item_path, item_data, req_titles, additional_data FROM ss13_characters_custom_items LEFT JOIN ss13_characters ON ss13_characters.id = ss13_characters_custom_items.char_id WHERE char_id = :char_id:")
		char_item_query.Execute(list("char_id"=M.character_id))
		while(char_item_query.NextRow())
			CHECK_TICK
			var/datum/custom_item/ci = new()
			ci.id = text2num(char_item_query.item[1])
			ci.character_id = text2num(char_item_query.item[2])
			ci.usr_ckey = char_item_query.item[3]
			ci.usr_charname = char_item_query.item[4]
			ci.item_path = text2path(char_item_query.item[5])
			ci.item_data = json_decode(char_item_query.item[6]) //TODO: try/catch
			ci.req_titles = json_decode(char_item_query.item[7]) //TODO: try/catch
			ci.additional_data = char_item_query.item[8]

			equip_custom_item_to_mob(ci,M)
	else
		for(var/item in custom_items)
			CHECK_TICK
			var/datum/custom_item/ci = item
			if(lowertext(ci.usr_ckey) != lowertext(M.ckey))
				continue
			if(lowertext(ci.usr_charname) != lowertext(M.real_name))
				continue
			equip_custom_item_to_mob(ci,M)


/proc/equip_custom_item_to_mob(var/datum/custom_item/citem, var/mob/living/carbon/human/M)
	// Check for required job title.
	if(length(citem.req_titles))
		var/has_title
		var/current_title = M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role
		for(var/title in citem.req_titles)
			if(title == current_title)
				has_title = 1
				break
		if(!has_title)
			to_chat(M, "A custom item could not be equipped as you have joined with the wrong role.")
			return FALSE

	if(ispath(citem.item_path, /obj/item/organ/internal/augment/fluff))
		var/obj/item/organ/internal/augment/fluff/aug = citem.spawn_item(M)
		var/obj/item/organ/external/affected = M.get_organ(aug.parent_organ)
		aug.replaced(M, affected)
		M.update_body()
		M.updatehealth()
		M.UpdateDamageIcon()
		return

	// ID cards and MCs are applied directly to the existing object rather than spawned fresh.
	var/obj/item/existing_item
	if(citem.item_path == /obj/item/card/id)
		existing_item = locate(/obj/item/card/id) in M.get_contents() //TODO: Improve this ?
	else if(citem.item_path == /obj/item/modular_computer)
		existing_item = locate(/obj/item/modular_computer) in M.contents

	// Spawn and equip the item.
	if(existing_item)
		citem.apply_to_item(existing_item)
		return TRUE
	else
		var/obj/item/newitem = citem.spawn_item()

		if(M.equip_to_appropriate_slot(newitem))
			return TRUE

		if(M.equip_to_storage(newitem))
			return TRUE

		newitem.forceMove(get_turf(M.loc))
		to_chat(M, "A custom item has been placed on the floor as there was no space for it on your mob.")
		return TRUE
