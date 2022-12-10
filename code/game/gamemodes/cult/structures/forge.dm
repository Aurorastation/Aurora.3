/obj/structure/cult/forge
	name = "daemon forge"
	desc = "A mysterious forge. The noxious heat emanating from it makes your skin crawl."
	desc_antag = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie. This is a powerful forge. If you are a cultist, you can click on this with an item in-hand to cultify it. Some items may burn in the process, but some can be forged into better variants."
	icon_state = "forge"

/obj/structure/cult/forge/attackby(obj/item/W, mob/user)
	if(iscultist(user))
		var/stored_message = "You cast \the [W] into the forge, where it rapidly changes form. In a flash, you see it reappear on your person."
		var/cult_item = W.cultify(TRUE)
		if(isnull(cult_item))
			to_chat(user, SPAN_WARNING("You get the idea that you can't reforge this."))
		else if(istype(cult_item, /obj/item))
			user.put_in_hands(cult_item)
			to_chat(user, SPAN_CULT(stored_message))
			return TRUE
		else if(!isnull(cult_item)) // it didn't return an item
			to_chat(user, SPAN_CULT(cult_item)) // but i still want it to play a message
			return TRUE
