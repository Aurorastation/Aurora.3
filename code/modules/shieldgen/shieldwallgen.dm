#define POWER_INACTIVE 0
#define POWER_STARTING 1
#define POWER_ACTIVE 2

/obj/machinery/shieldwallgen
	name = "shield generator"
	desc = "A portable shield generator, capable of casting a shield to another powered generator in range."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "Shield_Gen"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP)

	var/power_state = FALSE
	var/is_powered = FALSE
	var/wrenched = FALSE
	var/steps = 0
	var/last_check = 0
	var/check_delay = 10
	var/locked = TRUE
	var/storedpower = 0
	obj_flags = OBJ_FLAG_CONDUCTABLE

	//There have to be at least two posts, so these are effectively doubled
	var/power_draw = 30000 //30 kW. How much power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of more power draw.
	var/max_stored_power = 50000 //50 kW
	use_power = POWER_USE_OFF //Draws directly from power net. Does not use APC power.

/obj/machinery/shieldwallgen/update_icon()
	if(power_state >= POWER_STARTING)
		icon_state = "Shield_Gen +a"
	else
		icon_state = "Shield_Gen"

/obj/machinery/shieldwallgen/attack_hand(mob/user)
	if(!wrenched)
		to_chat(user, SPAN_WARNING("The shield generator needs to be firmly secured to the floor first."))
		return TRUE
	if(locked && !issilicon(user))
		to_chat(user, SPAN_WARNING("The controls are locked!"))
		return TRUE
	if(!is_powered)
		to_chat(user, SPAN_WARNING("The shield generator needs to be powered by wire underneath."))
		return TRUE

	if(power_state >= POWER_STARTING)
		power_state = POWER_INACTIVE
		user.visible_message("<b>[user]</b> turns \the [src] off.", SPAN_NOTICE("You turn off \the [src]."), SPAN_NOTICE("You hear a heavy droning fade out."))
		alldir_cleanup()
	else
		power_state = POWER_STARTING
		user.visible_message("<b>[user]</b> turns \the [src] on.", SPAN_NOTICE("You turn on \the [src]."), SPAN_NOTICE("You hear a heavy droning start up."))
	update_icon()
	add_fingerprint(user)

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		is_powered = FALSE
		return FALSE
	var/turf/T = loc
	if(!istype(T))
		is_powered = FALSE
		return FALSE

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)
		PN = C.powernet // find the powernet of the connected cable

	if(!PN)
		is_powered = FALSE
		return FALSE

	var/shieldload = between(500, max_stored_power - storedpower, power_draw)	//what we try to draw
	shieldload = PN.draw_power(shieldload) //what we actually get
	storedpower += shieldload

	//If we're still in the red, then there must not be enough available power to cover our load.
	if(storedpower <= 0)
		is_powered = FALSE
		return FALSE

	is_powered = TRUE	// IVE GOT THE POWER!
	return TRUE

/obj/machinery/shieldwallgen/process()
	power()
	if(is_powered)
		storedpower -= 2500

	storedpower = clamp(storedpower, 0, max_stored_power)

	if(power_state == POWER_STARTING)
		if(!wrenched)
			power_state = POWER_INACTIVE
			return
		addtimer(CALLBACK(src, PROC_REF(setup_field), 1), 1)
		addtimer(CALLBACK(src, PROC_REF(setup_field), 2), 2)
		addtimer(CALLBACK(src, PROC_REF(setup_field), 3), 4)
		addtimer(CALLBACK(src, PROC_REF(setup_field), 4), 8)
		power_state = POWER_ACTIVE

	if(power_state >= POWER_STARTING)
		if(!is_powered)
			visible_message(SPAN_WARNING("\The [src] shuts down due to a lack of power."), SPAN_NOTICE("You hear a heavy droning fade out."))
			power_state = POWER_INACTIVE
			update_icon()
			alldir_cleanup()

