/datum/game_mode/feeding
	name = "Feeding (Vamp+Ling)"
	round_description = "The crew is being fed upon!"
	extended_round_description = "Vampires and Changelings spawn during this round."
	config_tag = "feeding"
	required_players = 20
	required_enemies = 5
	end_on_antag_death = 0
	require_all_templates = 1
	votable = 1
	antag_tags = list(MODE_VAMPIRE, MODE_CHANGELING)

	allow_emergency_spawns = TRUE