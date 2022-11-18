/obj/item/clothing/under/rank/scc2
	name = "\improper SCC uniform"
	desc = "A standardized uniform used by SCC personnel."
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_liaison"
	item_state = "scc_liaison"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/armor/vest/scc
	name = "\improper SCC vest"
	desc = "A stylish vest worn by SCC personnel."
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_liaison_vest"
	item_state = "scc_liaison_vest"
	contained_sprite = TRUE
	opened = null // Not used.
	allowed = list(
		/obj/item/gun,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/device/flashlight
	)
	body_parts_covered = UPPER_TORSO
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/toggle/armor/vest/scc/toggle_open()
	return

/obj/item/clothing/accessory/tie/corporate/scc
	name = "\improper SCC tie"
	desc = "A sleek corporate tie, worn by SCC employees."
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_tie"
	item_state = "scc_tie"
	contained_sprite = TRUE

/obj/item/clothing/head/beret/scc
	name = "\improper SCC beret"
	desc = "A corporate beret in the colours of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as the Chainlink, is a joint alliance between the NanoTrasen, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals, and Zavodskoi Interstellar corporations to exercise an undisputed economic dominance over the Orion Spur."
	icon = 'icons/obj/contained_items/scc.dmi'
	icon_state = "scc_beret"
	item_state = "scc_beret"
	contained_sprite = TRUE