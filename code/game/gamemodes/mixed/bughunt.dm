/datum/game_mode/bughunt
	name = "Bughunt (merc+borer)"
	round_description = "A mercenary strike force is approaching at the same time as a borer infestation!"
	extended_round_description = "Mercenaries and borers spawn in this game mode."
	config_tag = "bughunt"
	required_players = 20
	required_enemies = 6
	end_on_antag_death = FALSE
	antag_tags = list(MODE_BORER, MODE_MERCENARY)
	require_all_templates = TRUE
	votable = TRUE
