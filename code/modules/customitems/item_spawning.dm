//TODO: Write explanation

/var/list/custom_items = list()

//Loads the custom items from the json file if the db backend is disabled
/hook/startup/proc/load_custom_items()
	var/load_from_file = 0

	if (config.sql_enabled)
		//If we have sql enabled we check if the db is empty. If so we migrate the json file to the db
		//If the db is not empty we dont load the json file
		if(!establish_db_connection(dbcon))
			log_debug("Custom Items: Unable to establish database connection. - Aborting")
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM ss13_characters_custom_items")
		query.Execute()

		if (!query.NextRow())
			log_debug("Custom Items: Unable to fetch custom item count from database. - Aborting")
			return
		var/item_count = text2num(query.item[1])
		if(item_count > 0)
			return
		//If there are no items in the db, migrate them
		load_from_file = 2
		log_debug("Custom Items: No items found in the database - attempting migration")
	else
		//If we dont have a db, we need to load the json file
		load_from_file = 1

	if(load_from_file)
		//Check if the json file exists
		if(fexists("config/custom_items.json"))
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
				ci.item_data["name"] = item["item_name"]
				ci.item_data["desc"] = item["item_desc"]
				ci.additional_data = item["additional_data"]
				custom_items.Add(ci)
			log_debug("Custom Items: Loaded [length(custom_items)] custom items")
		else if(fexists("config/custom_items.txt"))
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
						current_data.req_access = text2num(field_data)
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
	if(load_from_file == 2) //insert the item into the db
		log_debug("Custom Items: Migrating custom_items to database")
		for(var/item in custom_items)
			var/datum/custom_item/ci = item
			//Fetch the character id of the character
			var/DBQuery/char_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey: AND name = :name: AND deleted_at IS NOT NULL ORDER BY id DESC")
			char_query.Execute(list("ckey"=ckey(ci.usr_ckey),"name"=ci.usr_charname))

			if (!char_query.NextRow())
				log_debug("Custom Items: Unable to find matching character for: ckey: [ci.usr_ckey] name: [ci.usr_charname]")
				return

			var/char_id = text2num(char_query.item[1])

			var/DBQuery/item_insert_query = dbcon.NewQuery("INSERT INTO ss13_characters_custom_items (`char_id`, `item_path`, `item_data`, `req_access`, `req_titles`, `additional_data`) VALUES (:char_id:, :item_path:, :item_data:, :req_access:, :req_titles:, :additional_data:)")
			item_insert_query.Execute(list("char_id"=char_id,"item_path"=ci.item_path,"item_data"=json_encode(ci.item_data),"req_access"=ci.req_access,"req_titles"=json_encode(ci.req_titles),"additional_data"=ci.additional_data))


/datum/custom_item
	var/id
	//the character_id is used with the db setup
	var/character_id
	//the char_name/ckey is used with the disk based setup (and auto-generated from the char id for the db based setup)
	var/usr_ckey
	var/usr_charname

	var/item_path
	var/list/item_data = list()

	var/req_access = 0
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
	for(var/var_name in item_data["vars"])
		try
			item.vars[var_name] = item_data["vars"][var_name]
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

		var/DBQuery/char_item_query = dbcon.NewQuery("SELECT id, char_id, ckey as usr_ckey, name as usr_charname, item_path, item_data, req_access, req_titles, additional_data FROM ss13_characters_custom_items LEFT JOIN ss13_characters ON ss13_characters.id = ss13_characters.custom_items.char_id")
		while(char_item_query.NextRow())
			var/datum/custom_item/ci = new()
			ci.id = text2num(char_item_query.item[1])
			ci.character_id = text2num(char_item_query.item[2])
			ci.usr_ckey = char_item_query.item[3]
			ci.usr_charname = char_item_query.item[4]
			ci.item_path = text2path(char_item_query.item[5])
			ci.item_data = json_decode(char_item_query.item[6]) //TODO: try/catch
			ci.req_access = text2num(char_item_query.item[7])
			ci.req_titles = json_decode(char_item_query.item[8]) //TODO: try/catch

			equip_custom_item_to_mob(ci,M)
	else
		for(var/item in custom_items)
			var/datum/custom_item/ci = item
			if(lowertext(ci.usr_ckey) != lowertext(M.ckey))
				continue
			if(lowertext(ci.usr_charname) != lowertext(M.real_name))
				continue
			equip_custom_item_to_mob(ci,M)


/proc/equip_custom_item_to_mob(var/datum/custom_item/citem, var/mob/living/carbon/human/M)
	// Check for required access.
	var/obj/item/I = M.wear_id
	if(citem.req_access && citem.req_access > 0)
		if(!(istype(I) && (citem.req_access in I.GetAccess())))
			return

	// Check for required job title.
	if(citem.req_titles && citem.req_titles.len > 0)
		var/has_title
		var/current_title = M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role
		for(var/title in citem.req_titles)
			if(title == current_title)
				has_title = 1
				break
		if(!has_title)
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
	else
		place_custom_item(M,citem)

// Places the item on the target mob.
/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)

	if(!citem) return
	var/obj/item/newitem = citem.spawn_item()

	if(M.equip_to_appropriate_slot(newitem))
		return newitem

	if(M.equip_to_storage(newitem))
		return newitem

	newitem.forceMove(get_turf(M.loc))
	return newitem
