/obj/item/clothing/suit/armor/tactical/nka
	name = "chestplate"
	desc = "The standard body armor of the Imperial Army"
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "chest_armour"
	item_state = "chest_armour"
	contained_sprite = TRUE
	armor = list(melee = 50, bullet = 50, laser = 15, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	pocket_size = 2

/obj/item/clothing/suit/armor/tactical/nka/grenadier
	desc = "The standard body armor of the Royal Grenadiers"
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "roygrenchest"
	item_state = "roygrenchest"
	armor = list(melee = 70, bullet = 70, laser = 20, energy = 10, bomb = 25, bio = 0, rad = 0)
	pocket_size = 4

/obj/item/clothing/suit/armor/hunter
	name = "heavy coat"
	desc = "A heavy pelt coat, commonly used by Adhomian hunters on the field."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "hunter_coat"
	item_state = "hunter_coat"
	contained_sprite = TRUE
	armor = list(melee = 30, bullet = 20, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/constable
	name = "padded coat"
	desc = "A simple padded coat, commonly used by Chief Constables of the New Kingdom."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "chief_constable"
	item_state = "chief_constable"
	contained_sprite = TRUE
	armor = list(melee = 40, bullet = 25, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/pra
	name = "republican jacket"
	desc = "A padded military jacket,commonly used by Republican officers."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "greenservice"
	item_state = "greenservice"
	contained_sprite = TRUE
	armor = list(melee = 40, bullet = 20, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/apron/brown
	desc = "A brown apron, commonly used by blacksmiths."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "apron"
	item_state = "apron"
	contained_sprite = TRUE
	allowed = list (/obj/item/weapon/material/blacksmith_hammer)

/obj/item/clothing/suit/storage/archeologist
	name = "brown jacket"
	desc = "A brown jacket used by archeologist and treasure hunters."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "explorer_jacket"
	item_state = "explorer_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 20, bullet = 15, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/brown_jacket
	name = "brown jacket"
	desc = "A brown jacket, rugged and durable."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "explorer_jacket"
	item_state = "explorer_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/padded_coat
	name = "warm padded coat"
	desc = "A simple padded coat heavy jacket, for warmth, not for protection."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "chief_constable"
	item_state = "chief_constable"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/chef/nka
	name = "royal cooking coat"
	desc = "A royal cooking niform, it has gilded buttons on its cuffs and ranking epaulets don its shoulders."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "cook_coat"
	item_state = "cook_coat"
	contained_sprite = TRUE
	allowed = list(
		/obj/item/weapon/material/kitchen/rollingpin,
		/obj/item/weapon/material/hatchet/butch,
		/obj/item/weapon/material/knife)