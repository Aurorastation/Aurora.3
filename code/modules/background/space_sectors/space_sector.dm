/datum/space_sector
	var/name
	var/description
	var/starlight_color = COLOR_WHITE
	var/starlight_power = 1
	var/starlight_range = 1
	var/list/possible_erts = list()
	var/list/possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/snow, /obj/effect/overmap/visitable/sector/exoplanet/desert)
	var/list/cargo_price_coef = list("nt" = 1, "hpi" = 1, "zhu" = 1, "een" = 1, "get" = 1, "arz" = 1, "blm" = 1,
								"iac" = 1, "zsc" = 1, "vfc" = 1, "bis" = 1, "xmg" = 1, "npi" = 1) //how much the space sector afffects how expensive is ordering from that cargo supplier
	var/skybox_icon = "ceti"

	var/list/sector_lobby_art = null //if this is set, it will override the map lobby icons
	var/sector_lobby_transitions = null //if this is set, it will override the map lobby transition
	var/sector_welcome_message = null ///if this is set, it will override welcome audio message
	var/sector_hud_menu = null //if this is set, it will override the hud menu icons
	var/sector_hud_menu_sound = null //if this is set, it will override the hud menu click sound
	var/sector_hud_arrow = null //if this is set, it will use an overlay instead of the animation that makes the button bigger

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

/datum/space_sector/proc/get_chat_description()
	return "<hr><div align='center'><hr1><B>Current Sector: [name]!</B></hr1><br><i>[description]</i><hr></div>"

/datum/space_sector/proc/get_port_travel_time()
	return "[rand(1, 3)] days"

/datum/space_sector/proc/generate_system_name()
	return "[pick("Miranda", "BNM", "Xavier", "GJ", "HD", "TC", "Melissa", "TC")][prob(10) ? " Eridani" : ""] [rand(100,999)][prob(10) ? " [pick(greek_letters)]" : ""]"

/// Returns a flat list of all possible away sites that can spawn in this sector.
/datum/space_sector/proc/possible_sites_in_sector()
	var/list/away_sites = list()
	for(var/id in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site = SSmapping.away_sites_templates[id]
		if(name in away_site.sectors)
			away_sites += away_site
	return away_sites
