/var/global/datum/controller/subsystem/trade/SSspace_ruins

/datum/controller/subsystem/space_ruins
	name = "Space Ruins"
	flags = SS_NO_FIRE
	init_order = SS_INIT_SPACE_RUINS

/datum/controller/subsystem/space_ruins/New()
	NEW_SS_GLOBAL(SSspace_ruins)

/datum/controller/subsystem/space_ruins/Initialize()
	if(current_map.has_space_ruins)
		create_space_ruin()
	..()

/datum/controller/subsystem/space_ruins/proc/create_space_ruin()
	var/map_directory = "maps/space_ruins/"
	var/list/files = flist(map_directory)
	var/start_time = world.time

	if(length(files) <= 0)
		log_ss("map_finalization","There are no space ruin map.")
		return

	var/chosen_ruin = pick(files)

	if(!dd_hassuffix(chosen_ruin,".dmm"))
		files -= chosen_ruin
		log_ss("map_finalization","ALERT: [chosen_ruin] is not a .dmm file! Skipping!")

	var/map_file = "[map_directory][chosen_ruin]"

	if(fexists(map_file))
		var/datum/map_template/T = new(map_file, "Space Ruin")
		T.load_new_z()

	else
		log_ss("map_finalization","ERROR: Something weird happened with the file: [chosen_ruin].")

	log_ss("map_finalization","Loaded [chosen_ruin] space ruin in [(world.time - start_time)/10] seconds.")
	create_space_ruin_report("chosen_ruin")


/datum/controller/subsystem/space_ruins/proc/create_space_ruin_report(var/ruin_name)
	var/ruintext = "<center><img src = ntlogo.png><BR><h2><BR><B>Icarus Reading Report</h2></B></FONT size><HR></center>"
	ruintext += "<B><font face='Courier New'>The Icarus sensors located a away site with the possible characteristics:</font></B><br>"

	switch(ruin_name)
		if("crashed_freighter")
			ruintext += "Lifeform signals.<br>"

		if("derelict" || "nt_cloneship")
			ruintext += "NanoTrasen infrastructure.<br>"

		if("pra_blockade_runner")
			ruintext += "Large biomass signals.<br>"

		if("sol_frigate")
			ruintext += "Warp signal.<br>"

		else
			ruintext += "Unrecognizable signals.<br>"

	if(prob(20))
		ruintext += "Mineral concentration.<br>"

	if(prob(20))
		ruintext += "Bluespace signals.<br>"

	if(prob(20))
		ruintext += "Artificial intelligence signals.<br>"

	ruintext += "<HR>"

	ruintext += "<B><font face='Courier New'>This reading has been detected within shuttle range of the [current_map.station_name] and deemed safe for survey by [current_map.company_name] personnel. \
	The designated research director, or a captain level decision may determine the goal of any missions to this site. On-site command is deferred to any nearby command staff.</font></B><br>"

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "Space Ruin Paper")
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(C))
			P.name = "Icarus reading report"
			P.info = ruintext
			P.update_icon()