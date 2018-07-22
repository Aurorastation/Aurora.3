/obj/structure/sarcophagus
	name = "sarcophagus"
	desc = "A sealed ancient sarcophagus."
	icon = 'icons/obj/sarcophagus.dmi'
	icon_state = "sarcophagus"
	density = 1
	anchored = 1
	var/open = FALSE

/obj/structure/sarcophagus/update_icon()
	if(open)
		icon_state = "sarcophagus_open"
	else
		icon_state = initial(icon_state)

/obj/structure/sarcophagus/attackby(obj/item/I as obj, mob/user as mob)
	if(open)
		return
	if(istype(I, /obj/item/sarcophagus_key))
		open()

/obj/structure/sarcophagus/proc/open()
	open = TRUE
	update_icon()
