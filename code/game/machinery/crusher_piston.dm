#define PISTON_MOVE_DAMAGE 30
#define PISTON_MOVE_DIVISOR 8

/obj/machinery/crusher_piston/base
	name = "Trash compactor"
	desc = "A colossal piston used for crushing garbage."
	icon = 'icons/obj/machines/research.dmi' //Placeholder
	icon_state = "server" //Placeholder
	anchored = 1
	density = 1

	var/disabled = 0
	var/width = 3
	var/list/bex = list()//Base Expansions
	var/list/piston_stg1 = list() //Stage 1 pistons
	var/list/piston_stg2 = list() //Stage 2 pistons
	var/list/piston_stg3 = list() //Stage 3 pistons

	var/action //Action the piston should perform
	// idle -> Do nothing
	// extend -> Extend the piston
	// retract -> Retract the piston

	var/status = "idle"//The status the piston is in
	// idle -> The piston is idle, doing nothing
	// pre_start -> The piston is pre-starting
	// stage 1 -> The piston is at stage 1
	// stage 2 -> The piston is at stage 2
	// stage 3 -> The piston is at stage 3


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

/obj/machinery/crusher_piston/base/initialize()
	action_start_time = world.time

	//Spawn the other parts of the piston base to the east of the base piston
	for(var/i=2,i<=width,i++)
		log_debug("Spawning Base Expansion")
		var/obj/machinery/crusher_piston/base_expansion/bexp = new(locate(x+i-1,y,z))
		bex += bexp
	
	//Spawn the stage 1 pistons south of it with a density of 0
	for(var/j=1,j<=width,j++)
		log_debug("Spawning Crusher Piston Stage")
		var/obj/machinery/crusher_piston/stage/pstn = new(locate(x+j-1,y-1,z))
		piston_stg1 += pstn
		pstn.crs_base = src

