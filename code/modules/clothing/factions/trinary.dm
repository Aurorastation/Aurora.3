// Orthodox Trinarist gear
/obj/item/clothing/suit/storage/hooded/trinary_robes
	name = "trinary perfection robe"
	desc = "Robes worn by those who serve The Trinary Perfection."
	icon_state = "trinary_robe"
	item_state = "trinary_robe"
	icon = 'icons/obj/item/clothing/suit/trinarist_robes.dmi'
	hoodtype = /obj/item/clothing/head/winterhood/trinary
	contained_sprite = TRUE

/obj/item/clothing/head/winterhood/trinary
	name = "trinary perfection hood"
	desc = "A hood worn by those who serve the Trinary Perfection."
	icon_state = "trinary_robe_hood"
	item_state = "trinary_robe_hood"
	icon = 'icons/obj/item/clothing/suit/trinarist_robes.dmi'
	flags_inv = HIDEEARS | HIDEEARS // We don't want this to block hair.

/obj/item/clothing/suit/storage/hooded/trinary_robes/templeist
	name = "templeist robes"
	desc = "A robe worn by members of the Lodge of Temple Architect, an order within the Trinary Perfection \
	focused on technological and industrial development."
	icon_state = "templeist_robe"
	item_state = "templeist_robe"
	hoodtype = /obj/item/clothing/head/winterhood/trinary/templeist
	contained_sprite = TRUE

/obj/item/clothing/head/winterhood/trinary/templeist
	name = "templeist hood"
	desc = "A hood worn by members of the Lodge of Temple Architect, an order within the Trinary Perfection \
	focused on technological and industrial development."
	icon_state = "templeist_robe_hood"
	item_state = "templeist_robe_hood"

/obj/item/clothing/suit/storage/hooded/trinary_robes/habit
	name = "trinary perfection habit"
	desc = "Robes worn by those who serve The Trinary Perfection."
	icon_state = "trinary_habit"
	item_state = "trinary_habit"
	hoodtype = /obj/item/clothing/head/winterhood/trinary/habit
	contained_sprite = TRUE

/obj/item/clothing/head/winterhood/trinary/habit
	name = "trinary perfection habit hood"
	desc = "A hood worn by those who serve the Trinary Perfection."
	icon_state = "trinary_habit_hood"
	item_state = "trinary_habit_hood"

/obj/item/clothing/head/trinary
	name = "trinary coif"
	desc = "A coif worn primarily by members of the monastic Sodality of Our Lady Corkfell, a religious order within the Trinary Perfection focused on the medical needs of its human practicioners. It seems to be made out of a light \
	and breathable material in order to cope with Axiom's hot summers."
	icon = 'icons/obj/item/clothing/head/ipc/trinary_coif.dmi'
	icon_state = "trinary_coif"
	item_state = "trinary_coif"
	contained_sprite = TRUE

//Exclusionist Gear
/obj/item/clothing/suit/storage/hooded/exclusionist_robe
	name = "exclusionist robes"
	desc = "Red and gold robes worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon = 'icons/obj/item/clothing/suit/storage/exclusionist_robes.dmi'
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
	icon = 'icons/obj/item/clothing/suit/storage/exclusionist_robes.dmi'
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
	icon = 'icons/obj/item/clothing/suit/storage/exclusionist_robes.dmi'
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
	slowdown = 0.5
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

/obj/item/clothing/mask/exclusionist
	name = "exclusionist mask"
	desc = "A fearsome steel mask, worn by those who follow the Exclusionist heresy of the Trinary Perfection."
	icon = 'icons/obj/item/clothing/suit/storage/exclusionist_robes.dmi'
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
