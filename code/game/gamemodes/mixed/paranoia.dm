/datum/game_mode/paranoia
	name = "Paranoia (Malf+Traitor+Ling)"
	round_description = "The AI has malfunctioned, and subversive elements infest the crew."
	extended_round_description = "Rampant AIs, traitors and changelings spawn in this mode."
	config_tag = "paranoia"
	required_players = 15
	required_enemies = 5
	end_on_antag_death = 1
	require_all_templates = 1
	votable = 1
	antag_tags = list(MODE_MALFUNCTION, MODE_TRAITOR, MODE_CHANGELING)
	disabled_jobs = list("AI")

	allow_emergency_spawns = TRUE