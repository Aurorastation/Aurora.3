/obj/item/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "emp"
	origin_tech = "{'materials':2,'magnets':3}"

/obj/item/grenade/empgrenade/prime()
	..()
	if(empulse(src, 2, 5))
		qdel(src)
	return
