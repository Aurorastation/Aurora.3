/*
Overview:
	Used to create objects that need a per step proc call.  Default definition of 'New()'
	stores a reference to src machine in global 'machines list'.  Default definition
	of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
	use_power (num)
		current state of auto power use.
		Possible Values:
			0 -- no auto power use
			1 -- machine is using power at its idle power level
			2 -- machine is using power at its active power level

	active_power_usage (num)
		Value for the amount of power to use when in active power mode

	idle_power_usage (num)
		Value for the amount of power to use when in idle power mode

	power_channel (num)
		What channel to draw from when drawing power for power mode
		Possible Values:
			EQUIP:0 -- Equipment Channel
			LIGHT:2 -- Lighting Channel
			ENVIRON:3 -- Environment Channel

	component_parts (list)
		A list of component parts of machine used by frame based machines.

	panel_open (num)
		Whether the panel is open

	uid (num)
		Unique id of machine across all machines.

	gl_uid (global num)
		Next uid value in sequence

	stat (bitflag)
		Machine status bit flags.
		Possible bit flags:
			BROKEN:1 -- Machine is broken
			NOPOWER:2 -- No power is being supplied to machine.
			POWEROFF:4 -- tbd
			MAINT:8 -- machine is currently under going maintenance.
			EMPED:16 -- temporary broken by EMP pulse

Class Procs:
	New()                     'game/machinery/machine.dm'

	Destroy()                     'game/machinery/machine.dm'

	powered(chan = EQUIP)         'modules/power/power_usage.dm'
		Checks to see if area that contains the object has power available for power
		channel given in 'chan'.

	use_power_oneoff(amount, chan=EQUIP, autocalled)   'modules/power/power_usage.dm'
		Deducts 'amount' from the power channel 'chan' of the area that contains the object.
		This is not a continuous draw, but rather will be cleared after one APC update.

	power_change()               'modules/power/power_usage.dm'
		Called by the area that contains the object when ever that area under goes a
		power state change (area runs out of power, or area channel is turned off).

	RefreshParts()               'game/machinery/machine.dm'
		Called to refresh the variables in the machine that are contributed to by parts
		contained in the component_parts list. (example: glass and material amounts for
		the autolathe)

		Default definition does nothing.

	assign_uid()               'game/machinery/machine.dm'
		Called by machine to assign a value to the uid variable.

	process()                  'game/machinery/machine.dm'
		Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEMSIZE_IMMENSE
	layer = OBJ_LAYER - 0.1
	init_flags = INIT_MACHINERY_PROCESS_SELF

	var/stat = 0
	var/emagged = 0
	var/use_power = POWER_USE_IDLE // See code/__defines/machinery.dm
	var/internal = FALSE
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_init_complete = FALSE
	var/power_channel = EQUIP //EQUIP, ENVIRON or LIGHT
	/* List of types that should be spawned as component_parts for this machine.
		Structure:
			type -> num_objects

		num_objects is optional, and will be treated as 1 if omitted.

		example:
		component_types = list(
			/obj/foo/bar,
			/obj/baz = 2
		)
	*/
	var/list/component_types
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/printing = 0 // Is this machine currently printing anything?
	var/list/processing_parts // Component parts queued for processing by the machine. Expected type: `/obj/item/stock_parts` Unused currently
	var/processing_flags // Bitflag. What is being processed. One of `MACHINERY_PROCESS_*`.
	var/clicksound //played sound on usage
	var/clickvol = 40 //volume
	var/obj/item/device/assembly/signaler/signaler // signaller attached to the machine
	var/obj/effect/overmap/visitable/linked // overmap sector the machine is linked to

	/// Manufacturer of this machine. Used for TGUI themes, when you have a base type and subtypes with different themes (like the coffee machine).
	/// Pass the manufacturer in ui_data and then use it in the UI.
	var/manufacturer = null

/obj/machinery/Initialize(mapload, d = 0, populate_components = TRUE, is_internal = FALSE)
	. = ..()
	if(d)
		set_dir(d)

	if(init_flags & INIT_MACHINERY_PROCESS_ALL)
		START_PROCESSING_MACHINE(src, init_flags & INIT_MACHINERY_PROCESS_ALL)
	SSmachinery.machinery += src // All machines should be in machinery.

	if (populate_components && component_types)
		component_parts = list()
		for (var/type in component_types)
			var/count = component_types[type]
			if(ispath(type, /obj/item/stack))
				if(isnull(count))
					count = 1
				component_parts += new type(src, count)
			else
				if(count > 1)
					for (var/i in 1 to count)
						component_parts += new type(src)
				else
					component_parts += new type(src)

		if(component_parts.len)
			RefreshParts()

/obj/machinery/Destroy()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)
	SSmachinery.machinery -= src
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				component_parts -= A

	return ..()

