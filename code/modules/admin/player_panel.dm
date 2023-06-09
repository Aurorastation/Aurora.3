/datum/admins/proc/check_antagonists()
	if (SSticker.current_state >= GAME_STATE_PLAYING)
		var/dat = ""
		dat += "Current Game Mode: <b>[SSticker.mode.name]</b><br>"
		dat += "Round Duration: [get_round_duration_formatted()]<br>"
		dat += "<b>Evacuation</b><br>"
		if (evacuation_controller.is_idle())
			dat += "<vui-button :params=\"{ call_shuttle: 1 }\">Call Evacuation</vui-button><br>"
		else
			var/timeleft = evacuation_controller.get_eta()
			if (evacuation_controller.waiting_to_leave())
				dat += "ETA: [(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"
				dat += "<a href='?src=\ref[src];call_shuttle=2'>Send Back</a><br>"

		dat += "<vui-button :params=\"{ delay_round_end: 1 }\">[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</vui-button><br>"
		dat += "<hr>"
		for(var/antag_type in all_antag_types)
			var/datum/antagonist/A = all_antag_types[antag_type]
			dat += A.get_check_antag_output(src)

		var/datum/vueui/ui = new(usr, src, "?<div>[dat]</div>", 400, 500, "Round Status", list(), staff_state)
		ui.open()
	else
		alert("The game hasn't started yet!")

/datum/tgui_module/ui_state(mob/user)
	return always_state

/datum/tgui_module/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/tgui_module/player_panel

/datum/tgui_module/player_panel/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerPanel", "Player Panel", 800, 600)
		ui.open()

/datum/tgui_module/player_panel/ui_data(mob/user)
	var/list/data = list()
	var/isMod = check_rights(R_MOD|R_ADMIN, 0, user)
	data["holder_ref"] = "\ref[user.client.holder]"
	data["is_mod"] = isMod

	var/list/mobs = sortmobs()

	data["players"] = list()

	for(var/mob/M in mobs)
		var/ref = "\ref[M]"
		var/list/player = list()
		player["ckey"] = TRUE
		if(!M.ckey)
			player["ckey"] = FALSE
			continue

		player["ref"] = ref
		player["name"] = M.name
		var/real_name = GetMobRealName(M)
		player["real_name"] = real_name

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.mind?.assigned_role)
				player["assigment"] = H.mind.assigned_role
		else
			player["assigment"] = "NA"

		player["key"] = M.key

		if(isMod)
			player["ip"] = M.lastKnownIP
		else
			player["ip"] = FALSE

		player["connected"] = !!M.client

		if(isMod)
			var/special_char = is_special_character(M)
			player["antag"] = special_char
		else
			player["antag"] = -1

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
			player["age"] = age
		else
			player["age"] = FALSE

		data["players"] += list(player)
	return data

/datum/tgui_module/player_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/C = usr.client
	if(!C || !C.holder)
		return

	switch(action)
		if("show_player_panel")
			var/mob/M = locate(params["show_player_panel"])
			C.holder.show_player_panel(M)
			. = TRUE

		if("private_message")
			var/client/messagee = locate(params["private_message"])
			var/datum/ticket/ticket = locate(params["ticket"])

			if (!isnull(ticket) && !istype(ticket))
				return

			if(ismob(messagee)) 		//Old stuff can feed-in mobs instead of clients
				var/mob/M = messagee
				messagee = M.client

			C.cmd_admin_pm(messagee, null, ticket)
			. = TRUE

		if("subtle_message")
			if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))
				return

			var/mob/M = locate(params["subtle_message"])
			C.cmd_admin_subtle_message(M)
			. = TRUE

		if("view_variables")
			C.debug_variables(locate(params["view_variables"]))
			. = TRUE

		if("notes")
			var/ckey = params["ckey"]
			if(!ckey)
				var/mob/M = locate(params["mob"])
				if(ismob(M))
					ckey = M.ckey

			C.holder.show_player_info(ckey)
			. = TRUE

		if("traitor_panel")
			if(!check_rights(R_ADMIN|R_MOD))
				return

			if(!ROUND_IS_STARTED)
				alert("The game hasn't started yet!")
				return

			var/mob/M = locate(params["traitor_panel"])
			if(!ismob(M))
				to_chat(usr, SPAN_WARNING("This can only be used on mobs."))
				return
			C.holder.show_traitor_panel(M)
			. = TRUE

		if("jump_to")
			if(!check_rights(R_MOD|R_ADMIN))
				return

			var/mob/M = locate(params["jump_to"])

			if(!isobserver(usr))
				C.admin_ghost()
			sleep(2)
			C.jumptomob(M)
			. = TRUE

		if("wind")
			var/mob/M = locate(params["wind"])
			if(!ismob(M))
				to_chat(usr, SPAN_WARNING("This can only be used on mobs."))
				return

			C.holder.paralyze_mob(M)
			. = TRUE

/datum/tgui_module/player_panel/proc/GetMobRealName(var/mob/M)
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
