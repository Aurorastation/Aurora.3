//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// Mulebot - carries crates around for Quartermaster
// Navigates via floor navbeacons
// Remote Controlled from QM's PDA

#define IDLE 0
#define LOADING_UNLOADING 1
#define NAVIGATING 2
#define HOME 3
#define NAV_BLOCKED 4
#define CANNOT_REACH 5
#define SUMMONED 6
#define MOVING_LEVELS 7

/obj/machinery/bot/mulebot
	name = "Mulebot"
	desc = "A Multiple Utility Load Effector bot."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mule_fast"
	layer = MOB_LAYER
	density = FALSE
	anchored = TRUE
	animate_movement = TRUE
	health = 150 //yeah, it's tougher than ed209 because it is a big metal box with wheels --rastaf0
	maxhealth = 150
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	var/datum/weakref/load = null		// the loaded crate (usually)
	var/beacon_freq = 1400
	var/control_freq = BOT_FREQ

	suffix = ""

	var/turf/target				// this is turf to navigate to (location of beacon)
	var/turf/final_target
	var/loaddir = 0				// this the direction to unload onto/load from
	var/new_destination = ""	// pending new destination (waiting for beacon response)
	var/destination = ""		// destination description
	var/home_destination = "" 	// tag of home beacon
	req_access = list(access_cargo) // added robotics access so assembly line drop-off works properly -veyveyr //I don't think so, Tim. You need to add it to the MULE's hidden robot ID card. -NEO
	var/turf/list/path = list()

	var/mode = IDLE

	var/blockcount	= 0		//number of times retried a blocked path
	var/reached_target = 1 	//true if already reached the target

	var/refresh = 1		// true to refresh dialogue
	var/auto_return = 1	// true if auto return to home beacon after unload
	var/auto_pickup = 1 // true if auto-pickup at beacon

	var/obj/item/cell/cell
						// the installed power cell

	// constants for internal wiring bitflags
	var/datum/wires/mulebot/wires = null

	var/bloodiness = 0		// count of bloodiness
	var/static/total_mules = 0
	var/move_to_delay = 4
	var/obj/mulebot_listener/listener = null
	var/summon_name
	var/datum/walk_to_custom/walk = null

/obj/machinery/bot/mulebot/Initialize()
	. = ..()
	wires = new(src)
	botcard = new(src)
	botcard.access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	cell = new(src)
	cell.charge = 2000
	cell.maxcharge = 2000

	listener = new /obj/mulebot_listener(src)
	listener.bot = WEAKREF(src)

	if(SSradio)
		SSradio.add_object(listener, control_freq, filter = RADIO_MULEBOT)
		SSradio.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

	total_mules++
	if(!suffix)
		suffix = "#[total_mules]"
	name = name + "([suffix])"

/obj/machinery/bot/mulebot/Destroy()
	unload(0)
	qdel(wires)
	wires = null
	mode = IDLE
	stop()
	if(SSradio)
		SSradio.remove_object(listener, beacon_freq)
		SSradio.remove_object(listener, control_freq)

	QDEL_NULL(listener)
	target = null
	return ..()

// attack by item
// emag : lock/unlock,
// screwdriver: open/close hatch
// cell: insert it
// other: chance to knock rider off bot
/obj/machinery/bot/mulebot/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/cell) && open && !cell)
		var/obj/item/cell/C = I
		user.drop_from_inventory(C,src)
		cell = C
		updateDialog()
	else if(I.isscrewdriver())
		if(locked)
			to_chat(user, "<span class='notice'>The maintenance hatch cannot be opened or closed while the controls are locked.</span>")
			return

		open = !open
		if(open)
			src.visible_message("[user] opens the maintenance hatch of [src]", "<span class='notice'>You open [src]'s maintenance hatch.</span>")
			on = 0
			update_icon()
		else
			src.visible_message("[user] closes the maintenance hatch of [src]", "<span class='notice'>You close [src]'s maintenance hatch.</span>")
			update_icon()

		updateDialog()
	else if (I.iswrench())
		if (src.health < maxhealth)
			src.health = min(maxhealth, src.health+25)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.visible_message(
				"<span class='notice'>\The [user] repairs \the [src]!</span>",
				"<span class='notice'>You repair \the [src]!</span>"
			)
		else
			to_chat(user, "<span class='notice'>[src] does not need a repair!</span>")
	else if(load && ismob(load))  // chance to knock off rider
		if(prob(1+I.force * 2))
			unload(0)
			user.visible_message("<span class='warning'>[user] knocks [load] off [src] with \the [I]!</span>", "<span class='warning'>You knock [load] off [src] with \the [I]!</span>")
		else
			to_chat(user, "You hit [src] with \the [I] but to no effect.")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	else
		..()
	return

