

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"

/obj/machinery/crystal/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "crystal2"
