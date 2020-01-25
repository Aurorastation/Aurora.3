/obj/structure/cult/forge
	name = "daemon forge"
	desc = "A mysterious forge. The noxious heat emanating from it makes your skin crawl."
	description_antag = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie. This is a powerful forge. If you are a cultist, you can click on this with an item in-hand to cultify it. Some items may burn in the process, but some can be forged into better variants."
	icon_state = "forge"
	
/obj/structure/cult/forge/attackby(obj/item/W, mob/user)
	if(iscultist(user))
		W.cultify()
		to_chat(user, span("cult", "You put \the [W] into \the [src]. What remains, remains."))