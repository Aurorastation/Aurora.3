//tree
/obj/structure/flora/tree/konyang
	name = "jungle beet tree"
	desc = "A squat tree resembling an overgrown beet, this is known for its extremely strong roots and low center of mass - making it able to survive harsh Konyanger seasonal weather."
	icon = 'icons/obj/flora/konyang/trees.dmi'
	layer = 9
	icon_state = "beet_tree_example"
	pixel_x = -32
	stumptype = /obj/structure/flora/stump

/obj/effect/overlay/konyang_tree
	icon = 'icons/obj/flora/konyang/trees.dmi'
	icon_state = "shadow"
	layer = ON_TURF_LAYER

/obj/structure/flora/tree/konyang/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/konyang_tree
	icon_state = "beet_tree[rand(1, 3)]"
	return
//cliff faces

/obj/structure/konyang_cliff
	name = "shale encrusted cliff face"
	desc = "A difficult-to-scale cliff face uprooted by some gentle, long-term erosion. It's rather smooth, but has a few surfaces for grabbing."
	icon = 'icons/obj/flora/konyang/cliff.dmi'
	icon_state = "cliff1"
	anchored = TRUE
	density = TRUE
	climbable = TRUE

//rock
/obj/structure/flora/rock/konyang
	name = "dense boulder"
	icon = 'icons/obj/flora/konyang/rocks.dmi'
	icon_state = "rock"

/obj/structure/flora/rock/konyang/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 7)]"

/obj/structure/flora/rock/konyang/moss
	name = "moss-covered boulder"
	icon_state = "moss"

/obj/structure/flora/rock/konyang/moss/Initialize(mapload)
	. = ..()
	icon_state = "moss[rand(1, 3)]"

/obj/structure/flora/rock/konyang/water
	name = "submerged boulder"
	icon_state = "rock_water"

/obj/structure/flora/rock/konyang/water/Initialize(mapload)
	. = ..()
	icon_state = "rock_water[rand(1, 4)]"

/obj/structure/flora/bush/konyang_reeds
	name = "grass stalks"
	desc = "Thin and tall grass stalks, easy to sway to the wind and harsh to the touch."
	icon = 'icons/obj/flora/konyang/grass.dmi'
	icon_state = "stalks"
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/structure/flora/bush/konyang_reeds/Initialize(mapload)
	. = ..()
	icon_state = "stalks[rand(1, 5)]"

/obj/structure/flora/bush/konyang_reeds/Crossed(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		to_chat(L, "<span class='notice'>You brush through \the [src] really quite loudly.</span>")
		playsound(loc, 'sound/effects/plantshake.ogg', 100, 1)
		shake_animation()
	..()

/obj/structure/flora/bush/konyang_reeds/water
	icon_state = "water_stalks"

/obj/structure/flora/bush/konyang_reeds/water/Initialize(mapload)
	. = ..()
	icon_state = "water_stalks[rand(1, 5)]"

/obj/effect/floor_decal/konyang_flowers
	name = "lustrous flowers"
	icon = 'icons/obj/flora/konyang/grass.dmi'
	icon_state = "flowers"

/obj/effect/floor_decal/konyang_flowers/Initialize(mapload)
	icon_state = "flowers[rand(1,6)]"
	. = ..()
