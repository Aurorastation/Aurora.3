//Captain's voidsuit
/obj/item/clothing/head/helmet/space/void/captain
	name = "command voidsuit helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment by SCC staff."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35

/obj/item/clothing/suit/space/void/captain
	name = "command voidsuit"
	desc = "A special suit designed for work in a hazardous, low-pressure environment by SCC staff."
	icon_state = "capspace"
	item_state = "capspace"
	item_state_slots = list(
		slot_l_hand_str = "capspacesuit",
		slot_r_hand_str = "capspacesuit"
	)
	w_class = ITEMSIZE_LARGE
	allowed = list(/obj/item/tank, /obj/item/device/flashlight,/obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs)
	slowdown = 1.5
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
