/obj/item/hullbeacon
	name = "hull beacon"
	desc = "A light-emitting hull beacon."
	icon = 'icons/obj/lighting.dmi'
	anchored = TRUE
	light_system = MOVABLE_LIGHT
	light_range = 3

/obj/item/hullbeacon/Initialize()
	. = ..()
	set_light_on(TRUE)

/obj/item/hullbeacon/attack_hand(mob/user)
	return

/obj/item/hullbeacon/red
	name = "red hull beacon"
	desc = "A red, light-emitting hull beacon."
	icon_state = "beacon_red_on"
	light_color = LIGHT_COLOR_RED

/obj/item/hullbeacon/green
	name = "green hull beacon"
	desc = "A green, light-emitting hull beacon."
	icon_state = "beacon_green_on"
	light_color = LIGHT_COLOR_GREEN
