/datum/game_mode/acolytes
	name = "Acolytes (Cult & Borer)"
	extended_round_description = "Cultists and borers spawn during this round."
	config_tag = "acolytes"
	required_players = 20
	required_enemies = 4
	antag_tags = list(MODE_BORER, MODE_CULTIST)
	require_all_templates = TRUE

/datum/game_mode/acolytes/pre_setup()
	round_description = "A cult and a borer infestation are on-[current_map.station_type]!"
	. = ..()
