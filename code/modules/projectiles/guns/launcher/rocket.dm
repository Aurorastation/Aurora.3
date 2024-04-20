/obj/item/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon = 'icons/obj/guns/rocket.dmi'
	icon_state = "rocket"
	item_state = "rocket"
	w_class = ITEMSIZE_LARGE
	throw_speed = 2
	throw_range = 10
	force = 11
	obj_flags =  OBJ_FLAG_CONDUCTABLE
	slot_flags = 0
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	needspin = FALSE

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()

/obj/item/gun/launcher/rocket/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		. += "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>"

/obj/item/gun/launcher/rocket/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			user.drop_from_inventory(attacking_item, src)
			rockets += attacking_item
			to_chat(user, "<span class='notice'>You put the rocket in [src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")
		else
			to_chat(usr, "<span class='warning'>[src] cannot hold more rockets.</span>")

/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
	log_game("[key_name(user)] used a rocket launcher ([src.name]) at [target].",ckey=key_name(src))
	..()

/obj/item/gun/launcher/rocket/konyang
	name = "konyang rocket launcher"
	desc = "An unguided rocket launcher often used by the armed forces of Konyang."
	desc_extended = "The KGM-701 is a heavy anti-tank guided missile in use by the Konyang Army, another carryover from their old Solarian stockpiles. Capable of handling any tank that wouldn't get bogged down on Konyang's soft terrain, the KGM-701 is expected to soldier on for many years to come. This however, is not a KGM-701, but the KGM-701D, the unguided discount variation of the old Solarian ATGM, typically issued to colonial garrisons and not rated against any modern vehicles."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "kgm"
	item_state = "kgm"
