/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "combat_rig"
	suit_type = "combat hardsuit"
	armor = list(melee = 70, bullet = 55, laser = 45, energy = 15, bomb = 75, bio = 100, rad = 60)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

	species_restricted = list("Human")

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
	name = "military hardsuit control module"
	desc = "A powerfull hardsuit designed for military operations."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(melee = 80, bullet = 75, laser = 60, energy = 15, bomb = 80, bio = 100, rad = 30)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	species_restricted = list("Human")

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

/obj/item/rig/retro
	name = "retrofitted military hardsuit control module"
	desc = "An old repurposed construction exoskeleton redesigned for combat. Its colors and insignias match those of the Tau Ceti Foreign Legion."
	icon_state = "legion_rig"
	suit_type = "retrofitted military hardsuit"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 40, bio = 100, rad = 30)
	siemens_coefficient = 0.35
	slowdown = 2
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)

	species_restricted = list("Human","Tajara","Unathi", "Skrell", "Machine", "Vaurca")

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/retro/equipped
	req_access = list(access_legion)
	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/rig/gunslinger
	name = "gunslinger hardsuit control module"
	desc = "A favorite of Frontier rangers, the Gunslinger suit is a sturdy hardsuit meant to provide the user absolute situational awareness."
	icon_state = "gunslinger"
	suit_type = "gunslinger hardsuit"
	armor = list(melee = 50, bullet = 60, laser = 40, energy = 30, bomb = 30, bio = 100, rad = 60)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list("Human")

/obj/item/rig/gunslinger/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/strike
	name = "strike hardsuit control module"
	desc = "An expensive hardsuit utilized by Eridani security contractors to field heavy weapons and coordinate non-lethal takedowns directly. Usually seen spearheading police raids."
	icon_state = "strikesuit"
	suit_type = "strike hardsuit"
	armor = list(melee = 80, bullet = 45, laser = 45, energy = 25, bomb = 25, bio = 100, rad = 100)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list("Human")

/obj/item/rig/strike/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/elyran
	name = "elyran battlesuit control module"
	desc = "An advanced Elyran hardsuit specialized in scorched earth tactics."
	icon_state = "elyran_rig"
	suit_type = "elyran battlesuit"
	armor = list(melee = 60, bullet = 40, laser = 60, energy = 60, bomb = 25, bio = 100, rad = 100)
	siemens_coefficient = 0.1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

	species_restricted = list("Human")

	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/rig/elyran/equipped
	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/bunker
	name = "bunker suit control module"
	desc = "A powerful niche-function hardsuit utilized by Ceres' Lance to apprehend synthetics. Unstoppable in the right circumstances, and nothing more than a burden anywhere else."
	icon_state = "bunker"
	suit_type = "bunker suit"
	armor = list(melee = 80, bullet = 80, laser = 80, energy = 80, bomb = 25, bio = 25, rad = 25)
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -30
	slowdown = 8
	offline_slowdown = 10

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_UTILITY

	species_restricted = list("Human")

	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

	glove_type = /obj/item/clothing/gloves/powerfist
	boot_type =  /obj/item/clothing/shoes

/obj/item/rig/bunker/equipped
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/fabricator/energy_net
		)
