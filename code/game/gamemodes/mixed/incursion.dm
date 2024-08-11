/datum/game_mode/incursion
	name = "Incursion (merc+operatives)"
	config_tag = "incursion"
	required_players = 20
	required_enemies = 6
	antag_tags = list(MODE_MERCENARY, MODE_NINJA)
	require_all_templates = TRUE

/datum/game_mode/incursion/pre_setup()
	round_description = "A group of mercenaries and a set of operatives have their eyes set on the [SSatlas.current_map.station_name]."
	extended_round_description = "[SSatlas.current_map.company_short] has been playing with fire, maybe a little visit will teach them a lesson."
	. = ..()
