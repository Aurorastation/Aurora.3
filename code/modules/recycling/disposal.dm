// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE) //kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define PRESSURE_TANK_VOLUME 150	//L
#define PUMP_MAX_FLOW_RATE 90		//L/s - 4 m/s using a 15 cm by 15 cm inlet

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = 1
	density = 1
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/Initialize()
	. = ..()
	trunk = locate() in src.loc
	if(!trunk)
		mode = 0
		flush = 0
	else
		trunk.linked = src	// link the pipe trunk to self

	air_contents = new/datum/gas_mixture(PRESSURE_TANK_VOLUME)
	update()

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	return ..()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(var/obj/item/I, var/mob/user)
	if(stat & BROKEN || !I || !user)
		return

	src.add_fingerprint(user)
	if(mode<=0) // It's off
		if(I.isscrewdriver())
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode==0) // It's off but still not unscrewed
				mode=-1 // Set it to doubleoff l0l
				playsound(src.loc, I.usesound, 50, 1)
				to_chat(user, "You remove the screws around the power connection.")
				return
			else if(mode==-1)
				mode=0
				playsound(src.loc, I.usesound, 50, 1)
				to_chat(user, "You attach the screws around the power connection.")
				return
		else if(I.iswelder() && mode==-1)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			var/obj/item/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "You start slicing the floorweld off the disposal unit.")

				if(do_after(user,20/W.toolspeed))
					if(!src || !W.isOn()) return
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C = new (src.loc)
					src.transfer_fingerprints_to(C)
					C.ptype = 6 // 6 = disposal unit
					C.anchored = 1
					C.density = 1
					C.update()
					qdel(src)
				return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return
	if(istype(I, /obj/item/melee/energy/blade))
		to_chat(user, "You can't place that item inside the disposal unit.")
		return

	if(istype(I, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, "<span class='notice'>You empty the bag.</span>")
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O,src)
		T.update_icon()
		update()
		return

	else if (istype (I, /obj/item/device/lightreplacer))
		var/count = 0
		var/obj/item/device/lightreplacer/R = I
		if (R.store_broken)
			for(var/obj/item/light/L in R.contents)
				count++
				L.forceMove(src)

			if (count)
				to_chat(user, "<span class='notice'>You empty [count] broken bulbs into the disposal.</span>")
			else
				to_chat(user, "<span class='notice'>There are no broken bulbs to empty out.</span>")
			update()
			return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			for (var/mob/V in viewers(usr))
				V.show_message("[usr] starts putting [GM.name] into the disposal.", 3)
			if(do_after(usr, 20))
				if (GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.forceMove(src)
				for (var/mob/C in viewers(src))
					C.show_message("<span class='warning'>[GM.name] has been placed in the [src] by [user].</span>", 3)
				qdel(G)
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [GM.name] ([GM.ckey]) in disposals.</font>")
				GM.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [usr.name] ([usr.ckey])</font>")
				msg_admin_attack("[key_name_admin(usr)] placed [key_name_admin(GM)] in a disposals unit. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)",ckey=key_name(usr),ckey_target=key_name(GM))
		return
	if(!dropsafety(I))
		return

	if(!I)
		return

	user.drop_from_inventory(I,src)

	to_chat(user, "You place \the [I] into the [src].")
	for(var/mob/M in viewers(src))
		if(M == user)
			continue
		M.show_message("[user.name] places \the [I] into the [src].", 3)

	update()

// mouse drop another mob or self
//
/obj/machinery/disposal/MouseDrop_T(mob/target, mob/user)
	if(user.stat || !user.canmove || !istype(target))
		return
	if(target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1)
		return

	//animals cannot put mobs other than themselves into disposal
	if(isanimal(user) && target != user)
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
	if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)	// if drop self, then climbed in
											// must be awake, not stunned or whatever
		msg = "[user.name] climbs into the [src]."
		to_chat(user, "You climb into the [src].")
	else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		msg = "[user.name] stuffs [target.name] into the [src]!"
		to_chat(user, "You stuff [target.name] into the [src]!")

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [target.name] ([target.ckey]) in disposals.</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [user.name] ([user.ckey])</font>")
		msg_admin_attack("[user] ([user.ckey]) placed [target] ([target.ckey]) in a disposals unit. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
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
	return

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user as mob)
	if(user.stat || src.flushing)
		return
	if(user.loc == src)
		src.go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)

	if (user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(src.loc)
	update()
	return

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user as mob)
	interact(user, 1)

