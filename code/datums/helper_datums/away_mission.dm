/datum/away_mission
	var/name
	var/weight = 1
	var/autoselect = TRUE
	var/list/map_files = null
	var/list/valid_maps = null
	var/list/characteristics = null

	var/base_dir = null

/datum/away_mission/New(var/list/config, var/i_base_dir)
	name = config["name"]
	weight = config["weight"]
	autoselect = config["autoselect"]
	map_files = config["map_files"]
	valid_maps = config["valid_maps"]
	characteristics = config["characteristics"]
	base_dir = i_base_dir

/datum/away_mission/proc/validate_maps()
	for(var/map in map_files)
		if(!fexists("[base_dir][map]"))
			log_debug("[base_dir][map] does not exist")
			return FALSE
	return TRUE

/datum/away_mission/proc/get_contact_report()
	var/list/schar = sortList(characteristics) //Sort them alphabetically to avoid metaing based on the order
	var/ruintext = "<center><img src = ntlogo.png><br><h2><br><b>Icarus Reading Report</h2></b></FONT size><HR></center>"
	ruintext += "<b><font face='Courier New'>The NDV Icarus sensors have located an away site with the following possible characteristics:</font></b><br><ul>"

	for(var/characteristic in schar)
		if(prob(schar[characteristic]))
			ruintext += "<li>[characteristic]</li>"

	ruintext += "</ul><HR>"

	ruintext += "<b><font face='Courier New'>This reading has been detected within shuttle range of the [current_map.station_name] and deemed safe for survey by [current_map.company_name] personnel. \
	The designated research director, or a captain level decision may determine the goal of any missions to this site. On-site command is deferred to any nearby command staff.</font></b><br>"

	return ruintext
