/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A rudimentary armor made of bones of several creatures."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "bonearmor"
	item_state = "bonearmor"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/bone
	name = "bone helmet"
	desc = "A rudimentary helmet made of some dead creature."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "skull"
	item_state = "skull"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)