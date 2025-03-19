// Station voidsuits
//Engineering rig
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
	icon_state = "engineering_helm"
	item_state = "engineering_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "engineering_helm",
		slot_l_hand_str = "engineering_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
	icon_state = "engineering"
	item_state = "engineering"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "engineering",
		slot_l_hand_str = "engineering"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	slowdown = 1
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction,/obj/item/storage/bag/inflatable)

//Mining rig
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon = 'icons/obj/clothing/voidsuit/station/mining.dmi'
	icon_state = "mining_helm"
	item_state = "mining_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "mining_helm",
		slot_l_hand_str = "mining_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	light_overlay = "merc_voidsuit_lights"
	brightness_on = 6

/obj/item/clothing/suit/space/void/mining
	name = "mining voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	icon = 'icons/obj/clothing/voidsuit/station/mining.dmi'
	icon_state = "mining"
	item_state = "mining"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "mining",
		slot_l_hand_str = "mining"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/pickaxe, /obj/item/gun/custom_ka, /obj/item/gun/energy/vaurca/thermaldrill,/obj/item/rfd/mining)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)

//Medical Rig
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon = 'icons/obj/clothing/voidsuit/station/medical.dmi'
	icon_state = "medical_helm"
	item_state = "medical_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "medical_helm",
		slot_l_hand_str = "medical_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/medical
	name = "medical voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	icon = 'icons/obj/clothing/voidsuit/station/medical.dmi'
	icon_state = "medical"
	item_state = "medical"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "medical",
		slot_l_hand_str = "medical"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/device/breath_analyzer,/obj/item/material/twohanded/fireaxe)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

	//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
	icon_state = "security_helm"
	item_state = "security_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "security_helm",
		slot_l_hand_str = "security_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/security
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
	icon_state = "security"
	item_state = "security"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "security",
		slot_l_hand_str = "security"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

//Atmospherics Rig
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
	icon_state = "atmos_helm"
	item_state = "atmos_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "atmos_helm",
		slot_l_hand_str = "atmos_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000 // It is a suit designed for fire, enclosed
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)

/obj/item/clothing/suit/space/void/atmos
	name = "atmos voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
	icon_state = "atmos"
	item_state = "atmos"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "atmos",
		slot_l_hand_str = "atmos"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction,/obj/item/storage/bag/inflatable)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE + 10000 // It is a suit designed for fire, enclosed
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)

//Head of Security
/obj/item/clothing/head/helmet/space/void/hos
	name = "heavy security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor, and gold trim."
	icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
	icon_state = "hos_helm"
	item_state = "hos_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "security_helm",
		slot_l_hand_str = "security_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	light_overlay = "helmet_light_dual"
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/hos
	name = "heavy security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor, and gold trim."
	icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
	icon_state = "hos"
	item_state = "hos"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "security",
		slot_l_hand_str = "security"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

	//Science
/obj/item/clothing/head/helmet/space/void/sci
	name = "research voidsuit helmet"
	desc = "A special helmet designed for usage by SCC research personnel in hazardous, low pressure environments."
	icon = 'icons/obj/clothing/voidsuit/station/research.dmi'
	icon_state = "research_helm"
	item_state = "research_helm"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "research_helm",
		slot_l_hand_str = "research_helm"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)

/obj/item/clothing/suit/space/void/sci
	name = "research voidsuit"
	desc = "A special suit that designed for usage by SCC research personnel in hazardous, low pressure environments."
	icon = 'icons/obj/clothing/voidsuit/station/research.dmi'
	icon_state = "research"
	item_state = "research"
	item_state_slots = list( //so that it isn't overridden on refit
		slot_r_hand_str = "research",
		slot_l_hand_str = "research"
	)
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc", "vau")
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit)
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		LASER = ARMOR_LASER_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)
