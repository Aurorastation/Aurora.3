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
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "cellconsole"
	light_color = LIGHT_COLOR_GREEN
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = FALSE
	interact_offline = TRUE
	var/mode = null

	var/list/frozen_items = list()

	var/storage_type = "Crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = TRUE

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems"
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"
	circuit = /obj/item/circuitboard/robotstoragecontrol

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

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View Storage Log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View Objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover Object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover All Objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])
		if(!length(frozen_crew))
			to_chat(user, SPAN_WARNING("Nothing has been stored recently."))
			return
		var/dat = "<center><b>Recently Stored [storage_type]</b></center><br/><hr/>"
		for(var/person in frozen_crew)
			dat += " - [person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	if(href_list["view"])
		if(!allow_items)
			return
		if(!length(frozen_items))
			to_chat(user, SPAN_WARNING("There are no stored objects."))
			return

		var/dat = "<center><b>Recently Stored Objects</b></center><br/><hr/>"
		for(var/obj/item/I in frozen_items)
			dat += " - [I.name]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryoitems")

	else if(href_list["item"])
		if(!allow_items)
			return

		if(frozen_items.len <= 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
			return

		var/obj/item/I = input(user, "Please choose which object to retrieve.", "Object recovery", null) as null|anything in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			to_chat(user, SPAN_NOTICE("\The [I] is no longer in storage."))
			return

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges \the [I]."), range = 3)

		I.forceMove(get_turf(src))
		frozen_items -= I
		log_and_message_admins("has retrieved \an [I] from \the [src]", user, get_turf(src))

	else if(href_list["allitems"])
		if(!allow_items)
			return

		if(frozen_items.len <= 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
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
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = "/obj/machinery/computer/cryopod/robot"
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
	var/list/preserve_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/storage,
		/obj/item/rig,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/suit,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space
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
	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.drop_from_inventory(W, src)

		if(W.contents.len) //Make sure we catch anything not handled by qdel() on the items.
			for(var/obj/item/O in W.contents)
				if(istype(O,/obj/item/storage/internal)) //Stop eating pockets, you fuck!
					continue
				if(istype(O.loc, /obj/item/storage)) // keep stuff inside storage containers
					continue
				O.forceMove(src)

	//Delete all items not on the preservation list.
	var/list/items = src.contents.Copy()
	items -= occupant // Don't delete the occupant

	for(var/obj/item/W in items)
		var/preserve = FALSE
		// Snowflaaaake.
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				brain.forceMove(get_turf(src))
				continue
			else
				preserve = TRUE
		else if(istype(W, /obj/item/rig))
			var/obj/item/rig/R = W
			R.open = FALSE
			R.locked = TRUE
			R.offline = TRUE
			R.sealing = FALSE
			R.canremove = TRUE
			preserve = TRUE
		else
			if(is_type_in_list(W, preserve_items))
				preserve = TRUE
			if(is_type_in_list(W.loc, preserve_items)) // keep stuff in storage safe
				preserve = TRUE

		if(!preserve)
			qdel(W)
		else
			if(control_computer?.allow_items)
				control_computer.frozen_items += W
				W.forceMove(control_computer)
			else
				W.forceMove(get_turf(src))

	flick("[initial(icon_state)]-anim", src)
	icon_state = base_icon_state

	global_announcer.autosay("[occupant.real_name], [occupant.mind.role_alt_title], [on_store_message]", "[on_store_name]")
	visible_message(SPAN_NOTICE("\The [src] hums and hisses as it moves [occupant] into storage."))
	frozen_crew += occupant

	// Let SSjobs handle the rest.
	SSjobs.DespawnMob(occupant)
	set_occupant(null)

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

			flick("[initial(icon_state)]-anim", src)
			icon_state = occupied_icon_state

			to_chat(M, SPAN_NOTICE("[on_enter_occupant_message]"))
			to_chat(M, span("danger", "Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))
			set_occupant(M)
			time_entered = world.time

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
			to_chat(usr, span("warning", "[L.name] will not fit into the cryo pod because they have a slime latched onto their head."))
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

		flick("[initial(icon_state)]-anim", src)
		icon_state = occupied_icon_state

		to_chat(L, SPAN_NOTICE("You feel cool air surround you. You go numb as your senses turn inward."))
		to_chat(L, span("danger", "Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))
		occupant = L
		time_entered = world.time

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

	flick("[initial(icon_state)]-anim", src)
	icon_state = base_icon_state

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
	return

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
			to_chat(usr, span("warning", "You cannot do this while a slime is latched onto you!"))
			return

	usr.visible_message(SPAN_NOTICE("[usr] starts climbing into [src]."), SPAN_NOTICE("You start climbing into [src]."), range = 3)

	if(do_after(usr, 20))
		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, SPAN_WARNING("\The [src] is in use."))
			return

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		set_occupant(usr)

		flick("[initial(icon_state)]-anim", src)
		icon_state = occupied_icon_state

		to_chat(usr, SPAN_NOTICE("[on_enter_occupant_message]"))
		to_chat(usr, span("danger", "Press Ghost in the OOC tab to cryo, your character will shortly be removed from the round and the slot you occupy will be freed."))

		time_entered = world.time

		src.add_fingerprint(usr)

	return

/obj/machinery/cryopod/proc/go_out()
	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	set_occupant(null)

	flick("[initial(icon_state)]-anim", src)
	icon_state = base_icon_state

	return

/obj/machinery/cryopod/proc/set_occupant(var/occupant)
	src.occupant = occupant
	name = initial(name)
	if(occupant)
		name = "[name] ([occupant])"