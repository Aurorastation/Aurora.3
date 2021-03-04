/datum/admins/proc/check_antagonists()
	if (SSticker.current_state >= GAME_STATE_PLAYING)
		var/dat = ""
		dat += "Current Game Mode: <b>[SSticker.mode.name]</b><br>"
		dat += "Round Duration: [get_round_duration_formatted()]<br>"
		dat += "<b>Emergency Shuttle</b><br>"
		if (!emergency_shuttle.online())
			dat += "<vui-button :params=\"{ call_shuttle: 1 }\">Call Shuttle</vui-button><br>"
		else
			if (emergency_shuttle.wait_for_launch)
				var/timeleft = emergency_shuttle.estimate_launch_time()
				dat += "ETL: <vui-button :params=\"{ edit_shuttle_time: 1 }\">[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]</vui-button><br>"

			else if (emergency_shuttle.shuttle.has_arrive_time())
				var/timeleft = emergency_shuttle.estimate_arrival_time()
				dat += "ETA: <vui-button :params=\"{ edit_shuttle_time: 1 }\">[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]</vui-button><br>"
				dat += "<a href='?src=\ref[src];call_shuttle=2'>Send Back</a><br>"

			if (emergency_shuttle.shuttle.moving_status == SHUTTLE_WARMUP)
				dat += "Launching now...<br>"

		dat += "<vui-button :params=\"{ delay_round_end: 1 }\">[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</vui-button><br>"
		dat += "<hr>"
		for(var/antag_type in all_antag_types)
			var/datum/antagonist/A = all_antag_types[antag_type]
			dat += A.get_check_antag_output(src)
	
		var/datum/vueui/ui = new(usr, src, "?<div>[dat]</div>", 400, 500, "Round Status", list(), interactive_state)
		ui.open()
	else
		alert("The game hasn't started yet!")

/datum/vueui_module/player_panel

/datum/vueui_module/player_panel/ui_interact(mob/user)
	if (!usr.client.holder)
		return
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "admin-player-panel", 800, 600, "Modern player panel", state = interactive_state)
		ui.header = "minimal"
		ui.auto_update_content = TRUE

	ui.open()

/datum/vueui_module/player_panel/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()
	if(!user.client.holder)
		return
	var/isMod = check_rights(R_MOD|R_ADMIN, 0, user)
	VUEUI_SET_CHECK(data["holder_ref"], "\ref[user.client.holder]", ., data)
	VUEUI_SET_CHECK(data["ismod"], isMod, ., data)


	var/list/mobs = sortmobs()
	
	LAZYINITLIST(data["players"])
	if(LAZYLEN(data["players"]) != mobs.len)
		data["players"] = list()
	for(var/mob/M in mobs)
		var/ref = "\ref[M]"
		LAZYINITLIST(data["players"][ref])
		if(!M.ckey)
			data["players"][ref] = FALSE
			continue
		LAZYINITLIST(data["players"][ref])
		VUEUI_SET_CHECK(data["players"][ref]["ref"], ref, ., data)
		VUEUI_SET_CHECK(data["players"][ref]["name"], M.name, ., data)
		var/real_name = GetMobRealName(M)
		VUEUI_SET_CHECK(data["players"][ref]["real_name"], real_name, ., data)
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.mind?.assigned_role)
				VUEUI_SET_CHECK(data["players"][ref]["assigment"], H.mind.assigned_role, ., data)
		else
			VUEUI_SET_CHECK(data["players"][ref]["assigment"], "NA", ., data)
		VUEUI_SET_CHECK(data["players"][ref]["key"], M.key, ., data)
		if(isMod)
			VUEUI_SET_CHECK(data["players"][ref]["ip"], M.lastKnownIP, ., data)
		else
			VUEUI_SET_CHECK(data["players"][ref]["ip"], FALSE, ., data)
		VUEUI_SET_CHECK(data["players"][ref]["connected"], !!M.client, ., data)
		if(isMod)
			var/special_char = is_special_character(M)
			VUEUI_SET_CHECK(data["players"][ref]["antag"], special_char, ., data)
		else
			VUEUI_SET_CHECK(data["players"][ref]["antag"], -1, ., data)
		if(isMod && (M.client?.player_age || M.player_age))
			var/age = "Requires database"
			if(M.client?.player_age)
				age = M.client.player_age
			else if(M.player_age)
				age = M.player_age
			else
				age = "NA"
			if(age == "Requires database")
				age = "NA"
			VUEUI_SET_CHECK(data["players"][ref]["age"], age, ., data)
		else
			VUEUI_SET_CHECK(data["players"][ref]["age"], FALSE, ., data)

/datum/vueui_module/player_panel/proc/GetMobRealName(var/mob/M)
	if(isAI(M))
		return "AI"
	if(isrobot(M))
		return "Cyborg"
	if(ishuman(M))
		if(M.real_name)
			return M.real_name
		return "Unknown"
	if(istype(M, /mob/living/silicon/pai))
		return "pAI"
	if(istype(M, /mob/abstract/new_player))
		return "New Player"
	if(isobserver(M))
		return "Ghost"
	if(issmall(M))
		return "Monkey"
	if(isalien(M))
		return "Alien"
	return "Unknown"