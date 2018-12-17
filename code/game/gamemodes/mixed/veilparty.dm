/datum/game_mode/veilparty
	name = "Veil Party (Cult+Vamp)"
	round_description = "Paranormal activities occur on the station."
	extended_round_description = "Vampires and a Cult spawn in this mode."
	config_tag = "veilparty"
	required_players = 20
	required_enemies = 5
	end_on_antag_death = 0
	require_all_templates = 1
	votable = 1
	antag_tags = list(MODE_VAMPIRE, MODE_CULTIST)

	allow_emergency_spawns = TRUE
