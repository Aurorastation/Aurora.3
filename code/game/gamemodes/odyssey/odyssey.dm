/datum/game_mode/odyssey
	name = "Odyssey"
	round_description = "Continue the Horizon's odyssey throughout the Spur and partake in whatever goes wrong (or right) today."
	extended_round_description = "The SCCV Horizon - being an exploration vessel - often finds itself in various situations, good or bad. Today could be a good day for you, \
								or you could end up brutally murdered by otherworldly horrors. Do it for Miranda."
	config_tag = "odyssey"
	required_players = 8
	required_enemies = 1 // The actual antag-setting is handled by the mission singleton.
	antag_tags = list(MODE_STORYTELLER)
	antag_scaling_coeff = 1

/datum/game_mode/odyssey/post_finalize_vote()
	GLOB.round_progressing = FALSE
	SSodyssey.pick_situation()
	to_world(FONT_LARGE(EXAMINE_BLOCK_ODYSSEY("The Situation picked for this round is: <b>[SPAN_NOTICE(SSodyssey.situation.name)]</b>.\n\
			[SSodyssey.situation.desc]\n\
			It is a <b>[SSodyssey.situation.mission_type == SITUATION_TYPE_NONCANON ? "non-canon" : "canon"]</b> situation.")))
	SSodyssey.situation.setup_situation()
	GLOB.round_progressing = TRUE
