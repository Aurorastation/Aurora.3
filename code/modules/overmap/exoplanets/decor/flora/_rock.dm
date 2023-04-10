/obj/structure/flora/rock
	name = "rock"
	desc = "A rock."
	icon = 'icons/obj/flora/rocks_grey.dmi'
	icon_state = "basalt"

/obj/structure/flora/rock/pile
	name = "rocks"
	desc = "A pile of rocks."
	icon_state = "lavarocks"

/obj/structure/flora/rock/ice
	name = "ice"
	desc = "A large formation made of ice."
	icon = 'icons/obj/flora/ice_rocks.dmi'
	icon_state = "rock_1"

/obj/structure/flora/rock/ice/Initialize(mapload)
	. = ..()
	icon_state = "rock_[rand(1,2)]"
