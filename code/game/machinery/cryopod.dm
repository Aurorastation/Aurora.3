/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

GLOBAL_LIST_EMPTY(frozen_crew)

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/computer.dmi'
	icon_state = "altcomputerw"
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = FALSE
	interact_offline = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall

	icon_screen = "cryo"
	icon_scanline = "altcomputerw-scanline"
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

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

/obj/machinery/computer/cryopod/living_quarters
	name = "living quarters oversight console"
	desc = "An interface between the main ship and the living quarters where the crew lives."
	circuit = /obj/item/circuitboard/living_quarters_cryo

	storage_name = "Living Quarters Oversight Control"
	allow_items = TRUE

/obj/machinery/computer/cryopod/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	src.attack_hand(user)

/obj/machinery/computer/cryopod/attack_hand(mob/user)
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
		if(!length(GLOB.frozen_crew))
			to_chat(user, SPAN_WARNING("Nothing has been stored recently."))
			return
		var/dat = "<center><b>Recently Stored [storage_type]</b></center><hr>"
		for(var/person in GLOB.frozen_crew)
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

		var/obj/item/I = tgui_input_list(user, "Please choose which object to retrieve.", "Object Recovery", frozen_items)
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

/obj/item/circuitboard/living_quarters_cryo
	name = "Circuit board (Living Quarters Console)"
	build_path = /obj/machinery/computer/cryopod/living_quarters
	origin_tech = list(TECH_DATA = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed
	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE
	dir = WEST

/obj/structure/cryofeed/pipes
	name = "cryogenic feed pipes"
	desc = "A bewildering tangle of pipes."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "cryo_rear_pipes"

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scanner"
	density = TRUE
	anchored = TRUE
	dir = WEST
	var/on_store_message = "has entered"
	var/on_store_location = "long-term storage"
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/on_enter_sound = 'sound/machines/cryopod/cryopod_enter.ogg'
	var/on_exit_sound = 'sound/machines/cryopod/cryopod_exit.ogg'
	var/on_store_sound = 'sound/machines/cryopod/cryopod_store.ogg'
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant					// Person waiting to be despawned.
	var/time_till_despawn = 1200		// Two minute safe period before being despawned.
	var/time_till_force_cryo = 3000		// Five minutes safe period until they're despawned even if active.
	var/time_entered = 0				// Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce

	var/obj/machinery/computer/cryopod/control_computer

	// These items are preserved when the process() despawn proc occurs.
	var/list/items_blacklist = list(
		/obj/item/organ,
		/obj/item/implant,
		/obj/item/card/id,
		/obj/item/modular_computer,
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
	on_store_location = "robotic storage"
	on_store_name = "Robotic Storage Oversight"
	on_enter_sound = 'sound/machines/cryopod/lift_enter.ogg'
	on_exit_sound = 'sound/machines/cryopod/lift_exit.ogg'
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)

/obj/machinery/cryopod/living_quarters
	name = "living quarters lift"
	desc = "A lift heading to the living quarters."
	icon = 'icons/obj/crew_quarters_lift.dmi'
	icon_state = "pod"
	on_store_message = "has departed for"
	on_store_location = "the living quarters"
	on_store_name = "Living Quarters Oversight"
	on_enter_sound = 'sound/machines/cryopod/lift_enter.ogg'
	on_exit_sound = 'sound/machines/cryopod/lift_exit.ogg'
	on_enter_occupant_message = "The elevator door closes slowly, ready to bring you down to the living quarters."
	disallow_occupant_types = list(/mob/living/silicon/robot)

/obj/machinery/cryopod/living_quarters/update_icon()
	cut_overlays()
	var/image/I = image(icon, "pod_top")
	add_overlay(I)


	if(occupant)
		I = image(icon, "pod_back")
		add_overlay(I)

		name = "[name] ([occupant])"
		I = image(occupant.icon, occupant.icon_state, dir = SOUTH)
		I.overlays = occupant.overlays
		I.pixel_z = 11
		add_overlay(I)

		I = image(icon, "pod_door")
		add_overlay(I)
	else
		name = initial(name)

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant.resting = TRUE
	return ..()

/obj/machinery/cryopod/Initialize()
	..()
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/cryopod/LateInitialize()
	. = ..()
	find_control_computer()

/obj/machinery/cryopod/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(occupant)
		. += SPAN_NOTICE("<b>[occupant]</b> [occupant.get_pronoun("is")] inside \the [initial(name)].")

/obj/machinery/cryopod/can_hold_dropped_items()
	return FALSE

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	for(var/obj/machinery/computer/cryopod/C in get_area(src))
		control_computer = C
		break

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
/obj/machinery/cryopod/process()
	if(occupant)
		//Allow a two minute gap between entering the pod and actually despawning.
		if((world.time - time_entered < time_till_despawn) && occupant.ckey)
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
			if(control_computer && control_computer?.allow_items)
				control_computer.frozen_items += W
				W.forceMove(control_computer)
			else
				W.forceMove(T)

	if(isStationLevel(z))
		GLOB.global_announcer.autosay("[occupant.real_name], [occupant.mind.role_alt_title], [on_store_message] [on_store_location].", "[on_store_name]")
	visible_message(SPAN_NOTICE("\The [src] hums and hisses as it moves [occupant] to [on_store_location]."))
	playsound(loc, on_store_sound, 25)
	GLOB.frozen_crew += occupant
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.ghost_spawner)
			var/datum/ghostspawner/human/GS = H.ghost_spawner.resolve()
			LAZYREMOVE(GS.spawned_mobs, WEAKREF(H))
			GS.count--

	// Let SSjobs handle the rest.
	SSjobs.DespawnMob(occupant)
	occupant = null
	update_icon()

