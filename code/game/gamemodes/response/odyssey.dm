/datum/game_mode/odyssey
	name = "Odyssey"
	round_description = "Continue the Horizon's odyssey throughout the Spur and partake in whatever goes wrong (or right) today."
	extended_round_description = "The SCCV Horizon - being an exploration vessel - often finds itself in various situations, good or bad. Today could be a good day for you, \
								or you could end up brutally murdered by otherworldly horrors. Do it for Miranda."
	config_tag = "odyssey"
	required_players = 8
	required_enemies = 1 // The actual antag-setting is handled by the mission singleton.
	antag_tags = list(MODE_STORYTELLER, MODE_ACTOR)
	antag_scaling_coeff = 1

/datum/game_mode/odyssey/pre_setup()
	. = ..()
	SSodyssey.pick_situation()
