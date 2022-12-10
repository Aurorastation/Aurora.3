/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG|R_DEV))	return

	if(Debug2)
		Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.",admin_key=key_name(usr))
	else
		Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.",admin_key=key_name(usr))

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// callproc moved to code/modules/admin/callproc


/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<span class='notice'>Coordinates: [T.x],[T.y],[T.z]\n</span>"
	t += "<span class='warning'>Temperature: [env.temperature]\n</span>"
	t += "<span class='warning'>Pressure: [env.return_pressure()]kPa\n</span>"
	for(var/g in env.gas)
		t += "<span class='notice'>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n</span>"

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].",admin_key=key_name(usr),ckey=key_name(M))
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in mob_list)
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

	log_admin("[key_name(src)] has animalized [M.key].",admin_key=key_name(usr),ckey=key_name(M))
	spawn(10)
		M.Animalize()


/client/proc/cmd_admin_slimeize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make slime"

	if(!ROUND_IS_STARTED)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_and_message_admins("has slimeized [key_name(M)].", user = usr)
		spawn(10)
			M:slimeize()
			feedback_add_details("admin_verb","MKMET") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Invalid mob")

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/abstract, /mob/abstract/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
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
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.",admin_key=key_name(usr))
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].",admin_key=key_name(usr))
	message_admins("[key_name_admin(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in mob_list)
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
	log_admin("[key_name(src)] has granted [M.key] full access.",admin_key=key_name(usr),ckey=key_name(M))
	message_admins("<span class='notice'>[key_name_admin(usr)] has granted [M.key] full access.</span>", 1)

/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN|R_DEV|R_FUN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/abstract/observer/ghost = new/mob/abstract/observer(M,1)
			ghost.ckey = M.ckey
	message_admins("<span class='notice'>[key_name_admin(usr)] assumed direct control of [M].</span>", 1)
	log_admin("[key_name(usr)] assumed direct control of [M].",admin_key=key_name(usr))
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

	to_world("<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
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
		var/list/valid_choices = player_list.Copy()
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
		var/mob/abstract/observer/O = spawn_observer
		H.ckey = O.ckey
		qdel(O)

/client/proc/cmd_admin_dress(mob/living/carbon/human/H in human_mob_list)
	set category = "Fun"
	set name = "Set Human Outfit"

	if(!check_rights(R_FUN))
		return
	do_dressing(H)

/client/proc/do_dressing(var/mob/living/carbon/human/M = null)
	if(!M || !istype(M))
		M = input("Select a mob you would like to dress.", "Set Human Outfit") as null|anything in human_mob_list
	if(!M)
		return

	var/list/outfit_catagories = list()
	switch(alert("Would you like ERT outfits, or standard admin outfits?", "ERT-or-Admin?", "ERT", "Admin", "Cancel"))
		if("Cancel")
			return
		if("ERT")
			outfit_catagories["NT-ERT"] = typesof(/datum/outfit/admin/ert/nanotrasen)
			outfit_catagories["Deathsquad"] = typesof(/datum/outfit/admin/deathsquad)
			outfit_catagories["TCFL"] = typesof(/datum/outfit/admin/ert/legion)
			outfit_catagories["Syndicate"] = typesof(/datum/outfit/admin/deathsquad/syndicate)
			outfit_catagories["Freelance Mercenaries"] = typesof(/datum/outfit/admin/ert/mercenary)
			outfit_catagories["Free Solarian Fleets Marines"] = typesof(/datum/outfit/admin/ert/fsf)
			outfit_catagories["Kataphracts"] = typesof(/datum/outfit/admin/ert/kataphract)
			outfit_catagories["Eridani"] = typesof(/datum/outfit/admin/ert/ap_eridani)
			outfit_catagories["IAC"] = typesof(/datum/outfit/admin/ert/iac)
			outfit_catagories["Kosmostrelki"] = typesof(/datum/outfit/admin/ert/pra_cosmonaut)
			outfit_catagories["Elyran Navy"] = typesof(/datum/outfit/admin/ert/elyran_trooper)
		if("Admin")
			outfit_catagories["Stellar Corporate Conglomerate"] = typesof(/datum/outfit/admin/scc)
			outfit_catagories["NanoTrasen"] = typesof(/datum/outfit/admin/nt)
			outfit_catagories["Antagonist"] = typesof(/datum/outfit/admin/syndicate)
			outfit_catagories["Event"] = typesof(/datum/outfit/admin/event)
			outfit_catagories["TCFL"] = typesof(/datum/outfit/admin/tcfl)
			outfit_catagories["Killers"] = typesof(/datum/outfit/admin/killer)
			outfit_catagories["Job"] = subtypesof(/datum/outfit/job)
			outfit_catagories["Megacorps"] = subtypesof(/datum/outfit/admin/megacorp)
			outfit_catagories["Pod Survivors"] = subtypesof(/datum/outfit/admin/pod)
			outfit_catagories["Miscellaneous"] = typesof(/datum/outfit/admin/random)
			outfit_catagories["Miscellaneous"] += /datum/outfit/admin/random_employee

	var/chosen_catagory = input("Select an outfit catagory.", "Robust Quick-dress Shop") as null|anything in outfit_catagories
	if(isnull(chosen_catagory))
		return

	var/list/outfit_types = list()
	for(var/outfit in outfit_catagories[chosen_catagory])
		var/datum/outfit/admin/A = new outfit
		outfit_types[A.name] = A

	var/chosen_outfit = input("Select an outfit.", "Robust Quick-dress Shop") as null|anything in outfit_types
	if(isnull(chosen_outfit))
		return

	feedback_add_details("admin_verb","SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

	var/datum/outfit/O = outfit_types[chosen_outfit]
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

	log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [chosen_outfit].",admin_key=key_name(usr),ckey=key_name(M))
	message_admins("<span class='notice'>[key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [chosen_outfit].</span>", 1)
	return

/client/proc/startSinglo()

	set category = "Debug"
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing through the station"

	if(alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Yes","No") != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in world)
		if(E.anchored)
			E.active = 1

	for(var/obj/machinery/field_generator/F in world)
		if(F.anchored)
			F.Varedit_start = 1
	spawn(30)
		for(var/obj/machinery/the_singularitygen/G in world)
			if(G.anchored)
				var/obj/singularity/S = new /obj/singularity(get_turf(G), 50)
				spawn(0)
					qdel(G)
				S.energy = 1750
				S.current_size = 7
				S.icon = 'icons/effects/224x224.dmi'
				S.icon_state = "singularity_s7"
				S.pixel_x = -96
				S.pixel_y = -96
				S.grav_pull = 0
				//S.consume_range = 3
				S.dissipate = 0
				//S.dissipate_delay = 10
				//S.dissipate_track = 0
				//S.dissipate_strength = 10

	for(var/obj/machinery/power/rad_collector/Rad in world)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)
				Phoron.air_contents.gas[GAS_PHORON] = 70
				Rad.drainratio = 0
				Rad.P = Phoron
				Phoron.forceMove(Rad)

			if(!Rad.active)
				Rad.toggle_power()

	for(var/obj/machinery/power/smes/SMES in world)
		if(SMES.anchored)
			SMES.input_attempt = 1

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Staff","Mobs","Living Mobs","Dead Mobs","Frozen Mobs","Clients"))
		if("Players")
			to_chat(usr, jointext(player_list,", "))
		if("Staff")
			to_chat(usr, jointext(staff,", "))
		if("Mobs")
			to_chat(usr, jointext(mob_list,", "))
		if("Living Mobs")
			to_chat(usr, jointext(living_mob_list,", "))
		if("Dead Mobs")
			to_chat(usr, jointext(dead_mob_list,", "))
		if("Frozen Mobs")
			to_chat(usr, jointext(frozen_crew,", "))
		if("Clients")
			to_chat(usr, jointext(clients,", "))

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
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!",admin_key=key_name(src),ckey=key_name(M))
	else
		alert("Invalid mob")

/client/proc/cmd_display_del_log()
	set category = "Debug"
	set name = "Display del() Log"
	set desc = "Displays a list of things that have failed to GC this round"

	var/dat = "<B>List of things that failed to GC this round</B><BR><BR>"
	for(var/path in SSgarbage.didntgc)
		dat += "[path] - [SSgarbage.didntgc[path]] times<BR>"

	dat += "<B>List of paths that did not return a qdel hint in Destroy()</B><BR><BR>"
	for(var/path in SSgarbage.noqdelhint)
		dat += "[path]<BR>"

	dat += "<B>List of paths that slept in Destroy()</B><BR><BR>"
	for(var/path in SSgarbage.sleptDestroy)
		dat += "[path]<BR>"

	usr << browse(dat, "window=dellog")

/client/proc/cmd_display_init_log()
	set category = "Debug"
	set name = "Display Initialize() Log"
	set desc = "Displays a list of things that didn't handle Initialize() properly"

	usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")
