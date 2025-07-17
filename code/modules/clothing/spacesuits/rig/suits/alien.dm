/obj/item/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-hardsuit. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon = 'icons/clothing/rig/unathi_breacher_cheap.dmi'
	icon_state = "breacher_rig_cheap"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_RESISTANT,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.1
	emp_protection = -20
	slowdown = 6
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND

	species_restricted = list(BODYTYPE_UNATHI)

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton,/obj/item/melee/energy)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT

/obj/item/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon = 'icons/clothing/rig/unathi_breacher.dmi'
	icon_state = "breacher_rig"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_AP,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_STRONG,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	vision_restriction = TINT_NONE
	slowdown = 4
	glove_type = /obj/item/clothing/gloves/powerfist

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/unathi/fancy/equipped
	req_access = list(ACCESS_KATAPHRACT)
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/recharger
	)

/obj/item/rig/unathi/fancy/ninja
	req_access = list(ACCESS_SYNDICATE)
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/mounted/energy_blade
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_MEDICAL | MODULE_UTILITY

/obj/item/rig/unathi/redsnout
	name = "redsnout hardsuit control module"
	desc = "A variation on the Unathi breacher chassis design, fielded by the elite unit of the Tau Ceti Armed Forces known as the Redsnouts."
	suit_type = "redsnout hardsuit"
	icon = 'icons/clothing/rig/redsnout.dmi'
	icon_state = "redsnout_rig"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_AP,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_STRONG,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	vision_restriction = TINT_NONE
	offline_vision_restriction = TINT_BLIND
	slowdown = 4
	offline_slowdown = 3
	siemens_coefficient = 0.1
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL
	glove_type = /obj/item/clothing/gloves/powerfist
	helm_type = /obj/item/clothing/head/helmet/space/rig/tcfl

/obj/item/rig/unathi/redsnout/equipped
	req_access = list(ACCESS_LEGION)
	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/mounted/smg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher/frag,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/recharger
		)

/obj/item/rig/vaurca
	name = "combat exoskeleton control module"
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield."
	suit_type = "combat exoskeleton"
	icon = 'icons/clothing/rig/vaurca.dmi'
	icon_state = "vaurca_rig"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SHIELDED,
		BOMB = ARMOR_BOMB_SHIELDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.1
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3

	species_restricted = list(BODYTYPE_VAURCA)

	helm_type = /obj/item/clothing/head/helmet/space/rig/vaurca
	air_type =   /obj/item/tank/phoron

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton,/obj/item/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/chem_dispenser/vaurca,
		/obj/item/rig_module/boring,
		/obj/item/rig_module/lattice,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/recharger

		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_VAURCA

/obj/item/rig/vaurca/minimal
	initial_modules = list(/obj/item/rig_module/chem_dispenser/vaurca)

/obj/item/rig/vaurca/ninja
		initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/chem_dispenser/vaurca,
		/obj/item/rig_module/boring,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/door_hack
		)

/obj/item/clothing/head/helmet/space/rig/vaurca
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"


/obj/item/rig/tesla
	name = "tesla suit control module"
	desc = "A tajaran hardsuit designated to be used by the special forces of the Tesla Brigade."
	desc_extended = "Formed in 2461, the Tesla Brigade is an experimental force composed of augmented veterans. Created after the intense casualties of the Das'nrra campaign and the \
	severe loss of Republican Guard units. Additional funding and focus was placed on a previously shelved proposal for heavily armed shock and high technology assault troopers. A \
	special unit designated to withstand the numerical disadvantages and prolonged engagements special forces of the Republic often faces."
	suit_type = "tesla suit"
	icon = 'icons/clothing/rig/tesla.dmi'
	icon_state = "tesla_rig"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3

	species_restricted = list(BODYTYPE_TAJARA)

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton,/obj/item/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/tesla_coil,
		/obj/item/rig_module/mounted/tesla)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_UTILITY

/obj/item/rig/tesla/process()
	..()
	if(wearer)
		var/obj/item/organ/internal/augment/tesla/T = wearer.internal_organs_by_name[BP_AUG_TESLA]
		if(T && !T.is_broken())
			if(cell)
				cell.give(T.max_charges)

/obj/item/rig/tesla/ninja

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/tesla_coil,
		/obj/item/rig_module/mounted/tesla,
		/obj/item/rig_module/device/door_hack)
