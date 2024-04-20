#define MAX_CONVEYOR_ITEMS_MOVE 20
//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor0"
	name = "conveyor belt"
	desc = "A conveyor belt."
	layer = BELOW_OBJ_LAYER
	anchored = 1
	var/operating = 0	// 1 if running forward, -1 if backwards, 0 if off
	var/operable = 1	// true if can operate (no broken segments in this belt run)
	var/forwards		// this is the default (forward) direction, set by the map dir
	var/backwards		// hopefully self-explanatory
	var/movedir			// the actual direction to move stuff in
	var/reversed		// se to 1 if the belt is reversed
	var/conveying = FALSE

	var/id = ""			// the control ID	- must match controller ID

	var/listener/antenna

/obj/machinery/conveyor/centcom_auto
	id = "round_end_belt"

	// create a conveyor
/obj/machinery/conveyor/Initialize(mapload, newdir, on = 0)
	. = ..()
	if(newdir)
		set_dir(newdir)

	if(dir & (dir-1)) // Diagonal. Forwards is *away* from dir, curving to the right.
		forwards = turn(dir, 135)
		backwards = turn(dir, 45)
	else
		forwards = dir
		backwards = turn(dir, 180)

	if(on)
		operating = reversed ? -1 : 1
		setmove()

	if (id)
		antenna = new(id, src)

/obj/machinery/conveyor/Destroy()
	QDEL_NULL(antenna)
	return ..()

/obj/machinery/conveyor/proc/setmove()
	if(operating == 1)
		movedir = forwards
	else if(operating == -1)
		movedir = backwards
	else operating = 0
	update()

/obj/machinery/conveyor/proc/update()
	if(stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = 0
		return
	if(!operable)
		operating = 0
	if(stat & NOPOWER)
		operating = 0
	icon_state = "conveyor[operating]"

	// machine process
	// move items to the target location
/obj/machinery/conveyor/process()
	if(stat & (BROKEN | NOPOWER))
		return
	if(!operating || conveying)
		return

	if (!loc)
		stat |= BROKEN
		return

	use_power_oneoff(100)

	var/turf/locturf = loc
	var/list/items = locturf.contents - src
	if(!length(items))
		return
	var/list/affecting
	if(length(items) > MAX_CONVEYOR_ITEMS_MOVE)
		affecting = items.Copy(1, MAX_CONVEYOR_ITEMS_MOVE + 1)
	else
		affecting = items
	conveying = TRUE

	addtimer(CALLBACK(src, PROC_REF(post_process), affecting),1)

/obj/machinery/conveyor/proc/post_process(var/list/affecting)
	for(var/af in affecting)
		if(!ismovable(af))
			continue

		//If we're overrunning the tick, abort and we will continue at the next machine processing
		if(TICK_CHECK)
			break

		var/atom/movable/mv = af
		if(QDELETED(mv) || (mv.loc != loc))
			continue
		if(!mv.simulated)
			continue

		if(!mv.anchored && mv.simulated && has_gravity(mv))
			mv.conveyor_act(movedir)

	conveying = FALSE

/atom/movable/proc/conveyor_act(move_dir)
	set waitfor = FALSE
	step(src, move_dir)

/obj/effect/conveyor_act()
	return

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscrowbar())
		if(!(stat & BROKEN))
			var/obj/item/conveyor_construct/C = new/obj/item/conveyor_construct(src.loc)
			C.id = id
			transfer_fingerprints_to(C)
		to_chat(user, "<span class='notice'>You remove the conveyor belt.</span>")
		qdel(src)
		return
	if(isrobot(user))
		return //Carn: fix for borgs dropping their modules on conveyor belts
	if(attacking_item.loc != user)
		return // This should stop mounted modules ending up outside the module.

	user.drop_item(get_turf(src))

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	return


// make the conveyor broken
// also propagate inoperability to any connected conveyor with the same ID
/obj/machinery/conveyor/proc/broken()
	stat |= BROKEN
	update()

	var/obj/machinery/conveyor/C = locate() in get_step(src, dir)
	if(C)
		C.set_operable(dir, id, 0)

	C = locate() in get_step(src, turn(dir,180))
	if(C)
		C.set_operable(turn(dir,180), id, 0)


//set the operable var if ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(stepdir, match_id, op)

	if(id != match_id)
		return
	operable = op

	update()
	var/obj/machinery/conveyor/C = locate() in get_step(src, stepdir)
	if(C)
		C.set_operable(stepdir, id, op)

/*
/obj/machinery/conveyor/verb/destroy()
	set src in view()
	src.broken()
*/

