/datum/game_mode/intruder
	name = "intruder"
	config_tag = "intruder"
	required_players = 1 // TESTING - revert to 5 before merging
	required_enemies = 1
	antag_tags = list(MODE_INTRUDER)
	antag_scaling_coeff = 4

/datum/game_mode/intruder/pre_setup()
	round_description = "There are intruders that have infiltrated the [SSatlas.current_map.station_type]. Find and stop them before they can accomplish their goals!"
	extended_round_description = "One or more operatives have been deployed to infiltrate and sabotage the [station_name()]. They will arrive posing as regular crew members, but their true allegiance lies with hostile interests. Stay vigilant and watch for suspicious behavior."
	return ..()
