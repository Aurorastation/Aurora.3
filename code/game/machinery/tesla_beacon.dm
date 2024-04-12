//
// Tesla Beacon
//

/obj/machinery/power/tesla_beacon
	name = "emergency tesla beacon"
	desc = "A beacon that is designed to be used as last resort to contain a tesla reactor's energy ball. " + SPAN_DANGER("A one time use device.")
	icon = 'icons/obj/tesla_beacon.dmi'
	icon_state = "beacon_off"
	anchored = FALSE
	density = TRUE

	var/active = FALSE

/obj/machinery/power/tesla_beacon/proc/activate(mob/user = null)
	if(surplus() < 1500)
		if(user) to_chat(user, SPAN_NOTICE("The connected wire doesn't have enough current."))
		return
	for(var/A in SScalamity.singularities)
		var/obj/singularity/singulo = A
		if(singulo.z == z)
			singulo.target = src
	icon_state = "beacon_on"
	active = TRUE
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	if(user)
		to_chat(user, SPAN_NOTICE("You activate \the [src]."))


/obj/machinery/power/tesla_beacon/proc/deactivate(mob/user = null)
	for(var/A in SScalamity.singularities)
		var/obj/singularity/singulo = A
		if(singulo.target == src)
			singulo.target = null
	icon_state = "beacon_off"
	active = FALSE
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	if(user)
		to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))

/obj/machinery/power/tesla_beacon/attack_ai(mob/user)
	return

/obj/machinery/power/tesla_beacon/attack_hand(mob/user)
	if(anchored)
		return active ? deactivate(user) : activate(user)
	else
		to_chat(user, SPAN_WARNING("You need to screw \the [src] to the floor first!"))
		return

/obj/machinery/power/tesla_beacon/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(active)
			to_chat(user, SPAN_WARNING("You need to deactivate \the [src] first!"))
			return TRUE

		if(anchored)
			anchored = 0
			to_chat(user, SPAN_NOTICE("You unscrew \the [src] from the floor."))
			disconnect_from_network()
			return TRUE
		else
			if(!connect_to_network())
				to_chat(user, SPAN_NOTICE("\The [src] must be placed over an exposed cable."))
				return TRUE
			anchored = 1
			to_chat(user, SPAN_NOTICE("You screw \the [src] to the floor and attach the cable."))
			return TRUE
	return ..()

/obj/machinery/power/tesla_beacon/Destroy()
	if(active)
		deactivate()
	return ..()

//stealth direct power usage
/obj/machinery/power/tesla_beacon/process()
	if(!active)
		return PROCESS_KILL
	else
		if(draw_power(1500) < 1500)
			deactivate()

/obj/machinery/power/tesla_beacon/attack_ai(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, SPAN_WARNING("You need to be adjacent to \the [src] to activate it!"))
