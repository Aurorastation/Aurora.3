/datum/game_mode/towerdefense
	name = "Tower Defense (merc+heist+ninjas)"
	config_tag = "towerdefense"
	round_description = "A group of mercenaries, a gaggle of raiders, and a set of ninjas have their eyes set on the NSS Aurora."
	extended_round_description = "Nanotrasen has been playing with fire, maybe a big visit will teach them a lesson."
	required_players = 30
	required_enemies = 10
	end_on_antag_death = FALSE
	antag_tags = list(MODE_MERCENARY, MODE_RAIDER, MODE_NINJA)
	require_all_templates = TRUE
