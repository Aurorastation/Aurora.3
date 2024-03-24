/singleton/item_modifier/space_suit
	name = "Generic"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "void helmet",
			SETUP_DESCRIPTION = "A high-tech dark red space suit helmet. Used for AI satellite maintenance.",
			SETUP_ICON = 'icons/obj/clothing/hats.dmi',
			SETUP_ICON_STATE = "void",
			SETUP_LIGHT_OVERLAY = "helmet_light",
			SETUP_ARMOR = list(
				melee = ARMOR_MELEE_RESISTANT,
				bullet = ARMOR_BALLISTIC_MINOR,
				laser = ARMOR_LASER_SMALL,
				energy = ARMOR_ENERGY_MINOR,
				bomb = ARMOR_BOMB_PADDED,
				bio = ARMOR_BIO_SHIELDED,
				rad = ARMOR_RAD_MINOR
			),
			SETUP_MAX_PRESSURE = VOIDSUIT_MAX_PRESSURE,
			SETUP_MAX_TEMPERATURE = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE,
			SETUP_SIEMANS_COEFFICIENT = 0.5
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "voidsuit",
			SETUP_DESCRIPTION = "A high-tech dark red space suit. Used for AI satellite maintenance.",
			SETUP_ICON = 'icons/obj/clothing/suits.dmi',
			SETUP_ICON_STATE = "void",
			SETUP_ARMOR = list(
				melee = ARMOR_MELEE_RESISTANT,
				bullet = ARMOR_BALLISTIC_MINOR,
				laser = ARMOR_LASER_SMALL,
				energy = ARMOR_ENERGY_MINOR,
				bomb = ARMOR_BOMB_PADDED,
				bio = ARMOR_BIO_SHIELDED,
				rad = ARMOR_RAD_MINOR
			),
			SETUP_MAX_PRESSURE = VOIDSUIT_MAX_PRESSURE,
			SETUP_MAX_TEMPERATURE = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE,
			SETUP_SIEMANS_COEFFICIENT = 0.5,
			SETUP_ALLOWED = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit)
		)
	)

/singleton/item_modifier/space_suit/engineering
	name = "Engineering"

/singleton/item_modifier/space_suit/engineering/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "engineering voidsuit helmet"
	helmet_setup[SETUP_DESCRIPTION] = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	helmet_setup[SETUP_ICON_STATE] = "rig0-engineering"
	helmet_setup[SETUP_ARMOR] = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	helmet_setup[SETUP_MAX_PRESSURE] = ENG_VOIDSUIT_MAX_PRESSURE
	helmet_setup[SETUP_LIGHT_OVERLAY] = "helmet_light_dual_low"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "engineering voidsuit"
	suit_setup[SETUP_DESCRIPTION] = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	suit_setup[SETUP_ICON_STATE] = "rig-engineering"
	suit_setup[SETUP_ARMOR] = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	suit_setup[SETUP_MAX_PRESSURE] = ENG_VOIDSUIT_MAX_PRESSURE
	suit_setup[SETUP_ALLOWED_ITEMS] = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction,/obj/item/storage/bag/inflatable)

/singleton/item_modifier/space_suit/atmospherics
	name = "Atmospherics"

/singleton/item_modifier/space_suit/atmospherics/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_NAME] = "atmospherics voidsuit helmet"
	helmet_setup[SETUP_DESCRIPTION] = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	helmet_setup[SETUP_ICON_STATE] = "rig0-atmos"
	helmet_setup[SETUP_ARMOR] = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	helmet_setup[SETUP_MAX_TEMPERATURE] = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000
	helmet_setup[SETUP_MAX_PRESSURE] = FIRESUIT_MAX_PRESSURE
	helmet_setup[SETUP_LIGHT_OVERLAY] = "helmet_light_dual_low"

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_NAME] = "engineering voidsuit"
	suit_setup[SETUP_DESCRIPTION] = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	suit_setup[SETUP_ICON_STATE] = "rig-atmos"
	suit_setup[SETUP_ARMOR] = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	suit_setup[SETUP_MAX_TEMPERATURE] = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000
	suit_setup[SETUP_MAX_PRESSURE] = FIRESUIT_MAX_PRESSURE
	suit_setup[SETUP_ALLOWED_ITEMS] = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction,/obj/item/storage/bag/inflatable)
