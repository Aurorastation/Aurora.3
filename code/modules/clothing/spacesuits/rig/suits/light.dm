// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/weapon/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	icon_state = "ninja_rig"
	suit_type = "light suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/cell)
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	emp_protection = 10
	slowdown = 0
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	offline_slowdown = 0
	offline_vision_restriction = 0

	chest_type = /obj/item/clothing/suit/space/rig/light
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light
	glove_type = /obj/item/clothing/gloves/rig/light

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits

/obj/item/clothing/gloves/rig/light
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/light
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"

/obj/item/weapon/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(access_syndicate)

	airtight = 0
	seal_delay = 5 //not being vaccum-proof has an upside I guess

	helm_type = /obj/item/clothing/head/lightrig/hacker
	chest_type = /obj/item/clothing/suit/lightrig/hacker
	glove_type = /obj/item/clothing/gloves/lightrig/hacker
	boot_type = /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_SPECIAL

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/hacker
	name = "HUD"
	siemens_coefficient = 0.4
	flags = 0

/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.4

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.4
	flags = NOSLIP //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.

/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0

/obj/item/weapon/rig/light/ninja
	name = "stealth suit control module"
	suit_type = "stealth suit"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for stealth operations."
	icon_state = "ninja_rig"
	armor = list(melee = 50, bullet = 35, laser = 35, energy = 30, bomb = 25, bio = 100, rad = 30)
	emp_protection = 40
	slowdown = 0

	chest_type = /obj/item/clothing/suit/space/rig/light/ninja
	glove_type = /obj/item/clothing/gloves/rig/light/ninja
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light/ninja
	boot_type = /obj/item/clothing/shoes/rig/light/ninja

	req_access = list(access_syndicate)
	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/actuators
	)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/weapon/rig/light/ninja/equipped
	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/clothing/gloves/rig/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0

/obj/item/clothing/shoes/rig/light/ninja
	species_restricted = list("exclude","Diona","Xenomorph", "Golem")
	silent = 1

/obj/item/clothing/suit/space/rig/light/ninja
	species_restricted = list("exclude","Diona","Xenomorph", "Golem")
	breach_threshold = 38 //comparable to regular hardsuits

/obj/item/clothing/head/helmet/space/rig/light/ninja
	species_restricted = list("exclude","Diona","Xenomorph", "Golem")

/obj/item/weapon/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"
	armor = list(melee = 45, bullet = 20, laser = 50, energy = 10, bomb = 25, bio = 30, rad = 20)

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_SPECIAL

/obj/item/weapon/rig/light/offworlder
	name = "exo-stellar skeleton module"
	suit_type = "exo-stellar skeleton"
	desc = "A compact exoskeleton that hugs the body tightly and has various inbuilt utilities for life support."
	icon_state = "offworlder_rig"
	allowed = list(/obj/item/weapon/tank, /obj/item/device/flashlight)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 5)
	airtight = 0
	seal_delay = 5
	item_flags = 0
	helm_type = /obj/item/clothing/head/lightrig/offworlder
	chest_type = /obj/item/clothing/suit/lightrig/offworlder
	glove_type = null
	boot_type = null

	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder
		)

/obj/item/clothing/head/lightrig/offworlder
	name = "helmet"
	species_restricted = list("Human")

/obj/item/clothing/suit/lightrig/offworlder
	body_parts_covered = UPPER_TORSO
	heat_protection = UPPER_TORSO
	cold_protection = UPPER_TORSO
	flags_inv = 0
	species_restricted = list("Human")

/obj/item/weapon/rig/light/offworlder/techno
	name = "techno-conglomerate mobility hardsuit control module"
	desc = "A sleek hardsuit used by the frontier forces of the Techno-Conglomerate."
	icon_state = "techno_rig"
	suit_type = "techno-conglomerate mobility hardsuit"
	armor = list(melee = 40, bullet = 20, laser = 30, energy = 15, bomb = 40, bio = 100, rad = 100)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	slowdown = -1
	offline_slowdown = 0
	airtight = 1
	offline_vision_restriction = TINT_HEAVY

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/energy/sword
	)

	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/xray
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

	chest_type = /obj/item/clothing/suit/space/rig/light/offworlder
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light/offworlder
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light/offworlder
	glove_type = /obj/item/clothing/gloves/rig/light/offworlder

/obj/item/clothing/suit/space/rig/light/offworlder
	species_restricted = list("Human")

/obj/item/clothing/head/helmet/space/rig/light/offworlder
	species_restricted = list("Human")

 /obj/item/clothing/shoes/magboots/rig/light/offworlder
	species_restricted = list("Human")

/obj/item/clothing/gloves/rig/light/offworlder
	species_restricted = list("Human")