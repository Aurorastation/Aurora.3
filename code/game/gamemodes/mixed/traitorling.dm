/datum/game_mode/traitorling
	name = "Traitorling"
	extended_round_description = "Traitors and changelings both spawn during this mode."
	config_tag = "traitorling"
	required_players = 10
	required_enemies = 2
	require_all_templates = 1
	antag_tags = list(MODE_CHANGELING, MODE_TRAITOR)

/datum/game_mode/traitorling/pre_setup()
	round_description = "There are traitors and alien changelings on the [current_map.station_type]. Do not let the changelings succeed!"
	. = ..()
