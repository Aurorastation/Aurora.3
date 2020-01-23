/obj/item/clothing/head/culthood
	name = "ragged hood"
	icon_state = "culthood"
	desc = "A torn, dust-caked hood."
	flags_inv = HIDEFACE|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 20, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	new /obj/item/clothing/head/helmet/space/cult(get_turf(src))
	..()

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "ragged robes"
	desc = "A ragged, dusty set of robes."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/book/tome, /obj/item/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 20, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	new /obj/item/clothing/suit/space/cult(get_turf(src))
	..()

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"