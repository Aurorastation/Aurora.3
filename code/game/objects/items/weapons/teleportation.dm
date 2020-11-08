/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 *		Closet Teleporter
 */

/*
 * Locator
 */
/obj/item/locator
	name = "locator"
	desc = "A device that can be used to track those with locator implants."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = TRUE
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 400)

/obj/item/locator/attack_self(mob/user as mob)
	user.set_machine(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
<B>Persistent Signal Locator</B><HR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='?src=\ref[src];refresh=1'>Refresh</A>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/locator/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/turf/current_location = get_turf(usr)//What turf is the user on?
	if(!current_location||current_location.z==1)//If turf was not found or they're on z level 1.
		to_chat(usr, "The [src] is malfunctioning.")
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/obj/item/device/radio/beacon/W in teleportbeacons)
					if (W.frequency == src.frequency)
						var/turf/tr = get_turf(W)
						if (tr.z == sr.z && tr)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extranneous Signals:</B><BR>"
				for (var/obj/item/implant/tracking/W in implants)
					if (!W.implanted || !(istype(W.loc,/obj/item/organ/external) || ismob(W.loc)))
						continue
					else
						var/mob/M = W.loc
						if (M.stat == 2)
							if (M.timeofdeath + 6000 < world.time)
								continue

					var/turf/tr = get_turf(W)
					if (tr.z == sr.z && tr)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if (direct < 20)
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><span class='warning'>Processing Error:</span></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if (href_list["temp"])
					src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return


/*
 * Hand-tele
 */
/obj/item/hand_tele
	name = "hand tele"
	desc = "A hand-held bluespace teleporter that can rip open portals to a random nearby location, or lock onto a teleporter with a selected teleportation beacon."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 10000)
	var/list/active_teleporters = list()
	var/held_maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/hand_tele/Initialize()
	. = ..()
	if(get(loc, /mob))
		maptext = held_maptext

/obj/item/hand_tele/attack_self(mob/user)
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location || isNotStationLevel(current_location.z))
		to_chat(user, SPAN_WARNING("\The [src] can't get a bearing on anything right now."))
		return

	var/list/teleport_options = list()
	for(var/obj/machinery/teleport/hub/R in SSmachinery.all_machines)
		var/obj/machinery/computer/teleporter/com = R.com
		if(com?.locked && !com.one_time_use)
			if(R.icon_state == "tele1")
				teleport_options["[com.id] (Active)"] = com.locked
			else
				teleport_options["[com.id] (Inactive)"] = com.locked

	var/list/potential_turfs = list()
	for(var/turf/T in orange(10))
		if(T.x > world.maxx-8 || T.x < 8)
			continue	//putting them at the edge is dumb
		if(T.y > world.maxy-8 || T.y < 8)
			continue
		if(T.density || turf_contains_dense_objects(T))
			continue
		potential_turfs += T

	if(length(potential_turfs))
		teleport_options["None (Dangerous)"] = pick(potential_turfs)

	var/teleport_choice = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") as null|anything in teleport_options
	if(!teleport_choice || user.get_active_hand() != src || use_check_and_message(user))
		return

	if(length(active_teleporters) >= 3)
		user.show_message(SPAN_WARNING("\The [src] is recharging!"))
		return

	var/T = teleport_options[teleport_choice]
	audible_message(SPAN_NOTICE("Locked in."), hearing_distance = 3)
	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(src), T, src)
	active_teleporters += P
	if(length(active_teleporters) >= 3)
		check_maptext("<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charge</span>")
	add_fingerprint(user)

/obj/item/hand_tele/proc/remove_portal(var/obj/effect/portal/P)
	active_teleporters -= P
	if(length(active_teleporters) < 3)
		check_maptext("<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>")

/obj/item/hand_tele/proc/check_maptext(var/new_maptext)
	if(new_maptext)
		held_maptext = new_maptext
	if(ismob(loc) || ismob(loc.loc))
		maptext = held_maptext
	else
		maptext = ""

/obj/item/hand_tele/throw_at()
	..()
	check_maptext()

/obj/item/hand_tele/dropped()
	..()
	check_maptext()

/obj/item/hand_tele/on_give()
	check_maptext()

/obj/item/hand_tele/pickup()
	..()
	addtimer(CALLBACK(src, .proc/check_maptext), 1) // invoke async does not work here

/obj/item/closet_teleporter
	name = "closet teleporter"
	desc = "A device that allows a user to connect two closets into a bluespace network."
	desc_antag = "Click a closet with this to install. Step into the closet and close the door to teleport to the linked closet. It has a one minute cooldown after a batch teleport."
	icon = 'icons/obj/modular_components.dmi'
	icon_state = "cpu_normal_photonic"
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 2, TECH_BLUESPACE = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 400)
	var/obj/structure/closet/attached_closet
	var/obj/item/closet_teleporter/linked_teleporter
	var/last_use = 0

/obj/item/closet_teleporter/proc/do_teleport(var/mob/user)
	if(!attached_closet)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have an attached closet!"))
		return
	if(!linked_teleporter)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a linked teleporter!"))
		return
	if(!linked_teleporter.attached_closet)
		to_chat(user, SPAN_WARNING("The linked teleporter doesn't have an attached closet!"))
		return
	if(last_use + 600 > world.time)
		return
	var/obj/structure/closet/target_closet = linked_teleporter.attached_closet
	user.forceMove(target_closet)
	if(target_closet.opened)
		user.visible_message(SPAN_NOTICE("\The [user] steps out of the back of \the [target_closet]."), SPAN_NOTICE("You teleport into the linked closet, stepping out of it."))
	else
		target_closet.visible_message(SPAN_WARNING("\The [target_closet] rattles."))
		to_chat(user, SPAN_NOTICE("You teleport into the target closet, bumping into the closed door."))
		target_closet.animate_shake()
		playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100, TRUE)

/obj/item/closet_teleporter/Destroy()
	attached_closet = null
	if(linked_teleporter?.linked_teleporter == src)
		linked_teleporter.linked_teleporter = null
	linked_teleporter = null
	return ..()
