// Grass
/obj/structure/flora/grass
	name = "\proper grass"
	desc = "Some grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	density = FALSE

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"

// Bushes
/obj/structure/flora/bush
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	density = FALSE

/obj/structure/flora/bush/Initialize()
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"
