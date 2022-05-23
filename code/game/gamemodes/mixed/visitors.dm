/datum/game_mode/visitors
	name = "Visitors (Ninja+Techno)"
	extended_round_description = "A Ninja and a Technomancer spawn during this round."
	config_tag = "visitors"
	required_players = 20
	required_enemies = 3
	antag_tags = list(MODE_TECHNOMANCER, MODE_NINJA)
	require_all_templates = 1

/datum/game_mode/visitors/pre_setup()
	round_description = "A Technomancer and a Ninja have invaded the [current_map.station_type]!"
	. = ..()
