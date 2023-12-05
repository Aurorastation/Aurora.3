/datum/map/sccv_horizon
	name = "SCCV Horizon"
	full_name = "SCCV Horizon"
	path = "sccv_horizon"

	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi', 'icons/misc/titlescreens/aurora/vaurca.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1, 2, 3)
	admin_levels = list(4)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3, 5)
	restricted_levels = list()
	accessible_z_levels = list("1" = 5, "2" = 5, "3" = 5, "5" = 75)
	empty_levels = list(5)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/space,
		"5" = /turf/space,
		"6" = /turf/space
	)

	station_name = "SCCV Horizon"
	station_short = "Horizon"
	dock_name = "SCC Sector Liaison Post"
	dock_short = "Sector Liaison Post"
	boss_name = "Stellar Corporate Conglomerate"
	boss_short = "SCC"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"
	station_type = "ship"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the SCCV Horizon!"

	use_overmap = TRUE
	num_exoplanets = 2
	overmap_size = 35
	overmap_event_areas = 34
	planet_size = list(255,255)

	away_site_budget = 2
	away_ship_budget = 2
	away_variance = 1

	station_networks = list(
		NETWORK_COMMAND,
		NETWORK_REACTOR,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY,
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_INTREPID
	)

	shuttle_docked_message = "Attention all hands: the shift change preparations are over. It will start in approximately %ETA%."
	shuttle_leaving_dock = "Attention all hands: the shift change is underway, concluding in %ETA%."
	shuttle_called_message = "Attention all hands: the shift change has been scheduled. The swap will begin in %ETA%."
	shuttle_recall_message = "Attention all hands: the shift change has been cancelled, return to normal operating conditions."
	bluespace_docked_message = "Attention all hands: Bluespace jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETA%."
	bluespace_leaving_dock = "Attention all hands: Bluespace jump initiated, exiting bluespace in %ETA%."
	bluespace_called_message = "Attention all hands: Bluespace jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	bluespace_recall_message = "Attention all hands: Bluespace jump sequence aborted, return to normal operating conditions."
	emergency_shuttle_docked_message = "Attention all hands: the emergency evacuation has started. You have approximately %ETA% minutes to board the emergency pods."
	emergency_shuttle_leaving_dock = "Attention all hands: the emergency evacuation has been completed."
	emergency_shuttle_recall_message = "Attention all hands: the emergency evacuation has been canceled."
	emergency_shuttle_called_message = "Attention all hands: an emergency evacuation has been called. It will start in approximately %ETA%."

	meteors_detected_message = "A meteor storm has been detected on collision course with the ship. Estimated three minutes until impact, please activate the shielding fields and seek shelter in the central areas."
	meteor_contact_message = "Contact with meteor wave imminent, all hands brace for impact."
	meteor_end_message = "The ship has cleared the meteor shower, please return to your stations."

	ship_meteor_contact_message = "Debris from a nearby derelict are on collision course with the ship. Prepare for impact."
	ship_detected_end_message = "Ship debris colliding now, all hands brace for impact."
	ship_meteor_end_message = "The last of the ship debris has hit or passed by the ship, it is now safe to commence repairs."

	dust_detected_message = "A belt of space dust is approaching the ship."
	dust_contact_message = "The ship is now passing through a belt of space dust."
	dust_end_message = "The ship has now passed through the belt of space dust."

	radiation_detected_message = "High levels of radiation detected near the ship. Please evacuate into one of the shielded maintenance tunnels."
	radiation_contact_message = "The ship has entered the radiation belt. Please remain in a sheltered area until the ship has passed through it and engineering has given the all-clear."
	radiation_end_message = "The ship has passed the radiation belt. Please await an all-clear from engineering staff before exiting maintenance as there may be residual radiation. Immediately make your way to the medbay if you experience any unusual symptoms. Maintenance will lose all-access again shortly."

	rogue_drone_detected_messages = list("Combat drone swarms from a nearby facility have engaged the ship. If any are sighted in the area, approach with caution.",
													"Malfunctioning combat drones have been detected close to the ship. If any are sighted in the area, approach with caution.")
	rogue_drone_end_message = "The hostile drone swarm has left the ship's proximity."
	rogue_drone_destroyed_message = "Sensors indicate the unidentified drone swarm has left the immediate proximity of the ship."


	map_shuttles = list(
		/datum/shuttle/autodock/ferry/lift/scc_ship/morgue,
		/datum/shuttle/autodock/multi/lift/operations,
		/datum/shuttle/autodock/multi/lift/robotics,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod4,
		/datum/shuttle/autodock/ferry/supply/horizon,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_ship,
		/datum/shuttle/autodock/multi/antag/burglar_ship,
		/datum/shuttle/autodock/multi/antag/merc_ship,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/overmap/intrepid,
		/datum/shuttle/autodock/overmap/mining,
		/datum/shuttle/autodock/overmap/canary,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/overmap/orion_express_shuttle,
		/datum/shuttle/autodock/overmap/sfa_shuttle,
		/datum/shuttle/autodock/overmap/tcfl_shuttle,
		/datum/shuttle/autodock/overmap/ee_shuttle,
		/datum/shuttle/autodock/overmap/fsf_shuttle,
		/datum/shuttle/autodock/overmap/freighter_shuttle,
		/datum/shuttle/autodock/overmap/kataphract_transport,
		/datum/shuttle/autodock/overmap/iac_shuttle
	)

	evac_controller_type = /datum/evacuation_controller/starship

	allowed_spawns = list("Living Quarters Lift", "Cryogenic Storage")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift, /datum/spawnpoint/cryo)
	default_spawn = "Living Quarters Lift"

	allow_borgs_to_leave = TRUE

	warehouse_basearea = /area/operations/storage

