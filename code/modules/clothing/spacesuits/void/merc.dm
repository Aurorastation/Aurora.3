//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	item_state_slots = list(
		slot_l_hand_str = "syndie_helm",
		slot_r_hand_str = "syndie_helm"
	)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "merc_voidsuit_lights"
	camera = /obj/machinery/camera/network/mercenary
	brightness_on = 6
	light_color = "#ffffff"

/obj/item/clothing/suit/space/void/merc
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	icon_state = "rig-syndie"
	item_state = "rig-syndie"
	item_state_slots = list(
		slot_l_hand_str = "syndie_hardsuit",
		slot_r_hand_str = "syndie_hardsuit"
	)
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
