/obj/vehicle/train
	name = "train"
	dir = 4

	move_delay = 1

	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/passenger_allowed = 1

	var/active_engines = 0
	var/train_length = 0

	var/obj/vehicle/train/lead
	var/obj/vehicle/train/tow

	can_hold_mob = TRUE


//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/setup_vehicle()
	..()
	for(var/obj/vehicle/train/T in orange(1, src))
		latch(T)

/obj/vehicle/train/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(lead)
		. += SPAN_NOTICE("It is being towed by \the [lead] in the [dir2text(get_dir(src, lead))].")
	if(tow)
		. += SPAN_NOTICE("It towing \the [tow] in the [dir2text(get_dir(src, tow))].")

/obj/vehicle/train/Move()
	var/old_loc = get_turf(src)
	if(..())
		if(tow)
			tow.Move(old_loc)
		return 1
	else
		if(lead)
			unattach()
		return 0

/obj/vehicle/train/Collide(atom/Obstacle)
	. = ..()
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(emagged)
		if(isliving(A))
			var/mob/living/M = A
			visible_message(SPAN_WARNING("[src] knocks over [M]!"))
			var/def_zone = ran_zone()
			M.apply_effects(5, 5)				//knock people down if you hit them
			M.apply_damage(22 / move_delay, DAMAGE_BRUTE, def_zone,)	// and do damage according to how fast the train is going
			if(isliving(load))
				var/mob/living/D = load
				to_chat(D, SPAN_WARNING("You hit [M]!"))
				msg_admin_attack("[D.name] ([D.ckey]) hit [M.name] ([M.ckey]) with [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(D),ckey_target=key_name(M))


//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/train/explode()
	if (tow)
		tow.unattach()
	unattach()
	..()


//-------------------------------------------
// Interaction procs
//-------------------------------------------

/obj/vehicle/train/MouseDrop_T(atom/dropping, mob/user)
	if(use_check_and_message(user))
		return
	if(istype(dropping, /obj/vehicle/train))
		latch(dropping, user)
	else
		if(!load(dropping))
			to_chat(user, SPAN_WARNING("You were unable to load \the [dropping] on \the [src]."))

/obj/vehicle/train/attack_hand(mob/user as mob)
	if(use_check_and_message(user))
		return 0

	if(user != load && (user in src))
		user.forceMove(loc)			//for handling players stuck in src
	else if(load)
		unload(user)			//unload if loaded

/obj/vehicle/train/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 70)
		unattach(user)
		return
	return ..()

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

//attempts to attach src as a follower of the train T
//Note: there is a modified version of this in code\modules\vehicles\cargo_train.dm specifically for cargo train engines
/obj/vehicle/train/proc/attach_to(obj/vehicle/train/T, mob/user)
	if (get_dist(src, T) > 1)
		to_chat(user, SPAN_WARNING("\The [src] is too far away from \the [T] to hitch them together."))
		return

	if (lead)
		to_chat(user, SPAN_WARNING("\The [src] is already hitched to something."))
		return

	if (T.tow)
		to_chat(user, SPAN_WARNING("\The [T] is already towing something."))
		return

	//check for cycles.
	var/obj/vehicle/train/next_car = T
	while (next_car)
		if (next_car == src)
			to_chat(user, SPAN_WARNING("That seems very silly."))
			return
		next_car = next_car.lead

	//latch with src as the follower
	src.lead = T
	T.tow = src
	set_dir(get_dir(src, lead))
	to_chat(user, SPAN_NOTICE("You hitch \the [src] to \the [T]."))
	playsound(loc, 'sound/items/wrench.ogg', 70, TRUE)

	update_stats()


//detaches the train from whatever is towing it
/obj/vehicle/train/proc/unattach(mob/user)
	if (!lead)
		to_chat(user, SPAN_WARNING("\The [src] is not hitched to anything."))
		return

	lead.tow = null
	lead.update_stats()

	to_chat(user, SPAN_NOTICE("You unhitch \the [src] from \the [lead]."))
	lead = null

	update_stats()

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

/obj/vehicle/train/proc/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle/train/cargo/engine))
		src.attach_to(T, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(reverse_direction(dir) == T_dir)	//else if car is behind
			T.attach_to(src, user)

//returns 1 if this is the lead car of the train
/obj/vehicle/train/proc/is_train_head()
	if (lead)
		return 0
	return 1

//-------------------------------------------------------
// Stat update procs
//
// Used for updating the stats for how long the train is.
// These are useful for calculating speed based on the
// size of the train, to limit super long trains.
//-------------------------------------------------------
/obj/vehicle/train/update_stats()
	//first, seek to the end of the train
	var/obj/vehicle/train/T = src
	while(T.tow)
		//check for cyclic train.
		if (T.tow == src)
			lead.tow = null
			lead.update_stats()

			lead = null
			update_stats()
			return
		T = T.tow

	//now walk back to the front.
	var/active_engines = 0
	var/train_length = 0
	while(T)
		train_length++
		if (T.powered && T.on)
			active_engines++
		T.update_car(train_length, active_engines)
		T = T.lead

/obj/vehicle/train/proc/update_car(var/train_length, var/active_engines)
	return
