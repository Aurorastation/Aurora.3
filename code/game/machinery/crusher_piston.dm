#define PISTON_MOVE_DAMAGE 30
#define PISTON_MOVE_DIVISOR 8

/obj/machinery/crusher_base
	name = "Trash compactor"
	desc = "A colossal piston used for crushing garbage."
	icon = 'icons/obj/machines/crusherbase.dmi'
	icon_state = "standalone"
	anchored = 1
	density = 1

	var/obj/machinery/crusher_piston/pstn //Piston

	var/action = "idle" //Action the piston should perform
	// idle -> Do nothing
	// extend -> Extend the piston
	// retract -> Retract the piston

	var/status = "idle"//The status the piston is in
	// idle -> The piston is idle, doing nothing
	// pre_start -> The piston is pre-starting
	// stage 1 -> The piston is at stage 1
	// stage 2 -> The piston is at stage 2
	// stage 3 -> The piston is at stage 3

	var/asmtype = "standalone" //If the base is a stand alone base or part of a combined crusher
	// standalone -> Standalone base
	// leftcap -> Left piece of a combined crusher
	// middle -> Middle piece of a combined crusher
	// rightcap -> Right piece of a combined crusher

	var/action_start_time = null //The time when the action has been started
	var/time_stage_pre = 20 //The time it takes for the stage to complete
	var/time_stage_1 = 10 //The time it takes for the stage to complete
	var/time_stage_2 = 10 //The time it takes for the stage to complete
	var/time_stage_3 = 10 //The time it takes for the stage to complete
	var/time_stage_full = 10 //The time to wait when the piston is full extendet

	var/list/items_to_move = list() //The list of tiems that should be moved by the piston
	var/list/items_to_crush = list() //The list of items that should be destroyed by the piston

	var/initial = 1 // initial run of the piston process


	var/process_lock = 0 //If the call to process is locked because it is still running

