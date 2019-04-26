/obj/structure/girder/wood/adhomai
	name = "wooden girder"
	desc = "Gird your loins."
	state = 0
	health = 100
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "windownew_frame"

/obj/structure/girder/wood/dismantle()
	new /obj/item/stack/material/wood(get_turf(src))
	new /obj/item/stack/material/wood(get_turf(src))
	qdel(src)

/turf/simulated/wall/wood/adhomai