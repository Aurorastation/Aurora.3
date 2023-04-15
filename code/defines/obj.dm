/obj/effect/mark
		var/mark = ""
		icon = 'icons/misc/mark.dmi'
		icon_state = "blank"
		anchored = 1
		layer = 99
		mouse_opacity = 0
		unacidable = 1//Just to be sure.

/obj/effect/beam
	name = "beam"
	density = 0
	unacidable = 1//Just to be sure.
	var/def_zone
	flags = PROXMOVE
	pass_flags = PASSTABLE | PASSRAILING

/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		rank = replacetext(rank, "[prefix] ", "")
	for(var/datum/faction/faction as anything in SSjobs.factions)
		rank = replacetext(rank, " ([faction.title_suffix])", "")
	return rank

/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "beachball"
	density = 0
	anchored = 0
	w_class = ITEMSIZE_LARGE
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	flags = CONDUCT
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed, user)

/obj/effect/spawner
	name = "object spawner"

/obj/structure/spaceship
	name = "Abandoned Shuttle"
	desc = "An ancient and inoperable shuttle-craft"
	icon = 'icons/obj/machinery/spaceship.dmi'
	anchored = 1
	density = 1

/obj/structure/mainframe
	name = "Ancient Mainframe"
	desc = "A long-fried AI mainframe from the 2420s. It's more fit to be holding rats than AIs at this point."
	icon = 'icons/obj/mainframe.dmi'
	anchored = 1
	density = 1
