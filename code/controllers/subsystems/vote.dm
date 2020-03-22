var/datum/controller/subsystem/vote/SSvote

/datum/controller/subsystem/vote
	name = "Voting"
	wait = 1 SECOND
	flags = SS_KEEP_TIMING | SS_FIRE_IN_LOBBY | SS_NO_TICK_CHECK
	priority = SS_PRIORITY_VOTE

	var/next_transfer_time

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/voted = list()
	var/list/current_votes = list()
	var/auto_muted = 0
	var/last_transfer_vote = null

	var/list/round_voters = list()

/datum/controller/subsystem/vote/New()
	NEW_SS_GLOBAL(SSvote)

/datum/controller/subsystem/vote/Initialize(timeofday)
	next_transfer_time = config.vote_autotransfer_initial

/datum/controller/subsystem/vote/fire(resumed = FALSE)
	if (mode)
		// No more change mode votes after the game has started.
		if(mode == "gamemode" && ROUND_IS_STARTED)
			to_world("<b>Voting aborted due to game start.</b>")
			reset()
			return

		if(((started_time + config.vote_period - world.time)) < 0)
			result()
			SSvueui.close_uis(src)
			reset()

	if (get_round_duration() >= next_transfer_time - 600)
		autotransfer()
		next_transfer_time += config.vote_autotransfer_interval

/datum/controller/subsystem/vote/proc/autotransfer()
	initiate_vote("crew_transfer","the server", 1)
	log_debug("The server has called a crew transfer vote")

/datum/controller/subsystem/vote/proc/autogamemode()
	initiate_vote("gamemode","the server", 1)
	log_debug("The server has called a gamemode vote")

/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	current_votes.Cut()
	SSvueui.check_uis_for_change(src)

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]["votes"]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!config.vote_no_default && choices.len)
		var/non_voters = (clients.len - total_votes)
		if(non_voters > 0)
			if(mode == "restart")
				choices["Continue Playing"]["votes"] += non_voters
				if(choices["Continue Playing"]["votes"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]["votes"]
			else if(mode == "gamemode")
				if(master_mode in choices)
					choices[master_mode]["votes"] += non_voters
					if(choices[master_mode]["votes"] >= greatest_votes)
						greatest_votes = choices[master_mode]["votes"]
			else if(mode == "crew_transfer")
				var/factor = 0.5
				switch(get_round_duration() / (10 * 60)) // minutes
					if(0 to 60)
						factor = 0.5
					if(61 to 120)
						factor = 0.8
					if(121 to 240)
						factor = 1
					if(241 to 300)
						factor = 1.2
					else
						factor = 1.4
				choices["Initiate Crew Transfer"]["votes"] = round(choices["Initiate Crew Transfer"]["votes"] * factor)
				to_world("<font color='purple'>Crew Transfer Factor: [factor]</font>")
				greatest_votes = max(choices["Initiate Crew Transfer"]["votes"], choices["Continue The Round"]["votes"])

	if(mode == "crew_transfer")
		if(round(get_round_duration() / 36000)+12 <= 14)
			// Credit to Scopes @ oldcode.
			to_world("<font color='purple'><b>Majority voting rule in effect. 2/3rds majority needed to initiate transfer.</b></font>")
			choices["Initiate Crew Transfer"]["votes"] = round(choices["Initiate Crew Transfer"]["votes"] - round(total_votes / 3))
			greatest_votes = max(choices["Initiate Crew Transfer"]["votes"], choices["Continue The Round"]["votes"])

	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option]["votes"] == greatest_votes)
				. += option

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(winners.len > 1)
			if(mode != "gamemode" || SSticker.hide_mode == 0) // Here we are making sure we don't announce potential game modes
				text = "<b>Vote Tied Between:</b>\n"
				for(var/option in winners)
					text += "\t[option]\n"
		. = pick(winners)

		for(var/key in current_votes)
			if(current_votes[key] == .)
				round_voters += key // Keep track of who voted for the winning round.

		if((mode == "gamemode" && . == "Extended") || SSticker.hide_mode == 0) // Announce Extended gamemode, but not other gamemodes
			text += "<b>Vote Result: [.]</b>"
		else
			if(mode != "gamemode")
				text += "<b>Vote Result: [.]</b>"
			else
				text += "<b>The vote has ended.</b>" // What will be shown if it is a gamemode vote that isn't extended

	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
		if(mode == "add_antagonist")
			antag_add_failed = 1
	log_vote(text)
	to_world("<font color='purple'>[text]</font>")

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(master_mode != .)
					SSpersist_config.last_gamemode = .
					if(SSticker.mode)
						restart = 1
					else
						master_mode = .
			if("crew_transfer")
				if(. == "Initiate Crew Transfer")
					init_shift_change(null, 1)
				last_transfer_vote = get_round_duration()
			if("add_antagonist")
				if(isnull(.) || . == "None")
					antag_add_failed = 1
				else
					additional_antag_types |= antag_names_to_ids[.]

	if(mode == "gamemode") //fire this even if the vote fails.
		if(!round_progressing)
			round_progressing = 1
			to_world("<font color='red'><b>The round will start soon.</b></font>")

	if(restart)
		to_world("World restarting due to vote...")
		feedback_set_details("end_error","restart vote")
		sleep(50)
		log_game("Rebooting due to restart vote")
		world.Reboot()