/obj/machinery/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(signaler && is_adjacent)
		to_chat(user, SPAN_WARNING("\The [src] has a hidden signaler attached to it."))

// /obj/machinery/proc/process_all()
// 	/* Uncomment this if/when you need component processing
// 	if(processing_flags & MACHINERY_PROCESS_COMPONENTS)
// 		for(var/thing in processing_parts)
// 			var/obj/item/stock_parts/part = thing
// 			if(part.machine_process(src) == PROCESS_KILL)
// 				part.stop_processing() */

// 	if((processing_flags & MACHINERY_PROCESS_SELF))
// 		. = process()
// 		if(. == PROCESS_KILL)
// 			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/process()
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	. = ..()
	if(use_power && stat == 0)
		use_power_oneoff(7500/severity)

		var/obj/effect/overlay/pulse2 = new(src.loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(GLOB.cardinal))

		QDEL_IN(pulse2, 10)

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				qdel(src)
				return
	return

/proc/is_operable(var/obj/machinery/M, var/mob/user)
	return istype(M) && M.operable()

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/machinery/proc/toggle_power(power_set = -1, additional_flags = 0)
	if(power_set >= 0)
		update_use_power(power_set)
	else if (use_power || inoperable(additional_flags))
		update_use_power(POWER_USE_OFF)
	else
		update_use_power(initial(use_power))

	update_icon()

/obj/machinery/CanUseTopic(var/mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	return ..()

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	if(clicksound && iscarbon(user))
		playsound(src, clicksound, clickvol)
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)
	if(inoperable(MAINT))
		return 1
	if(user.lying || user.stat)
		return 1
	if ( ! (istype(usr, /mob/living/carbon/human) || \
			istype(usr, /mob/living/silicon)))
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1
/*
	//distance checks are made by atom/proc/DblClick
	if ((get_dist(src, user) > 1 || !istype(src.loc, /turf)) && !istype(user, /mob/living/silicon))
		return 1
*/
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			visible_message("<span class='warning'>[H] stares cluelessly at [src] and drools.</span>")
			return 1
		else if(prob(H.getBrainLoss()))
			to_chat(user, "<span class='warning'>You momentarily forget how to use [src].</span>")
			return 1

	src.add_fingerprint(user)

	return ..()

/obj/machinery/attackby(obj/item/W, mob/user)
	if(obj_flags & OBJ_FLAG_SIGNALER)
		if(issignaler(W))
			if(signaler)
				to_chat(user, SPAN_WARNING("\The [src] already has a signaler attached."))
				return TRUE
			var/obj/item/device/assembly/signaler/S = W
			user.drop_from_inventory(W, src)
			signaler = S
			S.machine = src
			user.visible_message("<b>[user]</b> attaches \the [S] to \the [src].", SPAN_NOTICE("You attach \the [S] to \the [src]."), range = 3)
			log_and_message_admins("has attached a signaler to \the [src].", user, get_turf(src))
			return TRUE
		else if(W.iswirecutter() && signaler)
			user.visible_message("<b>[user]</b> removes \the [signaler] from \the [src].", SPAN_NOTICE("You remove \the [signaler] from \the [src]."), range = 3)
			user.put_in_hands(detach_signaler())
			return TRUE

	return ..()

/obj/machinery/proc/detach_signaler(var/turf/detach_turf)
	if(!signaler)
		return

	if(!detach_turf)
		detach_turf = get_turf(src)
	if(!detach_turf)
		LOG_DEBUG("[src] tried to drop a signaler, but it had no turf ([src.x]-[src.y]-[src.z])")
		return

	var/obj/item/device/assembly/signaler/S = signaler

	signaler.forceMove(detach_turf)
	signaler.machine = null
	signaler = null

	return S

/obj/machinery/proc/RefreshParts()

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("[icon2html(src, O)] <span class = 'notice'>[msg]</span>", 2)

