/obj/structure/barricade/sandbags
	desc = "A barricade made out of sandbags."
	icon = 'icons/adhomai/sandbags.dmi'
	icon_state = "sandbags"
	smooth = SMOOTH_TRUE
	health = 300
	maxhealth = 300
	canSmoothWith = list(
		/obj/structure/barricade/sandbags,
		/turf/simulated/wall,
		/turf/simulated/floor,
		/turf/simulated/mineral)

/obj/structure/barricade/sandbags/New(var/newloc,var/material_name)
	..(newloc, "sandbag")