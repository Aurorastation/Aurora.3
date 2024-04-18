/datum/vote/gamemode
	name = "Gamemode"
	vote_sound = 'sound/ambience/vote_alarm.ogg'
	message = "Vote for the gamemode of this round"

/datum/vote/gamemode/create_vote(mob/vote_creator)
	if(SSticker.current_state != GAME_STATE_PREGAME)
		return FALSE

	//List of modes, will be inserted sorted by criteria
	var/list/gamemodes_list = list()

	default_choices = list()

	//Put secret as the first option
	default_choices.Add("Secret")

	//Sort the gamemodes
	for(var/votable_mode_name in GLOB.config.votable_modes)
		var/datum/game_mode/M = GLOB.gamemode_cache[votable_mode_name]
		if(!M)
			continue

		BINARY_INSERT(M, gamemodes_list, /datum/game_mode, M, required_players, COMPARE_KEY)

	//Actually populate the voting choices, which are now sorted
	for(var/datum/game_mode/votable_mode_sorted in gamemodes_list)
		default_choices += capitalize(votable_mode_sorted.name)

	//Stop the countdown while we vote
	GLOB.round_progressing = FALSE

	. = ..()

//Otherwise we get thanos snapped from the possible votes list
/datum/vote/gamemode/is_accessible_vote()
	//Only accessible in pregame setup, further restricted from mobs in "can_be_initiated()"
	if(SSticker.current_state == GAME_STATE_PREGAME)
		return TRUE
	return FALSE

/datum/vote/gamemode/can_be_initiated(mob/by_who, forced)
	. = ..()
	//This can only be called by the server, noone else, not even admins
	if(forced && !ismob(by_who))
		return TRUE
	return FALSE


/datum/vote/gamemode/get_simple_winner()
	var/list/winner = ..()

	//If noone voted, start extended
	//yes this is kind of stupid, if noone won the list should be empty not have them all
	//no it's not worth to change it, unless you want to do it yourself, if so, be my guest I guess
	if(length(winner) == length(default_choices))
		to_world(SPAN_NOTICE("No votes for gamemode registered, defaulting to extended!"))
		return list("extended")

	else
		return winner

/datum/vote/gamemode/finalize_vote(winning_option)
	to_world(SPAN_WARNING("<b>The round will start soon.</b>"))

	var/winning_option_lowertext = lowertext(winning_option)

	if(GLOB.master_mode != winning_option_lowertext)
		SSpersistent_configuration.last_gamemode = winning_option_lowertext

		//This is because `/datum/configuration/proc/pick_mode()` uses the config tag, for god-knows what reason
		//unless it's one of these snowflake gamemodes
		if(winning_option_lowertext in list(ROUNDTYPE_STR_SECRET, ROUNDTYPE_STR_MIXED_SECRET, ROUNDTYPE_STR_RANDOM))
			GLOB.master_mode = winning_option_lowertext

		else

			for(var/votable_mode_name in GLOB.config.votable_modes)
				var/datum/game_mode/M = GLOB.gamemode_cache[votable_mode_name]

				if(M.name == winning_option)
					GLOB.master_mode = M.config_tag
					break

/datum/vote/gamemode/reset()
	. = ..()
	//Resume the countdown at vote end
	GLOB.round_progressing = TRUE