/obj/machinery/conveyor/power_change()
	..()
	update()

// the conveyor control switch
//
//

/obj/machinery/conveyor_switch

	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = 0			// 0 off, -1 reverse, 1 forward
	var/last_pos = -1			// last direction setting
	var/operated = 1			// true if just operated

	var/id = "" 				// must match conveyor IDs to control them

	anchored = 1

/obj/machinery/conveyor_switch/Initialize(mapload, newid)
	. = ..()
	if(!id)
		id = newid
	update()

// update the icon depending on the position

/obj/machinery/conveyor_switch/proc/update()
	if(position < 0)
		icon_state = "switch-rev"
	else if(position > 0)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	if(position == 0)
		if(last_pos < 0)
			position = 1
			last_pos = 0
		else
			position = -1
			last_pos = 0
	else
		last_pos = position
		position = 0

	operated = 1
	update()

	for (var/thing in GET_LISTENERS(id))
		var/listener/L = thing
		var/obj/machinery/conveyor/C = L.target
		if (istype(C))
			C.operating = C.reversed ? position * - 1 : position
			C.setmove()
		else
			var/obj/machinery/conveyor_switch/S = L.target
			if (istype(S))
				S.position = position
				S.update()

/obj/machinery/conveyor_switch/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.iscrowbar())
		var/obj/item/conveyor_switch_construct/C = new/obj/item/conveyor_switch_construct(src.loc)
		C.id = id
		transfer_fingerprints_to(C)
		to_chat(user, "<span class='notice'>You deattach the conveyor switch.</span>")
		qdel(src)

/obj/machinery/conveyor_switch/oneway
	var/convdir = 1 //Set to 1 or -1 depending on which way you want the convayor to go. (In other words keep at 1 and set the proper dir on the belts.)
	desc = "A conveyor control switch. It appears to only go in one direction."

// attack with hand, switch position
/obj/machinery/conveyor_switch/oneway/attack_hand(mob/user)
	if(position == 0)
		position = convdir
	else
		position = 0

	operated = 1
	update()

	for (var/thing in GET_LISTENERS(id))
		var/listener/L = thing
		var/obj/machinery/conveyor/C = L.target
		if (istype(C))
			C.operating = C.reversed ? position * - 1 : position
			C.setmove()
		else
			var/obj/machinery/conveyor_switch/S = L.target
			if (istype(S))
				S.position = position
				S.update()

//
// CONVEYOR CONSTRUCTION STARTS HERE
//

/obj/item/conveyor_construct
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor0"
	name = "conveyor belt assembly"
	desc = "A conveyor belt assembly."
	w_class = ITEMSIZE_LARGE
	var/id = "" //inherited by the belt

/obj/item/conveyor_construct/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/conveyor_switch_construct))
		to_chat(user, "<span class='notice'>You link the switch to the conveyor belt assembly.</span>")
		var/obj/item/conveyor_switch_construct/C = attacking_item
		id = C.id
		return TRUE

/obj/item/conveyor_construct/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !istype(A, /turf/simulated/floor) || istype(A, /area/shuttle) || user.incapacitated())
		return
	var/cdir = get_dir(A, user)
	if(!(cdir in GLOB.cardinal) || A == user.loc)
		return
	for(var/obj/machinery/conveyor/CB in A)
		if(CB.dir == cdir || CB.dir == turn(cdir,180))
			return
		cdir |= CB.dir
		qdel(CB)
	var/obj/machinery/conveyor/C = new/obj/machinery/conveyor(A,cdir)
	C.id = id
	transfer_fingerprints_to(C)
	qdel(src)

/obj/item/conveyor_switch_construct
	name = "conveyor switch assembly"
	desc = "A conveyor control switch assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	w_class = ITEMSIZE_LARGE
	var/id = "" //inherited by the switch

/obj/item/conveyor_switch_construct/New()
	..()
	id = rand() //this couldn't possibly go wrong

/obj/item/conveyor_switch_construct/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !istype(A, /turf/simulated/floor) || istype(A, /area/shuttle) || user.incapacitated())
		return
	var/found = 0
	for(var/obj/machinery/conveyor/C in view())
		if(C.id == src.id)
			found = 1
			break
	if(!found)
		to_chat(user, "[icon2html(src, user)]<span class=notice>The conveyor switch did not detect any linked conveyor belts in range.</span>")
		return
	var/obj/machinery/conveyor_switch/NC = new/obj/machinery/conveyor_switch(A, id)
	transfer_fingerprints_to(NC)
	qdel(src)

#undef MAX_CONVEYOR_ITEMS_MOVE