// human interact with machine
/obj/machinery/disposal/attack_hand(mob/user as mob)

	if(stat & BROKEN)
		return

	if(user && user.loc == src)
		to_chat(usr, "<span class='warning'>You cannot reach the controls from inside.</span>")
		return

	// Clumsy folks can only flush it.
	if(user.IsAdvancedToolUser(1))
		interact(user, 0)
	else
		flush = !flush
		update()
	return

// user interaction
/obj/machinery/disposal/interact(mob/user, var/ai=0)

	src.add_fingerprint(user)
	if(stat & BROKEN)
		user.unset_machine()
		return

	var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

		dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100* air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: [round(per, 1)]%<BR></body>"


	user.set_machine(src)
	user << browse(dat, "window=disposal;size=360x170")
	onclose(user, "disposal")

// handle machine interaction

/obj/machinery/disposal/Topic(href, href_list)
	if(usr.loc == src)
		to_chat(usr, "<span class='warning'>You cannot reach the controls from inside.</span>")
		return

	if(mode==-1 && !href_list["eject"]) // only allow ejecting if mode is -1
		to_chat(usr, "<span class='warning'>The disposal units power is disabled.</span>")
		return
	if(..())
		return

	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained() || src.flushing)
		return

	if(istype(src.loc, /turf))
		usr.set_machine(src)

		if(href_list["close"])
			usr.unset_machine()
			usr << browse(null, "window=disposal")
			return

		if(href_list["pump"])
			if(text2num(href_list["pump"]))
				mode = 1
			else
				mode = 0
			update()

		if(!isAI(usr))
			if(href_list["handle"])
				flush = text2num(href_list["handle"])
				update()

			if(href_list["eject"])
				eject()
	else
		usr << browse(null, "window=disposal")
		usr.unset_machine()
		return
	return

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(src.loc)
		AM.pipe_eject(0)
	update()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/proc/update()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = 0
		flush = 0
		return

	// flush handle
	if(flush)
		add_overlay("dispover-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == -1)
		return

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		add_overlay("dispover-full")

	// charging and ready light
	if(mode == 1)
		add_overlay("dispover-charge")
	else if(mode == 2)
		add_overlay("dispover-ready")

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/machinery_process()
	if(!air_contents || (stat & BROKEN))			// nothing can happen if broken
		update_use_power(0)
		return

	flush_count++
	if( flush_count >= flush_every_ticks )
		if( contents.len )
			if(mode == 2)
				spawn(0)
					feedback_inc("disposal_auto_flush",1)
					flush()
		flush_count = 0

	src.updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE )	// flush can happen even without power
		flush()

	if(mode != 1) //if off or ready, no need to charge
		update_use_power(1)
	else if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = 2 //if full enough, switch to ready mode
		update()
	else
		src.pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	if(stat & NOPOWER)			// won't charge if no power
		update_use_power(0)
		return

	var/atom/L = loc						// recharging from loc turf
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles	//group_multiplier is divided out here
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power(power_draw)

// perform a flush
/obj/machinery/disposal/proc/flush()
	set waitfor = FALSE

	flushing = 1
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
	sleep(5) // wait for animation to finish


	H.init(src, air_contents)	// copy the contents of disposer to holder
	air_contents = new(PRESSURE_TANK_VOLUME)	// new empty gas resv.

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return


// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update()	// update icon
	return


// called when holder is expelled from a disposal
// should usually only occur if the pipe network is modified
/obj/machinery/disposal/proc/expel(var/obj/disposalholder/H)

	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(H) // Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.forceMove(src.loc)
			AM.pipe_eject(0)
			if(!istype(AM,/mob/living/silicon/robot/drone)) //Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
				addtimer(CALLBACK(AM, /atom/movable/.proc/throw_at, target, 5, 1), 1)

		H.vent_gas(loc)
		qdel(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(75))
			I.forceMove(src)
			for(var/mob/M in viewers(src))
				M.show_message("\The [I] lands in \the [src].", 3)
		else
			for(var/mob/M in viewers(src))
				M.show_message("\The [I] bounces off of \the [src]'s rim!", 3)
		return 0
	else
		return ..(mover, target, height, air_group)

// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/disposalholder
	invisibility = 101
	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	dir = 0
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/hasmob = 0 //If it contains a mob

	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.

	var/tmp/obj/structure/disposalpipe/tick_last

	// initialize a holder from the contents of a disposal unit
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


	// start the movement process
	// argument is the disposal unit the holder started in
