/obj/structure/automobile
	name = "generic automotive"
	desc = "A newer model of automotive."
	icon = 'icons/obj/structure/urban/cars.dmi'
	icon_state = "box"
	anchored = TRUE
	density = TRUE
	layer = 7

/obj/structure/automobile/random/New()
	name = "[pick("deluxe Shibata Sport automotive","beat-up Poplar Auto Group automotive","weathered Shibata Sport automotive","beat-up Langenfeld automotive","deluxe Langenfeld automotive","weathered Langenfeld automotive")]
	desc = "A [name] vehicle of working condition."
	icon_state = "[pick("box","urban")]
	..()

/obj/structure/automobile/police
	name = "police cruiser"
	desc = "A police vehicle with all the bells and whistles you'd expect from a decently-funded agency."
	icon_state = "copcar"

/obj/structure/automobile_filler
	name = "vehicle"
	desc = "A piece of a larger vehicle."
	icon = 'icons/obj/structure/urban/cars.dmi'
	icon_state = "blank"
	anchored = TRUE
	density = TRUE

/obj/structure/closet/crate/bin/urban
	name = "tall garbage can"
	desc = "Garbage day!"
	icon = 'icons/obj/structure/urban/waste.dmi'
	icon_state = "bin"

/obj/structure/closet/crate/bin/urban/compact
	name = "discrete garbage can"
	icon_state = "city-bin"
	anchored = TRUE

/obj/structure/closet/crate/bin/urban/dumpster
	name = "extra-wide hefty dumpster"
	desc = "This trunk carries a lot of junk."
	icon_state = "dumpster"
	anchored = TRUE

/obj/structure/shipping_container
	name = "freight container"
	desc = "A hulking industrial shipping container, bound for who knows where."
	icon = 'icons/obj/structure/industrial/shipping_containers.dmi'
	icon_state = "blue1"
	anchored = TRUE
	density = TRUE
	layer = 7

/obj/effect/overlay/container_logo
	name = "Hephaestus Industries emblem"
	icon = 'icons/obj/structure/industrial/shipping_containers.dmi'
	icon_state = "heph1"

/obj/effect/overlay/container_logo/einstein
	name = "Einstein Engines emblem"
	icon_state = "EE1"

/obj/effect/overlay/container_logo/zenghu
	name = "Zeng-Hu Pharmaceuticals emblem"
	icon_state = "zeng1"
