/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat. This one is a Stellar Corporate Conglomerate design in color scheme and make."
	icon = 'icons/obj/item/clothing/rig/combat.dmi'
	icon_state = "combat_rig"
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	suit_type = "combat hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1.5
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	boot_type =  /obj/item/clothing/shoes/magboots/rig/chonk

	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_TAJARA, BODYTYPE_UNATHI, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)

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
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/recharger
		)

/obj/item/rig/military
	name = "vampire hardsuit control module"
	desc = "A Zavodskoi-manufactured hardsuit designed for the Solarian Armed Forces, the Type-9 \"Vampire\" is the suit issued to Alliance military specialists and team leaders."
	icon = 'icons/obj/item/clothing/rig/military.dmi'
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1.5
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	species_restricted = list(BODYTYPE_HUMAN)

	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/rig/military/event
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

/obj/item/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/grenade_launcher/frag,
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

/obj/item/rig/military/commando
	name = "nosferatu hardsuit control module"
	desc = "A Zavodskoi-manufactured hardsuit specially designed for the elite units of the Solarian SOCOM. A feared sight to behold, the most well-known usage of the Type-9A \"Nosferatu\" suits is by the forces of the Alliance's MARSOC operatives."
	icon = 'icons/obj/item/clothing/rig/sol_marsoc.dmi'
	armor = list(
		MELEE = ARMOR_MELEE_SHIELDED,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_STRONG,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	emp_protection = 30
	slowdown = 0
	offline_slowdown = 1.5

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/pulse,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/recharger
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA // all modules

/obj/item/rig/retro
	name = "retrofitted foreign legions hardsuit control module"
	desc = "An old repurposed construction exoskeleton redesigned for combat. It is adorned with insignia of the TCAF's Foreign Legions."
	icon = 'icons/obj/item/clothing/rig/legion.dmi'
	icon_state = "legion_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una", "vau", "vaw")
	suit_type = "retrofitted foreign legions military hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_RESISTANT,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	slowdown = 1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/tcfl
	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
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
	req_one_access = list(ACCESS_TCAF)
	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/recharger
		)

/obj/item/clothing/head/helmet/space/rig/tcfl
	camera = /obj/structure/machinery/camera/network/tcaf

/obj/item/rig/gunslinger
	name = "gunslinger hardsuit control module"
	desc = "A favorite of the Frontier Rangers, the Gunslinger suit is a Xanan-designed hardsuit meant to provide the user absolute situational awareness, while remaining sturdy under fire."
	icon = 'icons/obj/item/clothing/rig/gunslinger.dmi'
	icon_state = "gunslinger"
	suit_type = "gunslinger hardsuit"
	icon_supported_species_tags = list("ipc", "skr", "taj")
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_SKRELL, BODYTYPE_TAJARA)

/obj/item/rig/gunslinger/equipped
	req_access = list(ACCESS_SYNDICATE)

	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/gunslinger/equipped/ert
	req_access = list(ACCESS_DISTRESS)

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
	icon = 'icons/obj/item/clothing/rig/strikesuit.dmi'
	icon_state = "strikesuit"
	suit_type = "strike hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN)

/obj/item/rig/strike/equipped
	req_access = list(ACCESS_SYNDICATE)

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
	req_access = list(ACCESS_DISTRESS)

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
	icon = 'icons/obj/item/clothing/rig/elyran_battlesuit.dmi'
	icon_state = "elyran_rig"
	suit_type = "elyran battlesuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN)

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/rig/elyran/equipped
	req_access = list(ACCESS_SYNDICATE)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/elyran/ninja
	req_access = list(ACCESS_SYNDICATE)

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
	icon = 'icons/obj/item/clothing/rig/bunker.dmi'
	icon_state = "bunker"
	suit_type = "bunker suit"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SHIELDED,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -30
	slowdown = 4
	offline_slowdown = 5

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_UTILITY

	species_restricted = list(BODYTYPE_HUMAN)

	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

	glove_type = /obj/item/clothing/gloves/powerfist
	boot_type =  /obj/item/clothing/shoes/magboots/rig/chonk

/obj/item/rig/bunker/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/rig/bunker/ninja // Ninjas have breachers, so it was approved they can have the unnerfed version.
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/recharger,
		/obj/item/rig_module/mounted/ion,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/device/drill,
		)

/obj/item/rig/bunker/nerfed
	name = "bunker suit control module"
	desc = "A powerful niche-function hardsuit utilized by Ceres' Lance to apprehend synthetics. This is a lighter version with more standard hardsuit plating."
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	offline_vision_restriction = TINT_HEAVY
	slowdown = 0.5

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/bunker/nerfed/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/recharger,
		/obj/item/rig_module/mounted/ion
		)

/obj/item/rig/jinxiang
	name = "jinxiang-pattern combat suit control module"
	desc = "An off-shoot of the core Bunker Suit design, utilized by the Imperial Dominian military and painted accordingly. This is a powerful suit specializing in melee confrontations."
	icon = 'icons/obj/item/clothing/rig/dominia.dmi'
	icon_state = "dominia"
	icon_supported_species_tags = list("una")
	suit_type = "jinxiang combat suit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	offline_vision_restriction = TINT_HEAVY
	offline_slowdown = 5

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

	glove_type = /obj/item/clothing/gloves/powerfist
	boot_type =  /obj/item/clothing/shoes/magboots/rig/chonk