/obj/machinery/bot/mulebot/emag_act(var/remaining_charges, var/user)
	locked = !locked
	to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the mulebot's controls!</span>")
	flick("mulebot-emagged", src)
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 0)
	return 1

/obj/machinery/bot/mulebot/ex_act(var/severity)
	unload(0)
	switch(severity)
		if(2)
			wires.RandomCutAll(40)//Fix by nanako because the old code was throwing runtimes
		if(3)
			wires.RandomCutAll(20)
	..()
	return

/obj/machinery/bot/mulebot/bullet_act()
	if(prob(50) && !isnull(load))
		unload(0)
	if(prob(25))
		src.visible_message("<span class='warning'>Something shorts out inside [src]!</span>")
		wires.RandomCut()
	..()


/obj/machinery/bot/mulebot/attack_ai(var/mob/user)
	user.set_machine(src)
	interact(user, 1)

/obj/machinery/bot/mulebot/attack_hand(var/mob/user)
	. = ..()
	if (.)
		return
	user.set_machine(src)
	interact(user, 0)

/obj/machinery/bot/mulebot/interact(var/mob/user, var/ai=0)
	var/dat
	dat += "<TT><B>Multiple Utility Load Effector Mk. III</B></TT><BR><BR>"
	dat += "ID: [suffix]<BR>"
	dat += "Power: [on ? "On" : "Off"]<BR>"

	var/atom/movable/A
	if (load)
		A = load.resolve()

	if(!open)

		dat += "Status: " + get_mode_status()

		dat += "<BR>Current Load: [A ? A.name : "<i>none</i>"]<BR>"
		dat += "Destination: [!destination ? "<i>none</i>" : destination]<BR>"
		dat += "Power level: [cell ? cell.percent() : 0]%<BR>"

		if(locked && !ai)
			dat += "<HR>Controls are locked <A href='byond://?src=\ref[src];op=unlock'><I>(unlock)</I></A>"
		else
			dat += "<HR>Controls are unlocked <A href='byond://?src=\ref[src];op=lock'><I>(lock)</I></A><BR><BR>"

			dat += "<A href='byond://?src=\ref[src];op=power'>Toggle Power</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=stop'>Stop</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=go'>Proceed</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=home'>Return to Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=destination'>Set Destination</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=setid'>Set Bot ID</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=sethome'>Set Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=autoret'>Toggle Auto Return Home</A> ([auto_return ? "On":"Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=autopick'>Toggle Auto Pickup Crate</A> ([auto_pickup ? "On":"Off"])<BR>"

			if(load)
				dat += "<A href='byond://?src=\ref[src];op=unload'>Unload Now</A><BR>"
			dat += "<HR>The maintenance hatch is closed.<BR>"

	else
		if(!ai)
			dat += "The maintenance hatch is open.<BR><BR>"
			dat += "Power cell: "
			if(cell)
				dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=cellinsert'>Removed</A><BR>"

			dat += wires.GetInteractWindow()
		else
			dat += "The bot is in maintenance mode and cannot be controlled.<BR>"

	user << browse("<HEAD><TITLE>Mulebot [suffix ? "([suffix])" : ""]</TITLE></HEAD>[dat]", "window=mulebot;size=350x500")
	onclose(user, "mulebot")
	return

