/datum/game_mode/cult
	name = "Cult"
	config_tag = "cult"
	required_players = 9
	required_enemies = 4
	antag_tags = list(MODE_CULTIST)

/datum/game_mode/cult/pre_setup()
	round_description = "Some crewmembers are attempting to start a cult!"
	extended_round_description = "The [SSatlas.current_map.station_type] has been infiltrated by a fanatical group of death-cultists! \
	They will use powers from beyond your comprehension to subvert you to their cause and \
	ultimately please their gods through sacrificial summons and physical immolation! Try to survive!"
	. = ..()
