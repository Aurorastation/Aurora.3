/datum/game_mode/malfunction
	name = "AI malfunction"
	round_description = "The AI is behaving abnormally and must be stopped."
	extended_round_description = "The AI will attempt to hack the APCs around the station in order to gain as much control as possible."
	config_tag = "malfunction"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = 0
	auto_recall_shuttle = 0
	antag_tags = list(MODE_MALFUNCTION)
	disabled_jobs = list("AI")


/datum/game_mode/malfunction/post_setup()
	..()
	sleep(15) //Adds a delay to notifying the cyborgs, which looks slightly more realistic. This should only pause the post_setup proc.
	var/malf_ai = select_active_ai_with_fewest_borgs()
	if (malf_ai)
		for (var/mob/living/silicon/robot/borg in silicon_mob_list) //This is similar to baystation's solution, but without a notification.
			borg.connect_to_ai(malf_ai) //This will do nothing if the borg is synced before this line of code.
			notify_borg(borg)
	else
		error("Unable to locate the Malf AI during post_setup()! At the time, there were no AIs active.")
	return

/datum/game_mode/malfunction/proc/notify_borg(var/mob/living/silicon/robot/borg)
	to_chat(borg, "Station AI detected. Establishing connection...") //Fluff)
	sleep(10)
	to_chat(borg, "Connection to station AI successful. Synchronizing laws...") //Fluff.)
	sleep(5)
	to_chat(borg, "<span class='danger'>You have been bound to an AI, Laws synchronized!</span>") //to provide a noticable chat notification.)
	borg.law_update = TRUE //Required for sync() to function.
	borg.sync()
	borg.show_laws(0) //This should display updated laws to the borg.
