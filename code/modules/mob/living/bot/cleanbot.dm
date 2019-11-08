// Updated by Nadrew, bits and pieces taken from Baycode, but fairly heavily modified to function here (and because a few bits of the baycode was ehh)

// The main issue in the old code was the Life() loop and the fact that it could go infinite really easily.
// The fix involved labeling the various loops involved so they could be continued and broken properly.
// It also decreases the amount of calls to AStar() and handle_target()

var/list/cleanbot_types // Going to use this to generate a list of types once then cull it out locally, see comments below for more info

/obj/effect/decal/cleanable/var
	being_cleaned = 0
	tmp/mob/living/bot/cleanbot/clean_marked = 0 // If a cleaning bot has marked the cleanable to be cleaned, to prevent multiples from going to the same one.

/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_janitor, access_robotics)
	botcard_access = list(access_janitor, access_maint_tunnels)

	locked = 0 // Start unlocked so roboticist can set them to patrol.

	var/obj/effect/decal/cleanable/target
	var/list/path = list()
	var/list/patrol_path = list()
	var/list/ignorelist = list()

	var/obj/cleanbot_listener/listener = null
	var/beacon_freq = 1445 // navigation beacon frequency
	var/signal_sent = 0
	var/closest_dist
	var/next_dest
	var/next_dest_loc

	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/should_patrol = 0
	var/blood = 1
	var/list/target_types = list()

	var/maximum_search_range = 7

/mob/living/bot/cleanbot/Cross(atom/movable/crossed)
	if(crossed)
		if(istype(crossed,/mob/living/bot/cleanbot)) return 0
		return ..()

/mob/living/bot/cleanbot/Initialize()
	. = ..()
	get_targets()

	listener = new /obj/cleanbot_listener(src)
	listener.cleanbot = src

	janitorial_supplies |= src

	SSradio.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

/mob/living/bot/cleanbot/Destroy()
	. = ..()
	path = null
	patrol_path = null
	target = null
	ignorelist = null
	QDEL_NULL(listener)
	global.janitorial_supplies -= src

