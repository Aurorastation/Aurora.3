/obj/item/weapon/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon_state = "breacher_rig_cheap"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 60, bomb = 70, bio = 100, rad = 50)
	emp_protection = -20
	slowdown = 6
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/unathi
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(melee = 90, bullet = 90, laser = 90, energy = 90, bomb = 90, bio = 100, rad = 80) //Takes TEN TIMES as much damage to stop someone in a breacher. In exchange, it's slow.
	vision_restriction = 0
	slowdown = 4
	vision_restriction = TINT_NONE


/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list("Unathi")

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list("Unathi")

/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list("Unathi")



/obj/item/weapon/rig/vaurca
	name = "combat exoskeleton control module"
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield."
	suit_type = "combat exoskeleton"
	icon_state = "vaurca_rig"
	armor = list(melee = 65, bullet = 65, laser = 100, energy = 100, bomb = 90, bio = 100, rad = 80)
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3

	chest_type = /obj/item/clothing/suit/space/rig/vaurca
	helm_type = /obj/item/clothing/head/helmet/space/rig/vaurca
	boot_type = /obj/item/clothing/shoes/magboots/rig/vaurca
	air_type =   /obj/item/weapon/tank/phoron

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/chem_dispenser/vaurca,
		/obj/item/rig_module/boring,
		/obj/item/rig_module/lattice,
		/obj/item/rig_module/maneuvering_jets

		)
	
	allowed_module_types = list("general", "combat", "vaurca")

/obj/item/weapon/rig/vaurca/minimal
	initial_modules = list(/obj/item/rig_module/chem_dispenser/vaurca)

/obj/item/clothing/head/helmet/space/rig/vaurca
	species_restricted = list("Vaurca")
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/clothing/suit/space/rig/vaurca
	species_restricted = list("Vaurca")

/obj/item/clothing/shoes/magboots/rig/vaurca
	species_restricted = list("Vaurca")
