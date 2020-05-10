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

   auto_use_power()            'game/machinery/machine.dm'
      This proc determines how power mode power is deducted by the machine.
      'auto_use_power()' is called by the 'master_controller' game_controller every
      tick.

      Return Value:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.
      If it's autocalled then everything is normal, if something else calls use_power we are going to
      need to recalculate the power two ticks in a row.

   power_change()               'modules/power/power.dm'
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
	w_class = 10
	layer = OBJ_LAYER - 0.01

	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
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
	var/tmp/machinery_processing = FALSE	// Are we process()ing in SSmachinery?
	var/has_special_power_checks = FALSE	// If true, call auto_use_power instead of doing it all in SSmachinery.
	var/clicksound //played sound on usage
	var/clickvol = 40 //volume
	var/obj/item/device/assembly/signaler/signaler // signaller attached to the machine

/obj/machinery/Initialize(mapload, d = 0, populate_components = TRUE)
	. = ..()
	if(d)
		set_dir(d)

	if (populate_components && component_types)
		component_parts = list()
		for (var/type in component_types)
			var/count = component_types[type]
			if (count > 1)
				for (var/i in 1 to count)
					component_parts += new type(src)
			else
				component_parts += new type(src)

		if(component_parts.len)
			RefreshParts()

	add_machine(src)

/obj/machinery/Destroy()
	remove_machine(src, TRUE)
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				component_parts -= A

	return ..()

/obj/machinery/proc/machinery_process()	//If you dont use process or power why are you here
	if(!(use_power || idle_power_usage || active_power_usage))
		return PROCESS_KILL

	return M_NO_PROCESS

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = new(src.loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(cardinal))

		QDEL_IN(pulse2, 10)
	..()

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
		else
	return

//sets the use_power var and then forces an area power update
/obj/machinery/proc/update_use_power(var/new_use_power)
	use_power = new_use_power

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(src.use_power == 1)
		use_power(idle_power_usage,power_channel, 1)
	else if(src.use_power >= 2)
		use_power(active_power_usage,power_channel, 1)
	return 1

/proc/is_operable(var/obj/machinery/M, var/mob/user)
	return istype(M) && M.operable()

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

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

/obj/machinery/proc/RefreshParts()

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] <span class = 'notice'>[msg]</span>", 2)

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
	spark(src, 5, alldirs)
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
		return 0
	playsound(src.loc,  S.usesound, 50, 1)
	panel_open = !panel_open
	to_chat(user, "<span class='notice'>You [panel_open ? "open" : "close"] the maintenance hatch of [src].</span>")
	update_icon()
	return 1

/obj/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/storage/part_replacer/R)
	if(!istype(R))
		return 0
	if(!LAZYLEN(component_parts))
		return 0

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
						break
		RefreshParts()
		update_icon()
	else
		to_chat(user, "<span class='notice'>Following parts detected in the machine:</span>")
		for(var/obj/item/C in component_parts)
			to_chat(user, "<span class='notice'>    [C.name]</span>")
	return 1

/obj/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
	M.set_dir(src.dir)
	M.state = 3
	M.icon_state = "blueprint_1"
	for(var/obj/I in component_parts)
		I.forceMove(loc)
	qdel(src)
	return 1

/obj/machinery/proc/print(var/obj/paper, var/play_sound = 1, var/print_sfx = 'sound/items/polaroid1.ogg', var/print_delay = 10)
	if( printing )
		return 0

	printing = 1

	if (play_sound)
		playsound(src.loc, print_sfx, 50, 1)

	visible_message("<span class='notice'>[src] rattles to life and spits out a paper titled [paper].</span>")

	addtimer(CALLBACK(src, .proc/print_move_paper, paper), print_delay)

	return 1

/obj/machinery/proc/print_move_paper(obj/paper)
	paper.forceMove(loc)
	printing = FALSE

/obj/machinery/proc/do_hair_pull(mob/living/carbon/human/H)
	if(!ishuman(H))
		return

	//for whatever reason, skrell's tentacles have a really long length
	//horns would not get caught in the machine
	//vaurca have fine control of their antennae
	if(isskrell(H) || isunathi(H) || isvaurca(H))
		return

	var/datum/sprite_accessory/hair/hair_style = hair_styles_list[H.h_style]
	for(var/obj/item/protection in list(H.head))
		if(protection && (protection.flags_inv & BLOCKHAIR))
			return

	if(hair_style.length >= 4)
		if(prob(25))
			H.apply_damage(30, BRUTE, BP_HEAD)
			H.visible_message("<span class='danger'>[H]'s hair catches in \the [src]!</span>", "<span class='danger'>Your hair gets caught in \the [src]!</span>")
			if(H.can_feel_pain())
				H.emote("scream")
				H.apply_damage(45, PAIN)

/obj/machinery/proc/do_signaler() // override this to customize effects
	return