/obj/machinery/shieldwallgen/proc/setup_field(var/NSEW)
	var/turf/T = loc
	var/turf/T2 = loc
	var/obj/machinery/shieldwallgen/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	oNSEW = reverse_direction(NSEW)

	for(var/dist = 0, dist <= 9, dist++) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			steps -= 1
			if(!G.power_state)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = loc

	for(var/dist = 0, dist < steps, dist++) // creates each field tile
		var/field_dir = get_dir(T2, get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/shieldwall/CF = new /obj/shieldwall/(T, src, G) //(ref to this gen, ref to connected gen)
		CF.set_dir(field_dir)

/obj/machinery/shieldwallgen/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(power_state)
			to_chat(user, SPAN_WARNING("You cannot unsecure \the [src] while it's active."))
			return

		wrenched = !wrenched
		anchored = wrenched
		attacking_item.play_tool_sound(get_turf(src), 75)
		add_fingerprint(user)
		var/others_msg = wrenched ? "<b>[user]</b> secures the external reinforcing bolts to the floor." : "<b>[user]</b> unsecures the external reinforcing bolts."
		var/self_msg = wrenched ? "You secure the external reinforcing bolts to the floor." : "You unsecure the external reinforcing bolts."
		user.visible_message(others_msg, SPAN_NOTICE(self_msg), SPAN_NOTICE("You hear a ratcheting noise."))
		return

	if(attacking_item.GetID())
		add_fingerprint(user)
		if(allowed(user))
			locked = !locked
			var/msg = "The controls are now [locked ? "locked" : "unlocked"]."
			to_chat(user, SPAN_NOTICE(msg))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return
	return ..()

/obj/machinery/shieldwallgen/proc/alldir_cleanup()
	for(var/dir in list(NORTH, SOUTH, EAST, WEST))
		cleanup(dir)

/obj/machinery/shieldwallgen/proc/cleanup(var/NSEW)
	var/obj/shieldwall/F
	var/obj/machinery/shieldwallgen/G
	var/turf/T = loc
	var/turf/T2 = loc

	for(var/dist = 0, dist <= 9, dist++) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/shieldwall) in T)
			F = (locate(/obj/shieldwall) in T)
			qdel(F)

		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			if(!G.power_state)
				break

/obj/machinery/shieldwallgen/Destroy()
	alldir_cleanup()
	return ..()

/obj/machinery/shieldwallgen/bullet_act(var/obj/item/projectile/Proj)
	storedpower -= 400 * Proj.get_structure_damage()
	if(power_state >= POWER_STARTING)
		visible_message(SPAN_WARNING("\The [src]'s shielding sparks as \the [Proj] hits it!"))
	return ..()

/obj/shieldwall
	name = "energy shield"
	desc = "An energy shield."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	light_range = 3
	light_color = LIGHT_COLOR_BLUE
	var/needs_power = FALSE
	var/power_state = POWER_STARTING
	var/delay = 5
	var/last_active
	var/mob/U
	var/obj/machinery/shieldwallgen/gen_primary
	var/obj/machinery/shieldwallgen/gen_secondary
	var/power_usage = 2500	//how much power it takes to sustain the shield
	var/generate_power_usage = 7500	//how much power it takes to start up the shield

/obj/shieldwall/Initialize(mapload, var/obj/machinery/shieldwallgen/A, var/obj/machinery/shieldwallgen/B)
	. = ..()
	update_nearby_tiles()
	gen_primary = A
	gen_secondary = B
	if(A?.power_state && B?.power_state)
		needs_power = TRUE
		A.storedpower -= generate_power_usage / 2
		B.storedpower -= generate_power_usage / 2
		START_PROCESSING(SSprocessing, src)
	else
		qdel(src) //need at least two generator posts

/obj/shieldwall/Destroy()
	update_nearby_tiles()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/shieldwall/attack_hand(mob/user)
	to_chat(user, SPAN_WARNING("\The [src] pushes you back as you try to touch it."))

/obj/shieldwall/process()
	if(needs_power)
		if(!gen_primary || !gen_secondary)
			qdel(src)
			return

		if(!gen_primary.power_state || !gen_secondary.power_state)
			qdel(src)
			return

		gen_primary.storedpower -= power_usage / 2
		gen_secondary.storedpower -= power_usage / 2

/obj/shieldwall/bullet_act(var/obj/item/projectile/Proj)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		if(prob(50))
			G = gen_primary
		else
			G = gen_secondary
		visible_message(SPAN_WARNING("\The [src] wobbles precariously as \the [Proj] impacts it!"))
		G.storedpower -= 400 * Proj.get_structure_damage()
	return ..()

/obj/shieldwall/ex_act(severity)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		switch(severity)
			if(1.0) //big boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 120000

			if(2.0) //medium boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 30000

			if(3.0) //lil boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 12000

/obj/shieldwall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return prob(20)
	else
		if(istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !density


#undef POWER_INACTIVE
#undef POWER_STARTING
#undef POWER_ACTIVE
