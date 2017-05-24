/*
	- Abstract machinery -
	
	Pretty much designed for whenever you want something that is not a machine to interact with the power grid.
	Better to use one of these to be notified of power changes than poll with process().
	
*/

/obj/machinery/abstract
	name = "impossible device"
	desc = "No matter how hard you look at it, you have no idea what it is. (please inform coders if you see this)"
	simulated = FALSE
	anchored = 1
	mouse_opacity = 0
	
/obj/machinery/abstract/attack_ai(mob/user as mob)
	return

/obj/machinery/abstract/attack_hand(mob/user as mob)
	return

/obj/machinery/abstract/emp_act(severity)
	return		// No EMPing these.

/obj/machinery/abstract/ex_act(severity)
	return

/obj/machinery/abstract/tesla_act()
	return

/obj/machinery/abstract/singularity_act()
	return

/obj/machinery/abstract/singularity_pull()
	return

/obj/machinery/abstract/singuloCanEat()
	return FALSE

/obj/machinery/abstract/operable(additional_flags = 0)
	return TRUE
