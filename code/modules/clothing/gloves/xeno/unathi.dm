/obj/item/clothing/gloves/unathi
	name = "cloth handwraps"
	desc = "A roll of treated cloth used for wrapping clawed hands. Its growing popularity among unathi can be attributed to the cheap nature of its production and the utility it may provide in a pinch."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "handwrap"
	item_state = "handwrap"
	contained_sprite = TRUE
	species_restricted = null
	slot_flags = SLOT_GLOVES|SLOT_WRISTS
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/clothing/gloves/unathi/ancient
	name = "ancient bronze gauntlets"
	desc = "A set of heavy bronze gauntlets, tarnished from centuries of age. They appear to be made to fit clawed hands."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "ancient_gauntlets"
	item_state = "ancient_gauntlets"
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE
	armor = list( //not designed to hold up to bullets or lasers, but still better than nothing.
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_SMALL
	)
	force = 5
	punch_force = 5
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	matter = list(MATERIAL_BRONZE = 1000)

/obj/item/clothing/gloves/unathi/ancient/mador
	name = "\improper Sinta'Mador bladed gauntlets"
	desc = "A set of bronze gauntlets, adorned with wickedly sharp curved blades. Those familiar with Moghresian archaeology might recognize these as being forged in a Sinta'Mador style."
	icon_state = "mador_gauntlets"
	item_state = "mador_gauntlets"
	sharp = 1
	edge = TRUE
