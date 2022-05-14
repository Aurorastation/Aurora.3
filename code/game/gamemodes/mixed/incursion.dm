/datum/game_mode/incursion
	name = "Incursion (merc+ninjas)"
	config_tag = "incursion"
	extended_round_description = "The SCC has been playing with fire, maybe a little visit will teach them a lesson."
	required_players = 20
	required_enemies = 6
	antag_tags = list(MODE_MERCENARY, MODE_NINJA)
	require_all_templates = TRUE

/datum/game_mode/incursion/New()
	..()
	round_description = "A group of mercenaries and a set of ninjas have their eyes set on the [current_map.station_name]."
