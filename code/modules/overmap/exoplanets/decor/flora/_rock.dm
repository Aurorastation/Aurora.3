/obj/structure/flora/rock
	name = "rock"
	desc = "A rock."
	icon = 'icons/obj/flora/rocks_grey.dmi'
	icon_state = "basalt"

/obj/structure/flora/rock/random/Initialize(mapload)
	. = ..()
	icon_state = "basalt[rand(1,3)]"

/obj/structure/flora/rock/pile
	name = "rocks"
	desc = "A pile of rocks."
	icon_state = "lavarocks"

/obj/structure/flora/rock/pile/random/Initialize(mapload)
	. = ..()
	icon_state = "lavarocks[rand(1,3)]"

/obj/structure/flora/rock/ice
	name = "ice"
	desc = "A large formation made of ice."
	icon = 'icons/obj/flora/ice_rocks.dmi'
	icon_state = "rock_1"

/obj/structure/flora/rock/ice/Initialize(mapload)
	. = ..()
	icon_state = "rock_[rand(1,3)]"

/obj/structure/flora/rock/snow
	name = "snowy boulder"
	desc = "A weathered boulder, coated in a fine dusting of snow."
	icon = 'icons/obj/flora/snowrocks.dmi'
	icon_state = "rocklarge1"

/obj/structure/flora/rock/snow/Initialize(mapload)
	. = ..()
	icon_state = "rocklarge[rand(1,2)]"

/obj/effect/floor_decal/snowrocks
	name = "snow rocks"
	icon = 'icons/obj/flora/snowrocks.dmi'
	icon_state = "rocksmall1"

/obj/effect/floor_decal/snowrocks/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "rocksmall[rand(1,2)]"
	. = ..()
