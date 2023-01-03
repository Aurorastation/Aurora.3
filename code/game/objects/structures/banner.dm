/obj/structure/banner
	name = "corporate banner"
	desc = "A blue flag emblazoned with a golden logo of NanoTrasen hanging from a wooden stand."
	anchored = TRUE
	density = TRUE
	layer = 9
	var/icon_up = "banner_up"
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner_down"

/obj/structure/banner/verb/toggle()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Banner"

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	if(icon_state == initial(icon_state))
		icon_state = icon_up
		to_chat(usr, "You roll up the cloth.")
	else
		icon_state = initial(icon_state)
		to_chat(usr, "You roll down the cloth.")


	src.update_icon()

/obj/structure/banner/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		anchored = !anchored
		playsound(src.loc, W.usesound, 75, 1)
		user.visible_message("[user.name] [anchored ? "" : "un" ]secures \the [src.name] [anchored ? "to" : "from" ] the floor.", "You [anchored ? "" : "un" ]secure \the [src.name] [anchored ? "to" : "from" ] the floor.", "You hear a ratchet.")
		return

/obj/structure/banner/unmovable

/obj/structure/banner/unmovable/attackby(obj/item/W, mob/user)
	return

/obj/structure/banner/newgibson
	name = "\improper New Gibson banner"
	desc = "A banner depicting the flag of New Gibson."
	icon_state = "newgibson_down"
	icon_up = "newgibson_up"

/obj/structure/banner/scc
	name = "\improper Stellar Corporate Conglomerate banner"
	desc = "A deep blue banner adorned with the logo of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "scc_banner_down"
	icon_up = "scc_banner_up"