/obj/machinery/bot/mulebot/Topic(href, href_list)
	if(..())
		return
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])
			if("lock", "unlock")
				if(src.allowed(usr))
					locked = !locked
					updateDialog()
				else
					to_chat(usr, "<span class='warning'>Access denied.</span>")
					return
			if("power")
				if (src.on)
					turn_off()
				else if (cell && !open)
					if (!turn_on())
						to_chat(usr, "<span class='warning'>You can't switch on [src].</span>")
						return
				else
					return
				visible_message("[usr] switches [on ? "on" : "off"] [src].")
				updateDialog()


			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					cell.update_icon()
					usr.put_in_active_hand(cell)
					cell.add_fingerprint(usr)
					cell = null

					usr.visible_message("<span class='notice'>[usr] removes the power cell from [src].</span>", "<span class='notice'>You remove the power cell from [src].</span>")
					updateDialog()

			if("cellinsert")
				if(open && !cell)
					var/obj/item/cell/C = usr.get_active_hand()
					if(istype(C))
						usr.drop_from_inventory(C,src)
						cell = C
						C.add_fingerprint(usr)

						usr.visible_message("<span class='notice'>[usr] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
						updateDialog()


			if("stop")
				if(mode >=2)
					mode = IDLE
					stop()
					updateDialog()

			if("go")
				if(mode == 0)
					start()
					updateDialog()

			if("home")
				if(mode == 0 || mode == 2)
					start_home()
					updateDialog()

			if("destination")
				refresh=0
				var/new_dest
				var/list/beaconlist = new()
				for(var/obj/machinery/navbeacon/N in navbeacons)
					beaconlist.Add(N.location)
				if(beaconlist.len)
					new_dest = input("Select new destination tag", "Mulebot [suffix ? "([suffix])" : ""]", destination) in beaconlist
				else
					alert("No destination beacons available.")
				refresh=1
				if(new_dest)
					set_destination(new_dest)


			if("setid")
				refresh = 0
				var/new_id = sanitize(input("Enter new bot ID", "Mulebot [suffix ? "([suffix])" : ""]", suffix) as text|null, MAX_NAME_LEN)
				refresh = 1
				if(new_id)
					suffix = new_id
					name = "Mulebot ([suffix])"
					updateDialog()

			if("sethome")
				refresh = 0
				var/new_home = input("Enter new home tag", "Mulebot [suffix ? "([suffix])" : ""]", home_destination) as text|null
				refresh = 1
				if(new_home)
					home_destination = new_home
					updateDialog()

			if("unload")
				if(load && mode != LOADING_UNLOADING)
					if(loc == target)
						unload(loaddir)
					else
						unload(0)

			if("autoret")
				auto_return = !auto_return

			if("autopick")
				auto_pickup = !auto_pickup

			if("close")
				usr.unset_machine()
				usr << browse(null,"window=mulebot")

		updateDialog()
		//src.updateUsrDialog()
	else
		usr << browse(null, "window=mulebot")
		usr.unset_machine()
	return


/obj/machinery/bot/mulebot/proc/stop()
	path = null
	stop_walking(src)
	walk = null

// returns true if the bot has power
/obj/machinery/bot/mulebot/proc/has_power()
	return !open && cell && cell.charge>0 && wires.HasPower()

// mousedrop a crate to load the bot
// can load anything if emagged

/obj/machinery/bot/mulebot/MouseDrop_T(var/atom/movable/C, mob/user)

	if(user.stat)
		return

	if (!on || !istype(C)|| C.anchored || get_dist(user, src) > 1 || get_dist(src,C) > 1 )
		return

	if(load)
		return

	load(C)


// called to load a crate
/obj/machinery/bot/mulebot/proc/load(var/atom/movable/C)
	if(wires.LoadCheck() && (!istype(C, /obj/item) && !istype(C, /obj/structure) && !istype(C, /obj/machinery)))
		src.visible_message("[src] makes a sighing buzz.", "You hear an electronic buzzing sound.")
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return

	//I'm sure someone will come along and ask why this is here... well people were dragging screen items onto the mule, and that was not cool.
	//So this is a simple fix that only allows a selection of item types to be considered. Further narrowing-down is below.
	if(!istype(C, /obj/item) && !istype(C, /obj/machinery) && !istype(C, /obj/structure) && !ismob(C))
		return

	if(!isturf(C.loc)) //To prevent the loading from stuff from someone's inventory, which wouldn't get handled properly.
		return

	if(get_dist(C, src) > 1 || load || !on)
		return
	for(var/obj/structure/plasticflaps/P in src.loc)//Takes flaps into account
		if(!CanPass(C,P))
			return

	mode = LOADING_UNLOADING

	// if a create, close before loading
	var/obj/structure/closet/crate/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(src.loc)
	sleep(2)
	if(C.loc != src.loc) //To prevent you from going onto more thano ne bot.
		return

	C.forceMove(src.loc)
	load = WEAKREF(C)
	C.anchored = TRUE

	C.pixel_y += 9
	if(C.layer < layer)
		C.layer = layer + 0.1
	add_overlay(C)

	if(ismob(C))
		var/mob/M = C
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

	mode = IDLE
	send_status()

// called to unload the bot
// argument is optional direction to unload
// if zero, unload at bot's location
/obj/machinery/bot/mulebot/proc/unload(var/dirn = 0)
	if(!load)
		return

	mode = LOADING_UNLOADING
	cut_overlays()

	var/atom/movable/A = load.resolve()

	if (!A)
		return

	A.forceMove(src.loc)
	A.pixel_y -= 9
	A.layer = initial(A.layer)
	A.anchored = FALSE

	if(ismob(load))
		var/mob/M = load
		if(M.client)
			M.client.perspective = MOB_PERSPECTIVE
			M.client.eye = src


	if(dirn)
		var/turf/T = src.loc
		T = get_step(T,dirn)
		if(CanPass(load,T))//Can't get off onto anything that wouldn't let you pass normally
			step(load, dirn)
		else
			A.forceMove(src.loc)//Drops you right there, so you shouldn't be able to get yourself stuck

	load = null

	// in case non-load items end up in contents, dump every else too
	// this seems to happen sometimes due to race conditions
	// with items dropping as mobs are loaded

	for(var/atom/movable/AM in src)
		if(AM == cell || AM == botcard) continue

		AM.forceMove(src.loc)
		AM.layer = initial(AM.layer)
		AM.pixel_y = initial(AM.pixel_y)
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)
				M.client.perspective = MOB_PERSPECTIVE
				M.client.eye = src
	mode = IDLE

