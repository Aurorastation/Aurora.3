
/* 

Just some quick documentation about how this works

Synthckey is the players ckey which is represented under the synths name in the json, this is required to have
synthicon is just the sprites name in the dmi
aichassisicon is the ai chassis icon sprite name
aiholoicon is the ai hologram icon sprite name
paiicon is the pai icon sprite name

*/



/datum/custom_synth
	var/synthname = ""
	var/synthckey = ""
	var/synthicon = "robot"
	var/aichassisicon = ""
	var/aiholoicon = ""
	var/paiicon = ""



/proc/loadsynths_from_json()
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
		synth.synthname = synthsprite
		synth.synthckey = customsynthsprites[synthsprite]["ckey"]
		synth.synthicon = customsynthsprites[synthsprite]["synthicon"]
		synth.aichassisicon = customsynthsprites[synthsprite]["aichassisicon"]
		synth.aiholoicon = customsynthsprites[synthsprite]["aiholoicon"]
		synth.paiicon = customsynthsprites[synthsprite]["paiicon"]
		robot_custom_icons[synthsprite] = synth

/proc/loadsynths_from_sql()
	if(!config.sql_enabled)
		log_debug("Synthsprites: SQL Disabled - Falling back to JSON")
		loadsynths_from_json()
		return
	if(!establish_db_connection(dbcon))
		log_debug("Synthsprites: SQL ERROR - Failed to connect. - Falling back to JSON")
		loadsynths_from_json()
		return

	var/DBQuery/customsynthsprites = dbcon.NewQuery("SELECT synthname, synthckey, synthicon, aichassisicon, aiholoicon, paiicon FROM ss13_customsynths ORDER BY synthckey ASC")
	customsynthsprites.Execute()
	while(customsynthsprites.NextRow())
		CHECK_TICK
			
		var/datum/custom_synth/synth = new()
		synth.synthname = customsynthsprites.item[1]
		synth.synthckey = customsynthsprites.item[2]
		synth.synthicon = customsynthsprites.item[3]
		synth.aichassisicon = customsynthsprites.item[4]
		synth.aiholoicon = customsynthsprites.item[5]
		synth.paiicon = customsynthsprites.item[6]
		robot_custom_icons[synth.synthname] = synth