/obj/disposalholder/proc/start(var/obj/machinery/disposal/D)
	if(!D.trunk)
		D.expel(src)	// no trunk connected, so expel immediately
		return

	forceMove(D.trunk)
	set_dir(DOWN)
	START_PROCESSING(SSdisposals, src)

/obj/disposalholder/process()	// For the new SSdisposals-based movement.
	if (hasmob && prob(3))
		for(var/mob/living/H in src)
			if(!istype(H,/mob/living/silicon/robot/drone)) //Drones use the mailing code to move through the disposal system,
				H.take_overall_damage(20, 0, "Blunt Trauma")//horribly maim any living creature jumping down disposals.  c'est la vie

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

// find the turf which should contain the next pipe
/obj/disposalholder/proc/nextloc()
	return get_step(loc,dir)

	// find a matching pipe on a turf
/obj/disposalholder/proc/findpipe(var/turf/T)
	if(!T)
		return null

	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.dpdir)		// find pipe direction mask that matches flipped dir
			return P
	// if no matching pipe, return null
	return null

	// merge two holder objects
	// used when a a holder meets a stuck holder
/obj/disposalholder/proc/merge(obj/disposalholder/other)
	for(var/atom/movable/AM in other)
		AM.forceMove(src)		// move everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)	// if a client mob, update eye to follow this holder
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


	// called when player tries to move while in a pipe
/obj/disposalholder/relaymove(mob/user as mob)
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

	// called to vent all gas in holder to a location
/obj/disposalholder/proc/vent_gas(atom/location)
	location.assume_air(gas)  // vent all gas to turf

/obj/disposalholder/Destroy()
	STOP_PROCESSING(SSdisposals, src)
	QDEL_NULL(gas)
	tick_last = null
	return ..()

// Disposal pipes

/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = 1
	density = 0

	level = 1			// underfloor only
	var/dpdir = 0		// bitmask of pipe directions
	dir = 0				// dir will contain dominant direction for junction pipes
	var/health = 10 	// health points 0-10
	layer = 2.3			// slightly lower than wires and other pipes
	var/base_icon_state	// initial icon state on map
	var/sortType = ""
	var/subtype = 0
	// new pipe, set the icon_state as on map

/obj/structure/disposalpipe/Initialize()
	. = ..()
	base_icon_state = icon_state

// pipe is deleted
// ensure if holder is present, it is expelled
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

// returns the direction of the next pipe object, given the entrance dir
// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(var/fromdir)
	return dpdir & (~turn(fromdir, 180))

// transfer the holder through this pipe segment
// overriden for special behaviour
//
/obj/structure/disposalpipe/proc/transfer(var/obj/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/disposalholder/H2 = locate() in P
		if(H2 && !H2.isprocessing)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = src.loc
	hide(!T.is_plating() && !istype(T,/turf/space))	// space never hides pipes

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalpipe/hide(var/intact)
	invisibility = intact ? 101: 0	// hide if floor is intact
	updateicon()

// update actual icon_state depending on visibility
// if invisible, append "f" to icon_state to show faded version
// this will be revealed if a T-scanner is used
// if visible, use regular icon_state
/obj/structure/disposalpipe/proc/updateicon()
/*		if(invisibility)	//we hide things with alpha now, no need for transparent icons
		icon_state = "[base_icon_state]f"
	else
		icon_state = base_icon_state*/
	icon_state = base_icon_state
	return


	// expel the held objects into a turf
	// called when there is a break in the pipe
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
				addtimer(CALLBACK(AM, /atom/movable/.proc/throw_at, target, 100, 1), 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				addtimer(CALLBACK(AM, /atom/movable/.proc/throw_at, target, 5, 1), 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)

// call to break the pipe
// will expel any holder inside at the time
// then delete the pipe
// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(var/remains = 0)
	if(remains)
		for(var/D in cardinal)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(src.loc)
				P.set_dir(D)

	src.invisibility = 101	// make invisible (since we won't delete the pipe immediately)
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


// pipe affected by explosion
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


// test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health<1)
		broken(1)

//attack by item
//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(var/obj/item/I, var/mob/user)
	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(I.iswelder())
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			// check if anything changed over 3 seconds
			to_chat(user, "Slicing the disposal pipe...")
			if (do_after(user, 3/W.toolspeed SECONDS, act_target = src))
				if(!src || !W.isOn()) return
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")

// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()
	var/obj/structure/disposalconstruct/C = new (src.loc)
	switch(base_icon_state)
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

// pipe is deleted
// ensure if holder is present, it is expelled
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

/obj/structure/disposalpipe/hides_under_flooring()
	return 1

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/disposalholder/H in world)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/Initialize()
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)

	update()

