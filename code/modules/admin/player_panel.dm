/datum/tgui_module/moderator/shared/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/C = usr.client
	if(!C || !C.holder)
		return

	switch(action)
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

			if(!isghost(usr))
				C.admin_ghost()
			sleep(2)
			C.jumptomob(M)
			. = TRUE

		if("show_player_panel")
			var/mob/M = locate(params["show_player_panel"])
			C.holder.show_player_panel(M)
			. = TRUE

/datum/tgui_module/moderator/shared/check_antagonists

/datum/tgui_module/moderator/shared/check_antagonists/ui_interact(mob/user, datum/tgui/ui)
	if (!SSticker || SSticker.current_state < GAME_STATE_PLAYING)
		alert(user, "The game hasn't started yet!")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoundStatus", "Round Status", 400, 500)
		ui.open()

/datum/tgui_module/moderator/shared/check_antagonists/ui_data(mob/user)
	var/list/data = list()
	data["gamemode"] = SSticker.mode.name
	data["round_duration"] = get_round_duration_formatted()
	data["evacuation_is_idle"] = GLOB.evacuation_controller.is_idle()
	data["time_left"] = GLOB.evacuation_controller.get_eta()
	data["waiting_to_leave"] = GLOB.evacuation_controller.waiting_to_leave()
	data["round_delayed"] = SSticker.delay_end
	data["antagonists"] = list()
	data["antagonist_types"] = list()
	for(var/antag_type in GLOB.all_antag_types)
		var/datum/antagonist/A = GLOB.all_antag_types[antag_type]
		for(var/datum/mind/mind in A.current_antagonists)
			var/mob/M = mind.current
			data["antagonists"] += list(list(
				"role" = A.role_text_plural,
				"name" = M ? M.real_name : null,
				"stat" = M ? M.stat : null,
				"ref" = REF(M)
			))
			data["antagonist_types"] |= A.role_text_plural
		if(A.flags & ANTAG_HAS_NUKE)
			data["nuke_disks"] = list()
			for(var/obj/item/disk/nuclear/N in GLOB.nuke_disks)
				var/turf/T = get_turf(N)
				var/location_name
				if(ismob(N.loc))
					var/mob/L = N.loc
					location_name = L.real_name
				else
					location_name = N.loc ? N.loc.name : null
				data["nuke_disks"] += list(list(
					"location_name" = location_name,
					"x" = T.x,
					"y" = T.y,
					"z" = T.z,
				))
	return data

/datum/tgui_module/moderator/shared/check_antagonists/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/C = usr.client
	if(!C || !C.holder)
		return

	switch(action)
		if("call_shuttle")
			if(!check_rights(R_ADMIN))
				return
			switch(params["call_shuttle"])
				if("1")
					if (GLOB.evacuation_controller.call_evacuation(usr, TRUE))
						log_admin("[key_name(usr)] called an evacuation.")
						message_admins("[key_name_admin(usr)] called an evacuation.", 1)
						. = TRUE

				if("2")
					if (GLOB.evacuation_controller.call_evacuation(usr, TRUE))
						log_admin("[key_name(usr)] called an evacuation.")
						message_admins("[key_name_admin(usr)] called an evacuation.", 1)
					else if (GLOB.evacuation_controller.cancel_evacuation())
						log_admin("[key_name(usr)] cancelled an evacuation.")
						message_admins("[key_name_admin(usr)] cancelled an evacuation.", 1)
						. = TRUE

/datum/tgui_module/moderator/shared/player_panel

/datum/tgui_module/moderator/shared/player_panel/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerPanel", "Player Panel", 800, 600)
		ui.open()

/datum/tgui_module/moderator/shared/player_panel/ui_data(mob/user)
	var/list/data = list()
	var/isMod = check_rights(R_MOD|R_ADMIN, 0, user)
	data["holder_ref"] = "[REF(user.client.holder)]"
	data["is_mod"] = isMod

	var/list/mobs = sortmobs()

	data["players"] = list()

	for(var/mob/M in mobs)
		var/ref = "[REF(M)]"
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

/datum/tgui_module/moderator/shared/player_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/C = usr.client
	if(!C || !C.holder)
		return

	switch(action)
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

		if("wind")
			var/mob/M = locate(params["wind"])
			if(!ismob(M))
				to_chat(usr, SPAN_WARNING("This can only be used on mobs."))
				return

			C.holder.paralyze_mob(M)
			. = TRUE

/datum/tgui_module/moderator/shared/player_panel/proc/GetMobRealName(var/mob/M)
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
	if(isstoryteller(M))
		return "Storyteller"
	return "Unknown"
