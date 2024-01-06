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
	has_sensor = SUIT_HAS_SENSORS
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

/obj/item/clothing/under/syndicate/hammertail
	name = "\improper crimson jumpsuit"
	desc = "A blood-red jumpsuit with purple shoulder patches and a thick black apron tied around the front. The patches are cut in the shape of two energy swords."
	desc_extended = "While black markets may be common, the concept of a “black factory” is much rarer, the idea of an entire industry producing and selling in \
	illegality, generally to other criminal elements. The Hammertail Smiths are just that, an organization of engineers, scientists, machinists, and industrial workers \
	whose ingenuity, and occasionally deranged inspiration, is fueled and funded by eager clients, from pirate fleets and other Unathi criminal organizations to \
	individual actors, may they be in the Hegemony, or on the other side of the spur."
	icon = 'icons/obj/item/clothing/under/hammertail.dmi'
	icon_state = "hammertail"
	item_state = "hammertail"
	worn_state = "hammertail"
	contained_sprite = TRUE
