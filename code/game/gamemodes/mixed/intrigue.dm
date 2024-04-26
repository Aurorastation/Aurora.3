/datum/game_mode/intrigue
	name = "Intrigue (Traitor+Operatives)"
	extended_round_description = "Traitors and operatives spawn during this round."
	config_tag = "intrigue"
	required_players = 20
	required_enemies = 3
	antag_tags = list(MODE_NINJA, MODE_TRAITOR)
	require_all_templates = 1

/datum/game_mode/intrigue/pre_setup()
	round_description = "Crewmembers are contacted by external elements while an outsider infiltrates the [SSatlas.current_map.station_type]."
	. = ..()
