/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG|R_DEV))	return

	if(GLOB.Debug2)
		GLOB.Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		GLOB.Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	switch(alert("Do you want to print all logs to world? This should ONLY EVER HAPPEN IN CRISIS OR DURING DEBUGGING / DEVELOPMENT.", "All logs to world?", "No", "Yes"))
		if("Yes")
			GLOB.config.all_logs_to_chat = 1
		else
			GLOB.config.all_logs_to_chat = 0

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/DebugToggle()
	set category = "Debug"
	set name = "Debugs Toggle"
	if(!check_rights(R_DEBUG|R_DEV))	return

	var/target = input(usr, "Select which log to toggle", "Debugs Toggle", null) in sortAssoc(GLOB.config.logsettings)
	if(target)
		GLOB.config.logsettings[target] = !GLOB.config.logsettings[target]
		to_chat(usr, "The log category [target] is now [GLOB.config.logsettings[target]]")

/client/proc/DebugToggleAll()
	set category = "Debug"
	set name = "Debugs Toggle ALL"
	if(!check_rights(R_DEBUG|R_DEV))	return

	switch(alert("Do you want to turn on ALL LOGS?.", "All logs to ON?", "No", "Yes"))
		if("Yes")
			for(var/k in GLOB.config.logsettings)
				GLOB.config.logsettings[k] = TRUE

// callproc moved to code/modules/admin/callproc


/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = get_turf(mob)

	if (!istype(T))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = SPAN_NOTICE("Coordinates: [T.x],[T.y],[T.z]\n")
	t += SPAN_WARNING("Temperature: [env.temperature]\n")
	t += SPAN_WARNING("Pressure: [env.return_pressure()]kPa\n")
	for(var/g in env.gas)
		t += SPAN_NOTICE("[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n")

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		log_admin("[key_name(src)] has robotized [H.key].")
		H.Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/abstract/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()


/client/proc/cmd_admin_slimeize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make slime"

	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		log_and_message_admins("has slimeized [key_name(H)].", user = usr)
		H.slimeize()
		feedback_add_details("admin_verb","MKMET") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Invalid mob")

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/abstract, /mob/abstract/ghost/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(/obj) + typesof(/mob) - blocked
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O, TRUE)
				CHECK_TICK
		log_and_message_admins("has deleted all instances of [hsbitem].")
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Make Powernets"
	SSmachinery.makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Grant Full Access"

	if (!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (H.GetIdCard())
			var/obj/item/card/id/id = H.GetIdCard()
			id.icon_state = "gold"
			id.access = get_all_accesses()
		else
			var/obj/item/card/id/id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id.access = get_all_accesses()
			id.registered_name = H.real_name
			id.assignment = "Captain"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, slot_wear_id)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] full access."), 1)

/client/proc/cmd_assume_direct_control(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN|R_DEV|R_FUN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/abstract/ghost/observer/ghost = new/mob/abstract/ghost/observer(M,1)
			ghost.ckey = M.ckey
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] assumed direct control of [M]."), 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!






