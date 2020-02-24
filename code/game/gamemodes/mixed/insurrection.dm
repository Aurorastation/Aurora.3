/datum/game_mode/insurrection
	name = "Insurrection (rev+borer)"
	round_description = "Some crewmembers are attempting to start a revolution while borers infest the crew!"
	extended_round_description = "Revolutionaries and borers spawn during this round."
	config_tag = "insurrection"
	required_players = 20
	required_enemies = 5
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST, MODE_BORER)
	require_all_templates = TRUE
