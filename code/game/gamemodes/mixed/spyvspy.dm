/datum/game_mode/spyvspy
	name = "Spy v. Spy (traitor+renegade)"
	round_description = "There are traitorous forces at play, but some crew have resolved to stop them by any means necessary!"
	extended_round_description = "Traitors and renegades both spawn during this mode."
	config_tag = "spyvspy"
	required_players = 4
	required_enemies = 4
	end_on_antag_death = FALSE
	votable = TRUE
	antag_tags = list(MODE_TRAITOR, MODE_RENEGADE)
	require_all_templates = TRUE
	antag_scaling_coeff = 5
	round_autoantag = TRUE
