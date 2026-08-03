//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/structure/machinery/r_n_d
	name = "R&D device"
	icon = 'icons/obj/machinery/research.dmi'
	density = TRUE
	anchored = TRUE
	var/busy = 0
	var/obj/structure/machinery/computer/rdconsole/linked_console

/obj/structure/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/structure/machinery/r_n_d/proc/getMaterialType(var/name)
	return SSmaterials.material_stack_type(name)
