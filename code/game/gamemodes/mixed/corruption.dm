/datum/game_mode/corruption
	name = "Corruption (Traitor+Malf)"
	round_description = "Crewmembers are contacted by external elements while the AI is malfunctioning"
	extended_round_description = "Traitors and a malf AI spawn during this round."
	config_tag = "corruption"
	required_players = 10
	required_enemies = 4
	end_on_antag_death = 0
	antag_tags = list(MODE_MALF, MODE_TRAITOR)
	require_all_templates = 1
