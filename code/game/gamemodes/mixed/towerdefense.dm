/datum/game_mode/towerdefense
	name = "Tower Defense (merc+heist+ninjas)"
	config_tag = "towerdefense"
	required_players = 70
	required_enemies = 10
	antag_tags = list(MODE_MERCENARY, MODE_RAIDER, MODE_NINJA)
	require_all_templates = TRUE

/datum/game_mode/incursion/pre_setup()
	round_description = "A group of mercenaries, a gaggle of raiders, and a set of ninjas have their eyes set on the [current_map.station_name]."
	extended_round_description = "[current_map.company_short] has been playing with fire, maybe a big visit will teach them a lesson."
	. = ..()
