/obj/machinery/red_fab
	name = "reverse engineering device sample analyzer"
	desc = "Used to analyze samples produced by the RED."
	icon = 'icons/obj/machines/gravity_generator.dmi'
	anchored = 1
	density = 1
	use_power = 0
	unacidable = 1
	var/obj/item/red_sample/sample // the sample inside

/obj/machinery/red_fab/attack_hand(mob/user as mob)
	add_fingerprint(user)
	//if(stat & (BROKEN|NOPOWER))
	//	return
	ui_interact(user)

/obj/machinery/red_fab/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/red_sample))
		return ..()
	user << "You insert the [W] into the sample slot."
	W.forceMove(src)
	sample = W
