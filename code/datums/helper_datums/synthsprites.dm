/datum/custom_synth
	var/synthckey = ""
	var/synthname = "cyborg"
	var/synthicon = "robot"
	var/ainame = ""
	var/aichassisicon = ""
	var/aiholoicon = ""
	var/paiicon = ""



/datum/custom_synth/proc/load_from_json()
	var/list/customsynthsprites = list()
	try
		customsynthsprites = json_decode(return_file_text("config/customsynths.json"))
	catch(var/exception/ej)
		log_debug("Error: Warning: Could not load custom synth config, as customsynths.json is missing - [ej]")
		return

	robot_custom_icons = list()
	customsynthsprites = customsynthsprites["synths"]
	for (var/synthsprite in customsynthsprites)
		var/datum/custom_synth/synth = new()
		synth.synthckey = customsynthsprites[synthsprite]["ckey"]
		synth.synthicon = customsynthsprites[synthsprite]["synthicon"]
		synth.ainame = customsynthsprites[synthsprite]["ainame"]
		synth.aichassisicon = customsynthsprites[synthsprite]["aichassisicon"]
		synth.aiholoicon = customsynthsprites[synthsprite]["aiholoicon"]
		synth.paiicon = customsynthsprites[synthsprite]["paiicon"]
		robot_custom_icons[synthsprite] = synth

/datum/custom_synth/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
	
		var/DBQuery/customsynthsprites = dbcon.NewQuery("SELECT synthckey, synthicon, ainame, aichassisicon, aiholoicon, paiicon FROM ss13_customsynths WHERE deleted_at IS NULL ORDER BY synthckey ASC")
		customsynthsprites.Execute()
		while(customsynthsprites.NextRow())
			CHECK_TICK
			try
				
				var/datum/custom_synth/synth = new()
				synth.synthckey = customsynthsprites.item[1]
				synth.synthicon = customsynthsprites.item[2]
				synth.ainame = customsynthsprites.item[3]
				synth.aichassisicon = customsynthsprites.item[4]
				synth.aiholoicon = customsynthsprites.item[5]
				synth.paiicon = customsynthsprites.item[6]
				robot_custom_icons[customsynthsprites] = synth
			catch(var/exception/el)
				log_debug("Error: Could not load synth sprite [el]")
