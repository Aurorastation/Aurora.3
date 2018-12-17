/datum/game_mode/infiltration
	name = "Infiltration (Malf+Ninja)"
	round_description = "The AI is malfunctioning and a ninja is onboard!"
	extended_round_description = "A malf AI and a Ninja spawn during this round."
	config_tag = "infiltration"
	required_players = 15
	required_enemies = 2
	end_on_antag_death = 0
	require_all_templates = 1
	votable = 1
	antag_tags = list(MODE_MALFUNCTION, MODE_NINJA)
	disabled_jobs = list("AI")