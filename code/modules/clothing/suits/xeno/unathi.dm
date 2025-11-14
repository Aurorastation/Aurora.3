/obj/item/clothing/suit/unathi
	name = "abstract suit"
	icon = 'icons/obj/unathi_items.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "roughspun_robe"
	item_state = "roughspun_robe"
	protects_against_weather = TRUE

/obj/item/clothing/suit/unathi/robe/beige
	color = "#DBC684"

/obj/item/clothing/suit/unathi/robe/kilt
	name = "wasteland kilt"
	desc = "A long tunic made of old material that acts as a kilt for the poorest of Unathi, who aren't afraid to let \
	the sand and sun strike their scales."
	icon_state = "wasteland_kilt"
	item_state = "wasteland_kilt"

/obj/item/clothing/suit/unathi/robe/robe_coat
	name = "tzirzi robes"
	desc = "A casual garment native to Moghes typically worn by Unathi."
	icon_state = "robe_coat"
	item_state = "robe_coat"

/obj/item/clothing/suit/unathi/robe/robe_coat/orange
	icon_state = "robe_coat2"
	item_state = "robe_coat2"

/obj/item/clothing/suit/unathi/robe/robe_coat/blue
	icon_state = "robe_coat3"
	item_state = "robe_coat3"

/obj/item/clothing/suit/unathi/robe/robe_coat/red
	icon_state = "robe_coat4"
	item_state = "robe_coat4"

/obj/item/clothing/suit/unathi/jokfar
	name = "jokfar vest"
	desc = "The nobility favor this vest for its glamor, but although it isn't a garment to get in the way, it is \
	not ideal for physical labor."
	icon_state = "jokfar"
	item_state = "jokfar"
	build_from_parts = TRUE
	worn_overlay = "trim"

/obj/item/clothing/suit/unathi/wrapping
	name = "Th'akhist body wrappings"
	desc = "A bunch of stitched together clothing with bandages covering them. Looks tailored for a Unathi."
	desc_extended = "This is considered humble Sinta wear for Th'akh shamans— most Unathi don't wear these, barring Aut'akh."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "thakh_wrappings" //special thanks to Araskael
	item_state = "thakh_wrappings"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE
	protects_against_weather = TRUE

/obj/item/clothing/suit/armor/unathi/ancient
	name = "ancient bronze armor"
	desc = "An ancient bronze breastplate, remarkably well-preserved given how old it must be. It is unmistakably designed to fit an Unathi."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "ancient_armor"
	item_state = "ancient_armor"
	armor = list( //not designed to hold up to bullets or lasers, but still better than nothing.
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_SMALL
	)
	matter = list(MATERIAL_BRONZE = 1000)
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound

/obj/item/clothing/suit/armor/unathi/ancient/mador
	name = "\improper Sinta'Mador bronze armor"
	desc = "An ancient set of interlocking bronze plates, designed to reach to the knees of an Unathi. Those familiar with Moghresian archaeology might recognise this set as being a Sinta'Mador relic."
	icon_state = "mador_armor"
	item_state = "mador_armor"
