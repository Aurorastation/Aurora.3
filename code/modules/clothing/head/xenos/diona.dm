/obj/item/clothing/head/diona/ekane
	name = "feather cap"
	desc = "A simple hat adorned with colorful feathers across its surface. Despite the design, wearers will feel the heat of the sun greater than without."
	icon = 'icons/obj/diona_items.dmi'
	item_state = "ekanehat"
	icon_state = "ekanehat"
	contained_sprite = TRUE

/obj/item/clothing/head/diona/ekane/decorated
	name = "decorated feather cap"
	desc = "An exuberant hat adorned with colorful feathers across its surface. Despite the design, wearers will feel the heat of the sun greater than without."
	item_state = "ekane_hatd"
	icon_state = "ekane_hatd"
	icon_override = null
	contained_sprite = TRUE
	build_from_parts = TRUE
	has_accents = TRUE

/obj/item/clothing/head/diona/voidtamer
	name = "carp hood"
	desc = "A hood made of aged and tanned carp hide, decorated with gold pointed structures across all sides."
	icon = 'icons/obj/diona_items.dmi'
	contained_sprite = TRUE
	item_state = "void_hood"
	icon_state = "void_hood"

/obj/item/clothing/head/diona/voidtamer/open
	name = "open carp hood"
	desc = "A hood made of aged and tanned carp hide, decorated with gold pointed structures across all sides. This one has an open visor, showing the wearer's face."
	item_state = "void_hood_open"
	icon_state = "void_hood_open"

/obj/item/clothing/head/hardhat/narrows
	name = "narrows hard hat"
	desc = "An old hard hat painted in Hephaestus colors, fabric hanging off the sides to protect the wearer's ears."
	icon = 'icons/obj/diona_items.dmi'
	icon_state = "narrows_hardhat"
	item_state = "narrows_hardhat"

/obj/item/clothing/head/helmet/voidtamer
	name = "voidtamer helmet"
	desc = "A hood-like helmet of hardened material, adorned with gold, typically worn by Dionae from the Voidtamer Confluence."
	icon = 'icons/obj/diona_items.dmi'
	icon_state = "void_helmet"
	item_state = "void_helmet"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_MELEE_MAJOR,
		LASER = ARMOR_LASER_KEVLAR,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