/mob/living/bot/cleanbot/proc/handle_target()
	if(target.clean_marked && target.clean_marked != src)
		target = null
		path = list()
		ignorelist |= target
		return
	if(loc == target.loc)
		if(!cleaning)
			UnarmedAttack(target)
			return 1
	if(!path.len)
		path = AStar(loc, target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
		if(!path)
			//log_debug("[src] can't reach [target.name] ([target.x], [target.y])")
			ignorelist |= target
			target.clean_marked = null
			target = null
			path = list()
		return
	if(path.len)
		step_to(src, path[1])
		path -= path[1]
		return 1
	return

/mob/living/bot/cleanbot/proc/remove_from_ignore(path)
	ignorelist -= path

/mob/living/bot/cleanbot/Life()
	..()
	if(!on)
		ignorelist = list()
		return

	if(ignorelist.len && prob(2))
		ignorelist -= pick(ignorelist)

	if(client)
		return
	if(cleaning)
		return

	if(!screwloose && !oddbutton && prob(2))
		custom_emote(2, "makes an excited beeping booping sound!")

	if(screwloose && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(oddbutton && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. He seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		ignorelist += gib
		addtimer(CALLBACK(src, .proc/remove_from_ignore, gib), 600)

/mob/living/bot/cleanbot/think()
	..()
	if (!on)
		return

	if(pulledby) // Don't wiggle if someone pulls you
		patrol_path.Cut()
		return

	var/found_spot
	if(!should_patrol)
		return

	// This loop will progressively search outwards for /cleanables in view(), gradually to prevent excessively large view() calls when none are needed.
	search_for: // We use the label so we can break out of this loop from within the next loop.
		// Not breaking out of these loops properly is where the infinite loop was coming from before.
		for(var/i=0, i <= maximum_search_range, i++)
			clean_for: // This one isn't really needed in this context, but it's good to have in case we expand later.
				for(var/obj/effect/decal/cleanable/D in view(i, src))
					if(D.clean_marked && D.clean_marked != src) continue clean_for
					var/mob/living/bot/cleanbot/other_bot = locate() in D.loc
					if(other_bot && other_bot.cleaning && other_bot != src)
						continue clean_for
					if((D in ignorelist))
						// If the object has been slated to be ignored we continue the loop.
						continue clean_for
					if((D.type in target_types))
						// A matching /cleanable was found, now we want to A* it and see if we can reach it.
						patrol_path = list()
						target = D
						D.clean_marked = src
						found_spot = handle_target()
						if (found_spot)
							break search_for // If the target location is found and pathed properly, break the search loop.

						else
							target = null // Otherwise we want to try the next cleanable in view, if any.
							D.clean_marked = null


	if(!found_spot && !target) // No targets in range
		if(!patrol_path || !patrol_path.len)
			if(!signal_sent || signal_sent > world.time + 200) // Waited enough or didn't send yet
				var/datum/radio_frequency/frequency = SSradio.return_frequency(beacon_freq)
				if(!frequency)
					return

				closest_dist = 9999
				next_dest = null
				next_dest_loc = null

				var/datum/signal/signal = new()
				signal.source = src
				signal.transmission_method = 1
				signal.data = list("findbeacon" = "patrol")
				frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
				signal_sent = world.time
			else
				if(next_dest)
					next_dest_loc = listener.memorized[next_dest]
					if(next_dest_loc)
						patrol_path = AStar(loc, next_dest_loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id = botcard, exclude = null)
						signal_sent = 0
		else
			if(pulledby) // Don't wiggle if someone pulls you
				patrol_path = list()
				return
			if(patrol_path[1] == loc)
				patrol_path -= patrol_path[1]
			var/moved = step_towards(src, patrol_path[1])
			if(moved)
				patrol_path -= patrol_path[1]

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	cleaning = 1
	target.being_cleaned = 1
	update_icons()
	var/cleantime = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	spawn(1)
		if(do_after(src, cleantime))
			if(istype(loc, /turf/simulated))
				var/turf/simulated/f = loc
				f.dirt = 0
			if(!D)
				return
			D.clean_marked = null
			if(D == target)
				target.being_cleaned = 0
				target = null
			qdel(D)
		cleaning = 0
		update_icons()

/mob/living/bot/cleanbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/weapon/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	spark(src, 3, alldirs)
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(cleaning)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/turn_off()
	..()
	target = null
	path = list()
	patrol_path = list()

/mob/living/bot/cleanbot/attack_hand(var/mob/user)
	if (!has_ui_access(user) && !emagged)
		user << "<span class='warning'>The unit's interface refuses to unlock!</span>"
		return

	var/dat
	dat += "<TT><B>Automatic Station Cleaner v1.1</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]"
	if(!locked || issilicon(user))
		dat += "<BR>Cleans Blood: <A href='?src=\ref[src];operation=blood'>[blood ? "Yes" : "No"]</A><BR>"
		dat += "<BR>Patrol station: <A href='?src=\ref[src];operation=patrol'>[should_patrol ? "Yes" : "No"]</A><BR>"
	if(open && !locked)
		dat += "Odd looking screw twiddled: <A href='?src=\ref[src];operation=screw'>[screwloose ? "Yes" : "No"]</A><BR>"
		dat += "Weird button pressed: <A href='?src=\ref[src];operation=oddbutton'>[oddbutton ? "Yes" : "No"]</A>"

	user << browse("<HEAD><TITLE>Cleaner v1.1 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")
	return

/mob/living/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if (!has_ui_access(usr) && !emagged)
		usr << "<span class='warning'>Insufficient permissions.</span>"
		return

	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("blood")
			blood = !blood
			get_targets()
		if("patrol")
			should_patrol = !should_patrol
			patrol_path = list()
		if("freq")
			var/freq = text2num(input("Select frequency for  navigation beacons", "Frequnecy", num2text(beacon_freq / 10))) * 10
			if (freq > 0)
				beacon_freq = freq
		if("screw")
			screwloose = !screwloose
			usr << "<span class='notice'>You twiddle the screw.</span>"
		if("oddbutton")
			oddbutton = !oddbutton
			usr << "<span class='notice'>You press the weird button.</span>"
	attack_hand(usr)

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!screwloose || !oddbutton)
		if(user)
			user << "<span class='notice'>The [src] buzzes and beeps.</span>"
		oddbutton = 1
		screwloose = 1
		return 1

/mob/living/bot/cleanbot/proc/get_targets()
	// To avoid excessive loops, instead of storing a list of top-level types, we're going to store a list of all cleanables.
	// It eats a little more memory, but uses quite a bit less CPU when attempting to do the type check in the cleaning routine.
	// We're always going to have more memory to work with than CPU when it comes to BYOND and the extra usage is not much.
	// And to avoid calling typesof() a bunch, we're going to generate the list once globally then Copy() to the bot's list and remove blood if needed.
	// In my tests with around 50 cleanbots actively cleaning up messes it reduced the CPU usage on average around 10%
	if(!cleanbot_types)
		// This just generates the global list if it hasn't been done already, quick process.
		cleanbot_types = typesof(/obj/effect/decal/cleanable/blood,/obj/effect/decal/cleanable/vomit,\
						/obj/effect/decal/cleanable/crayon,/obj/effect/decal/cleanable/liquid_fuel,/obj/effect/decal/cleanable/mucus,/obj/effect/decal/cleanable/dirt)
						 // I honestly forgot you could pass multiple types to typesof() until I accidentally did it here.
	target_types = cleanbot_types.Copy()
	if(!blood)
		target_types -= typesof(/obj/effect/decal/cleanable/blood)-typesof(/obj/effect/decal/cleanable/blood/oil)
/*	target_types = list()

	target_types += /obj/effect/decal/cleanable/blood/oil
	target_types += /obj/effect/decal/cleanable/vomit
	target_types += /obj/effect/decal/cleanable/crayon
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood*/

/* Radio object that listens to signals */

/obj/cleanbot_listener
	var/mob/living/bot/cleanbot/cleanbot = null
	var/list/memorized = list()

/obj/cleanbot_listener/receive_signal(var/datum/signal/signal)
	var/recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid || !cleanbot)
		return

	var/dist = get_dist(cleanbot, signal.source.loc)
	memorized[recv] = signal.source.loc

	if(dist < cleanbot.closest_dist) // We check all signals, choosing the closest beacon; then we move to the NEXT one after the closest one
		cleanbot.closest_dist = dist
		cleanbot.next_dest = signal.data["next_patrol"]

/obj/cleanbot_listener/Destroy()
	cleanbot = null
	return ..()

/* Assembly */

/obj/item/weapon/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Cleanbot"

/obj/item/weapon/bucket_sensor/attackby(var/obj/item/O, var/mob/user)
	..()
	if(istype(O, /obj/item/robot_parts/l_arm) || istype(O, /obj/item/robot_parts/r_arm))
		user.drop_from_inventory(O,get_turf(src))
		qdel(O)
		var/turf/T = get_turf(loc)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		user << "<span class='notice'>You add the robot arm to the bucket and sensor assembly. Beep boop!</span>"
		qdel(src)

	else if(istype(O, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
