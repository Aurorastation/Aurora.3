/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon = 'icons/obj/clothing/hats/hardhats.dmi'
	icon_state = "hardhat_yellow"
	item_state = "hardhat_yellow"
	light_overlay = "hardhat_light"
	contained_sprite = TRUE
	action_button_name = "Toggle Headlamp"
	brightness_on = 4 //luminosity when on
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_MINOR,
		rad = ARMOR_RAD_MINOR
	)
	flags_inv = 0
	w_class = ITEMSIZE_NORMAL
	siemens_coefficient = 0.9
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	light_wedge = LIGHT_WIDE
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat_orange"
	item_state = "hardhat_orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat_red"
	item_state = "hardhat_red"

/obj/item/clothing/head/hardhat/green
	icon_state = "hardhat_green"
	item_state = "hardhat_green"

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat_dblue"
	item_state = "hardhat_dblue"

/obj/item/clothing/head/hardhat/white
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight. This one looks heat-resistant."
	icon_state = "hardhat_white"
	item_state = "hardhat_white"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/atmos
	name = "atmospheric firefighter helmet"
	desc = "An atmospheric firefighter's helmet, able to keep the user protected from heat and fire."
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 15000
	icon = 'icons/clothing/kit/firefighter.dmi'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/fire.dmi'
	)
	icon_state = "atmos_fire"
	item_state = "atmos_fire"
	light_overlay = "atmos_fire"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")
	contained_sprite = TRUE
	min_pressure_protection = FIRESUIT_MIN_PRESSURE

/obj/item/clothing/head/hardhat/first_responder
	name = "medical helmet"
	desc = "A polymer helmet worn by first responders throughout human space to protect their heads. This one comes with an attached flashlight and has green crosses on the sides."
	icon_state = "helmet_paramed"
	item_state = "helmet_paramed"
	light_overlay = "EMS_light"

/obj/item/clothing/head/hardhat/firefighter
	name = "firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. It is airtight and has a port for internals."
	icon = 'icons/clothing/kit/firefighter.dmi'
	icon_state = "helmet_firefighter"
	item_state = "helmet_firefighter"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/fire.dmi'
	)
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")
	item_flags = THICKMATERIAL | AIRTIGHT
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = FIRESUIT_MIN_PRESSURE
	permeability_coefficient = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/head/hardhat/firefighter/chief
	name = "chief firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. This one is in the colors of the Chief Engineer. It is airtight and has a port for internals."
	icon_state = "helmet_firefighter_ce"
	item_state = "helmet_firefighter_ce"
