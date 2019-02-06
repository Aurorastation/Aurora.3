/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"

/obj/item/weapon/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(melee = 80, bullet = 65, laser = 50, energy = 15, bomb = 80, bio = 100, rad = 60)
	slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT


/obj/item/weapon/rig/combat/equipped


	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat
		)

/obj/item/weapon/rig/military
	name = "military hardsuit control module"
	desc = "A powerfull hardsuit designed for military operations."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(melee = 80, bullet = 75, laser = 60, energy = 15, bomb = 80, bio = 100, rad = 30)
	slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)

	chest_type = /obj/item/clothing/suit/space/rig/military
	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type = /obj/item/clothing/shoes/magboots/rig/military
	glove_type = /obj/item/clothing/gloves/rig/military

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"
	species_restricted = list("Human")

/obj/item/clothing/suit/space/rig/military
	species_restricted = list("Human")

/obj/item/clothing/shoes/magboots/rig/military
	species_restricted = list("Human")

/obj/item/clothing/gloves/rig/military
	species_restricted = list("Human")

/obj/item/weapon/rig/military/equipped
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

/obj/item/weapon/rig/retro
	name = "retrofitted military hardsuit control module"
	desc = "An old repurposed construction exoskeleton redesigned for combat. Its colors and insignias match those of the Tau Ceti Foreign Legion."
	icon_state = "legion_rig"
	suit_type = "retrofitted military hardsuit"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 40, bio = 100, rad = 30)
	slowdown = 2
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/handcuffs
	)

	chest_type = /obj/item/clothing/suit/space/rig/retro
	helm_type = /obj/item/clothing/head/helmet/space/rig/retro

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/weapon/rig/retro/equipped
	req_access = list(access_legion)
	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/clothing/head/helmet/space/rig/retro
	species_restricted = list("exclude","Diona","Xenomorph", "Golem")

/obj/item/clothing/suit/space/rig/retro
	species_restricted = list("exclude","Diona","Xenomorph", "Golem")
