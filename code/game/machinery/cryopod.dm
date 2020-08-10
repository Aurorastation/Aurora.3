/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

var/global/list/frozen_crew = list()

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon_state = "altcomputerw"
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = FALSE
	interact_offline = TRUE

	icon_screen = "cryo"
	icon_scanline = "altcomputerw-scanline"
	light_color = LIGHT_COLOR_GREEN

	var/mode = null

	var/list/frozen_items = list()

	var/storage_type = "Crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = TRUE

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems"
	icon_state = "altcomputerw"
	circuit = /obj/item/circuitboard/robotstoragecontrol

	icon_screen = "cryo_robot"
	light_color = LIGHT_COLOR_PURPLE

	storage_type = "Cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = FALSE

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if(!(ROUND_IS_STARTED))
		return

	dat += "<hr><b>[storage_name]</b><br>"
	dat += "<i>Welcome, [user.real_name].</i><br><hr><br>"
	dat += "<a href='?src=\ref[src];log=1'>View Storage Log</a><br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View Objects</a><br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover Object</a><br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover All Objects</a><br>"

	var/datum/browser/cryocon_win = new(user, "cryopod_console", "Cryogenic Oversight Console")
	cryocon_win.set_content(dat)
	cryocon_win.open()

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])
		if(!length(frozen_crew))
			to_chat(user, SPAN_WARNING("Nothing has been stored recently."))
			return
		var/dat = "<center><b>Recently Stored [storage_type]</b></center><hr>"
		for(var/person in frozen_crew)
			dat += " - [person]<br>"
		dat += "<hr>"

		var/datum/browser/cryolog_win = new(user, "cryolog", "Cryogenic Storage Log")
		cryolog_win.set_content(dat)
		cryolog_win.open()

	if(href_list["view"])
		if(!allow_items)
			return
		if(!length(frozen_items))
			to_chat(user, SPAN_WARNING("There are no stored objects."))
			return

		var/dat = "<center><b>Recently Stored Objects</b></center><br><hr>"
		for(var/obj/item/I in frozen_items)
			dat += " - [I.name]<br>"
		dat += "<hr>"

		var/datum/browser/cryoitems_win = new(user, "cryoitems", "Cryogenic Storage Log")
		cryoitems_win.set_content(dat)
		cryoitems_win.open()

	else if(href_list["item"])
		if(!allow_items)
			return

		if(frozen_items.len <= 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		var/obj/item/I = input(user, "Please choose which object to retrieve.", "Object recovery", null) as null|anything in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			to_chat(user, SPAN_WARNING("\The [I] is no longer in storage."))
			return

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges \the [I]."), range = 3)

		I.forceMove(get_turf(src))
		if(Adjacent(user))
			user.put_in_hands(I)
		frozen_items -= I
		log_and_message_admins("has retrieved \an [I] from \the [src]", user, get_turf(src))

	else if(href_list["allitems"])
		if(!allow_items)
			return

		if(frozen_items.len <= 0)
			to_chat(user, SPAN_WARNING("There is nothing to recover from storage."))
			return

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges the desired objects."), range = 3)

		for(var/obj/item/I in frozen_items)
			I.forceMove(get_turf(src))
			frozen_items -= I
		log_and_message_admins("has retrieved all the items from \the [src]", user, get_turf(src))

	src.updateUsrDialog()
	return

/obj/item/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = /obj/machinery/computer/cryopod/robot
	origin_tech = list(TECH_DATA = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed
	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE
	dir = WEST

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scanner"
	density = TRUE
	anchored = TRUE
	dir = WEST

	var/base_icon_state = "body_scanner"
	var/occupied_icon_state = "body_scanner-closed"
	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant					// Person waiting to be despawned.
	var/time_till_despawn = 1200		// Two minute safe period before being despawned.
	var/time_till_force_cryo = 3000		// Five minutes safe period until they're despawned even if active.
	var/time_entered = 0				// Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0

	// These items are preserved when the process() despawn proc occurs.
	var/list/items_blacklist = list(
		/obj/item/organ,
		/obj/item/implant,
		/obj/item/card/id,
		/obj/item/modular_computer,
		/obj/item/device/pda,
		/obj/item/cartridge,
		/obj/item/device/radio/headset,
		/obj/item/device/encryptionkey
	)

	//For subtypes of the blacklist that are allowed to be kept
	var/list/items_whitelist = list(
		/obj/item/card/id/captains_spare
		)

/obj/machinery/cryopod/robot
	name = "robotic storage unit"
	desc = "A storage unit for robots."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "pod"
	base_icon_state = "pod"
	occupied_icon_state = "pod-closed"
	on_store_message = "has entered robotic storage."
	on_store_name = "Robotic Storage Oversight"
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)
	disallow_occupant_types = list(/mob/living/silicon/robot/drone)

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant.resting = TRUE
	return ..()

/obj/machinery/cryopod/Initialize()
	. = ..()

	icon_state = base_icon_state
	find_control_computer()

/obj/machinery/cryopod/examine(mob/user)
	..(user)
	if(occupant)
		to_chat(user, SPAN_NOTICE("<b>[occupant]</b> [gender_datums[occupant.gender].is] inside \the [src]."))

/obj/machinery/cryopod/can_hold_dropped_items()
	return FALSE

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	for(var/obj/machinery/computer/cryopod/C in get_area(src))
		control_computer = C
		break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [src.loc.loc] could not find control computer!")
		message_admins("Cryopod in [src.loc.loc] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = FALSE
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = TRUE
			break

	if(!correct_type)
		return FALSE

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return FALSE

	return TRUE

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/machinery_process()
	if(occupant)
		//Allow a two minute gap between entering the pod and actually despawning.
		if((world.time - time_entered < time_till_despawn) && occupant.ckey)
			return
		if(!control_computer)
			if(!find_control_computer(urgent=1))
				return

		if(!occupant.client && occupant.stat != DEAD) //Occupant is living and has no client.
			despawn_occupant()

		else if(world.time - time_entered > time_till_force_cryo)
			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/robot/despawn_occupant()
	var/mob/living/silicon/robot/R = occupant
	if(!istype(R))
		return ..()

	qdel(R.mmi)
	for(var/obj/item/I in R.module) // the tools the borg has; metal, glass, guns etc
		for(var/obj/item/O in I) // the things inside the tools, if anything; mainly for janiborg trash bags
			O.forceMove(R)
		qdel(I)
	qdel(R.module)

	return ..()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	var/list/items = occupant.get_contents()
	var/turf/T = get_turf(src)
	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.drop_from_inventory(W, src)
	//Prepare items tnat require modification before dropping
	for(var/obj/item/W in items)
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				brain.forceMove(T)
				items -= brain
				continue

		else if(istype(W, /obj/item/rig))
			var/obj/item/rig/R = W
			R.open = FALSE
			R.locked = TRUE
			R.offline = TRUE
			R.sealing = FALSE
			R.canremove = TRUE

		if(!is_type_in_list(W, items_whitelist) && is_type_in_list(W, items_blacklist))
			items.Remove(W)
			qdel(W)

	for(var/obj/item/W in items)
		if(W.loc == src)
			if(control_computer?.allow_items)
				control_computer.frozen_items += W
				W.forceMove(control_computer)
			else
				W.forceMove(T)

	global_announcer.autosay("[occupant.real_name], [occupant.mind.role_alt_title], [on_store_message]", "[on_store_name]")
	visible_message(SPAN_NOTICE("\The [src] hums and hisses as it moves [occupant] into storage."))
	frozen_crew += occupant

	// Let SSjobs handle the rest.
	SSjobs.DespawnMob(occupant)
	occupant = null
	update_icon()

/obj/machinery/cryopod/attackby(var/obj/item/grab/G, var/mob/user)
	if(istype(G))
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is in use."))
			return
		if(!ismob(G.affecting))
			return
		if(!check_occupant_allowed(G.affecting))
			return

		var/willing = FALSE //We don't want to allow people to be forced into despawning.
		var/mob/M = G.affecting

		if(M.client)
			var/original_loc = M.loc
			if(alert(M, "Would you like to enter long-term storage?", , "Yes", "No") == "Yes")
				if(!M || !G || !G.affecting || M.loc != original_loc)
					return
				willing = TRUE
		else
			willing = TRUE

		if(willing)
			user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [G.affecting] into \the [src]."), SPAN_NOTICE("You start putting [G.affecting] into [src]."), range = 3)

			if(do_after(user, 20))
				if(!M || !G || !G.affecting)
					return

				M.forceMove(src)

				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src

			update_icon()
			to_chat(M, SPAN_NOTICE("[on_enter_occupant_message]"))
			to_chat(M, SPAN_DANGER("Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))
			set_occupant(M)

			if(isipc(M))
				save_ipc_tag(M)

			// Book keeping!
			var/turf/location = get_turf(src)
			log_admin("[key_name_admin(M)] has entered a stasis pod. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)",ckey=key_name(M))
			message_admins("<span class='notice'>[key_name_admin(M)] has entered a stasis pod.</span>")

			//Despawning occurs when process() is called with an occupant without a client.
			src.add_fingerprint(M)

/obj/machinery/cryopod/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(user))
		return
	if(!check_occupant_allowed(O))
		return
	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is in use."))
		return

	var/mob/living/L = O

	if(!L.bucklecheck(user)) //We must make sure the person is unbuckled before they go in
		return

	if(L.stat == DEAD)
		to_chat(user, SPAN_WARNING("Dead people can not be put into stasis."))
		return
	for(var/mob/living/carbon/slime/M in range(1, L))
		if(M.victim == L)
			to_chat(usr, SPAN_WARNING("[L.name] will not fit into the cryo pod because they have a slime latched onto their head."))
			return

	var/willing = FALSE //We don't want to allow people to be forced into despawning.

	if(L.client)
		var/original_loc = L.loc
		if(alert(L, "Would you like to enter stasis?", , "Yes", "No") == "Yes")
			if(!L || L.loc != original_loc)
				return
			willing = TRUE
	else
		willing = TRUE

	if(willing)
		if(L == user)
			user.visible_message(SPAN_NOTICE("\The [user] starts climbing into \the [src]."), SPAN_NOTICE("You start climbing into \the [src]."), range = 3)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [L] into \the [src]."), SPAN_NOTICE("You start putting \the [L] into \the [src]."), range = 3)

		if(do_after(user, 20))
			if(!L)
				return

			L.forceMove(src)

			if(L.client)
				L.client.perspective = EYE_PERSPECTIVE
				L.client.eye = src
		else
			to_chat(user, SPAN_NOTICE("You stop [L == user ? "climbing into" : "putting [L] into"] \the [name]."))
			return

		to_chat(L, SPAN_NOTICE("You feel cool air surround you. You go numb as your senses turn inward."))
		to_chat(L, SPAN_DANGER("Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))
		set_occupant(L)
		update_icon()

		if(isipc(L))
			save_ipc_tag(L)

		// Book keeping!
		var/turf/location = get_turf(src)
		log_admin("[key_name_admin(L)] has entered a stasis pod.",ckey=key_name(L))
		message_admins("<span class='notice'>[key_name_admin(L)] has entered a stasis pod.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)</span>")

		//Despawning occurs when process() is called with an occupant without a client.
		src.add_fingerprint(L)

	return

/obj/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(use_check_and_message(usr))
		return

	//Eject any items that aren't meant to be in the pod.
	var/list/items = src.contents
	if(occupant)
		items -= occupant
	if(announce)
		items -= announce

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))

	src.go_out()
	add_fingerprint(usr)
	name = initial(name)
	update_icon()

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr) || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		to_chat(usr, SPAN_WARNING("\The [src] is in use."))
		return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.victim == usr)
			to_chat(usr, SPAN_WARNING("You cannot do this while a slime is latched onto you!"))
			return

	usr.visible_message(SPAN_NOTICE("[usr] starts climbing into [src]."), SPAN_NOTICE("You start climbing into [src]."), range = 3)

	if(do_after(usr, 20))
		if(!usr || !usr.client)
			return

		if(occupant)
			to_chat(usr, SPAN_WARNING("\The [src] is in use."))
			return

		set_occupant(usr)

		update_icon()

		to_chat(usr, SPAN_NOTICE("[on_enter_occupant_message]"))
		to_chat(usr, SPAN_DANGER("Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))

		if(isipc(usr))
			var/choice = alert(usr, "Would you like to save your tag data?", "Tag Persistence", "Yes", "No")
			if(choice == "Yes")
				var/mob/living/carbon/human/H = usr
				var/obj/item/organ/internal/ipc_tag/tag = H.organs_by_name[BP_IPCTAG]
				if(tag)
					H.client.prefs.machine_ownership_status = tag.ownership_info
					H.client.prefs.machine_serial_number = tag.serial_number
					H.client.prefs.citizenship = tag.citizenship_info
					H.client.prefs.machine_tag_status = TRUE
				else if(isnull(tag) || !tag)
					H.client.prefs.machine_tag_status = FALSE
				H.client.prefs.save_character()
				H.client.prefs.save_preferences()
		src.add_fingerprint(usr)

/obj/machinery/cryopod/proc/go_out()
	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	occupant = null
	update_icon()

/obj/machinery/cryopod/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	occupant.forceMove(src)
	occupant.stop_pulling()
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
		time_entered = world.time
	update_icon()

/obj/machinery/cryopod/update_icon()
	if(occupant)
		name = "[name] ([occupant])"
		icon_state = occupied_icon_state
	else
		icon_state = base_icon_state
		name = initial(name)

/obj/machinery/cryopod/relaymove(var/mob/user)
	go_out()

/obj/machinery/cryopod/proc/save_ipc_tag(var/mob/M)
	var/choice = alert(M, "Would you like to save your tag data?", "Tag Persistence", "Yes", "No")
	if(choice == "Yes")
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(tag)
			M.client.prefs.machine_ownership_status = tag.ownership_info
			M.client.prefs.machine_serial_number = tag.serial_number
			M.client.prefs.citizenship = tag.citizenship_info
			M.client.prefs.machine_tag_status = TRUE
		else if(isnull(tag) || !tag)
			M.client.prefs.machine_tag_status = FALSE
		M.client.prefs.save_character()
		M.client.prefs.save_preferences()