/obj/machinery/food_cart
	name = "food cart"
	desc = "A compact unpackable mobile cooking stand. Wow! When unpacked, it reminds you of those greasy gamer setups some people on NTNet have."
	icon = 'icons/obj/machinery/cooking_machines.dmi'
	icon_state = "foodcart"
	density = TRUE
	anchored = FALSE
	stat = POWEROFF
	use_power = POWER_USE_OFF
	req_access = list(ACCESS_KITCHEN)
	var/unpacked = FALSE
	/// When it's anchored and has all it's things outside
	var/obj/machinery/appliance/cooker/grill/stand/cart_griddle
	/// Griddle inside of the foodcart
	var/obj/machinery/smartfridge/foodheater/stand/cart_smartfridge
	/// Smartfridge inside of foodcart
	var/obj/structure/table/reinforced/wood/cart_table
	/// Table inside of foodcart
	var/obj/effect/food_cart_stand/cart_tent
	/// Overlay that spawns once foodcart is setup
	var/list/packed_things
	/// Contains cart_griddle, cart_smartfridge, cart_table, cart_cent

/obj/machinery/food_cart/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(stat & BROKEN)
		return
	if(cart_griddle.stat & BROKEN)
		. += SPAN_WARNING("The stand's [SPAN_BOLD("grill")] is completely broken!")
	else
		. += SPAN_NOTICE("The stand's [SPAN_BOLD("grill")] is intact.")
	. += SPAN_NOTICE("The stand's [SPAN_BOLD("fridge")] seems fine.") //weirdly enough, these fridges don't break
	. += SPAN_NOTICE("The stand's [SPAN_BOLD("table")] seems fine.")

/obj/machinery/food_cart/Initialize(mapload)
	. = ..()
	cart_griddle = new(src)
	cart_smartfridge = new(src)
	cart_table = new(src)
	cart_tent = new(src)
	packed_things = list(cart_table, cart_smartfridge, cart_tent, cart_griddle) //middle, left, left, right
	RegisterSignal(cart_griddle, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_smartfridge, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_table, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_tent, COMSIG_QDELETING, PROC_REF(lost_part))

/obj/machinery/food_cart/Destroy()
	QDEL_NULL(cart_griddle)
	QDEL_NULL(cart_smartfridge)
	QDEL_NULL(cart_table)
	QDEL_NULL(cart_tent)
	packed_things.Cut()
	return ..()

/**
 * Retract the structures into the food cart
 */
/obj/machinery/food_cart/proc/pack_up()
	if(!unpacked)
		return
	visible_message(SPAN_NOTICE("[src] retracts all of it's unpacked components."))
	for(var/obj/object as anything in packed_things)
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	if(!(cart_griddle?.stat & BROKEN)) // Don't draw power if it's packed inside
		cart_griddle.stat = POWEROFF
		cart_griddle.use_power = POWER_USE_OFF
		cart_griddle.update_icon()
	if(!(cart_smartfridge?.stat & BROKEN))
		cart_smartfridge.use_power = POWER_USE_OFF
	anchored = FALSE
	unpacked = FALSE

/**
 * Deploy the structures inside the food cart
 */
/obj/machinery/food_cart/proc/unpack(mob/user)
	if(unpacked)
		return
	if(!check_setup_place())
		to_chat(user, SPAN_WARNING("There isn't enough room to unpack here! Bad spaces were marked in red."))
		return
	visible_message(SPAN_NOTICE("[src] expands into a full stand."))
	anchored = TRUE
	if(!(cart_griddle?.stat & BROKEN))
		cart_griddle.stat = POWEROFF
	if(!(cart_smartfridge?.stat & BROKEN)) // Unpacked, draw power
		cart_smartfridge.use_power = POWER_USE_IDLE
	var/iteration = 1
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		var/obj/thing = packed_things[iteration]
		thing.forceMove(T)
		RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(lost_part))
		iteration++
	unpacked = TRUE

/obj/machinery/food_cart/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("[src] is completely busted."))
		return
	var/obj/item/card/id/id_card = user.GetIdCard()
	if(!check_access(id_card))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(usr, SPAN_WARNING("Access denied."))
		return
	playsound(get_turf(src), 'sound/items/rfd_start.ogg', 50, FALSE)
	to_chat(user, SPAN_NOTICE("You attempt to [unpacked ? "pack up" :"unpack"] [src]..."))
	if(!do_after(user, 5 SECONDS, src))
		playsound(get_turf(src), 'sound/items/rfd_interrupt.ogg', 50, FALSE)
		return
	playsound(get_turf(src), 'sound/items/rfd_end.ogg', 50, FALSE)
	if(unpacked)
		pack_up()
	else
		unpack(user)

/**
 * Step and check whether cart structures have non-dense space to placed onto
 *
 * Returns a boolean
 */
/obj/machinery/food_cart/proc/check_setup_place()
	var/has_space = TRUE
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		if(T.density || T.contains_dense_objects())
			has_space = FALSE
			new /obj/effect/temp_visual/cart_space/bad(T)
		else
			new /obj/effect/temp_visual/cart_space(T)
	return has_space

/**
 * Some part of the food cart went missing
 */
/obj/machinery/food_cart/proc/lost_part(atom/movable/source, force)
	SIGNAL_HANDLER

	//okay, so it's deleting the fridge or griddle which are more important. We're gonna break the machine then
	UnregisterSignal(cart_griddle, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_smartfridge, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_table, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_tent, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	atom_break()

/obj/machinery/food_cart/atom_break()
	. = ..()
	pack_up()
	if(!QDELETED(cart_griddle))
		QDEL_NULL(cart_griddle)
	if(!QDELETED(cart_smartfridge))
		QDEL_NULL(cart_smartfridge)
	if(!QDELETED(cart_table))
		QDEL_NULL(cart_table)
	if(!QDELETED(cart_tent))
		QDEL_NULL(cart_tent)

/obj/effect/food_cart_stand
	name = "food cart tent"
	desc = "Something to battle the sun, for there are no breaks for the burger flippers."
	icon = 'icons/obj/fluff/3x3.dmi'
	icon_state = "stand"
	layer = ABOVE_HUMAN_LAYER //big mobs will still go over the tent, this is fine and cool
