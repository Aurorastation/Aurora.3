/obj/item/clothing/under/rank/scc2
	name = "\improper SCC uniform"
	desc = "A standardized uniform used by SCC personnel."
	contained_sprite = TRUE
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_liaison"
	item_state = "scc_liaison"


/obj/item/clothing/suit/storage/toggle/armor/vest/scc
	name = "SCC vest"
	desc = "A stylish vest worn by SCC personnel."
	contained_sprite = TRUE
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_liaison_vest"
	item_state = "scc_liaison_vest"
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	body_parts_covered = UPPER_TORSO
	cold_protection = 0
	min_cold_protection_temperature = 0
	heat_protection = 0
	max_heat_protection_temperature = 0
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/toggle/armor/vest/scc/toggle_open()
	to_chat(usr ,"Safety regulations forbid you from opening the stab-vest while on the job.")
	return

/obj/item/clothing/accessory/tie/corporate/scc
	name = "SCC tie"
	desc = "A sleek corporate tie, worn by SCC employees."
	contained_sprite = TRUE
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_tie"
	item_state = "scc_tie"

/obj/item/clothing/head/beret/scc
	name = "SCC beret"
	desc = "A corporate beret in the colours of the Stellar Corporate Conglomerate."
	contained_sprite = TRUE
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_beret"
	item_state = "scc_beret"