/datum/controller/subsystem/vote/proc/submit_vote(ckey, vote)
	if(mode)
		if (mode == "crew_transfer")
			if(config.vote_no_dead && usr && !usr.client.holder)
				if (isnewplayer(usr))
					to_chat(usr, "<span class='warning'>You must be playing or have been playing to start a vote.</span>")
					return 0
				else if (isobserver(usr))
					var/mob/abstract/observer/O = usr
					if (O.started_as_observer)
						to_chat(usr, "<span class='warning'>You must be playing or have been playing to start a vote.</span>")
						return 0
		if(vote in choices)
			if(current_votes[ckey])
				choices[current_votes[ckey]]["votes"]--
			voted += usr.ckey
			choices[vote]["votes"]++	//check this
			current_votes[ckey] = vote
			return 1
	return 0


/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, automatic = FALSE)
	if(!mode)
		if(started_time != null && !(check_rights(R_ADMIN|R_MOD) || automatic))
			// Transfer votes are their own little special snowflake
			var/next_allowed_time = 0
			if (vote_type == "crew_transfer")
				if (config.vote_no_dead && !usr.client.holder)
					if (isnewplayer(usr))
						to_chat(usr, "<span class='warning'>You must be playing or have been playing to start a vote.</span>")
						return 0
					else if (isobserver(usr))
						var/mob/abstract/observer/O = usr
						if (O.started_as_observer)
							to_chat(usr, "<span class='warning'>You must be playing or have been playing to start a vote.</span>")
							return 0

				if (last_transfer_vote)
					next_allowed_time = (last_transfer_vote + config.vote_delay)
				else
					next_allowed_time = config.transfer_timeout
			else
				next_allowed_time = (started_time + config.vote_delay)

			if(next_allowed_time > get_round_duration())
				return 0

		//reset()
		switch(vote_type)
			if("restart")
				AddChoice("Restart Round")
				AddChoice("Continue Playing")
			if("gamemode")
				round_voters.Cut() //Delete the old list, since we are having a new gamemode vote
				if(SSticker.current_state >= 2)
					return 0
				for (var/F in config.votable_modes)
					var/datum/game_mode/M = gamemode_cache[F]
					if(!M)
						continue
					AddChoice(F, capitalize(M.name), "[M.required_players]")
				AddChoice(ROUNDTYPE_STR_SECRET, "Secret")
				if(ROUNDTYPE_STR_MIXED_SECRET in choices)
					AddChoice(ROUNDTYPE_STR_MIXED_SECRET, "Mixed Secret")
			if("crew_transfer")
				if(check_rights(R_ADMIN|R_MOD, 0))
					question = "End the shift?"
					AddChoice("Initiate Crew Transfer")
					AddChoice("Continue The Round")
				else
					if (get_security_level() == "red" || get_security_level() == "delta")
						to_chat(initiator_key, "The current alert status is too high to call for a crew transfer!")
						return 0
					if(SSticker.current_state <= 2)
						return 0
						to_chat(initiator_key, "The crew transfer button has been disabled!")
					question = "End the shift?"
					AddChoice("Initiate Crew Transfer")
					AddChoice("Continue The Round")
			if("add_antagonist")
				if(!config.allow_extra_antags || SSticker.current_state >= 2)
					return 0
				for(var/antag_type in all_antag_types)
					var/datum/antagonist/antag = all_antag_types[antag_type]
					if(!(antag.id in additional_antag_types) && antag.is_votable())
						AddChoice(antag.role_text)
				AddChoice("None")
			if("custom")
				question = input(usr,"What is the vote for?") as text|null
				if(!question)	return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(sanitize(input(usr,"Please enter an option or hit cancel to finish") as text|null))
					if(!option || mode || !usr.client)	break
					AddChoice(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "custom")
			text += "\n[sanitizeSafe(question)]"

		log_vote(text)
		to_world("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src];open=1'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")
		for(var/cc in clients)
			var/client/C = cc
			if(C.prefs.asfx_togs & ASFX_VOTE) //Personal mute
				switch(vote_type)
					if("crew_transfer")
						C << sound('sound/effects/vote.ogg', repeat = 0, wait = 0, volume = 50, channel = 3)
					if("gamemode")
						C << sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3)
					if("custom")
						C << sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3)
		if(mode == "gamemode" && round_progressing)
			round_progressing = 0
			to_world("<font color='red'><b>Round start has been delayed.</b></font>")
		SSvueui.check_uis_for_change(src)
		return 1
	return 0

