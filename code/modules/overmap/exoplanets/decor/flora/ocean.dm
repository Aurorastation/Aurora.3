/obj/structure/flora/bush/seaweed
	name = "seaweed"
	desc = "A dense growth of seaweed erupting from an unseen depth."
	icon = 'icons/obj/flora/oceanflora.dmi'
	icon_state = "seaweed"

/obj/structure/flora/bush/seaweed/Initialize()
	. = ..()
	icon_state = "seaweed[rand(1,5)]"

/obj/structure/flora/bush/kelp
	name = "dense kelp"
	desc = "A dense growth of kelp erupting from an unseen depth."
	icon = 'icons/obj/flora/oceanflora.dmi'
	icon_state = "kelp"

/obj/structure/flora/bush/kelp/Initialize()
	. = ..()
	icon_state = "kelp[rand(1,5)]"
