/obj/item/hullbeacon
	name = "hull beacon"
	desc = "A light-emitting hull beacon."
	icon = 'icons/obj/lighting.dmi'
	anchored = TRUE

/obj/item/hullbeacon/attack_hand(mob/user)
	return

/obj/item/hullbeacon/red
	name = "red hull beacon"
	desc = "A light-emitting red hull beacon."
	icon_state = "beacon_red_on"
	light_color = LIGHT_COLOR_RED
	light_range = 3