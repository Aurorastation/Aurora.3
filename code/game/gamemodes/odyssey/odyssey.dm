/datum/game_mode/odyssey
	name = "Odyssey"
	round_description = "Continue the Horizon's odyssey throughout the Spur and partake in whatever goes wrong (or right) today."
	extended_round_description = "The SCCV Horizon - being an exploration vessel - often finds itself in various situations, good or bad. Today could be a good day for you, \
								or you could end up brutally murdered by otherworldly horrors. Do it for Miranda."
	config_tag = "odyssey"
	required_players = 8
	required_enemies = 1 // The actual antag-setting is handled by the mission singleton.
	antag_tags = list(MODE_ACTOR)
	antag_scaling_coeff = 1

/datum/game_mode/odyssey/post_finalize_vote()
	GLOB.round_progressing = FALSE
	SSodyssey.pick_odyssey()
	to_world(FONT_LARGE(EXAMINE_BLOCK_ODYSSEY("The Odyssey picked for this round is: <b>[SPAN_NOTICE(SSodyssey.odyssey.name)]</b>.\n\
			[SSodyssey.odyssey.desc]\n\
			It is a <b>[SSodyssey.odyssey.odyssey_type == ODYSSEY_TYPE_NONCANON ? "non-canon" : "canon"]</b> Odyssey.\n\
			Please keep in mind that the Storyteller may alter the story as they see fit, and remember to go along with what they have planned!")))
	SSodyssey.odyssey.setup_odyssey()
	GLOB.round_progressing = TRUE