/obj/machinery/crusher_base/New()
	..()

	//Create parts for crusher.
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/crusher(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/crusher_base/Destroy()
	qdel(pstn)
	return ..()

/obj/machinery/crusher_base/initialize()
	action_start_time = world.time

	//Spawn the stage 1 pistons south of it with a density of 0
	log_debug("Spawning Crusher Piston Stage")
	pstn = new(locate(x,y-1,z))
	pstn.crs_base = src

	// Change the icon if theres another base next to it
	change_base_icon()
	// Change the icons of the neighboring bases
	change_neighbor_base_icons()

/obj/machinery/crusher_base/proc/change_neighbor_base_icons()
	var/obj/machinery/crusher_base/left = locate(/obj/machinery/crusher_base, get_step(src, WEST))
	var/obj/machinery/crusher_base/right = locate(/obj/machinery/crusher_base, get_step(src, EAST))
	if (left)
		left.change_base_icon()

	if (right)
		right.change_base_icon()

/obj/machinery/crusher_base/proc/change_base_icon()
	var/obj/machinery/crusher_base/left = locate(/obj/machinery/crusher_base, get_step(src, WEST))
	var/obj/machinery/crusher_base/right = locate(/obj/machinery/crusher_base, get_step(src, EAST))

	if (left && right)
		asmtype = "middle"
		icon_state = "middle"
		log_debug("middle piece")
		return
	if (left)
		asmtype = "rightcap"
		icon_state = "rightcap"
		log_debug("right piece")
		return
	if (right)
		asmtype = "leftcap"
		icon_state = "leftcap"
		log_debug("left piece")
		return
	
	asmtype = "standalone"
	icon_state = "standalone"
	return

/obj/machinery/crusher_base/process()
	set waitfor = FALSE
	if (process_lock)
		log_debug("crusher_piston process() has been called while it was still locked. Aborting")
		return
	process_lock = 1
	var/timediff = (world.time - action_start_time) / 10

	//Check what action should be performed
	if(action == "idle")
		action_start_time = world.time
		initial = 1
	else if(action == "extend")
		//If we are idle, flash the warning lights and then put us into pre_start once we are done
		if(status == "idle")
			if(initial)
				playsound(loc, 'sound/machines/airalarm.ogg', 50, 1)	//Plays a beep
				initial = 0
			//TODO: Flash the lights
			if(timediff > time_stage_pre)
				initial = 1
				status = "pre_start" // Bring us into pre start
				action_start_time = world.time
				

		//We are now ready to expand the first piston
		else if(status == "pre_start")
			//Call extend on all the stage 1 pistons
			if(initial)
				initial = 0
				if(!pstn.extend_0_1())
					status = "idle"
					action = "idle"
					initial = 1
					log_debug("Cant extend piston 0-1 - Continue idling")
			if(timediff > time_stage_1)
				status = "stage1"
				action_start_time = world.time
				initial = 1
		
		//Extend the second piston
		else if(status == "stage1")
			//Call extend on all the stage 2 pistons
			if(initial)
				initial = 0
				if(!pstn.extend_1_2())
					action = "retract"
					log_debug("cant extend piston 1-2 - Retract")
			if(timediff > time_stage_2)
				status = "stage2"
				action_start_time = world.time
				initial = 1

		//Extend the thrid piston
		else if(status == "stage2")
			//Call extend on all the stage 2 pistons
			if(initial)
				initial = 0
				if(!pstn.extend_2_3())
					action = "retract"
					log_debug("cant extend piston 2-3 - retract")
			if(timediff > time_stage_3)
				status = "stage3"
				action_start_time = world.time
				initial = 1
		
		//Wait a moment, then reverse the direction
		else if(status == "stage3")
			if(initial)
				initial = 0
			if(timediff > time_stage_full)
				action = "retract"
				action_start_time = world.time
				initial = 1
	
	//Retract the pistons
	else if(action == "retract")
		//Retract the 3rd stage pistons
		if(status == "stage3")
			if(initial)
				initial = 0
				pstn.retract_3_0()
			if(timediff > time_stage_3) //Once the time is up, reset the icon state
				pstn.icon_state = initial(pstn.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
		if(status == "stage2")
			if(initial)
				initial = 0
				pstn.retract_2_0()
			if(timediff > time_stage_2) //Once the time is up, reset the icon state
				pstn.icon_state = initial(pstn.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
		if(status == "stage1")
			if(initial)
				initial = 0
				pstn.retract_1_0()
			if(timediff > time_stage_1) //Once the time is up, reset the icon state
				pstn.icon_state = initial(pstn.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
	
	//Move all the items in the move list
	for(var/atom/movable/AM in items_to_move)
		if(!AM.simulated)
			items_to_move -= AM
			continue
		if(istype(AM,/obj/machinery/crusher_piston))
			items_to_move -= AM
			continue
		items_to_move -= AM
		//If a item could not be moved. Add it to the crush list
		if(!AM.piston_move())
			items_to_crush += AM
		CHECK_TICK
	
	//Destroy all the items in the crush list
	for(var/atom/movable/AM in items_to_crush)
		items_to_crush -= AM
		AM.crush_act()
		CHECK_TICK

	process_lock = 0


/obj/machinery/crusher_base/proc/crush_start()
	action = "extend"


/obj/machinery/crusher_base/proc/crush_abort()
	//Abort the crush
	//Retract all the pistons, ...
	action = "retract"
	//TODO-Crusher: Add more stages to the piston so retracting will not cause a visual bug


//Piston Stage 1
/obj/machinery/crusher_piston
	name = "Trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	icon = 'icons/obj/machines/crusherpiston.dmi' //Placeholder TODO: Get a proper icon
	icon_state = "piston_0" 
	density = 0
	anchored = 1
	pixel_y = -64
	var/stage = 0 //The stage of the piston
	var/obj/machinery/crusher_base/crs_base //Crusher Base the piston is linked to
	var/obj/effect/piston_blocker/pb1
	var/obj/effect/piston_blocker/pb2
	var/obj/effect/piston_blocker/pb3

/obj/machinery/crusher_piston/Destroy()
	qdel(pb1)
	qdel(pb2)
	qdel(pb3)
	return ..()

/obj/machinery/crusher_piston/proc/extend_0_1()
	for(var/A in get_step(src,SOUTH))
		if(!can_extend_into(A))
			log_debug("cant extend 0-1 - Abort")
			return 0
	icon_state="piston_0_1"
	stage = 1
	pb1 = new(locate(x,y,z))
	for(var/atom/movable/AM in get_turf(locate(x,y,z)))
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/extend_1_2()
	for(var/A in get_step(pb1,SOUTH))
		if(!can_extend_into(A))
			log_debug("cant extend 1-2 - Abort")
			return 0
	icon_state="piston_1_2"
	stage = 2
	pb2 = new(locate(x,y-1,z))
	for(var/atom/movable/AM in get_turf(locate(x,y-1,z)))
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/extend_2_3()
	for(var/A in get_step(pb2,SOUTH))
		if(!can_extend_into(A) && !istype(A,/obj/machinery/crusher_piston))
			log_debug("cant extend 2-3 - Abort")
			return 0
	icon_state="piston_2_3"
	stage = 3
	pb3 = new(locate(x,y-2,z))
	for(var/atom/movable/AM in get_turf(locate(x,y-2,z)))
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/retract_3_0()
	icon_state="piston_3_0"
	stage = 0
	qdel(pb1)
	qdel(pb2)
	qdel(pb3)
/obj/machinery/crusher_piston/proc/retract_2_0()
	icon_state="piston_2_0"
	stage = 0
	qdel(pb1)
	qdel(pb2)
	qdel(pb3)
/obj/machinery/crusher_piston/proc/retract_1_0()
	icon_state="piston_1_0"
	stage = 0
	qdel(pb1)
	qdel(pb2)
	qdel(pb3)

/obj/machinery/crusher_piston/proc/can_extend_into(var/A)
	//Check if atom is of a specific Type
	var/list/unmovable_items = list(
		/turf/simulated/wall,
		/obj/machinery,
		/obj/structure,
		/obj/item/modular_computer/telescreen,
		/obj/item/modular_computer/console,
	)
	log_debug("Checking if \"[A]\" is in unmovable list")
	if (is_type_in_list(A,unmovable_items))
		log_debug("Its in the unmovable list.")
		return 0
	log_debug("not in the unmovable list.")
	return 1

/obj/effect/piston_blocker
	name = "Trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	density = 1
	anchored = 1

//
// The piston_move proc for various objects
//
// Return 1 if it could successfully be moved
// Return 0 if it could not be moved
/atom/movable/proc/piston_move()
	var/turf/T = get_turf(src)

	var/list/valid_turfs = list()
	for(var/dir_to_test in cardinal)
		var/turf/new_turf = get_step(T, dir_to_test)
		if(!new_turf.contains_dense_objects())
			valid_turfs |= new_turf

	while(valid_turfs.len)
		T = pick(valid_turfs)
		valid_turfs -= T

		if(src.forceMove(T))
			return 1
	// We failed to move our target
	return 0

/mob/living/piston_move()
	for(var/i = 1, i <= PISTON_MOVE_DIVISOR, i++)
		adjustBruteLoss(round(PISTON_MOVE_DAMAGE / PISTON_MOVE_DIVISOR))
	AdjustStunned(5)
	AdjustWeakened(5)
	return ..()

/mob/living/carbon/piston_move()
	if(!(species && (species.flags & NO_PAIN)))
		emote("scream")
	return ..()

//Dont call the parent and return 1 to prevent effects from getting moved
/obj/effect/piston_move()
	return 1

//
// The crush act proc
//
/atom/movable/proc/crush_act()
	ex_act(1)
	qdel(src) //Just as a failsafe


#undef PISTON_MOVE_DAMAGE
#undef PISTON_MOVE_DIVISOR