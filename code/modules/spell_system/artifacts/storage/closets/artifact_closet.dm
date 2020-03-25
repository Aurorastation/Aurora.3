/obj/structure/closet/wizard
	name = "artifact closet"
	desc = "a special lead lined closet used to hold artifacts of immense power."
	icon = 'icons/obj/closet.dmi'
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"

/obj/structure/closet/wizard/Initialize()
	. = ..()
	var/obj/structure/bigDelivery/package = new /obj/structure/bigDelivery(get_turf(src))
	package.wrapped = src
	package.examtext = "Imported straight from the Wizard Academy. Do not lose the contents or suffer a demerit."
	src.forceMove(package)
	package.update_icon()