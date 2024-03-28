/obj/structure/warp_drive
	name = "old warp drive"
	desc = "A worn down, partially dismantled warp drive. A marvel of engineering from a more civilized age. It doesn't look like it'll be moving anything any time soon."
	icon_state = "warpdrive"
	density = TRUE
	anchored = TRUE
	light_color = "#6C6CFF"
	light_power = 4
	light_range = 3

/obj/structure/warp_drive/teleporting/attack_hand(var/mob/user)
	do_teleport(user, get_turf(user), 8, asoundin = 'sound/effects/phasein.ogg')

/obj/structure/warp_drive/hammer/pirate
	name = "Modified Suzuki-Zhang Hammer Drive"
	desc = "\
		A Suzuki-Zhang Hammer Drive, commonly found on larger interstellar vessels. \
		This one appears to be heavily modified however to work with a smaller power supply, \
		and components from nearly every major megacorporation can be seen making it up.\
	"