/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in world)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in world)
		var/area/A = get_area(APC)
		if(!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/alarm/alarm in world)
		var/area/A = get_area(alarm)
		if(!(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in world)
		var/area/A = get_area(RC)
		if(!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in world)
		var/area/A = get_area(L)
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in world)
		var/area/A = get_area(LS)
		if(!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/device/radio/intercom/I in world)
		var/area/A = get_area(I)
		if(!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in world)
		var/area/A = get_area(C)
		if(!(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	to_world("<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A REQUESTS CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A AREA_USAGE_LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		to_world("* [areatype]")

/client/proc/cmd_admin_grab_observers()
	set category = "Fun"
	set name = "Grab Observers"
	set desc = "Grabs players that are observing and spawns them as basic humans beneath your feet."

	var/list/chosen_observers = list()
	var/next_observer = "NotGeeves"
	while(next_observer)
		var/list/valid_choices = GLOB.player_list.Copy()
		for(var/choice in valid_choices)
			if(choice in chosen_observers)
				valid_choices -= choice
			if(!isobserver(choice))
				valid_choices -= choice
		next_observer = input("Choose an observer you want to add to the list.", "Choose Observer") as null|anything in valid_choices
		if(next_observer)
			chosen_observers += next_observer

	for(var/spawn_observer in chosen_observers)
		var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(usr))
		do_dressing(H)
		var/mob/abstract/ghost/observer/O = spawn_observer
		H.ckey = O.ckey
		qdel(O)

/client/proc/cmd_admin_dress(mob/living/carbon/human/H in GLOB.human_mob_list)
	set category = "Fun"
	set name = "Set Human Outfit"

	if(!check_rights(R_FUN))
		return
	do_dressing(H)

/proc/do_dressing(var/mob/living/carbon/human/M = null)
	if(!M || !istype(M))
		M = tgui_input_list(usr, "Select a mob you would like to dress.", "Set Human Outfit", GLOB.human_mob_list)
	if(!M)
		return


	var/chosen_outfit = tgui_input_list(usr, "Select an outfit.", "Set Human Outfit", GLOB.outfit_cache)
	if(isnull(chosen_outfit))
		return

	feedback_add_details("admin_verb","SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

	var/obj/outfit/O = GLOB.outfit_cache[chosen_outfit]
	if(O)
		for(var/obj/item/I in M)
			if(istype(I, /obj/item/implant))
				continue
			M.drop_from_inventory(I)
			if(I.loc != M)
				qdel(I)
		M.preEquipOutfit(O, FALSE)
		M.equipOutfit(O, FALSE)

	M.regenerate_icons()

	log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [chosen_outfit].")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [chosen_outfit]."), 1)
	return

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Staff","Mobs","Living Mobs","Dead Mobs","Frozen Mobs","Clients"))
		if("Players")
			to_chat(usr, jointext(GLOB.player_list,", "))
		if("Staff")
			to_chat(usr, jointext(GLOB.staff,", "))
		if("Mobs")
			to_chat(usr, jointext(GLOB.mob_list,", "))
		if("Living Mobs")
			to_chat(usr, jointext(GLOB.living_mob_list,", "))
		if("Dead Mobs")
			to_chat(usr, jointext(GLOB.dead_mob_list,", "))
		if("Clients")
			to_chat(usr, jointext(GLOB.clients,", "))

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.update_mutations()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")

/client/proc/cmd_display_del_log()
	set category = "Debug"
	set name = "Display del() Log"
	set desc = "Display del's log of everything that's passed through it."

	var/list/dellog = list("<B>List of things that have gone through qdel this round</B><BR><BR><ol>")
	sortTim(SSgarbage.items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if (I.qdel_flags & QDEL_ITEM_SUSPENDED_FOR_LAG)
			dellog += "<li>SUSPENDED FOR LAG</li>"
		if (I.failures)
			dellog += "<li>Failures: [I.failures]</li>"
		dellog += "<li>qdel() Count: [I.qdels]</li>"
		dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
		if (I.hard_deletes)
			dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
			dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
			dellog += "<li>Highest Time Spent Hard Deleting: [I.hard_delete_max]ms</li>"
			if (I.hard_deletes_over_threshold)
				dellog += "<li>Hard Deletes Over Threshold: [I.hard_deletes_over_threshold]</li>"
		if (I.slept_destroy)
			dellog += "<li>Sleeps: [I.slept_destroy]</li>"
		if (I.no_respect_force)
			dellog += "<li>Ignored force: [I.no_respect_force]</li>"
		if (I.no_hint)
			dellog += "<li>No hint: [I.no_hint]</li>"
		if(LAZYLEN(I.extra_details))
			var/details = I.extra_details.Join("</li><li>")
			dellog += "<li>Extra Info: <ul><li>[details]</li></ul>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=dellog")

/**
 * Same as `cmd_display_del_log`, but only shows harddels
 */
/client/proc/cmd_display_harddel_log()
	set category = "Debug"
	set name = "Display harddel() Log"
	set desc = "Display harddel's log."

	var/list/dellog = list("<B>List of things that have harddel'd this round</B><BR><BR><ol>")
	sortTim(SSgarbage.items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		if(I.hard_deletes)
			dellog += "<li><u>[path]</u><ul>"
			if (I.qdel_flags & QDEL_ITEM_SUSPENDED_FOR_LAG)
				dellog += "<li>SUSPENDED FOR LAG</li>"
			if (I.failures)
				dellog += "<li>Failures: [I.failures]</li>"
			dellog += "<li>qdel() Count: [I.qdels]</li>"
			dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
			if (I.hard_deletes)
				dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
				dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
				dellog += "<li>Highest Time Spent Hard Deleting: [I.hard_delete_max]ms</li>"
				if (I.hard_deletes_over_threshold)
					dellog += "<li>Hard Deletes Over Threshold: [I.hard_deletes_over_threshold]</li>"
			if (I.slept_destroy)
				dellog += "<li>Sleeps: [I.slept_destroy]</li>"
			if (I.no_respect_force)
				dellog += "<li>Ignored force: [I.no_respect_force]</li>"
			if (I.no_hint)
				dellog += "<li>No hint: [I.no_hint]</li>"
			if(LAZYLEN(I.extra_details))
				var/details = I.extra_details.Join("</li><li>")
				dellog += "<li>Extra Info: <ul><li>[details]</li></ul>"
			dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=harddellog")

/client/proc/cmd_display_init_log()
	set category = "Debug"
	set name = "Display Initialize() Log"
	set desc = "Displays a list of things that didn't handle Initialize() properly"

	usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

/client/proc/reload_nanoui_resources()
	set category = "Debug"
	set name = "Reload NanoUI Resources"
	set desc = "Force the client to redownload NanoUI Resources"

	// Close open NanoUIs.
	SSnanoui.close_user_uis(usr)

	// Re-load the assets.
	var/datum/asset/assets = get_asset_datum(/datum/asset/nanoui)
	assets.register()

	// Clear the user's cache so they get resent.
	usr.client.sent_assets = list()

/**
 * Used to generate lag and load the MC to test how things work under live server stress
 */
/client/proc/cmd_generate_lag()
	set name = "Generate Lag"
	set category = "Debug"
	set desc = "Generate lag, to be used for LOCAL TESTS ONLY"

	var/mollyguard = tgui_alert(src, "This is to be used only on local instances, DO NOT USE IT ON LIVE, YOU CANNOT UNDO THIS, do you understand?", "Molly Guard", list("No", "Yes"))

	if(mollyguard != "Yes")
		return

	var/tick_offenses = tgui_input_number(src, "Tick usage offset from 100?", "Tick Offset", 0, min_value = -100, round_value=TRUE)
	var/jitter = tgui_input_number(src, "What jitter should be applied?", "Jitter", 0, min_value = 0, round_value=TRUE)

	while(TRUE)
		var/jitter_this_run = rand(0, jitter)
		for(var/atom/an_atom in world)
			if(world.tick_usage > (100+(tick_offenses+jitter_this_run)))
				stoplag()
