/obj/item/weapon/gun/projectile/cannon
	name = "hand cannon"
	desc = "An amalgamation of ancient and modern tajaran technology. This old naval cannon was turned into a portable firearm."
	icon_state = "cannon"
	item_state = "cannon"
	caliber = "cannon"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS
	slot_flags = SLOT_BACK
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/cannon
	fire_delay = 25