/obj/machinery/cryopod/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/grab/G = attacking_item
	if(istype(G))
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is in use."))
			return TRUE
		if(!ismob(G.affecting))
			return TRUE
		if(!check_occupant_allowed(G.affecting))
			return TRUE

		var/mob/living/M = G.affecting
		go_in(user, M)
		return TRUE

/obj/machinery/cryopod/MouseDrop_T(atom/dropping, mob/user)
	if(!istype(user, /mob/living))
		return

	if(!check_occupant_allowed(dropping))
		return

	var/mob/living/M = dropping
	if(istype(M))
		go_in(user, M)

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr) || !check_occupant_allowed(usr))
		return

	go_in(usr, usr, TRUE) //if you're going in of your own volition, you're probably willing

/obj/machinery/cryopod/proc/go_in(mob/user, mob/living/M, var/willing = FALSE) // user refers to the person doing the putting into, M refers to the person being put in
	if(!M.bucklecheck(user)) //We must make sure the person is unbuckled before they go in
		return
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("Dead people can not be put into \the [src]."))
		return
	for(var/mob/living/carbon/slime/S in range(1, M))
		if(S.victim == M)
			to_chat(usr, SPAN_WARNING("[M.name] will not fit into \the [src] because they have a slime latched onto their head!"))
		if(S.victim == user)
			to_chat(usr, SPAN_WARNING("You cannot fit into \the [src] do this while a slime is latched onto your head!"))
			return
	if(!willing && M.client)
		var/original_loc = M.loc
		if(alert(M, "Would you like to enter [on_store_location]?", , "Yes", "No") == "Yes")
			if(!M || M.loc != original_loc)
				return
			willing = TRUE
	else
		willing = TRUE

	if(!willing)
		return

	user.visible_message(SPAN_NOTICE("\The [user] starts [M == user ? "climbing into" : "putting \the [M] into"] \the [name]."), SPAN_NOTICE("You start [M == user ? "climbing into" : "putting \the [M] into"] \the [name]."), range = 3)
	if(do_after(user, 2 SECOND, M, DO_UNIQUE))
		if(!M)
			return TRUE

		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is already in use."))
	else
		to_chat(user, SPAN_NOTICE("You stop [M == user ? "climbing into" : "putting \the [M] into"] \the [name]."))
		return

	to_chat(M, SPAN_NOTICE("[on_enter_occupant_message]"))
	playsound(loc, on_enter_sound, 25)
	to_chat(M, SPAN_DANGER("Press Ghost in the OOC tab to leave, your character will shortly be removed from the round and the slot you occupy will be freed."))
	set_occupant(M)

	if(isipc(M))
		save_ipc_tag(M)

	// Book keeping!
	var/turf/location = get_turf(src)
	log_admin("[key_name_admin(M)] has entered a [initial(src.name)].",ckey=key_name(M))
	message_admins("<span class='notice'>[key_name_admin(M)] has entered a [initial(src.name)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)</span>")

	//Despawning occurs when process() is called with an occupant without a client.
	src.add_fingerprint(user)

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

/obj/machinery/cryopod/proc/go_out()
	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
		occupant.reset_death_timers()

	occupant.forceMove(get_turf(src))
	occupant = null
	playsound(loc, on_exit_sound, 25)
	update_icon()

/obj/machinery/cryopod/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	occupant.forceMove(src)
	occupant.stop_pulling()
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
		time_entered = world.time
		occupant.set_respawn_time()
	update_icon()

/obj/machinery/cryopod/update_icon()
	flick("[initial(icon_state)]-anim", src)
	if(occupant)
		name = "[name] ([occupant])"
		if(stat & BROKEN)
			icon_state = "[initial(icon_state)]-broken-closed"
		if(stat & NOPOWER)
			icon_state = "[initial(icon_state)]-closed"
		else
			icon_state = "[initial(icon_state)]-working"
		return
	else
		name = initial(name)
		if(stat & BROKEN)
			icon_state = "[initial(icon_state)]-broken"
		else
			icon_state = initial(icon_state)

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
