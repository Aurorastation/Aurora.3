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

/obj/item/gun/energy/mountedplasma
	name = "plasma cannon"
	fire_sound = 'sound/weapons/gunshot/slammer.ogg'
	burst = 2
	burst_delay = 3
	max_shots = 15
	charge_cost = 100
	use_external_power = TRUE
	self_recharge = TRUE
	projectile_type = /obj/item/projectile/plasma

/obj/item/gun/projectile/plasma/bolter/pistol
	name = "plasma pistol"
	desc = "An Elyran designed firearm used for diplomatic protection and high value escort which fires super heated bolts of plasma. Rare outside of it's birth country due to the maintenance and production costs."
	icon = 'icons/obj/guns/plasma_pistol.dmi'
	icon_state = "plasma"
	item_state = "plasma"
	magazine_type = /obj/item/ammo_magazine/plasma/light/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/plasma/light/pistol)
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	accuracy = 1

/obj/item/gun/projectile/plasma/bolter/pistol/update_icon()
	..()
	if(ammo_magazine)
		var/ratio = length(ammo_magazine.stored_ammo) / ammo_magazine.max_ammo
		if(!length(ammo_magazine.stored_ammo))
			ratio = 0
		else
			ratio = max((round(ratio, 0.25) * 100), 25)
		icon_state = "[initial(icon_state)][ratio]"
		item_state = "[initial(item_state)][ratio]"
	else
		icon_state = "[initial(icon_state)]-empty"
		item_state = "[initial(item_state)]-empty"