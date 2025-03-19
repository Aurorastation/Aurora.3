/datum/vote/restart
	name = "Restart"
	message = "Restart the server?"
	default_choices = list("Restart Round", "Continue Playing")

/datum/vote/restart/can_be_initiated(mob/by_who, forced)
	. = ..()

	//If it's disabled and you're not staff, no voting
	if(!GLOB.config.allow_vote_restart && !forced)
		return FALSE

	//Prompt the mob to confirm the special use case if present, otherwise say it's possible so the button isn't greyed out
	if(ismob(by_who))
		var/acknowledge = tgui_alert(by_who, "CAUTION! This is a vote that must be used only in case of server issues that require a restart, and in no other case! Do you want to continue?",
										"Caution!", list("No", "Yes"), 1 MINUTE, TRUE)

		if(acknowledge == "Yes")
			return TRUE
		else
			return FALSE

	else
		return TRUE


/datum/vote/restart/finalize_vote(winning_option)
	if(winning_option != "Restart Round")
		return

	to_world("World restarting due to vote...")
	feedback_set_details("end_error","restart vote")
	sleep(50)
	log_game("Rebooting due to restart vote")
	world.Reboot()

/datum/vote/restart/toggle_votable(mob/toggler)
	if(toggler?.client?.holder && (toggler.client.holder.rights & (R_ADMIN|R_MOD)))
		GLOB.config.allow_vote_restart = !GLOB.config.allow_vote_restart

/datum/vote/restart/is_config_enabled()
	return GLOB.config.allow_vote_restart