/obj/item/rig/jinxiang/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/jinxiang/ninja
	initial_modules = list(
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
	icon = 'icons/obj/item/clothing/rig/nt_ert/commander.dmi'
	icon_state = "ert_commander_rig"
	icon_supported_species_tags = list("skr")
	species_restricted = list(BODYTYPE_SKRELL, BODYTYPE_HUMAN)
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.1

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen
	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy

	slowdown = 0.5
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/clothing/head/helmet/space/rig/nanotrasen
	light_overlay = "helmet_light_dual"

/obj/item/rig/nanotrasen/nexus
	name = "\improper Nexus RTRT hardsuit control module"
	desc = "A variant of NanoTrasen's military-grade hardsuit, designed for usage by Nexus Corporate Security's rapid trauma response teams."
	suit_type = "\improper Nexus RTRT hardsuit"
	icon = 'icons/obj/item/clothing/rig/nt_ert/medical.dmi'
	icon_state = "ert_medical_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen/nexus

/obj/item/clothing/head/helmet/space/rig/nanotrasen/nexus
	light_overlay = "helmet_light_dual"

/obj/item/rig/nanotrasen/corporate_auxiliary
	name = "\improper NanoTrasen corporate auxiliary hardsuit control module"
	desc = "A variant of NanoTrasen's military-grade hardsuit, designed for usage by NanoTrasen's contributions to the Republic of Biesel's corporate auxiliary forces."
	suit_type = "\improper NanoTrasen corporate auxiliary hardsuit"
	icon = 'icons/obj/item/clothing/rig/nt_ert/corporate_auxiliary.dmi'
	icon_state = "corporate_auxiliary_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/nanotrasen/corporate_auxiliary

/obj/item/clothing/head/helmet/space/rig/nanotrasen/corporate_auxiliary
	light_overlay = "helmet_light_dual"

/obj/item/rig/combat/tcaf
	name = "\improper TCAF Jötnar tactical hardsuit"
	desc = "An armored combat hardsuit in the blue colors of the Tau Ceti Armed Forces."
	desc_extended = "The Type-60A ‘Jötnar’ Tactical Hardsuit is an armoured combat hardsuit, produced in 2468 \
	and upgraded from previous iterations. It is brimming with modules and armour plates, the inside lined wit \
	brown ballistic padding and a tightly 	woven Caprician Weave liner to keep out hazardous environments. \
	Designed by Zavodskoi Interstellar, with modules generally supplied by NanoTrasen Corporation, Zavodskoi \
	Interstellar, and Zeng-Hu Pharmaceuticals."
	icon = 'icons/obj/item/clothing/rig/tcaf_legionnaire.dmi'
	icon_state = "legionnaire_rig"
	icon_supported_species_tags = null
	suit_type = "\improper TCAF Jötnar combat hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 1.5
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/tcaf

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
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

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_TAJARA, BODYTYPE_UNATHI, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)

/obj/item/clothing/head/helmet/space/rig/tcaf
	light_overlay = "helmet_light_tcaf_legionnaire"
	camera = /obj/structure/machinery/camera/network/tcaf

/obj/item/rig/combat/tcaf/equipped

	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/recharger
		)

/obj/item/rig/combat/zavod_heavy
	name = "reaper hardsuit control module"
	desc = "A heavily armored hardsuit manufactured and used by Zavodskoi operatives, the K2-98Z \"Reaper\" is employed by Zavodskoi's elite asset protection, as well as in corporate-sponsored police forces."
	desc_extended = "Borrowing design cues from their other popular hardsuits, such as those within the Solarian military, the Reaper was originally commissioned by the police chief in Rahe, " \
		+ "Vysoka for usage by point men in door-kicking operations and other close quarters assignments. " \
		+ "Corporate campaigns have all but normalized the motto \"Fear The Reaper\" as an attempt to increase sales—an attempt that was wildly successful. " \
		+ "Nowadays, they see extensive use in high-risk cargo vessels, with specialists directly attached to Zavodskoi VIPs, and joint operations with the Stellar Corporate Conglomerate."
	icon = 'icons/obj/item/clothing/rig/zavodheavy.dmi'
	icon_state = "zavod_heavy"
	icon_supported_species_tags = null
	suit_type = "reaper hardsuit"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	species_restricted = list(BODYTYPE_HUMAN)
	chest_type = /obj/item/clothing/suit/space/rig/zavod_heavy
	helm_type = /obj/item/clothing/head/helmet/space/rig/combat/zavod_heavy
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/combat/zavod_heavy/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/vision/nvg
		)

/obj/item/rig/combat/zavod_heavy/ninja
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/grenade_launcher/frag,
		)

/obj/item/clothing/suit/space/rig/zavod_heavy
	var/lights_active = FALSE

/obj/item/clothing/suit/space/rig/zavod_heavy/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot != slot_wear_suit_str)
		return I

	var/obj/item/rig/rigcontroller = H.get_equipped_item(slot_back_str)
	if(!istype(rigcontroller, /obj/item/rig) || rigcontroller.offline)
		// Turn off the suit lights
		if (lights_active)
			set_light_on(FALSE)
			lights_active = FALSE
		return I

	if (!lights_active && !rigcontroller.sealing)
		set_light_range_power_color(0.3, 0.2, "#ff0800")
		set_light_on(TRUE)
		lights_active = TRUE

	var/image/emissive_overlay = emissive_appearance(mob_icon, "zavod_heavy_sealed_su-emissive")
	I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/head/helmet/space/rig/combat/zavod_heavy
	light_overlay = "helmet_light"
	light_color = "#ff0800"

/obj/item/clothing/head/helmet/space/rig/combat/zavod_heavy/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot != slot_head_str)
		return I

	var/obj/item/rig/rigcontroller = H.get_equipped_item(slot_back_str)
	if(!istype(rigcontroller, /obj/item/rig) || rigcontroller.offline)
		return I

	var/image/emissive_overlay = emissive_appearance(mob_icon, "zavod_heavy_sealed_he-emissive")
	I.AddOverlays(emissive_overlay)
	return I
