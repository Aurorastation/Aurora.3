// Axiomite tunic variants
/obj/item/clothing/under/dressshirt/axiom_tunic
	name = "axiomite tunic"
	desc = "This is a simple tunic formed of a thin, linen-like material flowing down \
		to the knees. It's the latest fashion on Axiom, the home-planet of the church \
		of the Trinary Perfection, a religion which seeks to raise synthetics to a point \
		of spiritual and temporal perfection. It is thin, breathable, and not at all suited \
		for very cold weather."
	icon = 'icons/obj/item/clothing/under/synthetic/trinary_tunics.dmi'
	icon_state = "axiomite_tunic"
	item_state = "axiomite_tunic"
	contained_sprite = TRUE

/obj/item/clothing/under/dressshirt/axiom_tunic/blue_trim
	icon_state = "axiomite_tunic_bluetrim"
	item_state = "axiomite_tunic_bluetrim"

/obj/item/clothing/under/dressshirt/axiom_tunic/black
	icon_state = "axiomite_tunic_black"
	item_state = "axiomite_tunic_black"

/obj/item/clothing/under/dressshirt/axiom_tunic/blue
	icon_state = "axiomite_tunic_blue"
	item_state = "axiomite_tunic_blue"

/obj/item/clothing/under/dressshirt/axiom_tunic/green
	icon_state = "axiomite_tunic_green"
	item_state = "axiomite_tunic_green"

/obj/item/clothing/under/dressshirt/axiom_tunic/ecclesiastical
	name = "ecclesiastical tunic"
	desc = "An Axiomite tunic cast in the colours of the Ecclesiastical Authority; the garb \
		of a bureaucrat or government official belonging to the church of the Trinary Perfection, \
		and appointed to responsibility in the planetary government of Axiom."
	icon_state = "axiomite_tunic_posh"
	item_state = "axiomite_tunic_posh"

// Capes!
/obj/item/clothing/accessory/poncho/trinary
	name = "trinary cape"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection."
	icon = 'icons/obj/item/clothing/accessory/poncho/trinarist_cape.dmi'
	icon_state = "trinary_cape"
	item_state = "trinary_cape"
	protects_against_weather = FALSE
	icon_override = null

/obj/item/clothing/accessory/poncho/trinary/blue
	desc = "A brilliant blue and grey cape, commonly worn by those who serve the Trinary Perfection."
	icon_state = "trinary_cape_blue"
	item_state = "trinary_cape_blue"

/obj/item/clothing/accessory/poncho/trinary/pellegrina
	name = "trinary perfection pellegrina"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection. This one is signifcantly shorter."
	icon_state = "trinary_pellegrina"
	item_state = "trinary_pellegrina"

/obj/item/clothing/accessory/poncho/trinary/pellegrina/blue
	desc = "A brilliant blue and grey cape, commonly worn by those who serve the Trinary Perfection. This one is signifcantly shorter."
	icon_state = "trinary_pellegrina_blue"
	item_state = "trinary_pellegrina_blue"

/obj/item/clothing/accessory/poncho/trinary/shouldercape
	name = "trinary perfection shoulder cape"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection. This one is worn over one shoulder."
	icon_state = "trinary_shouldercape"
	item_state = "trinary_shouldercape"

/obj/item/clothing/accessory/poncho/trinary/shouldercape/blue
	desc = "A brilliant blue and grey cape, commonly worn by those who serve the Trinary Perfection. This one is worn over one shoulder."
	icon_state = "trinary_shouldercape_blue"
	item_state = "trinary_shouldercape_blue"

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

/// Coifs!
/obj/item/clothing/head/trinary
	name = "trinary coif"
	desc = "This is a simple design of coif popular in Ecclesiastical Axiom, and among the \
		innumerable monastic orders of the Trinary Perfection dotted throughout the Orion Spur."
	icon = 'icons/obj/item/clothing/head/ipc/trinary_coif.dmi'
	icon_state = "trinary_coif"
	item_state = "trinary_coif"
	contained_sprite = TRUE

/obj/item/clothing/head/trinary/blue_trim
	icon_state = "trinary_coif_bluetrim"
	item_state = "trinary_coif_bluetrim"

/obj/item/clothing/head/trinary/black
	icon_state = "trinary_coif_black"
	item_state = "trinary_coif_black"

/obj/item/clothing/head/trinary/blue
	icon_state = "trinary_coif_blue"
	item_state = "trinary_coif_blue"

/obj/item/clothing/head/trinary/green
	icon_state = "trinary_coif_green"
	item_state = "trinary_coif_green"

/obj/item/clothing/head/trinary/habit
	icon_state = "trinary_coif_sodalist"
	item_state = "trinary_coif_sodalist"

/obj/item/clothing/head/trinary/ecclesiastical
	name = "ecclesiatical coif"
	desc = "A coif cast in the colours of the Ecclesiastical Authority; the headwear \
	of some bureaucrat or government official acting on behalf of the church of \
	the Trinary Perfection and its temporal holdings on Axiom."
	icon_state = "trinary_coif_ecclesiastical"
	item_state = "trinary_coif_ecclesiastical"

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