/datum/controller/subsystem/vote/proc/AddChoice(name, display_name, extra_text)
	if(!display_name)
		display_name = name
	choices[name] = list("name" = display_name, "extra" = extra_text, "votes" = 0)

/datum/controller/subsystem/vote/Topic(href, list/href_list = list(), hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid
	if(href_list["open"])
		OpenVotingUI(usr)
	var/isstaff = usr.client.holder && (usr.client.holder.rights & (R_ADMIN|R_MOD))

	switch(href_list["action"])
		if("cancel")
			if(isstaff)
				reset()
		if("toggle_restart")
			if(isstaff)
				config.allow_vote_restart = !config.allow_vote_restart
				SSvueui.check_uis_for_change(src)
		if("toggle_gamemode")
			if(isstaff)
				config.allow_vote_mode = !config.allow_vote_mode
				SSvueui.check_uis_for_change(src)
		if("restart")
			if(isstaff)
				initiate_vote("restart",usr.key)
			else if (config.allow_vote_restart)
				var/admin_number_present = 0
				var/admin_number_afk = 0

				for (var/s in staff)
					var/client/X = s
					if (X.holder.rights & R_ADMIN)
						admin_number_present++
						if (X.is_afk())
							admin_number_afk++
						if (X.prefs.toggles & SOUND_ADMINHELP)
							to_chat(X, 'sound/effects/adminhelp.ogg')

				if ((admin_number_present - admin_number_afk) <= 0)
					initiate_vote("restart", usr.key)
				else
					log_and_message_admins("tried to start a restart vote.", usr, null)
					to_chat(usr, "<span class='notice'><b>There are active admins around! You cannot start a restart vote due to this.</b></span>")
		if("gamemode")
			if(config.allow_vote_mode || isstaff)
				initiate_vote("gamemode",usr.key)
		if("crew_transfer")
			if(config.allow_vote_restart || isstaff)
				initiate_vote("crew_transfer",usr.key)
		if("add_antagonist")
			if(!antag_add_failed && config.allow_extra_antags)
				initiate_vote("add_antagonist",usr.key)
		if("custom")
			if(isstaff)
				initiate_vote("custom",usr.key)
		if("vote")
			var/t = href_list["vote"]
			if(t) // It starts from 1, so there's no problem
				if(submit_vote(usr.ckey, t))
					SSvueui.check_uis_for_change(src)

/datum/controller/subsystem/vote/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = list("choices" = list(), "mode" = 0, "voted" = 0)
	data = . || data
	if(choices.len != LAZYLEN(data["choices"]))
		data["choices"] = list()
	for(var/choice in choices)
		VUEUI_SET_IFNOTSET(data["choices"][choice], deepCopyList(choices[choice]), ., data)
		VUEUI_SET_CHECK(data["choices"][choice]["votes"], choices[choice]["votes"], ., data) // Only votes trigger data update

	VUEUI_SET_CHECK(data["mode"], mode, ., data)
	VUEUI_SET_CHECK(data["voted"], current_votes[user.ckey], ., data)
	VUEUI_SET_CHECK(data["endtime"], started_time + config.vote_period, ., data)
	VUEUI_SET_CHECK(data["allow_vote_restart"], config.allow_vote_restart, ., data)
	VUEUI_SET_CHECK(data["allow_vote_mode"], config.allow_vote_mode, ., data)
	VUEUI_SET_CHECK(data["allow_extra_antags"], (!antag_add_failed && config.allow_extra_antags), ., data)

	if(!question)
		VUEUI_SET_CHECK(data["question"], capitalize(mode), ., data)
	else
		VUEUI_SET_CHECK(data["question"], question, ., data)
	VUEUI_SET_CHECK(data["isstaff"], (user.client.holder && (user.client.holder.rights & (R_ADMIN|R_MOD))), ., data)
	var/slevel = get_security_level()
	VUEUI_SET_CHECK(data["is_code_red"], (slevel == "red" || slevel == "delta"), ., data)



/datum/controller/subsystem/vote/proc/OpenVotingUI(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, SSvote, "misc-voting", 400, 500, "Voting panel", nstate = interactive_state)
		ui.header = "minimal"
	ui.open()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	SSvote.OpenVotingUI(src)