/datum/map/sccv_horizon/send_welcome()
	var/obj/effect/overmap/visitable/ship/horizon = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/sccv_horizon)

	var/welcome_text = "<center><img src = scclogo.png><br />[FONT_LARGE("<b>SCCV Horizon</b> Ultra-Range Sensor Readings:")]<br>"
	welcome_text += "Report generated on [worlddate2text()] at [worldtime2text()]</center><br /><br />"
	welcome_text += "<hr>Current sector:<br /><b>[SSatlas.current_sector.name]</b><br /><br>"

	if (horizon) //If the overmap is disabled, it's possible for there to be no Horizon.
		var/list/space_things = list()
		welcome_text += "Current Coordinates:<br /><b>[horizon.x]:[horizon.y]</b><br /><br>"
		welcome_text += "Next system targeted for jump:<br /><b>[SSatlas.current_sector.generate_system_name()]</b><br /><br>"
		var/last_visit
		var/current_day = time2text(world.realtime, "Day")
		switch(current_day)
			if("Monday")
				last_visit = "1 day ago"
			if("Tuesday")
				last_visit = "2 days ago"
			if("Wednesday")
				last_visit = "3 days ago"
			if("Thursday")
				last_visit = "4 days ago"
			if("Friday")
				last_visit = "5 days ago"
			if("Saturday")
				last_visit = "6 days ago"
			if("Sunday")
				last_visit = "1 week ago"
		welcome_text += "Last port visit: <br><b>[last_visit]</b><br><br>"
		welcome_text += "Travel time to nearest port:<br /><b>[SSatlas.current_sector.get_port_travel_time()]</b><br /><br>"
		welcome_text += "Scan results show the following points of interest:<br />"

		for(var/zlevel in map_sectors)
			var/obj/effect/overmap/visitable/O = map_sectors[zlevel]
			if(O.name == horizon.name)
				continue
			if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
				continue
			if (O.hide_from_reports)
				continue
			space_things |= O

		for(var/obj/effect/overmap/visitable/O in space_things)
			var/location_desc = " at present co-ordinates."
			if(O.loc != horizon.loc)
				var/bearing = round(90 - Atan2(O.x - horizon.x, O.y - horizon.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", bearing [bearing]."
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"

		welcome_text += "<hr>"

	post_comm_message("SCCV Horizon Sensor Readings", welcome_text)
	priority_announcement.Announce(message = "Long-range sensor readings have been printed out at all communication consoles.")

/datum/map/sccv_horizon/load_holodeck_programs()
	// loads only if at least two engineers are present
	// so as to not drain power on deadpop
	// also only loads if no program is loaded already
	var/list/roles = number_active_with_role()
	if(roles && roles["Engineer"] && roles["Engineer"] >= 2)
		for(var/obj/machinery/computer/HolodeckControl/holo in holodeck_controls)
			if(!holo.active)
				holo.load_random_program()
