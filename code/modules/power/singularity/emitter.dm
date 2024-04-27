#define EMITTER_LOOSE 0
#define EMITTER_BOLTED 1
#define EMITTER_WELDED 2

/obj/machinery/power/emitter
	name = "emitter"
	desc = "It is a heavy duty industrial laser."
	icon = 'icons/obj/emitter.dmi'
	icon_state = "emitter"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP)
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_SIGNALER
	var/id

	use_power = POWER_USE_OFF	//uses powernet power, not APC power
	active_power_usage = 30000	//30 kW laser. I guess that means 30 kJ per shot.

	var/active = FALSE
	var/powered = FALSE
	var/fire_delay = 100
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/shot_counter = 0
	var/state = EMITTER_LOOSE
	var/locked = FALSE

	var/special_emitter = FALSE // special emitters notify admins if something happens to them, to prevent grief

	var/_wifi_id
	var/datum/wifi/receiver/button/emitter/wifi_receiver

	var/datum/effect_system/sparks/spark_system

/obj/machinery/power/emitter/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	switch(state)
		if(EMITTER_LOOSE)
			. += SPAN_NOTICE("\The [src] isn't attached to anything and is not ready to fire.")
		if(EMITTER_BOLTED)
			. += SPAN_NOTICE("\The [src] is bolted to the floor, but not yet ready to fire.")
		if(EMITTER_WELDED)
			. += SPAN_WARNING("\The [src] is bolted and welded to the floor, and ready to fire.")
	if(is_adjacent)
		. += SPAN_NOTICE("The shot counter display reads: [shot_counter] shots.")

/obj/machinery/power/emitter/Destroy()
	if(special_emitter)
		message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Emitter deleted at ([x],[y],[z])")
		investigate_log("<span class='warning'>deleted</span> at ([x],[y],[z])","singulo")
	QDEL_NULL(wifi_receiver)
	QDEL_NULL(spark_system)
	QDEL_NULL(signaler)
	return ..()

/obj/machinery/power/emitter/Initialize()
	. = ..()
	spark_system = bind_spark(src, 5, GLOB.alldirs)
	if(state == EMITTER_WELDED && anchored)
		connect_to_network()
		if(_wifi_id)
			wifi_receiver = new(_wifi_id, src)

