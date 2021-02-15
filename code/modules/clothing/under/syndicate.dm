/obj/item/clothing/under/syndicate
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	has_sensor = 0
	armor = list(
		melee = ARMOR_MELEE_MINOR
		)
	siemens_coefficient = 0.75

/obj/item/clothing/under/syndicate/combat
	name = "combat turtleneck"

/obj/item/clothing/under/syndicate/tacticool
	name = "tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool"
	item_state = "bl_suit"
	worn_state = "tactifool"
	siemens_coefficient = 1
	has_sensor = 1
	armor = null

/obj/item/clothing/under/syndicate/tracksuit
	name = "tactical tracksuit"
	desc = "A tactical ready tracksuit, perfect for stealthy operations and squatting in cold places."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "fulltracksuit"
	item_state = "fulltracksuit"
	contained_sprite = 1

/obj/item/clothing/under/syndicate/ninja
	name = "slipsuit"
	desc = "A sleek, form-fitting undersuit designed to retain the wearer's mobility. It almost feels like you're wearing nothing at all."
	icon_state = "ninja"
	item_state = "ninja"
	worn_state = "ninja"