/obj/machinery/bot/mulebot/Move()
	..()
	if(load)
		var/atom/movable/AM = load.resolve()
		if (!AM)
			return
		AM.forceMove(src.loc)

/obj/machinery/bot/mulebot/machinery_process()
	if(!has_power())
		on = 0
		return
	if(on)
		var/speed = (wires.Motor1() ? 1: 0) + (wires.Motor2() ? 2: 0)
		switch(speed)
			if(0)
				return
			if(1)
				process_bot()
				for (var/i = 2, i < 8, i += 2)
					addtimer(CALLBACK(src, .proc/process_bot, i, TIMER_UNIQUE))
			if(2)
				process_bot()
				addtimer(CALLBACK(src, .proc/process_bot, 4, TIMER_UNIQUE))
			if(3)
				process_bot()

	if(refresh)
		updateDialog()

/obj/machinery/bot/mulebot/proc/process_bot()
	switch (mode)
		if (IDLE, HOME, CANNOT_REACH)		// idle
			stop_walking(src)
			update_icon()
			return
		if (LOADING_UNLOADING)		// loading/unloading
			return
		if (NAVIGATING, SUMMONED, MOVING_LEVELS)	// navigating to deliver, home or between Z levels
			if (!walk)
				calc_path()
				try_walking()
				blockcount = 0
			else
				if(cell)
					cell.use(1)

		if (NAV_BLOCKED)
			blockcount++
			if (blockcount > 5)
				src.visible_message("[src] makes an annoyed buzzing sound and stops moving", "You hear an electronic buzzing sound.")
				playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 45, 0)
				mode = CANNOT_REACH
				return

			stop()
			calc_path()
			try_walking()

			return

	update_icon()

/obj/machinery/bot/mulebot/proc/try_walking(var/timeout = 5 SECONDS)
	if(path.len > 0 && target)		// valid path
		var/turf/next = path[1]
		reached_target = FALSE

		if(istype(next, /turf))
			if(bloodiness)
				var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
				var/newdir = get_dir(next, loc)
				if(newdir == dir)
					B.set_dir(newdir)
				else
					newdir = newdir | dir
					if(newdir == 3)
						newdir = 1
					else if(newdir == 12)
						newdir = 4
					B.set_dir(newdir)
				bloodiness--

		walk = start_walking(src, next, 0, move_to_delay, 0, CALLBACK(src, .proc/finished_move), timeout)
		path -= next
	update_icon()