/obj/machinery/crusher_piston/base/process()
	if (process_lock)
		log_debug("crusher_piston process() has been called while it was still locked. Aborting")
	process_lock = 1
	var/timediff = (world.time - action_start_time) / 10
	log_debug("Processing piston base with a timediff of [timediff]")

	//Check what action should be performed
	if(action == "idle")
		action_start_time = world.time
		log_debug("Idling")
		initial = 1
	else if(action == "extend")
		//If we are idle, flash the warning lights and then put us into pre_start once we are done
		if(status == "idle")
			log_debug("Preparing to start the crushing [initial]")
			if(initial)
				playsound(loc, 'sound/machines/airalarm.ogg', 50, 1)	//Plays a beep
				initial = 0
			//TODO: Flash the lights, Sound the alarm
			if(timediff > time_stage_pre)
				initial = 1
				status = "pre_start" // Bring us into pre start
				action_start_time = world.time
				

		//We are now ready to expand the first piston
		else if(status == "pre_start")
			//Call extend on all the stage 1 pistons
			log_debug("Pre Start [initial]")
			if(initial)
				log_debug("Extending Stage 1 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg1)
					pstn.extend()
			if(timediff > time_stage_1)
				status = "stage1"
				action_start_time = world.time
				initial = 1
		
		//Extend the second piston
		else if(status == "stage1")
			//Call extend on all the stage 2 pistons
			log_debug("Stage 1 [initial]")
			if(initial)
				log_debug("Extending Stage 2 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg2)
					pstn.extend()
			if(timediff > time_stage_2)
				status = "stage2"
				action_start_time = world.time
				initial = 1

		//Extend the thrid piston
		else if(status == "stage2")
			//Call extend on all the stage 2 pistons
			log_debug("Stage 2 [initial]")
			if(initial)
				log_debug("Extending Stage 3 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg3)
					pstn.extend()
			if(timediff > time_stage_3)
				status = "stage3"
				action_start_time = world.time
				initial = 1
		
		//Wait a moment, then reverse the direction
		else if(status == "stage3")
			log_debug("Stage 3 [initial]")
			if(initial)
				log_debug("waiting during stage 3")
				initial = 0
			if(timediff > time_stage_full)
				action = "retract"
				action_start_time = world.time
				initial = 1
	
	//Retract the pistons
	else if(action == "retract")
		//Retract the 3rd stage pistons
		if(status == "stage3")
			log_debug("Stage 3 - Retract [initial]")
			if(initial)
				log_debug("Retracting Stage 3 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg3)
					pstn.retract()
			if(timediff > time_stage_3) //Once the time is up, move to stage 2
				status = "stage2"
				action_start_time = world.time
				initial = 1
		
		//Retract the 2nd stage pistons
		else if(status == "stage2")
			log_debug("Stage 2 - Retract [initial]")
			if(initial)
				log_debug("Retracting Stage 2 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg3)
					pstn.retract_out()
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg2)
					pstn.retract()
			if(timediff > time_stage_2) //Once the time is up, move to stage 1
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg3)
					//Change the img here to a retracting sprite
					piston_stg3 -= pstn
					qdel(pstn)
				status = "stage1"
				action_start_time = world.time
				initial = 1

		else if(status == "stage1")
			log_debug("Stage 1 - Retract [initial]")
			if(initial)
				log_debug("Retracting Stage 1 Pistons")
				initial = 0
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg2)
					pstn.retract_out()
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg1)
					pstn.retract()
			if(timediff > time_stage_1) //Once the time is up, reset the icon state
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg2)
					piston_stg2 -= pstn
					qdel(pstn)
				for(var/obj/machinery/crusher_piston/stage/pstn in piston_stg1)
					pstn.icon_state = initial(pstn.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
	
	//Move all the items in the move list
	for(var/atom/movable/AM in items_to_move)
		log_debug("Moving item [AM]")
		if(istype(AM,/obj/machinery/crusher_piston/stage))
			log_debug("Moving item [AM] is a piston - ignoring")
			items_to_move -= AM
			continue
		items_to_move -= AM
		if(!AM.piston_move())
			items_to_crush += AM
		CHECK_TICK
	
	//Destroy all the items in the crush list
	for(var/atom/movable/AM in items_to_crush)
		log_debug("Crushing item [AM]")
		items_to_crush -= AM
		AM.ex_act(1)
		qdel(AM) //Just as a failsafe
		//TODO: Maybe spawn some debris ??
		CHECK_TICK

	process_lock = 0


/obj/machinery/crusher_piston/base/proc/crush_start()
	log_debug("Crush started")
	action = "extend"


/obj/machinery/crusher_piston/base/proc/crush_abort()
	//Abort the crush
	//Retract all the pistons, ...
	log_debug("Crush aborted")
	action = "retract"


//Epxansion of the piston base
//TODO: Add a logic to select the proper icon on spawning
/obj/machinery/crusher_piston/base_expansion
	name = "Trash compactor base" //TODO: Change the name
	desc = "Base of the trash compactor" //TODO: Change the name
	icon = 'icons/obj/machines/research.dmi' //Placeholder
	icon_state = "server" //Placeholder
	density = 1
	anchored = 1
	var/num = 1 //Number of the expansion

//Piston Stage 1
/obj/machinery/crusher_piston/stage
	name = "Trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	icon = 'icons/obj/machines/trashcompressor.dmi' //Placeholder TODO: Get a proper icon
	icon_state = "stage1-retracted-in" //Placeholder TODO: Select a proper initial icon state
	density = 0
	anchored = 1
	var/status = 0 //0 - Retracted, 1 - Extendet
	var/stage = 1 //The stage of the piston //TODO: Use that to select a proper icon
	var/obj/machinery/crusher_piston/base/crs_base //Crusher Base the piston is linked to

/obj/machinery/crusher_piston/stage/New()
	icon_state = "stage[stage]-retracted-in"

/obj/machinery/crusher_piston/stage/proc/extend()
	if(status == 0) //Only extend if the piston is not already extendet
		density = 1
		icon_state = "stage[stage]-extend"
		status = 1
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				crs_base.items_to_move += AM
		//Spawn the stage 2 and 3 to the south
		if(stage < 3)
			var/obj/machinery/crusher_piston/stage/pstn = new(locate(x,y-1,z))
			pstn.stage = stage + 1
			pstn.icon_state = "stage[stage+1]-retracted-in"
			pstn.crs_base = crs_base
			if(stage == 1)
				crs_base.piston_stg2 += pstn
			else if(stage == 2)
				crs_base.piston_stg3 += pstn
			else
				log_debug("Something went wrong during extending the crusher piston at stage [stage]")
				qdel(pstn)

/obj/machinery/crusher_piston/stage/proc/retract()
	if(status == 1) //Only retract, if the piston is not already retracted
		density = 0
		icon_state = "stage[stage]-retract"
		status = 0

/obj/machinery/crusher_piston/stage/proc/retract_out()
	if(status == 0) //Only retract out of the piston is already retracted
		density = 0
		icon_state = "stage[stage]-retract-out"


//
// The piston_move proc for various objects
//
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
			var/mob/living/lvg = src
			if(istype(lvg,/mob/living))
				for(var/i = 1, i <= PISTON_MOVE_DIVISOR, i++)
					lvg.adjustBruteLoss(round(PISTON_MOVE_DAMAGE / PISTON_MOVE_DIVISOR))
				lvg.SetStunned(5)
				lvg.SetWeakened(5)
			return 1
	// We failed to move our target
	return 0

/mob/living/carbon/piston_move(var/crush_damage)
	if (!(species && (species.flags & NO_PAIN)))
		emote("scream")
	. = ..()

#undef PISTON_MOVE_DAMAGE
#undef PISTON_MOVE_DIVISOR