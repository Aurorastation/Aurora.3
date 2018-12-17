/datum/game_mode/siege
	name = "Siege (Rev+Merc)"
	config_tag = "siege"
	round_description = "Some crewmembers are attempting to start a revolution while a mercenary strike force is approaching the station!"
	extended_round_description = "Getting stuck between a rock and a hard place, maybe the nice visitors can help with your internal security problem?"
	required_players = 20
	required_enemies = 7
	end_on_antag_death = 0
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST, MODE_MERCENARY)
	require_all_templates = 1

	allow_emergency_spawns = TRUE