/datum/game_mode/odyssey
	name = "Odyssey"
	round_description = "Continue the Horizon's odyssey throughout the Spur and partake in whatever goes wrong (or right) today."
	extended_round_description = "The SCCV Horizon - being an exploration vessel - often finds itself in various situations, good or bad. Today could be a good day for you, \
								or you could end up brutally murdered by otherworldly horrors. Do it for Miranda."
	config_tag = "odyssey"
	required_players = 8
	required_enemies = 2 // The actual antag-setting is handled by the mission singleton.
	antag_tags = list(MODE_ACTOR)
	antag_scaling_coeff = 1

/datum/game_mode/odyssey/pre_game_setup()
	SSticker.prevent_unready = TRUE

	if(!SSodyssey.pick_odyssey())
		return FALSE

	var/odyssey_message = "The scenario picked for this round is: [SPAN_BOLD(SPAN_NOTICE(SSodyssey.scenario.name))].<br>\
			It is a [SPAN_BOLD(SSticker.round_canon.name)] scenario.<br>"

	odyssey_message += SPAN_DANGER("For information on the canonicity of the scenario, refer to the Canon Panel by pressing the [SSticker.round_canon.name] button in your Status panel. Remember that Storytellers and Admins may change this at will.<br>")

	odyssey_message += "Please keep in mind that the Storyteller and the Actors may alter the story as they see fit, and remember to go along with what they have planned!"

	to_world(FONT_LARGE(EXAMINE_BLOCK_ODYSSEY(odyssey_message)))

	if(!SSodyssey.scenario.setup_scenario())
		return FALSE

	// Need to repopulate antag spawns to get the actor landmarks to work, since this is only done in the map finalization SS.
	populate_antag_spawns()

	return TRUE