/obj/machinery/power/emitter/update_icon()
	if(active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/attack_hand(mob/user)
	add_fingerprint(user)
	activate(user)

/obj/machinery/power/emitter/proc/activate(mob/user)
	if(state == EMITTER_WELDED)
		if(!powernet)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src] isn't connected to a powered wire."))
			return TRUE
		if(!locked)
			if(active)
				active = FALSE
				if(user)
					to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
					if(special_emitter)
						message_admins("Emitter turned off by [key_name_admin(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
						log_game("Emitter turned off by [user.ckey]([user]) in ([x],[y],[z])",ckey=key_name(user))
						investigate_log("turned <span class='warning'>off</span> by [user.key]","singulo")
			else
				active = TRUE
				shot_number = 0
				shot_counter = 0
				fire_delay = 100
				if(user)
					to_chat(user, SPAN_NOTICE("You activate \the [src]."))
					if(special_emitter)
						message_admins("Emitter turned on by [key_name_admin(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
						log_game("Emitter turned on by [user.ckey]([user]) in ([x],[y],[z])",ckey=key_name(user))
						investigate_log("turned <font color='green'>on</font> by [user.key]","singulo")
			update_icon()
		else
			if(user)
				to_chat(user, SPAN_WARNING("The controls are locked!"))
	else
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return TRUE


/obj/machinery/power/emitter/emp_act(severity)
	. = ..()

	activate(null)
	return TRUE

/obj/machinery/power/emitter/process(seconds_per_tick)
	if(stat & (BROKEN))
		return
	if(state != EMITTER_WELDED || (!powernet && active_power_usage))
		active = FALSE
		update_icon()
		return
	if(((last_shot + fire_delay) <= world.time) && active)
		var/actual_load = draw_power(active_power_usage)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = TRUE
				update_icon()
				if(special_emitter)
					investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = FALSE
				update_icon()
				if(special_emitter)
					investigate_log("lost power and turned <span class='warning'>off</span>","singulo")
			return

		last_shot = world.time
		if (shot_number < burst_shots)
			fire_delay = get_burst_delay()
			shot_number++
		else
			fire_delay = get_rand_burst_delay()
			shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay) / 2 + 2 * (burst_shots - 1)
		var/power_per_shot = active_power_usage * (burst_time / 10) / burst_shots

		playsound(get_turf(src), 'sound/weapons/emitter.ogg', 15, TRUE, extrarange = (MEDIUM_RANGE_SOUND_EXTRARANGE-1))
		if(prob(35))
			spark_system.queue()

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		A.damage = round(power_per_shot / EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch_projectile(get_step(src, dir))
		shot_counter++

/obj/machinery/power/emitter/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(active)
			to_chat(user, SPAN_WARNING("You cannot unbolt \the [src] while it's active."))
			return
		switch(state)
			if(EMITTER_LOOSE)
				state = EMITTER_BOLTED
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
					SPAN_NOTICE("You secure \the [src]'s external reinforcing bolts to the floor."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = TRUE
			if(EMITTER_BOLTED)
				state = EMITTER_LOOSE
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src]'s reinforcing bolts from the floor."), \
					SPAN_NOTICE("You undo \the [src]'s external reinforcing bolts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = FALSE
			if(EMITTER_WELDED)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return

	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(active)
			to_chat(user, SPAN_NOTICE("You cannot unweld \the [src] while it's active."))
			return
		switch(state)
			if(EMITTER_LOOSE)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(EMITTER_BOLTED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to weld \the [src] to the floor."), \
						SPAN_NOTICE("You start to weld \the [src] to the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = EMITTER_WELDED
						to_chat(user, SPAN_NOTICE("You weld \the [src] to the floor."))
						connect_to_network()
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if(EMITTER_WELDED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to cut \the [src] free from the floor."), \
						SPAN_NOTICE("You start to cut \the [src] free from the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = EMITTER_BOLTED
						to_chat(user, SPAN_NOTICE("You cut \the [src] free from the floor."))
						disconnect_from_network()
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	if(attacking_item.GetID())
		if(emagged)
			to_chat(user, SPAN_WARNING("The lock seems to be broken."))
			return
		if(allowed(user))
			if(active)
				locked = !locked
				to_chat(user, SPAN_NOTICE("The controls are now [locked ? "locked." : "unlocked."]"))
			else
				locked = FALSE //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when \the [src] is online."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()
	return

/obj/machinery/power/emitter/emag_act(remaining_charges, mob/user)
	if(!emagged)
		locked = FALSE
		emagged = TRUE
		// Give this boy the buff it deserves. - Geeves
		burst_shots *= 2
		min_burst_delay *= 0.5
		max_burst_delay *= 0.5
		to_chat(user, SPAN_NOTICE("You short out the emitter's locking system, and put its capacitor into overdrive."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] seems to already have been modified."))
		return FALSE

/obj/machinery/power/emitter/do_signaler()
	if(!locked)
		activate(null)
	else
		visible_message("[icon2html(src, viewers(get_turf(src)))] [src] whines, \"Access denied!\"")

/obj/machinery/power/emitter/proc/get_initial_fire_delay()
	return 10 SECONDS

/obj/machinery/power/emitter/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/machinery/power/emitter/proc/get_burst_delay()
	return 0.2 SECONDS // This value doesn't really affect normal emitters, but *does* affect subtypes like the gyrotron that can have very long delays

/obj/machinery/power/emitter/proc/get_emitter_beam()
	return new /obj/item/projectile/beam/emitter(get_turf(src))

#undef EMITTER_LOOSE
#undef EMITTER_BOLTED
#undef EMITTER_WELDED
