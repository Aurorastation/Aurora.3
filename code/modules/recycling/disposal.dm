/**
 * Disposal bin
 * Holds items for disposal into pipe system
 * Draws air from turf, gradually charges internal reservoir
 * Once full (~1 atm), uses air resv to flush items into the pipes
 * Automatically recharges air (unless off), will flush when ready if pre-set
 * Can hold items and human size things, no other draggables
 * Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
 */

/// kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE)
/// (Liters L)
#define PRESSURE_TANK_VOLUME 150
/// L/s - 4 m/s using a 15 cm by 15 cm inlet
#define PUMP_MAX_FLOW_RATE 90

#define MODE_OFF			0
#define MODE_PRESSURIZING	1
#define MODE_READY			2
#define MODE_FLUSHING		3

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/disposals.dmi'
	icon_state = "disposal"
	anchored = 1
	density = 1
	/// Unit is powered
	var/is_on = TRUE
	var/datum/wires/disposal/wires
	/// Internal reservoir
	var/datum/gas_mixture/air_contents
	var/mode = MODE_PRESSURIZING
	/// Controlled by flush wire status
	var/can_flush = TRUE
	/// TRUE if flush handle is pulled
	var/flush = FALSE
	/// The attached pipe trunk
	var/obj/structure/disposalpipe/trunk/trunk = null
	/// TRUE if flushing in progress. To be replaced with mode entirely
	var/flushing = 0
	/// Every 30 ticks it will look whether it is ready to flush
	var/flush_every_ticks = 30
	/// This var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush
	var/flush_count = 0
	var/last_sound = 0
	/// Most pumps require air to function, but some don't
	var/uses_air = TRUE
	/// The pneumatic pump power. 3 HP ~ 2200W
	active_power_usage = 2200
	idle_power_usage = 100

/obj/machinery/disposal/airless
	uses_air = FALSE

/obj/machinery/disposal/small
	desc = "A compact pneumatic waste disposal unit."
	icon_state = "disposal_small"
	density = FALSE

/obj/machinery/disposal/small/north
	dir = NORTH
	pixel_y = -13
	layer = MOB_LAYER + 0.1

/obj/machinery/disposal/small/south
	dir = SOUTH
	pixel_y = 20
	layer = OBJ_LAYER + 0.3

/obj/machinery/disposal/small/east
	dir = EAST
	pixel_x = -12

/obj/machinery/disposal/small/west
	dir = WEST
	pixel_x = 11

/obj/machinery/disposal/small/airless
	uses_air = FALSE

/obj/machinery/disposal/small/Initialize()
	. = ..()
	if(pixel_x || pixel_y)
		return
	else
		switch(dir)
			if(NORTH)
				pixel_y = -13
				layer = MOB_LAYER + 0.1
			if(SOUTH)
				pixel_y = 20
				layer = OBJ_LAYER + 0.3
			if(EAST)
				pixel_x = -12
			if(WEST)
				pixel_x = 11

/obj/machinery/disposal/small/check_mob_size(mob/target)
	if(target.mob_size > MOB_SMALL)
		return FALSE
	return TRUE

/**
 * Create a new disposal:
 * Find the attached trunk (if present), and initialize gas reservoir.
 */
/obj/machinery/disposal/Initialize()
	. = ..()
	trunk = locate() in src.loc
	if(!trunk)
		mode = MODE_OFF
		is_on = FALSE
		flush = 0
	else
		trunk.linked = src	// link the pipe trunk to self

	wires = new(src)
	air_contents = new/datum/gas_mixture(PRESSURE_TANK_VOLUME)
	update()

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	return ..()

/obj/machinery/disposal/proc/contents_count()
	var/things = 0
	for(var/thing in contents)
		if(istype(thing, /obj/item/device/assembly/signaler))
			var/obj/item/device/assembly/signaler/S = thing
			if(S.connected == wires)
				continue
		things++
	return things

/**
 * Attack by an item places it into the disposal.
 */