/obj/machinery/bot/mulebot/proc/finished_move(var/reached)
	if (!reached)
		mode = NAV_BLOCKED
		src.visible_message("[src] makes an annoyed buzzing sound", "You hear an electronic buzzing sound.")
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 75, 0)
	else if (loc == target)
		if (MOVING_LEVELS && loc != final_target)

			// Change it to elevator above or below
			var/obj/machinery/mulebotelevator/elevator = locate(/obj/machinery/mulebotelevator/) in target.contents
			if (elevator)
				stop()

				if (!elevator.move_mule(src, final_target))
					mode = CANNOT_REACH
					return

				if (loc.z == final_target.z)
					mode = SUMMONED

				target = final_target
				calc_path()
				return

		at_target()
		stop_walking(src)
		return
	else
		try_walking()

// signals bot status etc. to controller
/obj/machinery/bot/mulebot/proc/send_status()
	var/load_name
	var/atom/movable/AM
	if (!load)
		load_name = "none"
	else
		
		AM = load.resolve()
		if (!AM)
			load_name = "none"
		else
			load_name = AM.name

	var/list/kv = list(
		"type" = "mulebot",
		"name" = suffix,
		"loca" = (loc ? loc.loc : "Unknown"),	// somehow loc can be null and cause a runtime - Quarxink
		"mode" = mode,
		"modestat" = get_mode_status(),
		"powr" = (cell ? cell.percent() : 0),
		"dest" = destination,
		"home" = home_destination,
		"load" = load_name,
		"retn" = auto_return,
		"pick" = auto_pickup
	)
	listener.post_signal_multiple(control_freq, kv)

/obj/machinery/bot/mulebot/proc/get_mode_status()
	switch (mode)
		if (IDLE)
			return "Ready"
		if (LOADING_UNLOADING)
			return "Loading/Unloading"
		if (NAVIGATING)
			return "Navigating to [get_area(target)]"
		if (HOME)
			return "Standby at home"
		if (NAV_BLOCKED)
			return "Navigation blocked. Location: [get_area(src)]"
		if (SUMMONED)
			return "Responding to [summon_name]"
		if (CANNOT_REACH)
			return "Cannot reach destination! Location: [get_area(src)]"
		if (MOVING_LEVELS)
			return "Navigating to the nearest mulebot elevator"

/obj/machinery/bot/mulebot/proc/check_levels()
	var/turf/current_turf = get_turf(src)
	if (target.z == current_turf.z)
		return TRUE

	var/obj/machinery/mulebotelevator/local_elevator
	var/dist = 9999
	for(var/i in muleelevators)
		var/obj/machinery/mulebotelevator/elevator = i
		if (elevator.z != src.z)
			continue
		
		if (get_dist(elevator, src) < dist)
			dist = get_dist(elevator, src)
			local_elevator = i

	if (local_elevator)
		target = get_turf(local_elevator)
		mode = MOVING_LEVELS
		return TRUE

	return FALSE


// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/mulebot/proc/calc_path(var/turf/avoid = null, var/turf/custom_target = null)
	if (!src.path)
		src.path = list()

	if (!check_levels())
		mode = CANNOT_REACH
		return

	if (!custom_target)
		custom_target = target

	if (target == null)
		mode = CANNOT_REACH
		return

	path = AStar(loc, custom_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, id = botcard, exclude = avoid)
	if (isnull(path) || !path.len)
		path = list()
		return

	var/list/path_new = list()
	var/turf/last = path[path.len]
	path_new.Add(path[1])
	for (var/i = 2, i < path.len, i++)
		if ((path[i + 1].x == path[i].x) || (path[i + 1].y == path[i].y)) // we have a straight line, scan for more to cut down
			path_new.Add(path[i])
			for(var/j = i + 1, j < path.len, j++)
				if ((path[j + 1].x != path[j - 1].x) && (path[j + 1].y != path[j - 1].y)) // This is a corner and end point of our line
					path_new.Add(path[j])
					i = j + 1
					break
				else if (j == path.len - 1)
					path = list()
					path = path_new.Copy()
					path.Add(last)
					return
		else
			path_new.Add(path[i])
	path = list()
	path = path_new.Copy()
	path.Add(last)

