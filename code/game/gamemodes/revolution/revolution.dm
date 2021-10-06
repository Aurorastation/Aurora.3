/datum/game_mode/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "Some crewmembers are attempting to start a movement!"
	extended_round_description = "A revolution is in the early stages of formation, and a group of loyalists are rallying to oppose them."
	required_players = 22
	required_enemies = 6
	auto_recall_shuttle = 0
	end_on_antag_death = 0
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST)
	require_all_templates = 1
	ert_disabled = TRUE
