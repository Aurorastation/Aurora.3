//tree
/obj/structure/flora/tree/konyang
	name = "jungle beet tree"
	desc = "A squat tree resembling an overgrown beet, this is known for its extremely strong roots and low center of mass - making it able to survive harsh Konyanger seasonal weather."
	icon = 'icons/obj/flora/konyang/beet_tree.dmi'
	layer = 9
	icon_state = "tree_example"
	pixel_x = -32
	stumptype = /obj/structure/flora/stump

/obj/effect/overlay/konyang_tree//shadow underlay
	icon = 'icons/obj/flora/konyang/beet_tree.dmi'
	icon_state = "shadow"
	layer = TURF_SHADOW_LAYER

/obj/structure/flora/tree/konyang/spring/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/konyang_tree
	icon_state = "beet_tree[rand(1, 3)]"
	return

/obj/structure/flora/tree/konyang/blossom
	desc = "A blossoming beet tree, its green canopy is beginning to take a lilac coloration as its leaves reach the end of their seasonal maturity."
	icon_state = "blossom_beet_tree_example"

/obj/structure/flora/tree/konyang/blossom/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/konyang_tree
	icon_state = "blossom_beet_tree[rand(1, 3)]"
	return

/obj/structure/flora/tree/konyang/fall
	desc = "A marvelous example of a jungle beet tree shedding its leaves. It takes on a deep pink tone, while its leaves slowly crumple and drift into the wind."
	icon_state = "fall_beet_tree_example"

/obj/structure/flora/tree/konyang/fall/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/konyang_tree
	icon_state = "fall_beet_tree[rand(1, 3)]"
	return

/obj/effect/decal/cleanable/generic/beet_tree_petals
	name = "beet tree petals"
	desc = "A wild assortment of loose petals from a beet tree, more akin to the shedding of flowers in appearance."
	icon = 'icons/obj/flora/konyang/clutter.dmi'
	icon_state = "petals"

/obj/effect/decal/cleanable/generic/beet_tree_petals/New()
	..()
	icon_state = "petals[rand(1, 6)]"
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

/obj/structure/flora/rock/konyang/small
	name = "pebble cluster"
	icon = 'icons/obj/flora/konyang/rocks.dmi'
	icon_state = "pebble"
	density = 0

/obj/structure/flora/rock/konyang/small/Initialize(mapload)
	. = ..()
	icon_state = "pebble[rand(1, 6)]"

/obj/structure/flora/bush/konyang_reeds
	name = "grass stalks"
	desc = "Thin and tall grass stalks, easy to sway to the wind and harsh to the touch."
	icon = 'icons/obj/flora/konyang/grass.dmi'
	icon_state = "stalks"
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

/obj/structure/flora/bush/konyang_reeds/Initialize(mapload)
	. = ..()
	icon_state = "stalks[rand(1, 5)]"

/obj/structure/flora/bush/konyang_reeds/Crossed(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		to_chat(L, "<span class='notice'>You brush through \the [src] really quite loudly.</span>")
		playsound(loc, 'sound/effects/plantshake.ogg', 60, TRUE)
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
