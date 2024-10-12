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

/datum/game_mode/odyssey/pre_game_setup()
	if(!SSodyssey.pick_odyssey())
		return FALSE

	to_world(FONT_LARGE(EXAMINE_BLOCK_ODYSSEY("The scenario picked for this round is: <b>[SPAN_NOTICE(SSodyssey.scenario.name)]</b>.\n\
			[SSodyssey.scenario.desc]\n\
			It is a <b>[SSodyssey.scenario.scenario_type == SCENARIO_TYPE_NONCANON ? "non-canon" : "canon"]</b> scenario.\n\
			Please keep in mind that the Storyteller or the Actors may alter the story as they see fit, and remember to go along with what they have planned!")))

	if(!SSodyssey.scenario.setup_scenario())
		return FALSE

	// Need to repopulate antag spawns to get the actor landmarks to work, since this is only done in the map finalization SS.
	populate_antag_spawns()

	return TRUE
