/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat. This one is a Stellar Corporate Conglomerate design in color scheme and make."
	icon = 'icons/clothing/rig/combat.dmi'
	icon_state = "combat_rig"
	icon_supported_species_tags = list("skr")
	suit_type = "combat hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL)

/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_cyan"

/obj/item/rig/combat/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat
		)

/obj/item/rig/military
	name = "vampire hardsuit control module"
	desc = "A Zavodskoi-manufactured hardsuit designed for the Solarian Armed Forces, the Type-9 \"Vampire\" is the suit issued to Alliance military specialists and team leaders."
	icon = 'icons/clothing/rig/military.dmi'
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	species_restricted = list(BODYTYPE_HUMAN)

	helm_type = /obj/item/clothing/head/helmet/space/rig/military


	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/pulse,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/military/fsf
	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/nvg
		)

/obj/item/rig/military/ninja
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/device/door_hack
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/retro
	name = "retrofitted military hardsuit control module"
	desc = "An old repurposed construction exoskeleton redesigned for combat. Its colors and insignias match those of the Tau Ceti Foreign Legion."
	icon = 'icons/clothing/rig/legion.dmi'
	icon_state = "legion_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una", "vau", "vaw")
	suit_type = "retrofitted military hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	slowdown = 2
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/tcfl

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs,
		/obj/item/material/twohanded/fireaxe,
		/obj/item/rfd/construction,
		/obj/item/material/twohanded/pike/flag
	)

	species_restricted = list(BODYTYPE_HUMAN,BODYTYPE_TAJARA,BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_IPC, BODYTYPE_VAURCA)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/retro/equipped
	req_access = list(access_legion)
	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/clothing/head/helmet/space/rig/tcfl
	camera = /obj/machinery/camera/network/tcfl

/obj/item/rig/gunslinger
	name = "gunslinger hardsuit control module"
	desc = "A favorite of the Frontier Rangers, the Gunslinger suit is a Xanan-designed hardsuit meant to provide the user absolute situational awareness, while remaining sturdy under fire."
	icon = 'icons/clothing/rig/gunslinger.dmi'
	icon_state = "gunslinger"
	suit_type = "gunslinger hardsuit"
	icon_supported_species_tags = list("ipc", "skr", "taj")
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_SKRELL, BODYTYPE_TAJARA)

/obj/item/rig/gunslinger/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/gunslinger/ninja

	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/fabricator/energy_net
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/strike
	name = "strike hardsuit control module"
	desc = "An expensive hardsuit utilized by Eridani security contractors to field heavy weapons and coordinate non-lethal takedowns directly. Usually seen spearheading police raids."
	icon = 'icons/clothing/rig/strikesuit.dmi'
	icon_state = "strikesuit"
	suit_type = "strike hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN)

/obj/item/rig/strike/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/nvg
		)

/obj/item/rig/strike/distress
	req_access = list(access_distress)

	initial_modules = list(
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/sechud
		)

/obj/item/rig/strike/ninja

	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/device/drill
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/elyran
	name = "elyran battlesuit control module"
	desc = "An advanced Elyran hardsuit specialized in scorched earth tactics."
	icon = 'icons/clothing/rig/elyran_battlesuit.dmi'
	icon_state = "elyran_rig"
	suit_type = "elyran battlesuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN)

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/rig/elyran/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/elyran/ninja
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/mounted/plasma
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/bunker
	name = "bunker suit control module"
	desc = "A powerful niche-function hardsuit utilized by Ceres' Lance to apprehend synthetics. Unstoppable in the right circumstances, and nothing more than a burden anywhere else."
	icon = 'icons/clothing/rig/bunker.dmi'
	icon_state = "bunker"
	suit_type = "bunker suit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -30
	slowdown = 8
	offline_slowdown = 10

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_UTILITY

	species_restricted = list(BODYTYPE_HUMAN)

	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

	glove_type = /obj/item/clothing/gloves/powerfist
	boot_type =  /obj/item/clothing/shoes

/obj/item/rig/bunker/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/rig/jinxiang
	name = "jinxiang-pattern combat suit control module"
	desc = "An off-shoot of the core Bunker Suit design, utilized by the Imperial Dominian military and painted accordingly. This is a powerful suit specializing in melee confrontations."
	icon = 'icons/clothing/rig/dominia.dmi'
	icon_state = "dominia"
	icon_supported_species_tags = list("una")
	suit_type = "jinxiang combat suit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	offline_vision_restriction = TINT_HEAVY
	offline_slowdown = 10

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

	glove_type = /obj/item/clothing/gloves/powerfist

/obj/item/rig/jinxiang/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/jinxiang/ninja
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/mounted/energy_blade
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/nanotrasen
	name = "\improper NanoTrasen military-grade hardsuit control module"
	desc = "A sleek and dangerous hardsuit, used by NanoTrasen's navy and emergency response teams."
	suit_type = "\improper NanoTrasen military-grade hardsuit"
	icon = 'icons/clothing/rig/nt_ert/commander.dmi'
	icon_state = "ert_commander_rig"
	icon_supported_species_tags = list("skr")
	species_restricted = list(BODYTYPE_SKRELL, BODYTYPE_HUMAN)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.1

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen

	slowdown = 1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/clothing/head/helmet/space/rig/nanotrasen
	light_overlay = "helmet_light_dual"

/obj/item/rig/nanotrasen/nexus
	name = "\improper Nexus RTRT hardsuit control module"
	desc = "A variant of NanoTrasen's military-grade hardsuit, designed for usage by Nexus Corporate Security's rapid trauma response teams."
	suit_type = "\improper Nexus RTRT hardsuit"
	icon = 'icons/clothing/rig/nt_ert/medical.dmi'
	icon_state = "ert_medical_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen/nexus

/obj/item/clothing/head/helmet/space/rig/nanotrasen/nexus
	light_overlay = "helmet_light_dual"

/obj/item/rig/nanotrasen/corporate_auxiliary
	name = "\improper NanoTrasen corporate auxiliary hardsuit control module"
	desc = "A variant of NanoTrasen's military-grade hardsuit, designed for usage by NanoTrasen's contributions to the Republic of Biesel's corporate auxiliary forces."
	suit_type = "\improper NanoTrasen corporate auxiliary hardsuit"
	icon = 'icons/clothing/rig/nt_ert/corporate_auxiliary.dmi'
	icon_state = "corporate_auxiliary_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen/corporate_auxiliary

/obj/item/clothing/head/helmet/space/rig/nanotrasen/corporate_auxiliary
	light_overlay = "helmet_light_dual"
