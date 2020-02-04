/obj/item/gun/energy/temperature
	name = "freeze ray"
	icon = 'icons/obj/guns/freezegun.dmi'
	icon_state = "freezegun"
	item_state = "freezegun"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "A gun that changes temperatures. It has a small label on the side, 'More extreme temperatures will cost more charge!'"
	var/temperature = T20C
	var/current_temperature = T20C
	charge_cost = 100
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK

	projectile_type = /obj/item/projectile/temp
	can_turret = 1
	turret_sprite_set = "temperature"

	cell_type = /obj/item/cell/crap //WAS High, but brought down to match energy use

	needspin = FALSE

/obj/item/gun/energy/temperature/Topic(href, href_list)
	if (..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)