// sets the current destination
// signals all beacons matching the delivery code
// beacons will return a signal giving their locations
/obj/machinery/bot/mulebot/proc/set_destination(var/new_dest)
	new_destination = new_dest
	listener.post_signal(beacon_freq, "findbeacon", "delivery")
	updateDialog()

// starts bot moving to current destination
/obj/machinery/bot/mulebot/proc/start()
	if(destination == home_destination)
		mode = HOME
	else
		mode = NAVIGATING
	update_icon()

// starts bot moving to home
// sends a beacon query to find
/obj/machinery/bot/mulebot/proc/start_home()
	set_destination(home_destination)
	mode = 4
	update_icon()

// called when bot reaches current target
/obj/machinery/bot/mulebot/proc/at_target()
	if(!reached_target)
		src.visible_message("[src] makes a chiming sound!", "You hear a chime.")
		playsound(src.loc, 'sound/machines/chime.ogg', 50, 0)
		reached_target = 1

		if(load)		// if loaded, unload at target
			unload(loaddir)
		else
			// not loaded
			if(auto_pickup)		// find a crate
				var/atom/movable/AM
				if(!wires.LoadCheck())		// if emagged, load first unanchored thing we find
					for(var/atom/movable/A in get_step(loc, loaddir))
						if(!A.anchored)
							AM = A
							break
				else			// otherwise, look for crates only
					AM = locate(/obj/structure/closet/crate) in get_step(loc, loaddir)
				if(AM)
					load(AM)
		// whatever happened, check to see if we return home

		if(auto_return && destination != home_destination)
			// auto return set and not at home already
			start_home()
			mode = 4
		else
			mode = 0	// otherwise go idle

	stop()
	send_status()	// report status to anyone listening

	return

// called when bot bumps into anything
/obj/machinery/bot/mulebot/Collide(var/atom/obs)
	if(!wires.MobAvoid())		//usually just bumps, but if avoidance disabled knock over mobs
		var/mob/M = obs
		if(ismob(M))
			if(istype(M,/mob/living/silicon/robot))
				src.visible_message("<span class='warning'>[src] bumps into [M]!</span>")
			else
				src.visible_message("<span class='warning'>[src] knocks over [M]!</span>")
				M.stop_pulling()
				M.Stun(8)
				M.Weaken(5)
				M.lying = 1

	if(on && botcard && istype(obs, /obj/machinery/door))
		var/obj/machinery/door/D = obs
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	. = ..()

// called from mob/living/carbon/human/Crossed()
// when mulebot is in the same loc
/obj/machinery/bot/mulebot/proc/RunOver(var/mob/living/carbon/human/H)
	src.visible_message("<span class='warning'>[src] drives over [H]!</span>")
	playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)

	var/damage = rand(5,15)
	H.apply_damage(2*damage, BRUTE, BP_HEAD)
	H.apply_damage(2*damage, BRUTE, BP_CHEST)
	H.apply_damage(0.5*damage, BRUTE, BP_L_LEG)
	H.apply_damage(0.5*damage, BRUTE, BP_R_LEG)
	H.apply_damage(0.5*damage, BRUTE, BP_L_ARM)
	H.apply_damage(0.5*damage, BRUTE, BP_R_ARM)

	blood_splatter(src,H,1)
	bloodiness += 4

	SSfeedback.IncrementSimpleStat("mule_victims")

// player on mulebot attempted to move
/obj/machinery/bot/mulebot/relaymove(var/mob/user)
	if(user.stat)
		return
	if (load)
		var/atom/movable/AM = load.resolve()
		if(AM == user)

			unload(0)
	return

/obj/machinery/bot/mulebot/emp_act(severity)
	if (cell)
		cell.emp_act(severity)
	if(load)
		var/atom/movable/A = load.resolve()
		if (!A)
			return

		A.emp_act(severity)
	..()


