/obj/machinery/anti_bluespace
	name = "bluespace inhibitor"
	desc = "Scrambles any bluespace related activity and displaces it away from the beacon's area of effect."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "nopad"
	anchored = 1
	use_power = 1
	idle_power_usage = 500

/obj/machinery/anti_bluespace/update_icon()
	if(stat & BROKEN)
		name = "modern art"
		desc = "What used to be a useful machine that prevented intrusion into secure areas is now a modern art piece."
		icon_state = "[initial(icon_state)]-broken"
	else if(stat & NOPOWER)
		name = initial(name)
		desc = "[initial(desc)] Well, only if it was powered."
		icon_state = "[initial(icon_state)]"
	else
		name = initial(name)
		desc = initial(desc)
		icon_state = "[initial(icon_state)]-on"

/obj/machinery/anti_bluespace/machinery_process()
	. = ..()
	update_icon()

/obj/machinery/anti_bluespace/dismantle()
	return 0

/obj/machinery/anti_bluespace/default_part_replacement()
	return 0

/obj/machinery/anti_bluespace/default_deconstruction_screwdriver(var/mob/user, var/obj/item/weapon/screwdriver/S)
	return 0

/obj/machinery/anti_bluespace/default_deconstruction_crowbar(var/mob/user, var/obj/item/weapon/crowbar/C)
	return 0

/obj/machinery/anti_bluespace/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(75))
				qdel(src)
			else
				stat =| BROKEN
		if(2.0)
			if (prob(50))
				qdel(src)
			else
				stat =| BROKEN
		if(3.0)
			if (prob(25))
				qdel(src)
			else
				stat =| BROKEN

	return