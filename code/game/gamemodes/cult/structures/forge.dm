/obj/structure/cult/forge
	name = "daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie."
	icon_state = "forge"

/obj/structure/cult/forge/attackby(obj/item/W, mob/user)
	W.cultify()
	to_chat(user, span("cult", "You put \the [W] into \the [src]. What remains, remains."))