/obj/machinery/proc/ping(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/obj/machinery/proc/pingx3(text=null)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/pingx3.ogg', 50, 0)

/obj/machinery/proc/buzz(text=null)
	if (!text)
		text = "\The [src] buzzes."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0) //TODO: Check if that one is the correct sound

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	spark(src, 5, GLOB.alldirs)
	if (electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.trigger_warning()
		if(user.stunned)
			return 1
	return 0

/obj/machinery/proc/default_deconstruction_crowbar(var/mob/user, var/obj/item/C)
	if(!istype(C) || !C.iscrowbar())
		return 0
	if(!panel_open)
		return 0
	. = dismantle()

/obj/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if(!istype(S) || !S.isscrewdriver())
		return FALSE
	playsound(src.loc, S.usesound, 50, 1)
	panel_open = !panel_open
	to_chat(user, "<span class='notice'>You [panel_open ? "open" : "close"] the maintenance hatch of [src].</span>")
	update_icon()
	return TRUE

/obj/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/storage/part_replacer/R)
	if(!istype(R))
		return FALSE
	if(!LAZYLEN(component_parts))
		return FALSE
	var/parts_replaced = FALSE
	if(panel_open)
		var/obj/item/circuitboard/CB = locate(/obj/item/circuitboard) in component_parts
		var/P
		for(var/obj/item/reagent_containers/glass/G in component_parts)
			for(var/D in CB.req_components)
				var/T = text2path(D)
				if(ispath(G.type, T))
					P = T
					break
			for(var/obj/item/reagent_containers/glass/B in R.contents)
				if(B.reagents && B.reagents.total_volume > 0) continue
				if(istype(B, P) && istype(G, P))
					if(B.volume > G.volume)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(G, 1)
						component_parts -= G
						component_parts += B
						B.forceMove(src)
						to_chat(user, "<span class='notice'>[G.name] replaced with [B.name].</span>")
						break
		for(var/obj/item/stock_parts/A in component_parts)
			for(var/D in CB.req_components)
				var/T = text2path(D)
				if(ispath(A.type, T))
					P = T
					break
			for(var/obj/item/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.rating > A.rating)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.forceMove(src)
						to_chat(user, "<span class='notice'>[A.name] replaced with [B.name].</span>")
						parts_replaced = TRUE
						break
		RefreshParts()
		update_icon()
	else
		to_chat(user, "<span class='notice'>The following parts have been detected in \the [src]:</span>")
		to_chat(user, counting_english_list(component_parts))
	if(parts_replaced) //only play sound when RPED actually replaces parts
		playsound(src, 'sound/items/rped.ogg', 40, TRUE)
	return 1

/obj/machinery/proc/dismantle()
	playsound(loc, /singleton/sound_category/crowbar_sound, 50, 1)
	var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
	M.set_dir(src.dir)
	M.state = 3
	M.icon_state = "blueprint_1"
	for(var/obj/I in component_parts)
		I.forceMove(loc)
	qdel(src)
	return TRUE

/obj/machinery/proc/print(var/obj/paper, var/play_sound = 1, var/print_sfx = /singleton/sound_category/print_sound, var/print_delay = 10, var/message, var/mob/user)
	if( printing )
		return FALSE

	printing = TRUE

	if (play_sound)
		playsound(src.loc, print_sfx, 50, 1)

	if(!message)
		message = "\The [src] rattles to life and spits out a paper titled [paper]."
	visible_message(SPAN_NOTICE(message))

	addtimer(CALLBACK(src, PROC_REF(print_move_paper), paper, user), print_delay)

	return TRUE

/obj/machinery/proc/print_move_paper(obj/paper, mob/user)
	if(user && ishuman(user) && user.Adjacent(src))
		user.put_in_hands(paper)
	else
		paper.forceMove(loc)
	printing = FALSE

/obj/machinery/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(P.get_structure_damage() > 5)
		bullet_ping(P)

/obj/machinery/proc/do_hair_pull(mob/living/carbon/human/H)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!istype(H))
		return

	//for whatever reason, skrell's tentacles have a really long length
	//horns would not get caught in the machine
	//vaurca have fine control of their antennae
	if(isskrell(H) || isunathi(H) || isvaurca(H))
		return

	var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[H.h_style]
	for(var/obj/item/protection in list(H.head))
		if(protection && (protection.flags_inv & BLOCKHAIR|BLOCKHEADHAIR))
			return

	if(hair_style.length >= 4 && prob(25))
		H.apply_damage(30, DAMAGE_BRUTE, BP_HEAD)
		H.visible_message(SPAN_DANGER("\The [H]'s hair catches in \the [src]!"),
					SPAN_DANGER("Your hair gets caught in \the [src]!"))
		if(H.can_feel_pain())
			H.emote("scream")
			H.apply_damage(45, DAMAGE_PAIN)

/obj/machinery/proc/do_signaler() // override this to customize effects
	return


// A late init operation called in SSshuttle for ship computers and holopads, used to attach the thing to the right ship.
/obj/machinery/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		linked = sector
		return TRUE
	return FALSE

/obj/machinery/proc/sync_linked()
	var/obj/effect/overmap/visitable/sector = GLOB.map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/machinery/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/candidate in sector)
		if((. = .(candidate)))
			return

/obj/proc/on_user_login(mob/M)
	return

/obj/machinery/proc/set_emergency_state(var/new_security_level)
	return

/obj/machinery/hitby(atom/movable/AM, var/speed = THROWFORCE_SPEED_DIVISOR)
	. = ..()
	if(isliving(AM))
		var/mob/living/M = AM
		M.turf_collision(src, speed)
		return
	else
		visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."))

/obj/machinery/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. < UI_INTERACTIVE)
		if(user.machine)
			user.unset_machine()
