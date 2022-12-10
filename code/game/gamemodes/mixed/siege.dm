/datum/game_mode/siege
	name = "Siege (Rev+Merc)"
	config_tag = "siege"
	extended_round_description = "Getting stuck between a rock and a hard place, maybe the nice visitors can help with your internal security problem?"
	required_players = 25
	required_enemies = 6
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST, MODE_MERCENARY)
	require_all_templates = 1

/datum/game_mode/siege/pre_setup()
	round_description = "Some crewmembers are attempting to start a revolution while a mercenary strike force is approaching the [current_map.station_type]!"
	. = ..()