/obj/machinery/bot/mulebot/explode()
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)
	if (cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell = null

	spark(Tsec, 3, alldirs)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	unload(0)
	qdel(src)

/obj/machinery/bot/mulebot/update_icon()

	cut_overlays()
	if (open)
		icon_state = initial(icon_state) + "-open"
	
	if (emagged)
		add_overlay("mule_fast-light-emagged")
	else if (mode == IDLE || mode == NAV_BLOCKED)
		add_overlay("mule_fast-light-paused")
	else if (mode == NAVIGATING || mode == LOADING_UNLOADING || mode == HOME || mode == SUMMONED)
		add_overlay("mule_fast-light-active")
	

/obj/mulebot_listener
	var/datum/weakref/bot

/obj/mulebot_listener/Destroy()
	bot = null
	return ..()

// send a radio signal with a single data key/value pair
/obj/mulebot_listener/proc/post_signal(var/freq, var/key, var/value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/mulebot_listener/proc/post_signal_multiple(var/freq, var/list/keyval)

	var/obj/machinery/bot/mulebot/mule = bot.resolve()

	if (!mule)
		return

	if(freq == mule.beacon_freq && !mule.wires.BeaconRX())
		return

	if(freq == mule.control_freq && !mule.wires.RemoteTX())
		return

	var/datum/radio_frequency/frequency = SSradio.return_frequency(freq)

	if(!frequency)
		return


	var/datum/signal/signal = new()

	signal.source = mule
	signal.transmission_method = 1
	signal.data = keyval

	if (signal.data["findbeacon"])
		frequency.post_signal(mule, signal, filter = RADIO_NAVBEACONS)
	else if (signal.data["type"] == "mulebot")
		frequency.post_signal(mule, signal, filter = RADIO_MULEBOT)
	else
		frequency.post_signal(mule, signal)

/obj/mulebot_listener/receive_signal(datum/signal/signal)
	var/obj/machinery/bot/mulebot/mule = bot.resolve()

	if (!mule)
		return
	
	if(!mule.on)
		return

	var/recv = signal.data["command"]
	// process all-bot input
	if(recv == "bot_status" && mule.wires.RemoteRX())
		mule.send_status()

	recv = signal.data["command [mule.suffix]"]
	if(mule.wires.RemoteRX())
		// process control input
		switch (recv)
			if ("stop")
				mule.mode = IDLE
				mule.update_icon()
				mule.stop()
				return

			if ("go")
				mule.start()
				return

			if ("target")
				mule.set_destination(signal.data["destination"] )
				return
			
			if ("target_custom")
				var/turf/T = get_turf(locate(signal.data["destination"][0], signal.data["destination"][1], signal.data["destination"][2]))
				if (!T)
					mule.mode = CANNOT_REACH
					return
				
				mule.target = T
				mule.final_target = T
				return

			if ("unload")
				if(mule.loc == mule.target)
					mule.unload(mule.loaddir)
				else
					mule.unload(0)
				return

			if ("home")
				mule.start_home()
				return

			if ("bot_status")
				mule.send_status()
				return

			if ("autoret")
				mule.auto_return = text2num(signal.data["value"])
				return

			if ("autopick")
				mule.auto_pickup = text2num(signal.data["value"])
				return
			
			if ("summon")
				mule.stop()
				var/obj/item/device/pda/pda = signal.data["target"]
				if (!pda)
					return

				mule.target = get_turf(pda)
				mule.final_target = mule.target
				mule.summon_name = pda.owner
				mule.mode = SUMMONED
				return

	// receive response from beacon
	recv = signal.data["beacon"]
	if(mule.wires.BeaconRX())
		if(recv == mule.new_destination)	// if the recvd beacon location matches the set destination
									// the we will navigate there
			mule.destination = mule.new_destination
			mule.target = signal.source.loc
			var/direction = signal.data["dir"]	// this will be the load/unload dir
			if(direction)
				mule.loaddir = text2num(direction)
			else
				mule.loaddir = 0
			mule.update_icon()
			mule.calc_path()
			mule.updateDialog()

#undef IDLE
#undef LOADING_UNLOADING
#undef NAVIGATING
#undef HOME
#undef NAV_BLOCKED
#undef CANNOT_REACH
#undef SUMMONED
#undef MOVING_LEVELS