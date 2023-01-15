/datum/game_mode/conflict
	name = "Conflict (Burglar+Heist)"
	extended_round_description = "Burglars and heisters spawn during this round."
	config_tag = "conflict"
	required_players = 15
	required_enemies = 6
	antag_tags = list(MODE_RAIDER, MODE_BURGLAR)
	require_all_templates = TRUE

/datum/game_mode/conflict/pre_setup()
	round_description = "Two underprepared teams of fools pick the same day to rob a highly valuable [current_map.company_short] [current_map.station_type]."
	. = ..()
