/obj/structure/simple_door/cell
	name = "cell door"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "bars"

/obj/structure/barricade/bars
	name = "bars"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "prisonbars"
	health = 300
	maxhealth = 300

/obj/structure/barricade/bars/New(var/newloc,var/material_name)
	..(newloc, DEFAULT_WALL_MATERIAL)