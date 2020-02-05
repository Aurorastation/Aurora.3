/obj/item/gun/projectile/plasma
	name = "plasma shotgun"
	desc = "A marvel of Elyran weapons technology which utilizes superheated plasma to pierce thick armor with gruesome results."
	icon = 'icons/obj/guns/slammer.dmi'
	icon_state = "slammer"
	item_state = "slammer"
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/plasma_slug
	magazine_type = /obj/item/ammo_magazine/plasma
	allowed_magazines = list(/obj/item/ammo_magazine/plasma)
	caliber = "plasma slug"
	fire_sound = 'sound/weapons/gunshot/slammer.ogg'
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS
	fire_delay = 8

/obj/item/gun/projectile/plasma/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-empty"


/obj/item/gun/projectile/plasma/bolter
	name = "plasma bolter"
	desc = "A miniaturized, less efficient version of the infamous plasma slammer. Sacrifices much of its power for a more compact frame."
	icon = 'icons/obj/guns/bolter.dmi'
	icon_state = "bolter"
	item_state = "bolter"
	w_class = ITEMSIZE_NORMAL
	ammo_type = /obj/item/ammo_casing/plasma_bolt
	magazine_type = /obj/item/ammo_magazine/plasma/light
	allowed_magazines = list(/obj/item/ammo_magazine/plasma/light)
	caliber = "plasma bolt"
	fire_sound = 'sound/weapons/gunshot/bolter.ogg'
	fire_delay = 6