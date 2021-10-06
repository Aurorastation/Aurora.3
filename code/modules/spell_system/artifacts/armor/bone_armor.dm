/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A rudimentary armor made of bones of several creatures."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "bonearmor"
	item_state = "bonearmor"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_SKELETON)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = ARMOR_MELEE_MAJOR, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/bone
	name = "bone helmet"
	desc = "A rudimentary helmet made of some dead creature."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "skull"
	item_state = "skull"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_SKELETON)
	armor = list(melee = ARMOR_MELEE_MAJOR, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)