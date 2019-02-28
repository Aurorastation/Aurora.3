/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	light_color = LIGHT_COLOR_GREEN
	circuit = /obj/item/weapon/circuitboard/cryopodcontrol
	density = 0
	interact_offline = 1
	var/mode = null

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()
	var/list/_admin_logs = list() // _ so it shows first in VV

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems"
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"
	circuit = /obj/item/weapon/circuitboard/robotstoragecontrol

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if (!(ROUND_IS_STARTED))
		return

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)

	if(..())
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryoitems")

	else if(href_list["item"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			user << "<span class='notice'>There is nothing to recover from storage.</span>"
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			user << "<span class='notice'>\The [I] is no longer in storage.</span>"
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges \the [I].</span>", range = 3)

		I.forceMove(get_turf(src))
		frozen_items -= I

	else if(href_list["allitems"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			user << "<span class='notice'>There is nothing to recover from storage.</span>"
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges the desired objects.</span>", range = 3)

		for(var/obj/item/I in frozen_items)
			I.forceMove(get_turf(src))
			frozen_items -= I

	src.updateUsrDialog()
	return

/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = "/obj/machinery/computer/cryopod/robot"
	origin_tech = list(TECH_DATA = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	dir = WEST

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	dir = WEST

	var/base_icon_state = "body_scanner_0"
	var/occupied_icon_state = "body_scanner_1"
	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant = null       // Person waiting to be despawned.
	var/time_till_despawn = 9000  // 15 minutes-ish safe period before being despawned.
	var/time_entered = 0          // Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce //

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/weapon/hand_tele,
		/obj/item/weapon/card/id/captains_spare,
		/obj/item/weapon/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/weapon/gun,
		/obj/item/weapon/pinpointer,
		/obj/item/clothing/suit,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/weapon/storage/internal
	)

/obj/machinery/cryopod/robot
	name = "robotic storage unit"
	desc = "A storage unit for robots."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "pod_0"
	base_icon_state = "pod_0"
	occupied_icon_state = "pod_1"
	on_store_message = "has entered robotic storage."
	on_store_name = "Robotic Storage Oversight"
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)
	disallow_occupant_types = list(/mob/living/silicon/robot/drone)

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant.resting = 1
	return ..()

/obj/machinery/cryopod/Initialize()
	. = ..()

	find_control_computer()

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	//control_computer = locate(/obj/machinery/computer/cryopod) in src.loc.loc
	for(var/obj/machinery/computer/cryopod/C in src.loc.loc)
		control_computer = C
		break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [src.loc.loc] could not find control computer!")
		message_admins("Cryopod in [src.loc.loc] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/machinery_process()
	if(occupant)
		//Allow a ten minute gap between entering the pod and actually despawning.
		if((world.time - time_entered < time_till_despawn) && occupant.ckey)
			return

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer(urgent=1))
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/robot/despawn_occupant()
	var/mob/living/silicon/robot/R = occupant
	if(!istype(R)) return ..()

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
		occupant.drop_from_inventory(W,src)

		if(W.contents.len) //Make sure we catch anything not handled by qdel() on the items.
			for(var/obj/item/O in W.contents)
				if(istype(O,/obj/item/weapon/storage/internal)) //Stop eating pockets, you fuck!
					continue
				O.forceMove(src)

	//Delete all items not on the preservation list.
	var/list/items = src.contents.Copy()
	items -= occupant // Don't delete the occupant

	for(var/obj/item/W in items)

		var/preserve = null
		// Snowflaaaake.
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				preserve = 1
			else
				continue
		else
			for(var/T in preserve_items)
				if(istype(W,T))
					preserve = 1
					break

		if(!preserve)
			qdel(W)
		else
			if(control_computer && control_computer.allow_items)
				control_computer.frozen_items += W
				W.forceMove(null)
			else
				W.forceMove(src.loc)

	icon_state = base_icon_state

	global_announcer.autosay("[occupant.real_name], [occupant.mind.role_alt_title], [on_store_message]", "[on_store_name]")
	visible_message("<span class='notice'>\The [initial(name)] hums and hisses as it moves [occupant.real_name] into storage.</span>")

	// Let SSjobs handle the rest.
	SSjobs.DespawnMob(occupant)

	set_occupant(null)

/obj/machinery/cryopod/attackby(var/obj/item/weapon/grab/G, var/mob/user as mob)

	if(istype(G))

		if(occupant)
			user << "<span class='notice'>\The [src] is in use.</span>"
			return

		if(!ismob(G.affecting))
			return

		if(!check_occupant_allowed(G.affecting))
			return

		var/willing = null //We don't want to allow people to be forced into despawning.
		var/mob/M = G.affecting

		if(M.client)
			var/originalloc = M.loc
			if(alert(M,"Would you like to enter long-term storage?",,"Yes","No") == "Yes")
				if(!M || !G || !G.affecting || M.loc != originalloc) return
				willing = 1
		else
			willing = 1

		if(willing)

			user.visible_message("<span class='notice'>[user] starts putting [G.affecting] into [src].</span>", "<span class='notice'>You start putting [G.affecting] into [src].</span>", range = 3)

			if(do_after(user, 20))
				if(!M || !G || !G.affecting) return

				M.forceMove(src)

				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src

			icon_state = occupied_icon_state

			M << "<span class='notice'>[on_enter_occupant_message]</span>"
			M << "<span class='notice'><b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b></span>"
			set_occupant(M)
			time_entered = world.time

			// Book keeping!
			var/turf/location = get_turf(src)
			log_admin("[key_name_admin(M)] has entered a stasis pod. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)",ckey=key_name(M))
			message_admins("<span class='notice'>[key_name_admin(M)] has entered a stasis pod.</span>")

			//Despawning occurs when process() is called with an occupant without a client.
			src.add_fingerprint(M)

/obj/machinery/cryopod/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!check_occupant_allowed(O))
		return
	if(occupant)
		user << "<span class='notice'>\The [src] is in use.</span>"
		return
	var/mob/living/L = O

	if(L.stat == DEAD)
		user << "<span class='notice'>Dead people can not be put into stasis.</span>"
		return
	for(var/mob/living/carbon/slime/M in range(1,L))
		if(M.Victim == L)
			usr << "[L.name] will not fit into the cryo pod because they have a slime latched onto their head."
			return

	var/willing = null //We don't want to allow people to be forced into despawning.

	if(L.client)
		var/originalloc = L.loc
		if(alert(L,"Would you like to enter stasis?",,"Yes","No") == "Yes")
			if(!L || L.loc != originalloc) return
			willing = 1
	else
		willing = 1

	if(willing)
		if(L == user)
			user.visible_message("<span class='notice'>[user] starts climbing into [src].</span>", "<span class='notice'>You start climbing into [src].</span>", range = 3)
		else
			user.visible_message("<span class='notice'>[user] starts putting [L] into [src].</span>", "<span class='notice'>You start putting [L] into [src].</span>", range = 3)

		if(do_after(user, 20))
			if(!L) return

			L.forceMove(src)

			if(L.client)
				L.client.perspective = EYE_PERSPECTIVE
				L.client.eye = src
		else
			user << "<span class='notice'>You stop [L == user ? "climbing into" : "putting [L] into"] \the [name].</span>"
			return

		icon_state = occupied_icon_state

		L << "<span class='notice'>You feel cool air surround you. You go numb as your senses turn inward.</span>"
		L << "<span class='notice'><b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b></span>"
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
	if(usr.stat != 0)
		return

	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	var/list/items = src.contents
	if(occupant) items -= occupant
	if(announce) items -= announce

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

	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		usr << "<span class='notice'><B>\The [src] is in use.</B></span>"
		return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			usr << "You're too busy getting your life sucked out of you."
			return

	usr.visible_message("<span class='notice'>[usr] starts climbing into [src].</span>", "<span class='notice'>You start climbing into [src].</span>", range = 3)

	if(do_after(usr, 20))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			usr << "<span class='notice'><B>\The [src] is in use.</B></span>"
			return

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		set_occupant(usr)

		icon_state = occupied_icon_state

		usr << "<span class='notice'>[on_enter_occupant_message]</span>"
		usr << "<span class='notice'><b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b></span>"

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

	icon_state = base_icon_state

	return

/obj/machinery/cryopod/proc/set_occupant(var/occupant)
	src.occupant = occupant
	name = initial(name)
	if(occupant)
		name = "[name] ([occupant])"
