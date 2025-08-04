#define RADIO_BROADCASTS "broadcasts"
#define RADIO_NEXT_BROADCAST "next_broadcast"
#define RADIO_BROADCAST_INDEX "broadcast_index"

/datum/space_sector
	var/name
	var/description
	var/starlight_color = COLOR_WHITE
	var/starlight_power = 1
	var/starlight_range = 1
	var/list/possible_erts = list()
	var/list/possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/snow, /obj/effect/overmap/visitable/sector/exoplanet/desert)
	///Guaranteed planets to spawn. This ignores the map exoplanet limit, so don't put too many planets in here.
	var/list/guaranteed_exoplanets = list()
	var/list/cargo_price_coef = list( //how much the space sector afffects how expensive is ordering from that cargo supplier
		"nanotrasen" = 1,
		"orion" = 1,
		"hephaestus" = 1,
		"zeng_hu" = 1,
		"eckharts" = 1,
		"getmore" = 1,
		"arizi" = 1,
		"blam" = 1,
		"iac" = 1,
		"zharkov" = 1,
		"virgo" = 1,
		"bishop" = 1,
		"xion" = 1,
		"zavodskoi" = 1,
		)

	var/skybox_icon = "ceti"

	/// An associated list of lore radio stations formatted like so: list("station name" = "path_to_broadcast.txt")
	/// This gets converted into a formatted list after initialization like so: list(RADIO_BROADCASTS = list("stuff"), RADIO_NEXT_BROADCAST = world.time, RADIO_BROADCAST_INDEX = the entry in the list that will be broadcasted)
	var/list/lore_radio_stations = null //what radio stations can be heard by the lore radio item here

	/// A list of paths to rotate for the lobby image, png/bmp/jpg/gif only
	/// if this is set, it will override the map ones
	var/list/lobby_icon_image_paths = null

	var/sector_welcome_message = null ///if this is set, it will override welcome audio message

	/**
	 * The hud menu icons folder path, it **must** end with a slash
	 *
	 * The folder **must** contain all the PNGs/JPGs/GIFs for the menu
	 */
	var/sector_hud_menu = "icons/misc/hudmenu/default/"

	var/sector_hud_menu_sound = null //if this is set, it will override the hud menu click sound
	var/sector_hud_arrow = null //if this is set, it will use an overlay instead of the animation that makes the button bigger

	/// Lobby music overrides.
	var/list/lobby_tracks

	/// A list of the major ports in this sector.
	/// Note that these are supposed to be visitable by the Horizon and its crew, so only put those there.
	var/list/ports_of_call
	/// The days of the next port visits. If null, port visits are disabled.
	/// Must be a day found in the all_days list.
	var/list/scheduled_port_visits = list("Sunday")
	/// This variable holds the calculated time (integer) until port visit. Do not edit manually.
	var/next_port_visit
	/// This variable holds the string of time until port visit. Will be "in 1 day", "in 2 days", "today", etc. Do not edit manually.
	var/next_port_visit_string

	/// Does this sector permit communication with Central Command? Reserved for remote/uncharted sectors. The EBS system is unaffected as it is necessary for certain CCIA functions (eg. scuttling).
	var/ccia_link = TRUE

	//vars used by the meteor random event

	var/list/meteors_minor = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10
		)

	var/list/meteors_moderate = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10,
		/obj/effect/meteor/emp        = 10
		)

	var/list/meteors_major = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/emp        = 30,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10
		)

	var/list/downed_ship_meteors = list(
		/obj/effect/meteor/ship_debris = 90,
		/obj/effect/meteor/dust       = 10
		)

	//vars used by the meteor gamemode

	// Dust, used by space dust event and during earliest stages of meteor mode.
	var/list/meteors_dust = list(/obj/effect/meteor/dust)

	// Standard meteors, used during early stages of the meteor gamemode.
	var/list/meteors_normal = list(\
		/obj/effect/meteor/medium=8,\
		/obj/effect/meteor/dust=3,\
		/obj/effect/meteor/irradiated=3,\
		/obj/effect/meteor/big=3,\
		/obj/effect/meteor/golden=1,\
		/obj/effect/meteor/silver=1\
		)

	// Threatening meteors, used during the meteor gamemode.
	var/list/meteors_threatening = list(\
		/obj/effect/meteor/big=10,\
		/obj/effect/meteor/medium=5,\
		/obj/effect/meteor/golden=3,\
		/obj/effect/meteor/silver=3,\
		/obj/effect/meteor/irradiated=3,\
		/obj/effect/meteor/emp=3\
		)

	// Catastrophic meteors, pretty dangerous without shields and used during the meteor gamemode.
	var/list/meteors_catastrophic = list(\
		/obj/effect/meteor/big=75,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/emp=10,\
		/obj/effect/meteor/medium=5,\
		/obj/effect/meteor/golden=4,\
		/obj/effect/meteor/silver=4
		)

	// Armageddon meteors, very dangerous, and currently used only during the meteor gamemode.
	var/list/meteors_armageddon = list(\
		/obj/effect/meteor/big=25,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/emp=10,\
		/obj/effect/meteor/medium=3,\
		/obj/effect/meteor/golden=2,\
		/obj/effect/meteor/silver=2\
		)

	// Cataclysm meteor selection. Very very dangerous and effective even against shields. Used in late game meteor gamemode only.
	var/list/meteors_cataclysm = list(\
		/obj/effect/meteor/big=40,\
		/obj/effect/meteor/emp=20,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/golden=10,\
		/obj/effect/meteor/silver=10,\
		/obj/effect/meteor/supermatter=1\
		)

