/datum/game_mode/veilparty
	name = "Veil Party (Cult & Vamp)"
	extended_round_description = "Cultists and vampires spawn in this mode."
	config_tag = "veilparty"
	required_players = 15
	required_enemies = 3
	require_all_templates = 1
	votable = 1
	antag_tags = list(MODE_VAMPIRE, MODE_CULTIST)

/datum/game_mode/veilparty/pre_setup()
	round_description = "Paranormal activities occur on the [current_map.station_type]."
	. = ..()
