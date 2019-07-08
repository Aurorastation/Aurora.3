/obj/item/weapon/gun/projectile/canon
	name = "hand canon"
	desc = "An amalgamation of ancient and modern tajaran technology. This old naval canon was turned into a portable firearm that can be used by a single soldier."
	icon_state = "hand_canon"
	item_state = "hand_canon"
	caliber = "canon ball"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/canon
	fire_delay = 25