/// When SSAtlas chooses us as the current sector, this function is called, which will set us up to start processing
/datum/space_sector/proc/setup_current_sector()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(SSatlas.current_map.ports_of_call && length(SSatlas.current_sector.scheduled_port_visits))
		var/current_day_index = GLOB.all_days.Find(time2text(world.realtime, "Day"))
		var/days_calculated = 0
		// The main problem to consider here is that you have to loop around for two weeks to find all the days, basically.
		// It could be Thursday with Wednesday as a port of call, for example.
		while(!next_port_visit)
			if(!(GLOB.all_days[current_day_index] in SSatlas.current_sector.scheduled_port_visits))
				days_calculated++
				current_day_index++
				if(current_day_index > length(GLOB.all_days))
					current_day_index = 1
					continue
			next_port_visit = current_day_index
			break

		next_port_visit_string = days_calculated == 0 ? "Today" : days_calculated == 1 ? "in [days_calculated] day" : "in [days_calculated] days"

	// For now, i've put processing to only happen if the sector has a radio station
	// but if, in the future, you add more stuff for the processor to handle, feel free to move it out of the if block
	if(length(lore_radio_stations))
		for(var/station in lore_radio_stations)
			var/list/station_broadcasts = file2list(lore_radio_stations[station])

			var/text_broadcast_index = 1
			for(var/broadcast in station_broadcasts)
				// Italics Regex
				var/regex/italics_regex = regex("/(.*?)/")
				broadcast = replacetext(broadcast, italics_regex, "<i>$1</i>")

				// Random Note Regex
				var/randomnote = pick("\u2669", "\u266A", "\u266B")
				broadcast = replacetext(broadcast, "\[RANDOMNOTE\]", randomnote)

				station_broadcasts[text_broadcast_index] = broadcast
				text_broadcast_index++

			var/broadcast_length = length(station_broadcasts)
			lore_radio_stations[station] = list(
				RADIO_BROADCASTS = station_broadcasts,
				RADIO_NEXT_BROADCAST = 0, // start ASAP
				RADIO_BROADCAST_INDEX = rand(1, broadcast_length) // start randomly in the broadcast so it isn't in the same sequence every time
			)

		START_PROCESSING(SSprocessing, src)

/datum/space_sector/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/space_sector/process(seconds_per_tick)
	for(var/station in lore_radio_stations)
		var/list/broadcast_info = lore_radio_stations[station]
		if(world.time < broadcast_info[RADIO_NEXT_BROADCAST])
			continue

		var/broadcast_index = broadcast_info[RADIO_BROADCAST_INDEX]
		var/broadcast_message = broadcast_info[RADIO_BROADCASTS][broadcast_index]

		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LORE_RADIO_BROADCAST, station, broadcast_message)

		if(broadcast_index == length(broadcast_info[RADIO_BROADCASTS]))
			broadcast_info[RADIO_BROADCAST_INDEX] = 1
			broadcast_info[RADIO_NEXT_BROADCAST] = world.time + 30 SECONDS // give it a bit of a breather if we've exhausted all the messages
		else
			broadcast_info[RADIO_BROADCAST_INDEX]++
			broadcast_info[RADIO_NEXT_BROADCAST] = world.time + (rand(6, 10) SECONDS) // otherwise, throw in a randomish delay (considering we're on SSprocessing, it'll uusssuaaalllyyy be about 2 seconds at minimum)

/datum/space_sector/proc/get_chat_description()
	return "<hr><div align='center'><hr1><B>Current Sector: [name]!</B></hr1><br><i>[description]</i><hr></div>"

/// Returns a flat list of all possible away sites that can spawn in this sector.
/datum/space_sector/proc/possible_sites_in_sector()
	var/list/away_sites = list()
	for(var/id in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site = SSmapping.away_sites_templates[id]
		if(name in away_site.sectors)
			away_sites += away_site
	return away_sites

/datum/space_sector/proc/lore_radio_message(/obj/item/R, chosen_station) //used for the lore radio in lore_radio.dm.
	return

#undef RADIO_BROADCASTS
#undef RADIO_NEXT_BROADCAST
#undef RADIO_BROADCAST_INDEX
