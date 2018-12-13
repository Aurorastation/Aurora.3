/datum/game_mode/cult
	name = "Cult"
	round_description = "Some crewmembers are attempting to start a cult!"
	extended_round_description = "The station has been infiltrated by a fanatical group of death-cultists! They will use powers from beyond your comprehension to subvert you to their cause and ultimately please their gods through sacrificial summons and physical immolation! Try to survive!"
	config_tag = "cult"
	required_players = 10
	required_enemies = 4
	required_enemies_scale = 15 //There needs to be at least 1 antag for every 15 players.
	end_on_antag_death = 1
	antag_tags = list(MODE_CULTIST)
