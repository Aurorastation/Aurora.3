// medpop burglar/merc hybrid

/datum/game_mode/jockeys
	name = "jockeys"
	config_tag = "jockeys"
	required_enemies = 2
	required_players = 10
	antag_scaling_coeff = 7 // three jockeys at highpop
	round_description = "Metal Crushers ain't got shit on this."
	antag_tags = list(MODE_JOCKEY)

/datum/game_mode/jockeys/pre_setup()
	extended_round_description = "A couple coolant-soaked knuckleheads are on their way to turn a corporate workplace into a thunderdome. Is the crew ready to rumble?"
	return ..()
