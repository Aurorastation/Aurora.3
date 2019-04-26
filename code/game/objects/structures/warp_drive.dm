/obj/structure/warp_drive
	name = "old warp drive"
	desc = "A worn down, partially dismantled warp drive. A marvel of engineering from a more civilized age. It doesn't look like it'll be moving anything any time soon."
	icon_state = "warpdrive"
	density = TRUE
	anchored = TRUE
	light_color = "#6C6CFF"
	light_power = 4
	light_range = 3

/obj/structure/warp_drive/attack_hand(var/mob/user)
	do_teleport(user, get_turf(user), 8, asoundin = 'sound/effects/phasein.ogg')