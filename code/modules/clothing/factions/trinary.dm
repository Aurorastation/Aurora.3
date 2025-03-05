/obj/item/clothing/suit/trinary_robes/habit
	name = "trinary perfection habit"
	desc = "Robes worn by those who serve The Trinary Perfection."
	icon_state = "trinary_habit"
	item_state = "trinary_habit"
	icon = 'icons/clothing/suits/trinary_habit.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/trinary_robes/templeist
	name = "templeist robe"
	desc = "A robe worn by members of the Lodge of Temple Architect, an order within the Trinary Perfection focused on technological and industrial development."
	icon_state = "templeist_robe"
	item_state = "templeist_robe"
	icon = 'icons/clothing/suits/templeist_robe.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/trinary
	name = "trinary coif"
	desc = "A coif worn primarily by members of the Monastic Sorority of Our Lady Corkfell, a religious order within the Trinary Perfection focused on the medical needs of its human practicioners. It seems to be made out of a light \
	and breathable material in order to cope with Orepit's hot summers."
	icon = 'icons/clothing/head/trinary_coif.dmi'
	icon_state = "trinary_coif"
	item_state = "trinary_coif"
	contained_sprite = TRUE

//Exclusionist Gear
/obj/item/clothing/suit/storage/hooded/exclusionist_robe
	name = "exclusionist robes"
	desc = "Red and gold robes worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon = 'icons/clothing/suits/exclusionist_robes.dmi'
	icon_state = "exclusionist_robe_priest"
	item_state = "exclusionist_robe_priest"
	hoodtype = /obj/item/clothing/head/winterhood/exclusionist
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/hooded/exclusionist_robe/warpriest
	name = "exclusionist warpriest's robe"
	desc = "Black and gold robes worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon_state = "exclusionist_robe_warpriest"
	item_state = "exclusionist_robe_warpriest"
	hoodtype = /obj/item/clothing/head/winterhood/exclusionist/warpriest

/obj/item/clothing/head/winterhood/exclusionist
	name = "exclusionist hood"
	desc = "A red and gold hood worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon = 'icons/clothing/suits/exclusionist_robes.dmi'
	icon_state = "exclusionist_robe_priest_hood"
	item_state = "exclusionist_robe_priest_hood"

/obj/item/clothing/head/winterhood/exclusionist/warpriest
	name = "exclusionist warpriest's hood"
	desc = "A black and gold hood worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon_state = "exclusionist_robe_warpriest_hood"
	item_state = "exclusionist_robe_warpriest_hood"

/obj/item/clothing/ears/antenna/trinary_halo/exclusionist
	color = "#1c1c1c"

/obj/item/clothing/suit/armor/exclusionist
	name = "armored exclusionist robe"
	desc = "Robes worn by those who follow the Exclusionist heresy of the Trinary Perfection. These ones seem to have been reinforced for battle."
	icon = 'icons/clothing/suits/exclusionist_robes.dmi'
	icon_state = "exclusionist_armored_robe"
	item_state = "exclusionist_armored_robe"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	contained_sprite = TRUE
	slowdown = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

/obj/item/clothing/mask/exclusionist
	name = "exclusionist mask"
	desc = "A fearsome steel mask, worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon = 'icons/clothing/suits/exclusionist_robes.dmi'
	icon_state = "exclusionist_mask"
	item_state = "exclusionist_mask"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_SMALL,
		BULLET = ARMOR_BALLISTIC_SMALL,
		LASER = ARMOR_LASER_MINOR,
		BIO = ARMOR_BIO_STRONG
	)
	flash_protection = FLASH_PROTECTION_MODERATE