///// Z-Level stuff
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
		T = GetAbove(src)
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
		if(H2 && !H2.isprocessing)
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
		T = GetBelow(src)
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
		if(H2 && !H2.isprocessing)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
///// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

//a three-way junction with dir being the dominant direction
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

// next direction to move
// if coming in from secondary dirs, then next is primary dir
// if coming in from primary dir, then next is equal chance of other dirs
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

/obj/structure/disposalpipe/tagger/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Changed tag to '[sort_tag]'.</span>")
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

//a three-way junction that sorts objects
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

/obj/structure/disposalpipe/sortjunction/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return

	if(istype(I, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = I

		if(O.currTag)// Tag set
			sortType = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Changed filter to '[sortType]'.</span>")
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(var/checkTag)
	return sortType == checkTag

// next direction to move
// if coming in from negdir, then next is primary dir or sortdir
// if coming in from posdir, then flip around and go back to posdir
// if coming in from sortdir, go to posdir

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
		if(H2 && !H2.isprocessing)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

//a three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "tagged sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."
	subtype = 1
	divert_check(var/checkTag)
		return checkTag != ""

//junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2
	divert_check(var/checkTag)
		return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

//a trunk joining to a disposal bin or outlet on the same turf
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

// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(var/obj/item/I, var/mob/user)

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
	if(I.iswelder())
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			// check if anything changed over 3 seconds
			to_chat(user, "Slicing the disposal pipe.")
			if (do_after(user, 3/W.toolspeed SECONDS, act_target = src))
				if(!src || !W.isOn()) return
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")

// would transfer to next pipe segment, but we are in a trunk
// if not entering from disposal bin,
// transfer to linked object (outlet or bin)
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

// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/Initialize()
	. = ..()
	update()

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(src.loc)
//	S.set_components(200,0,0)
	qdel(src)

// the disposal outlet machine

/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
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
	log_debug("\[[world.time]] Disposals: [thing]")

/obj/structure/disposaloutlet/proc/expel(var/obj/disposalholder/H)
	set waitfor = FALSE
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

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
	disposal_log("[src] \ref[src] expel(\ref[H])")

	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	disposal_log("[src] (\ref[src]) registering timers.")
	addtimer(CALLBACK(src, .proc/post_expel, H), 20, TIMER_UNIQUE|TIMER_CLIENT_TIME)			// Sound + gas.
	addtimer(CALLBACK(src, .proc/post_post_expel, H), 20 + 5, TIMER_UNIQUE|TIMER_CLIENT_TIME)	// Actually throwing the items.

/obj/structure/disposaloutlet/proc/post_expel(obj/structure/disposalholder/H)
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	disposal_log("[src] (\ref[src]) post_expel() timer fired.")
	if(H)
		H.vent_gas(src.loc)

/obj/structure/disposaloutlet/proc/throw_object(atom/movable/thing)
	disposal_log("[src] (\ref[src]) throw_object([thing] \ref[thing]) at [target] \ref[target] origin [loc] \ref[loc]")
	thing.forceMove(loc)
	thing.pipe_eject(dir)
	if (!istype(thing, /mob/living/silicon/robot/drone))
		thing.throw_at(target, 3, 1)

/obj/structure/disposaloutlet/proc/post_post_expel(obj/structure/disposalholder/H)
	disposal_log("[src] \ref[src] post_post_expel(\ref[H]), [H.contents.len] movables")
	for(var/atom/movable/AM in H)
		AM.forceMove(src.loc)
		AM.pipe_eject(dir)
		if(!istype(AM,/mob/living/silicon/robot/drone)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
			AM.throw_at(target, 3, 1)
	qdel(H)
*/

/obj/structure/disposaloutlet/attackby(var/obj/item/I, var/mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user)
	if(I.isscrewdriver())
		if(mode==0)
			mode=1
			playsound(src.loc, I.usesound, 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(mode==1)
			mode=0
			playsound(src.loc, I.usesound, 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(I.iswelder() && mode==1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(do_after(user,20/W.toolspeed))
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

// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour

/atom/movable/proc/pipe_eject(var/direction)
	return

// check if mob has client, if so restore client view on eject
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
		dirs = alldirs.Copy()

	src.streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = alldirs.Copy()

	src.streak(dirs)
