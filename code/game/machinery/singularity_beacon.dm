////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/power/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/beacon.dmi'
	icon_state = "beacon0"

	anchored = 0
	density = 1
	layer = MOB_LAYER - 0.1 //so people can't hide it and it's REALLY OBVIOUS
	stat = 0

	var/active = 0
	var/icontype = "beacon"


/obj/machinery/power/singularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user) to_chat(user, "<span class='notice'>The connected wire doesn't have enough current.</span>")
		return
	for(var/A in SScalamity.singularities)
		var/obj/singularity/singulo = A
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = 1
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	if(user)
		to_chat(user, "<span class='notice'>You activate the beacon.</span>")


/obj/machinery/power/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/A in SScalamity.singularities)
		var/obj/singularity/singulo = A
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = 0
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	if(user)
		to_chat(user, "<span class='notice'>You deactivate the beacon.</span>")

/obj/machinery/power/singularity_beacon/attack_ai(mob/user)
	return

/obj/machinery/power/singularity_beacon/attack_hand(mob/user)
	if(anchored)
		return active ? Deactivate(user) : Activate(user)
	else
		to_chat(user, "<span class='danger'>You need to screw the beacon to the floor first!</span>")
		return

/obj/machinery/power/singularity_beacon/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver())
		if(active)
			to_chat(user, "<span class='danger'>You need to deactivate the beacon first!</span>")
			return TRUE

		if(anchored)
			anchored = 0
			to_chat(user, "<span class='notice'>You unscrew the beacon from the floor.</span>")
			disconnect_from_network()
			return TRUE
		else
			if(!connect_to_network())
				to_chat(user, "This device must be placed over an exposed cable.")
				return TRUE
			anchored = 1
			to_chat(user, "<span class='notice'>You screw the beacon to the floor and attach the cable.</span>")
			return TRUE
	return ..()

/obj/machinery/power/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	return ..()

//stealth direct power usage
/obj/machinery/power/singularity_beacon/process()
	if(!active)
		return PROCESS_KILL
	else
		if(draw_power(1500) < 1500)
			Deactivate()

/obj/machinery/power/singularity_beacon/emergency
	name = "emergency singularity beacon"
	desc = "A beacon that is designed to be used as last resort to contain Singularity or Tesla Engine. A one time use device."

/obj/machinery/power/singularity_beacon/emergency/attack_ai(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, SPAN_WARNING("You need to be adjacent to \the [src] to activate it!"))