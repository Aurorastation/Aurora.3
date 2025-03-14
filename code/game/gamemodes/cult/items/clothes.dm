/obj/item/clothing/head/culthood
	name = "ragged hood"
	icon_state = "culthood"
	desc = "A torn, dust-caked hood."
	desc_antag = "As a Cultist, this can be reforged to become an eldritch voidsuit helmet."
	flags_inv = HIDEFACE|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_CARBINE,
		LASER = ARMOR_LASER_RIFLE,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SMALL
		)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	var/obj/item/clothing/head/helmet/space/cult/C = new /obj/item/clothing/head/helmet/space/cult(get_turf(src))
	qdel(src)
	return C

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "ragged robe"
	desc = "A ragged, dusty robe."
	desc_antag = "As a Cultist, this item can be reforged to become an eldritch voidsuit."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/book/tome, /obj/item/melee/cultblade)
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_CARBINE,
		LASER = ARMOR_LASER_RIFLE,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SMALL
		)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	var/obj/item/clothing/suit/space/cult/C = new /obj/item/clothing/suit/space/cult(get_turf(src))
	qdel(src)
	return C

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/shoes/cult
	name = "ragged boots"
	desc = "A ragged, dusty pair of boots."
	icon = 'icons/obj/item/clothing/shoes/miscellaneous.dmi'
	icon_state = "cult"
	item_state = "cult"
	contained_sprite = TRUE
	force = 11
	silent = 1
	siemens_coefficient = 0.35 //antags don't get exceptions, it's just heavy armor by magical standards
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_MEDIUM,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SMALL
		)
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cult/cultify()
	return
