/obj/item/weapon/rig/terminator
	name = "\improper Hunter-Killer exoskeleton"
	desc = "A robust synth exoskeleton outfitted with state of the art infiltration tools. Creepy."
	icon_state = "terminator_rig"
	suit_type = "synthetic exoskeleton"
	armor = list(melee = 80, bullet = 75, laser = 60, energy = 15, bomb = 80, bio = 100, rad = 30)
	slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	has_sealed_state = TRUE

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

	chest_type = /obj/item/clothing/suit/space/rig/terminator
	helm_type = /obj/item/clothing/head/helmet/space/rig/terminator
	boot_type = /obj/item/clothing/shoes/magboots/rig/terminator
	glove_type = /obj/item/clothing/gloves/rig/terminator

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/actuators/combat
	)

/obj/item/clothing/head/helmet/space/rig/terminator
	species_restricted = list("Machine")
	light_overlay = "helmet_light_terminator"
	light_color = LIGHT_COLOR_RED

/obj/item/clothing/suit/space/rig/terminator
	species_restricted = list("Machine")

/obj/item/clothing/shoes/magboots/rig/terminator
	species_restricted = list("Machine")

/obj/item/clothing/gloves/rig/terminator
	species_restricted = list("Machine")

/obj/item/weapon/rig/terminator/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/actuators/combat
	)
