/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 *		Closet Teleporter
 *		Inhibitor handling proc for above
 */

/*
 * Special inhibitor handling. Different from the one used by teleport datums.
 */
/proc/check_inhibitors(var/turf/T)
	for(var/found_inhibitor in bluespace_inhibitors)
		var/obj/machinery/anti_bluespace/AB = found_inhibitor
		if(T.z != AB.z || get_dist(T, AB) > 8 || (AB.stat & (NOPOWER | BROKEN)))
			continue
		else
			return FALSE
	return TRUE

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
					if (W.get_frequency() == src.frequency)
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

				src.temp += "<B>Extraneous Signals:</B><BR>"
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
	desc_info = "Ctrl-click to choose which teleportation pad to link to. Use in-hand or alt-click to deploy a portal. When not linked to a pad, or the pad isn't pointing at a beacon, it will choose a completely random teleportation destination."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	flags = HELDMAPTEXT
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 10000)

	var/obj/machinery/teleport/pad/linked_pad
	var/list/active_teleporters

	var/max_portals = 2

/obj/item/hand_tele/examine(mob/user, distance)
	. = ..()
	if(linked_pad)
		var/area/A = get_area(linked_pad)
		to_chat(user, SPAN_NOTICE("\The [src] is linked to a teleportation pad in [A.name]"))
	else
		to_chat(user, SPAN_WARNING("\The [src] isn't linked to any teleportation pads!"))

/obj/item/hand_tele/set_initial_maptext()
	held_maptext = SMALL_FONTS(7, "Ready")

/obj/item/hand_tele/attack_self(mob/user)
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location || isAdminLevel(current_location.z))
		to_chat(user, SPAN_WARNING("\The [src] can't get a bearing on anything right now."))
		return

	//Cannot make one if too close to an inhibitor
	if(!check_inhibitors(current_location))
		to_chat(user, SPAN_DANGER("\The [src] can't seem to find a lock. Something in the area must be preventing the portal from opening..."))
		return

	if(LAZYLEN(active_teleporters) >= max_portals)
		user.show_message(SPAN_WARNING("\The [src] is recharging!"))
		return

	var/turf/teleport_turf
	if(linked_pad)
		if(linked_pad.stat & (NOPOWER|BROKEN))
			to_chat(user, SPAN_WARNING("The pad \the [src] is connected doesn't seem to be responding!"))
			return
		var/obj/effect/overmap/current_sector
		if(current_map.use_overmap)
			current_sector = map_sectors["[current_location.z]"]
		var/list/nearby_z_levels = GetConnectedZlevels(current_location.z)
		if(current_sector)
			for(var/obj/effect/overmap/visitable/visitable in current_sector.loc)
				nearby_z_levels |= visitable.map_z
		if(!(linked_pad.z in nearby_z_levels))
			to_chat(user, SPAN_WARNING("The pad \the [src] is connected to isn't close enough to lock onto now!"))
			return
		if(linked_pad.locked_obj)
			teleport_turf = get_turf(linked_pad.locked_obj.resolve())
	else
		var/list/potential_turfs = list()
		for(var/turf/T in orange(10))
			if(T.x > world.maxx-8 || T.x < 8)
				continue	//putting them at the edge is dumb
			if(T.y > world.maxy-8 || T.y < 8)
				continue
			if(T.density || turf_contains_dense_objects(T))
				continue
			if(!check_inhibitors(T))
				continue
			potential_turfs += T
		teleport_turf = pick(potential_turfs)

	if(!teleport_turf)
		to_chat(user, SPAN_WARNING("\The [src] was unable to get a lock onto anything!"))
		return
	if(isAdminLevel(teleport_turf.z))
		to_chat(user, SPAN_WARNING("The signal to the beacon seems to be scrambled!"))
		return

	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(src), teleport_turf, src)
	LAZYADD(active_teleporters, P)
	if(LAZYLEN(active_teleporters) >= max_portals)
		check_maptext(SMALL_FONTS(6, "Charge"))
	add_fingerprint(user)

/obj/item/hand_tele/AltClick(mob/user)
	if(user == loc)
		attack_self(user)
		return
	return ..()

/obj/item/hand_tele/CtrlClick(mob/user)
	if(user == loc)
		var/turf/current_location = get_turf(src)
		var/list/teleport_options = list()
		for(var/obj/machinery/teleport/pad/P in SSmachinery.machinery)
			if(AreConnectedZLevels(current_location.z, P.z))
				var/area/A = get_area(P)
				if(P.engaged)
					teleport_options["[A.name] (Active)"] = P
				else
					teleport_options["[A.name] (Inactive)"] = P
		teleport_options["None (Dangerous)"] = null
		var/teleport_choice = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") as null|anything in teleport_options
		if(!teleport_choice)
			return
		var/old_pad = linked_pad
		linked_pad = teleport_options[teleport_choice]
		if(linked_pad)
			destroyed_event.register(linked_pad, src, /obj/item/hand_tele/proc/pad_destroyed)
		if(old_pad && linked_pad != old_pad)
			destroyed_event.unregister(old_pad, src)
		return
	return ..()

/obj/item/hand_tele/proc/pad_destroyed()
	linked_pad = null
	audible_message("\The [src] beeps, \"Connected pad destroyed, resetting to no-pad.\"", null, 3)

/obj/item/hand_tele/proc/remove_portal(var/obj/effect/portal/P)
	LAZYREMOVE(active_teleporters, P)
	if(LAZYLEN(active_teleporters) < max_portals)
		check_maptext(SMALL_FONTS(7, "Ready"))

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
		return FALSE
	if(!linked_teleporter)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a linked teleporter!"))
		return FALSE
	if(!linked_teleporter.attached_closet)
		to_chat(user, SPAN_WARNING("The linked teleporter doesn't have an attached closet!"))
		return FALSE
	if(last_use + 600 > world.time)
		return FALSE
	if(!check_inhibitors(get_turf(attached_closet)) || !check_inhibitors(get_turf(linked_teleporter.attached_closet)))
		to_chat(user, SPAN_WARNING("Something near you or your destination is destabilizing the bluespace network between the closets. \The [src] can't get a clear link to the other side!"))
		return FALSE

	var/obj/structure/closet/target_closet = linked_teleporter.attached_closet
	user.forceMove(target_closet.opened ? get_turf(target_closet) : target_closet)
	if(target_closet.opened)
		user.visible_message(SPAN_NOTICE("\The [user] steps out of the back of \the [target_closet]."), SPAN_NOTICE("You teleport into the linked closet, stepping out of it."))
	else
		target_closet.visible_message(SPAN_WARNING("\The [target_closet] rattles."))
		to_chat(user, SPAN_NOTICE("You teleport into the target closet, bumping into the closed door."))
		target_closet.shake_animation()
		playsound(get_turf(src), 'sound/effects/grillehit.ogg', 100, TRUE)
	return TRUE

/obj/item/closet_teleporter/Destroy()
	attached_closet = null
	if(linked_teleporter?.linked_teleporter == src)
		linked_teleporter.linked_teleporter = null
	linked_teleporter = null
	return ..()