/obj/machinery/disposal/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN || !attacking_item || !user)
		return

	var/has_contents

	src.add_fingerprint(user)
	if(!is_on)
		has_contents = contents_count()
		if(attacking_item.isscrewdriver())
			if(has_contents)
				to_chat(user, SPAN_WARNING("Eject the items first!"))
				return TRUE
			else if(default_deconstruction_screwdriver(user, attacking_item))
				update()
				return TRUE
		else if(attacking_item.iswelder() && panel_open)
			if(has_contents)
				to_chat(user, SPAN_WARNING("Eject the items first!"))
				return TRUE
			var/obj/item/weldingtool/W = attacking_item
			if(W.use(0,user))
				to_chat(user, SPAN_NOTICE("You start slicing the floorweld off the disposal unit."))
				if(W.use_tool(src, user, 20, volume = 50))
					if(!src || !W.isOn())
						return TRUE
					to_chat(user, SPAN_NOTICE("You sliced the floorweld off the disposal unit."))
					if(!istype(src, /obj/machinery/disposal/small))
						var/obj/structure/disposalconstruct/C = new (src.loc)
						src.transfer_fingerprints_to(C)
						C.ptype = 6 // 6 = disposal unit
						C.anchored = 1
						C.density = 1
						C.update()
					else
						var/obj/structure/disposalconstruct/C = new (src.loc)
						src.transfer_fingerprints_to(C)
						C.ptype = 15 // 15 = small disposal unit
						C.anchored = 1
						C.update()
					qdel(src)
				return TRUE
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
				return TRUE

	if(istype(attacking_item, /obj/item/melee/energy/blade))
		to_chat(user, SPAN_WARNING("You can't place that item inside the disposal unit."))
		return TRUE

	if(istype(attacking_item, /obj/item/storage) && length(attacking_item.contents) && user.a_intent != I_HURT)
		var/obj/item/storage/S = attacking_item

		if(istype(S, /obj/item/storage/secure))
			var/obj/item/storage/secure/secured_storage = S
			if(secured_storage.locked)
				to_chat(user, SPAN_WARNING("You can't empty \the [secured_storage] into \the [src]. It is locked."))
				return TRUE

		user.visible_message("<b>[user]</b> empties \the [S] into \the [src].", SPAN_NOTICE("You empty \the [S] into \the [src]."), range = 3)
		for(var/obj/item/O in S.contents)
			S.remove_from_storage(O, src)
		S.update_icon()
		update()
		return TRUE

	else if (istype (attacking_item, /obj/item/material/ashtray) && user.a_intent != I_HURT)
		var/obj/item/material/ashtray/A = attacking_item
		if(A.emptyout(src))
			user.visible_message("<b>[user]</b> pours [attacking_item] out into [src].", SPAN_NOTICE("You pour [attacking_item] out into [src]."))
		return TRUE

	else if (istype (attacking_item, /obj/item/device/lightreplacer))
		var/count = 0
		var/obj/item/device/lightreplacer/R = attacking_item
		if (R.store_broken)
			for(var/obj/item/light/L in R.contents)
				count++
				L.forceMove(src)

			if (count)
				to_chat(user, SPAN_NOTICE("You empty [count] broken bulbs into the disposal."))
			else
				to_chat(user, SPAN_NOTICE("There are no broken bulbs to empty out."))
			update()
			return TRUE

	var/obj/item/grab/G = attacking_item
	// handle grabbed mob
	if(istype(G))
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			if(!check_mob_size(GM))
				to_chat(user, SPAN_NOTICE("The opening is too narrow for [G.affecting] to fit!"))
				return TRUE
			for (var/mob/V in viewers(usr))
				V.show_message("[usr] starts putting [GM.name] into the disposal.", 3)
			if(do_after(usr, 20))
				if (GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.forceMove(src)
				for (var/mob/C in viewers(src))
					C.show_message(SPAN_WARNING("[GM.name] has been placed in the [src] by [user]."), 3)
				qdel(G)
				usr.attack_log += "\[[time_stamp()]\] <span class='warning'>Has placed [GM.name] ([GM.ckey]) in disposals.</span>"
				GM.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [usr.name] ([usr.ckey])</font>"
				msg_admin_attack("[key_name_admin(usr)] placed [key_name_admin(GM)] in a disposals unit. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)",ckey=key_name(usr),ckey_target=key_name(GM))
		return TRUE
	if(!attacking_item.dropsafety())
		return TRUE

	if(!attacking_item)
		return TRUE

	user.drop_from_inventory(attacking_item, src)

	user.visible_message("<b>[user]</b> places \the [attacking_item] into \the [src].", SPAN_NOTICE("You place \the [attacking_item] into the [src]."), range = 3)
	update()

/**
 * Handles mouse-dropping another mob or self onto disposal.
 */
/obj/machinery/disposal/mouse_drop_receive(atom/dropped, mob/user, params)
	var/mob/target = dropped
	if(!istype(target))
		return

	if(user.stat || !user.canmove || !istype(target))
		return
	if(target.buckled_to || get_dist(user, src) > 1 || get_dist(user, target) > 1)
		return

	// Animals cannot put mobs other than themselves into disposal
	if(isanimal(user) && target != user)
		return

	if(!check_mob_size(target))
		to_chat(user, SPAN_NOTICE("The opening is too narrow for [target] to fit!"))
		return

	// Makes it so synths can't be flushed
	if (isrobot(target) && !isDrone(target))
		to_chat(user, SPAN_NOTICE("[target] is a bit too clunky to fit!"))
		return

	src.add_fingerprint(user)
	var/target_loc = target.loc
	var/msg
	for (var/mob/V in viewers(usr))
		if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			V.show_message("[usr] starts climbing into the disposal.", 3)
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			if(target.anchored) return
			V.show_message("[usr] starts stuffing [target.name] into the disposal.", 3)
	if(!do_after(usr, 20))
		return
	if(target_loc != target.loc)
		return
	// If drop self, then climbed in. Must be awake, not stunned or whatever
	if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		msg = "[user.name] climbs into the [src]."
		to_chat(user, "You climb into the [src].")
	else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		msg = "[user.name] stuffs [target.name] into the [src]!"
		to_chat(user, "You stuff [target.name] into the [src]!")

		user.attack_log += "\[[time_stamp()]\] <span class='warning'>Has placed [target.name] ([target.ckey]) in disposals.</span>"
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [user.name] ([user.ckey])</font>"
		msg_admin_attack("[user] ([user.ckey]) placed [target] ([target.ckey]) in a disposals unit. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
	else
		return
	if (target.client)
		target.client.perspective = EYE_PERSPECTIVE
		target.client.eye = src

	target.forceMove(src)

	for (var/mob/C in viewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()

/obj/machinery/disposal/proc/check_mob_size(mob/target)
	return 1

/**
 * Attempt to move while inside.
 */
/obj/machinery/disposal/relaymove(mob/living/user, direction)
	. = ..()

	if(user.stat || src.mode == MODE_FLUSHING)
		return
	if(user.loc == src)
		src.go_out(user)
	return

/**
 * Leave the disposal.
 */
/obj/machinery/disposal/proc/go_out(mob/user)

	if (user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(src.loc)
	update()
	return

/**
 * AI: as human but can't flush.
 */
/obj/machinery/disposal/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	var/inside_bin = (user.loc == src)
	interact(user, !inside_bin)

/**
 * Human interacts with machine.
 */
/obj/machinery/disposal/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return

	if(user.loc == src)
		to_chat(user, SPAN_WARNING("You cannot reach the controls from here."))
		return

	interact(user)

/obj/machinery/disposal/interact(mob/user)
	if(!user)
		return

	src.add_fingerprint(user)
	user.set_machine(src)
	if(panel_open)
		wires.interact(user)

	return ui_interact(user)

/obj/machinery/disposal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DisposalUnit", "Disposal Unit", 320, 200)
		ui.open()

/obj/machinery/disposal/ui_data(mob/user)
	var/list/data = list()
	data["is_on"] = is_on
	data["flush"] = flush
	data["mode"] = mode
	data["uses_air"] = uses_air
	data["panel_open"] = panel_open
	data["pressure"] = CLAMP01(air_contents.return_pressure() / (SEND_PRESSURE))
	return data

/obj/machinery/disposal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("handle-0")
			flush = FALSE
			update()
			. = TRUE
		if("handle-1")
			flush = TRUE
			update()
			. = TRUE
		if("power")
			is_on = !is_on
			update()
			. = TRUE
		if("eject")
			eject()
			. = TRUE

/**
 * Eject the contents of the disposal unit.
 */
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(src.loc)
		AM.pipe_eject(0)
	update()

/**
 * Update the icon & overlays to reflect mode & status
 */
/obj/machinery/disposal/proc/update()
	ClearOverlays()
	if(stat & BROKEN)
		icon_state = "[icon_state]-broken"
		mode = MODE_OFF
		flush = 0
		return

	// flush handle
	if(flush)
		AddOverlays("[icon_state]-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == MODE_OFF)
		return

	// check for items in disposal - occupied light
	if(length(contents))
		AddOverlays("[icon_state]-full")

	// charging and ready light
	if(mode == MODE_PRESSURIZING)
		AddOverlays("[icon_state]-charge")
	else if(mode == MODE_READY)
		AddOverlays("[icon_state]-ready")

/**
 * Timed process. Charge the gas reservoir and perform flush if ready.
 */
/obj/machinery/disposal/process()
	if((stat & BROKEN) || !is_on)
		update_use_power(POWER_USE_OFF)
		return

	flush_count++
	// We've hit the flush counter automatically
	if(flush_count >= flush_every_ticks)
		if(length(contents))
			if(mode == MODE_READY)
				spawn(0)
				feedback_inc("disposal_auto_flush",1)
				flush()
		flush_count = 0
	src.updateDialog()

	// If we're ready, don't draw any extra power
	if(mode == MODE_READY || !uses_air)
		update_use_power(POWER_USE_IDLE)
		// We used the manual flush button
		if(flush)
			flush()
			return
		update()

	// Validate whether we're pressurized or not.
	if(mode == MODE_PRESSURIZING && air_contents.return_pressure() >= SEND_PRESSURE)
		mode = MODE_READY
		update()
		return

	// If you turn this into a bare 'else' statement it just tries to pressurize infinitely and I don't know why.
	else if(mode == MODE_PRESSURIZING && air_contents.return_pressure() < SEND_PRESSURE)
		src.pressurize()
		update()
		return

/**
 * If powered and working, transfer gas from local env to internal reservoir and use the required power to do so.
 */
/obj/machinery/disposal/proc/pressurize()
	// Don't pressurize if there's no power.
	if(stat & NOPOWER)
		update_use_power(POWER_USE_OFF)
		return
	// Recharge from loc turf
	var/atom/L = loc
	if(!loc) return
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		// Group_multiplier is divided out here
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles
		// Using power, pump air from local tile into itself
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power_oneoff(power_draw)
		// If we've reached the target pressure, we're ready to flush
		if(air_contents.return_pressure() >= SEND_PRESSURE)
			mode = MODE_READY

/**
 * Attempt to flush. If able, create a virtual holder object containing disposal bin & gas reservoir contents to ship through disposals network
 */
/obj/machinery/disposal/proc/flush()
	set waitfor = FALSE

	if(!can_flush)
		shake_animation()
		visible_message(SPAN_WARNING("\The [src] groans violently!"), range = 3)
		flush = FALSE
		return

	intent_message(MACHINE_SOUND)

	mode = MODE_FLUSHING
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	//Hacky test to get drones to mail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in src)
		wrapcheck = 1

	for(var/obj/item/smallDelivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1

	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	// Wait for animation to finish
	sleep(5)

	// Copy the contents of disposer to holder
	H.init(src, air_contents)
	// New empty gas reservoir
	air_contents = new(PRESSURE_TANK_VOLUME)

	// Start the holder processing movement
	H.start(src)

	// Now reset disposal state
	flush = 0
	if(mode == MODE_FLUSHING)
		if(uses_air)
			mode = MODE_PRESSURIZING
		else
			mode = MODE_READY
	update()
	return

/**
 * Called when area power changes.
 */
/obj/machinery/disposal/power_change()
	// do default setting/reset of stat NOPOWER bit
	..()
	// update icon
	update()
	return

/**
 * Called when holder is expelled from a disposal- should usually only occur if the pipe network is modified
 */
/obj/machinery/disposal/proc/expel(var/obj/disposalholder/H)

	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	// Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
	if(H)
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.forceMove(src.loc)
			AM.pipe_eject(0)
			// Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
			if(!istype(AM,/mob/living/silicon/robot/drone))
				addtimer(CALLBACK(AM, TYPE_PROC_REF(/atom/movable, throw_at), target, 5, 1), 1)

		H.vent_gas(loc)
		qdel(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover, /obj/projectile))
		return 1
	if(istype(mover,/obj/item) && mover.throwing)
		return 0

	else
		return ..(mover, target, height, air_group)

/obj/machinery/disposal/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isitem(hitting_atom))
		if(prob(75))
			hitting_atom.forceMove(src)
			visible_message(SPAN_NOTICE("[hitting_atom] lands in [src]."))
		else
			visible_message(SPAN_NOTICE("[hitting_atom] bounces off of [src]'s rim!"))
			return ..()
	else
		return ..()


/**
 * Virtual disposal object
 * Travels through pipes in lieu of actual items
 * Contents will be items flushed by the disposal
 * This allows the gas flushed to be tracked
 */
/obj/disposalholder
	invisibility = 101
	/// Gas used to flush, will appear at exit point
	var/datum/gas_mixture/gas = null
	dir = 0
	/// Can travel 2048 steps before going inactive (in case of loops)
	var/count = 2048
	/// Vhanges if contains a delivery container
	var/destinationTag = ""
	/// Changes if contains wrapped package
	var/tomail = 0
	/// If it contains a mob
	var/hasmob = 0

	/// Set by a partial tagger the first time round, then put in destinationTag if it goes through again.
	var/partialTag = ""

	var/tmp/obj/structure/disposalpipe/tick_last

/**
 * Initialize a holder from the contents of a disposal unit.
 */
/obj/disposalholder/proc/init(var/obj/machinery/disposal/D, var/datum/gas_mixture/flush_gas)
	gas = flush_gas// transfer gas resv. into holder object -- let's be explicit about the data this proc consumes, please.

	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in D)
		if(M && M.stat != 2 && !istype(M,/mob/living/silicon/robot/drone))
			hasmob = 1

	//Checks 1 contents level deep. This means that players can be sent through disposals...
	//...but it should require a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in D)
		if(O.contents)
			for(var/mob/living/M in O.contents)
				if(M && M.stat != 2 && !istype(M,/mob/living/silicon/robot/drone))
					hasmob = 1

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for(var/atom/movable/AM in D)
		if(istype(AM, /obj/item/device/assembly/signaler))
			var/obj/item/device/assembly/signaler/S = AM
			if(S.connected == D.wires)
				continue
		AM.forceMove(src)
		if(istype(AM, /obj/structure/bigDelivery) && !hasmob)
			var/obj/structure/bigDelivery/T = AM
			src.destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !hasmob)
			var/obj/item/smallDelivery/T = AM
			src.destinationTag = T.sortTag
		//Drones can mail themselves through maint.
		if(istype(AM, /mob/living/silicon/robot/drone))
			var/mob/living/silicon/robot/drone/drone = AM
			src.destinationTag = drone.mail_destination


/**
 * Start the movement process
 * Argument is the disposal unit the holder started in
 */
/obj/disposalholder/proc/start(var/obj/machinery/disposal/D)
	// No trunk connected, so expel immediately
	if(!D.trunk)
		D.expel(src)
		return

	forceMove(D.trunk)
	set_dir(DOWN)
	START_PROCESSING(SSdisposals, src)

/**
 * For the new SSdisposals-based movement.
 */
/obj/disposalholder/process()
	if (hasmob && prob(3))
		for(var/mob/living/H in src)
			// Drones use the mailing code to move through the disposal system,
			if(!istype(H,/mob/living/silicon/robot/drone))
				// Horribly maim any living creature jumping down disposals. C'est la vie
				H.take_overall_damage(20, 0, DAMAGE_FLAG_SHARP, "Blunt Trauma")

	var/obj/structure/disposalpipe/curr = loc
	if (!loc)
		STOP_PROCESSING(SSdisposals, src)
		tick_last = null
		crash_with("disposalholder processing in nullspace!")
		return

	tick_last = curr
	curr = curr.transfer(src)

	if (!loc)
		STOP_PROCESSING(SSdisposals, src)
		tick_last = null
		return

	if (!curr)
		//spawn (0)	// expel() can sleep, so we gotta fork to not upset SSdisposals.
		STOP_PROCESSING(SSdisposals, src)
		tick_last.expel(src, get_turf(loc), dir)

	if (!(count--))
		STOP_PROCESSING(SSdisposals, src)
		tick_last = null

/**
 * Find the turf which should contain the next pipe
 */
/obj/disposalholder/proc/nextloc()
	return get_step(loc,dir)

/**
 * Find a matching pipe on a turf
 */
/obj/disposalholder/proc/findpipe(var/turf/T)
	if(!T)
		return null

	// flip the movement direction
	var/fdir = turn(dir, 180)
	for(var/obj/structure/disposalpipe/P in T)
		// find pipe direction mask that matches flipped dir
		if(fdir & P.dpdir)
			return P
	// if no matching pipe, return null
	return null

/**
 * Merge two holder objects. Used when a a holder meets a stuck holder.
 */
/obj/disposalholder/proc/merge(obj/disposalholder/other)
	for(var/atom/movable/AM in other)
		// move everything in other holder to this one
		AM.forceMove(src)
		if(ismob(AM))
			var/mob/M = AM
			// if a client mob, update eye to follow this holder
			if(M.client)
				M.client.eye = src

	qdel(other)

/obj/disposalholder/proc/settag(new_tag)
	destinationTag = new_tag

/obj/disposalholder/proc/setpartialtag(new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag

/**
 * Called when player tries to move while in a pipe.
 */
/obj/disposalholder/relaymove(mob/living/user, direction)
	. = ..()

	if(!istype(user,/mob/living))
		return

	var/mob/living/U = user

	if (U.stat || U.last_special <= world.time)
		return

	U.last_special = world.time+100

	if (src.loc)
		for (var/mob/M in hearers(src.loc.loc))
			to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>CLONG, clong!</FONT>")

	playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)

/**
 * Called to vent all gas in holder to a location
 */
/obj/disposalholder/proc/vent_gas(atom/location)
	location.assume_air(gas)  // vent all gas to turf

/obj/disposalholder/Destroy()
	STOP_PROCESSING(SSdisposals, src)
	QDEL_NULL(gas)
	tick_last = null
	return ..()

// Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/disposals.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = 1
	density = 0

	level = 1			// underfloor only
	var/dpdir = 0		// bitmask of pipe directions
	//dir = 0				// dir will contain dominant direction for junction pipes
	var/health = 10 	// health points 0-10
	layer = EXPOSED_DISPOSALS_PIPE_LAYER
	var/sortType = ""
	var/subtype = 0
	// new pipe, set the icon_state as on map

/obj/structure/disposalpipe/Initialize(mapload)
	. = ..()

	if(mapload)
		var/turf/T = loc
		var/image/I = image(icon, T, icon_state, dir, pixel_x, pixel_y)
		I.layer = ABOVE_TILE_LAYER
		I.alpha = 125
		LAZYADD(T.blueprints, I)

/**
 * Pipe is deleted. Ensure if holder is present, it is expelled.
 */
/obj/structure/disposalpipe/Destroy()
	var/obj/disposalholder/H = locate() in src
	if(H)
		// holder was present
		STOP_PROCESSING(SSdisposals, H)
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)

			return ..()

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	return ..()

/**
 * Returns the direction of the next pipe object, given the entrance dir
 * By default, returns the bitmask of remaining directions
 */
/obj/structure/disposalpipe/proc/nextdir(var/fromdir)
	return dpdir & (~turn(fromdir, 180))

/**
 * Transfer the holder through this pipe segment
 * Overriden for special behaviour
 */
/obj/structure/disposalpipe/proc/transfer(var/obj/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/disposalholder/H2 = locate() in P
		if(H2 && !(H2.datum_flags & DF_ISPROCESSING))
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/**
 * Update the icon_state to reflect hidden status
 */
/obj/structure/disposalpipe/proc/update()
	var/turf/T = src.loc
	hide(!T.is_plating() && !istype(T,/turf/space))	// space never hides pipes

/**
 * Hide called by levelupdate if turf intact status changes
 * Change visibility status and force update of icon
 */
/obj/structure/disposalpipe/hide(var/intact)
	set_invisibility(intact ? 101: 0)	// hide if floor is intact

/**
 * Expel the held objects into a turf
 * Called when there is a break in the pipe
 */
/obj/structure/disposalpipe/proc/expel(var/obj/disposalholder/H, var/turf/T, var/direction)
	if(!istype(H) || !istype(T))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.forceMove(T)
			AM.pipe_eject(0)
		qdel(H)
		return

	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				// addtimer will check AM for null.
				addtimer(CALLBACK(AM, TYPE_PROC_REF(/atom/movable, throw_at), target, 100, 1), 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				addtimer(CALLBACK(AM, TYPE_PROC_REF(/atom/movable, throw_at), target, 5, 1), 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)


/**
 * Call to break the pipe: will expel any holder inside at the time then delete the pipe
 * remains: Set to leave broken pipe pieces in place.
 */
/obj/structure/disposalpipe/proc/broken(var/remains = 0)
	if(remains)
		for(var/D in GLOB.cardinals)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(src.loc)
				P.set_dir(D)

	set_invisibility(101)	// make invisible (since we won't delete the pipe immediately)
	var/obj/disposalholder/H = locate() in src
	if(H)
		// holder was present
		STOP_PROCESSING(SSdisposals, H)
		var/turf/T = src.loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)

	QDEL_IN(src, 2)	// delete pipe after 2 ticks to ensure expel proc finished


/**
 * Pipe is affected by an explosion
 */
/obj/structure/disposalpipe/ex_act(severity)
	switch(severity)
		if(1.0)
			broken(0)
			return
		if(2.0)
			health -= rand(5,15)
			healthcheck()
			return
		if(3.0)
			health -= rand(0,15)
			healthcheck()
			return


/**
 * Test pipe's health. Am I broken?
 */
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health<1)
		broken(1)

/**
 * Attack by item
 * Welding tool: Unfasten and convert to obj/disposalconstruct
 */
/obj/structure/disposalpipe/attackby(obj/item/attacking_item, mob/user)
	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/W = attacking_item

		if(W.use(0,user))
			playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
			// check if anything changed over 3 seconds
			to_chat(user, "Slicing the disposal pipe...")
			if(W.use_tool(src, user, 30, volume = 50))
				if(!src || !W.isOn()) return
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")

/**
 * Called when pipe is cut by a welder.
 */
/obj/structure/disposalpipe/proc/welded()
	var/obj/structure/disposalconstruct/C = new (src.loc)
	switch(icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
			C.sortType = sortType
		if("pipe-j2s")
			C.ptype = 10
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
///// Z-Level stuff
		if("pipe-tagger")
			C.ptype = 13
		if("pipe-tagger-partial")
			C.ptype = 14
	C.subtype = src.subtype
	src.transfer_fingerprints_to(C)
	C.set_dir(dir)
	C.density = 0
	C.anchored = 1
	C.update()

	qdel(src)

/obj/structure/disposalpipe/hides_under_flooring()
	return 1

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/disposalholder/H in world)
//		H.active = 0

/// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/Initialize()
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)

	update()

/// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/Initialize()
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/up/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == 11)
		nextdir = dir
	else
		nextdir = 12
	return nextdir

/obj/structure/disposalpipe/up/transfer(var/obj/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		var/turf/current_turf = get_turf(src)
		T = GET_TURF_ABOVE(current_turf)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/disposalholder/H2 = locate() in P
		if(H2 && !(H2.datum_flags & DF_ISPROCESSING))
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/Initialize()
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/down/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == 12)
		nextdir = dir
	else
		nextdir = 11
	return nextdir

/obj/structure/disposalpipe/down/transfer(var/obj/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.dir = nextdir

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		var/turf/current_turf = get_turf(src)
		T = GET_TURF_BELOW(current_turf)
		if(!T)
			H.forceMove(src.loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/disposalholder/H2 = locate() in P
		if(H2 && !(H2.datum_flags & DF_ISPROCESSING))
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

///a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/Initialize()
	. = ..()
	if(icon_state == "pipe-j1")
		dpdir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		dpdir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		dpdir = dir | turn(dir,90) | turn(dir, -90)
	update()

/*
 * Next direction to move:
 * If coming in from secondary dirs, then next is primary dir.
 * If coming in from primary dir, then next is equal chance of other dirs.
 */
/obj/structure/disposalpipe/junction/nextdir(var/fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so need to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)

/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0
	var/no_override = 0

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/Initialize()
	. = ..()
	dpdir = dir | turn(dir, 180)
	if(sort_tag)
		SSdisposals.tagger_locations |= sort_tag

	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/tagger/attackby(obj/item/attacking_item, mob/user)
	if(..())
		return

	if(istype(attacking_item, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = attacking_item

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Changed tag to '[sort_tag]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(var/obj/disposalholder/H)
	if(sort_tag)
		if(!no_override || H.destinationTag == "")
			if(partial)
				H.setpartialtag(sort_tag)
			else
				H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //needs two passes to tag
	name = "partial package tagger"
	desc = "A unique desitnation tagger that requires an object to pass 2 times to tag."
	icon_state = "pipe-tagger-partial"
	partial = 1

///a three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	name = "sorting junction"
	icon_state = "pipe-j1s"
	desc = "An underfloor disposal pipe with a package sorting mechanism."

	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's filtering objects with the '[sortType]' tag."

/obj/structure/disposalpipe/sortjunction/proc/updatename()
	if(sortType)
		name = "[initial(name)] ([sortType])"
	else
		name = initial(name)

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	posdir = dir
	negdir = turn(posdir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(posdir, 90)

	dpdir = sortdir | posdir | negdir

/obj/structure/disposalpipe/sortjunction/Initialize()
	. = ..()
	if(sortType)
		SSdisposals.tagger_locations |= sortType

	updatedir()
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/attackby(obj/item/attacking_item, mob/user)
	if(..())
		return

	if(istype(attacking_item, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = attacking_item

		if(O.currTag)// Tag set
			sortType = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("Changed filter to '[sortType]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(var/checkTag)
	return sortType == checkTag

/**
 * Next direction to move:
 * If coming in from negdir, then next is primary dir or sortdir.
 * If coming in from posdir, then flip around and go back to posdir.
 * If coming in from sortdir, go to posdir.
 */
/obj/structure/disposalpipe/sortjunction/nextdir(var/fromdir, var/sortTag)
	if(fromdir != sortdir)	// probably came from the negdir
		if(divert_check(sortTag))
			return sortdir
		else
			return posdir
	else				// came from sortdir
						// so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/sortjunction/transfer(var/obj/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/disposalholder/H2 = locate() in P
		if(H2 && !(H2.datum_flags & DF_ISPROCESSING))
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/// a three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "tagged sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."
	subtype = 1

/obj/structure/disposalpipe/sortjunction/wildcard/divert_check(var/checkTag)
	return checkTag != ""

/// junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2

/obj/structure/disposalpipe/sortjunction/untagged/divert_check(var/checkTag)
	return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

/// a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked 	// the linked obj/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/Initialize()
	. = ..()
	dpdir = dir

	update()

	getlinked()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked = null
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D)
		linked = D
		if (!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O)
		linked = O

	update()

/**
 * Override attackby so we disallow trunkremoval when somethings ontop
 */
/obj/structure/disposalpipe/trunk/attackby(obj/item/attacking_item, mob/user)

	//Disposal bins or chutes
	/*
	These shouldn't be required
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D && D.anchored)
		return

	//Disposal outlet
	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O && O.anchored)
		return
	*/

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in src.loc
	if(C && C.anchored)
		return

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/W = attacking_item

		if(W.use(0,user))
			playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
			// check if anything changed over 3 seconds
			to_chat(user, "Slicing the disposal pipe.")
			if(W.use_tool(src, user, 30, volume = 50))
				if(!src || !W.isOn()) return
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")

/*
 * Would transfer to next pipe segment, but we are in a trunk.
 * If not entering from disposal bin, transfer to linked object (outlet or bin)
 */
/obj/structure/disposalpipe/trunk/transfer(var/obj/disposalholder/H)

	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc
	// otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && (H))
			O.expel(H)	// expel at outlet
		else
			var/obj/machinery/disposal/D = linked
			if(H)
				D.expel(H)	// expel at disposal
	else
		if(H)
			src.expel(H, get_turf(src), 0)	// expel at turf
	return null

	// nextdir

/obj/structure/disposalpipe/trunk/nextdir(var/fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0

/obj/structure/disposalpipe/trunk/expel(obj/disposalholder/H)
	if (!linked)
		..(H)

/// A broken pipe.
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/Initialize()
	. = ..()
	update()

/**
 * Called when welded
 * For broken pipe, remove and turn into scrap
 */
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(src.loc)
//	S.set_components(200,0,0)
	qdel(src)

/// The disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/disposals.dmi'
	icon_state = "outlet"
	density = 1
	anchored = 1
	var/active = 0
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/mode = 0

	var/spread = 0
	var/spread_point = 3

/obj/structure/disposaloutlet/Initialize()
	. = ..()
	target = get_ranged_target_turf(src, dir, spread_point)

	var/obj/structure/disposalpipe/trunk/trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/proc/disposal_log(thing)
	LOG_DEBUG("\[[world.time]] Disposals: [thing]")

/obj/structure/disposaloutlet/proc/expel(var/obj/disposalholder/H)
	set waitfor = FALSE
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	intent_message(THUNK_SOUND)

	if(H)
		for(var/atom/movable/AM in H)
			AM.forceMove(src.loc)
			AM.pipe_eject(dir)
			if(!istype(AM,/mob/living/silicon/robot/drone)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				spawn(5)
					if(spread)
						var/turf/new_turf_target = get_step(target,turn(src.dir, rand(-spread,spread)))
						AM.throw_at(new_turf_target, spread_point, 1)
					else
						AM.throw_at(target, spread_point, 1)

		H.vent_gas(src.loc)
		qdel(H)

	return
/*
	// expel the contents of the holder object, then delete it
	// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(var/obj/structure/disposalholder/H)
	disposal_log("[src] [REF(src)] expel([REF(H)])")

	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	disposal_log("[src] ([REF(src)]) registering timers.")
	addtimer(CALLBACK(src, PROC_REF(post_expel, H)), 20, TIMER_UNIQUE|TIMER_CLIENT_TIME)			// Sound + gas.
	addtimer(CALLBACK(src, PROC_REF(post_post_expel, H)), 20 + 5, TIMER_UNIQUE|TIMER_CLIENT_TIME)	// Actually throwing the items.

/obj/structure/disposaloutlet/proc/post_expel(obj/structure/disposalholder/H)
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	disposal_log("[src] ([REF(src)]) post_expel() timer fired.")
	if(H)
		H.vent_gas(src.loc)

/obj/structure/disposaloutlet/proc/throw_object(atom/movable/thing)
	disposal_log("[src] ([REF(src)]) throw_object([thing] [REF(thing)]) at [target] [REF(target)] origin [loc] [REF(loc)]")
	thing.forceMove(loc)
	thing.pipe_eject(dir)
	if (!istype(thing, /mob/living/silicon/robot/drone))
		thing.throw_at(target, 3, 1)

/obj/structure/disposaloutlet/proc/post_post_expel(obj/structure/disposalholder/H)
	disposal_log("[src] [REF(src)] post_post_expel([REF(H)]), [H.contents.len] movables")
	for(var/atom/movable/AM in H)
		AM.forceMove(src.loc)
		AM.pipe_eject(dir)
		if(!istype(AM,/mob/living/silicon/robot/drone)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
			AM.throw_at(target, 3, 1)
	qdel(H)
*/

/obj/structure/disposaloutlet/attackby(obj/item/attacking_item, mob/user)
	if(!attacking_item || !user)
		return
	src.add_fingerprint(user)
	if(attacking_item.isscrewdriver())
		if(mode==0)
			mode=1
			attacking_item.play_tool_sound(get_turf(src), 50)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(mode==1)
			mode=0
			attacking_item.play_tool_sound(get_turf(src), 50)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(attacking_item.iswelder() && mode==1)
		var/obj/item/weldingtool/W = attacking_item
		if(W.use(0,user))
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(W.use_tool(src, user, 20, volume = 50))
				if(!src || !W.isOn()) return
				to_chat(user, "You slice the floorweld off the disposal outlet.")
				var/obj/structure/disposalconstruct/C = new (src.loc)
				src.transfer_fingerprints_to(C)
				C.ptype = 7 // 7 =  outlet
				C.update()
				C.anchored = 1
				C.density = 1
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return

/**
 * Called when movable is expelled from a disposal pipe or outlet
 * By default does nothing, override for special behaviour
 */
/atom/movable/proc/pipe_eject(var/direction)
	return

/**
 * Check if mob has client, if so restore client view on eject
 */
/mob/pipe_eject(var/direction)
	if (src.client)
		src.client.perspective = MOB_PERSPECTIVE
		src.client.eye = src

	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	src.streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	src.streak(dirs)

#undef MODE_OFF
#undef MODE_PRESSURIZING
#undef MODE_READY
#undef MODE_FLUSHING
