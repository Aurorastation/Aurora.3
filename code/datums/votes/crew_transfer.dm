///Snowflake var to know when it's ok to vote the transfer, and show in the statpanel the last time it happened
GLOBAL_VAR(last_transfer_vote)

/datum/vote/crewtransfer
	name = "Crew Transfer"
	message = "Initiate crew transfer"
	winner_method = VOTE_WINNER_METHOD_NONE //We handle this ourself
	default_choices = list("Initiate Crew Transfer", "Continue The Round")


/datum/vote/crewtransfer/can_be_initiated(mob/by_who, forced)
	. = ..()
	//Transfer already in progress, noone can call another vote
	if(SSatlas.current_map.shuttle_call_restart_timer || (GLOB.evacuation_controller.state != EVAC_IDLE))
		to_chat(by_who, SPAN_NOTICE("A crew transfer or evacuation is already in progress."))
		return FALSE

	//If in lobby, roundend, setup or whatever else
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(by_who, SPAN_NOTICE("The game is not running yet or has already finished."))
		return FALSE

	//Admins, system and whatnot can always start this vote otherwise
	if(forced)
		return TRUE

	if(GLOB.security_level >= SEC_LEVEL_DELTA)
		to_chat(by_who, "The current alert status is too high to call for a crew transfer!")
		return FALSE

	//If enought time from the start passed, allows the vote
	var/next_allowed_time = 0
	if(GLOB.last_transfer_vote)
		next_allowed_time = (GLOB.last_transfer_vote + GLOB.config.vote_delay)
	else
		next_allowed_time = GLOB.config.transfer_timeout

	if(next_allowed_time > get_round_duration()) //Sorry, not the time yet
		to_chat(by_who, SPAN_NOTICE("Time left until a crew transfer can be voted for: [next_allowed_time - get_round_duration()]"))
		return FALSE
	else
		return TRUE //We did it bro, we can vote the transfer now!


// Crew transfer during red alert gives less voting power to lobby-sitters and observers.
/datum/vote/crewtransfer/get_voting_power(mob/voter)
	var/vote_weight = ..()
	if(vote_weight != 0 && GLOB.security_level == SEC_LEVEL_RED)
		vote_weight = 0.5
		if(!isobserver(voter) && !isnewplayer(voter) && !((world.time - voter.mind.time_joined) < GLOB.config.minimum_participation_time))
			vote_weight = 1
	return vote_weight


/datum/vote/crewtransfer/get_vote_result(list/non_voters)
	SHOULD_CALL_PARENT(FALSE)

	// Calculate the factor based on the duration in minutes
	// Formula for an x/y majority: (y-x)/x
	var/factor = 1.0
	switch(get_round_duration() / (10 * 60)) // minutes
		if(0 to 180) //Up to 3 hours
			factor = 0.5 //2/3rds majority: transfer requires 2x the votes. (3-2)/2 = 0.5
		else
			factor = 1.0 //Equal weight

	var/list/result = null
	if((choices["Initiate Crew Transfer"]*factor) >= (choices["Continue The Round"]))
		result = list("Initiate Crew Transfer")
	else
		result = list("Continue The Round")

	if(round(get_round_duration() / 36000)+12 <= 14)
		to_world(SPAN_VOTE("Majority voting rule in effect. 2/3rds majority needed to initiate transfer."))

	return result


/datum/vote/crewtransfer/finalize_vote(winning_option)
	to_world(SPAN_VOTE("Vote result: [winning_option]"))
	GLOB.last_transfer_vote = get_round_duration()

	if(winning_option == "Initiate Crew Transfer")
		init_shift_change(null, TRUE)
