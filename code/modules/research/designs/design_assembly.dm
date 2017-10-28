/obj/item/device/designcase
	name = "design assembly"
	desc = "A case for shoving things into. Hopefully they work."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/size = CASE_SMALL
	var/list/parts
	var/maxparts = 4
	var/list/designs

/obj/item/device/designcase/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	var/obj/item/weapon/stock_parts/A = D
	if(!istype(D))
		return ..()
	A.forceMove(src)
	parts += A
	user << "<span class='notice'>You insert the [A] into the assembly.</span>"
	check_completion()

/*/obj/item/device/designcase/proc/check_completion()
	for(var/datum/design/A in designs)
		if(parts.len != A.req_parts.len)
			return 0
		for(var/B in parts)
			if(!(B in A.req_parts)
				return 0
		return 1*/