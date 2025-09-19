// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/rig/light
	name = "light suit control module"
	desc = "A lighter, less armored hardsuit."
	icon = 'icons/obj/item/clothing/rig/light_ninja.dmi'
	icon_state = "ninja_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	suit_type = "light suit"
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/cell,/obj/item/material/twohanded/fireaxe)
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_SMALL,
		LASER = ARMOR_LASER_RIFLE,
		energy = ARMOR_MELEE_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	emp_protection = 100
	slowdown = -1
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)
	item_flags = ITEM_FLAG_THICK_MATERIAL
	offline_slowdown = 0
	offline_vision_restriction = 0
	max_pressure_protection = LIGHT_RIG_MAX_PRESSURE
	min_pressure_protection = 0

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
	footstep_sound_override = null

/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"

/obj/item/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armor suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon = 'icons/obj/item/clothing/rig/light_hacker.dmi'
	icon_state = "hacker_rig"

	req_access = list(ACCESS_SYNDICATE)

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
	item_flags = 0

/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.4

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.4
	item_flags = ITEM_FLAG_NO_SLIP //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.

/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0

/obj/item/rig/light/hacker/ninja
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/fabricator/energy_net
		)


/obj/item/rig/light/ninja
	name = "stealth suit control module"
	suit_type = "stealth suit"
	desc = "A unique, vacuum-proof suit of nano-enhanced armor designed specifically for stealth operations."
	icon = 'icons/obj/item/clothing/rig/light_ninja.dmi'
	icon_state = "ninja_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una", "vau", "vaw")
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	emp_protection = 40
	slowdown = 0

	species_restricted = list(BODYTYPE_HUMAN,BODYTYPE_TAJARA,BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_IPC, BODYTYPE_VAURCA)

	helm_type = /obj/item/clothing/head/helmet/space/rig/light/ninja
	chest_type = /obj/item/clothing/suit/space/rig/light/ninja
	glove_type = /obj/item/clothing/gloves/rig/light/ninja
	boot_type = /obj/item/clothing/shoes/magboots/rig/light/ninja

	req_access = list(ACCESS_SYNDICATE)
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/anti_theft,
		/obj/item/rig_module/actuators/combat
	)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/clothing/head/helmet/space/rig/light/ninja
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/rig/light/ninja/equipped
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

/obj/item/clothing/shoes/magboots/rig/light/ninja
	silent = 1

/obj/item/clothing/suit/space/rig/light/ninja
	breach_threshold = 38 //comparable to regular hardsuits


/obj/item/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon = 'icons/obj/item/clothing/rig/light_stealth.dmi'
	icon_state = "stealth_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_SMALL,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SMALL,
		RAD = ARMOR_RAD_SMALL
	)

	req_access = list(ACCESS_SYNDICATE)

	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_SPECIAL

/obj/item/rig/light/offworlder
	name = "exo-stellar skeleton module"
	suit_type = "exo-stellar skeleton"
	desc = "A compact exoskeleton that hugs the body tightly and has various inbuilt utilities for life support."
	icon = 'icons/obj/item/clothing/rig/offworlder.dmi'
	icon_state = "offworlder_rig"
	icon_supported_species_tags = null
	allowed = list(/obj/item/tank, /obj/item/device/flashlight)
	armor = list(
		BIO = ARMOR_BIO_MINOR,
		RAD = ARMOR_RAD_MINOR
	)
	slowdown = 0
	airtight = 0
	seal_delay = 5
	helm_type = /obj/item/clothing/head/lightrig/offworlder
	chest_type = /obj/item/clothing/suit/lightrig/offworlder
	glove_type = null
	boot_type = null

	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder,
		/obj/item/rig_module/storage
		)

	species_restricted = list(BODYTYPE_HUMAN)

	siemens_coefficient = 0.9

/obj/item/clothing/head/lightrig/offworlder
	name = "helmet"
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/suit/lightrig/offworlder
	body_parts_covered = UPPER_TORSO
	heat_protection = UPPER_TORSO
	cold_protection = UPPER_TORSO
	flags_inv = 0

/obj/item/rig/light/offworlder/colorable
	icon_state = "offworlder_rig_colorable"

/obj/item/rig/light/offworlder/frontier
	name = "advanced mobility hardsuit control module"
	desc = "Patterned off of the standard Exo-Stellar Skeleton, this sophisticated and light hardsuit is a staple of many armed forces throughout the Frontier. The mobility it grants compared to bulkier suits, while still packing the potential for a versatile toolset, has made it especially popular in the often cramped environments of ships and stations."
	icon = 'icons/obj/item/clothing/rig/frontier.dmi'
	icon_state = "frontier_rig"
	suit_type = "advanced mobility hardsuit"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_SMALL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	slowdown = -1
	offline_slowdown = 0
	airtight = 1
	offline_vision_restriction = TINT_HEAVY
	siemens_coefficient = 0.2
	icon_supported_species_tags = null

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword
	)

	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/chem_dispenser/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

	chest_type = /obj/item/clothing/suit/space/rig/light
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light
	glove_type = /obj/item/clothing/gloves/rig/light

/obj/item/rig/light/offworlder/frontier/equipped
	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/xray
		)
/obj/item/rig/light/offworlder/frontier/ninja
	initial_modules = list(
		/obj/item/rig_module/device/healthscanner/vitalscanner,
		/obj/item/rig_module/chem_dispenser/offworlder,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/mounted/xray
		)

/obj/item/rig/light/falcata
	name = "falcata exoskeleton control module"
	desc = "An armored security exoskeleton, known as the Falcata. It serves as a lightweight platform for bearing security hardsuit modules."
	icon = 'icons/obj/item/clothing/rig/falcata.dmi'
	icon_state = "falcata_rig"
	icon_supported_species_tags = list("skr", "taj", "una", "vau",)
	suit_type = "falcata combat exoskeleton"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA, BODYTYPE_IPC, BODYTYPE_TAJARA)

	seal_delay = 3 // Its only deploying the myomers and helmet.
	offline_slowdown = 3
	slowdown = 1
	offline_vision_restriction = TINT_BLIND // Visorless helmet sprite, the helmet's face is just a camera.

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

	chest_type = /obj/item/clothing/suit/space/rig/light/falcata
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light/falcata
	glove_type = null
	boot_type = null

/obj/item/rig/light/falcata/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_back_str && !offline)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "falcata_rig_ba-emissive")
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/rig/light/falcata/set_vision(var/active)
	if(helmet)
		// don't tint the vision if the suit isn't sealed, the sprite doesn't cover the face
		// this does however still tint the vision if it's sealed and the battery dies though
		helmet.tint = (active || canremove ? vision_restriction : offline_vision_restriction)

/obj/item/rig/light/falcata/set_piece_adaptation(var/obj/item/clothing/piece)
	// the suit doesn't need to differ by-species
	if(istype(piece, /obj/item/clothing/suit/space/rig/light/falcata))
		return
	return ..()

/obj/item/rig/light/falcata/update_sealed_piece_icon(var/obj/item/clothing/piece, var/seal_target)
	if(istype(piece, /obj/item/clothing/head/helmet/space/rig/light/falcata))
		if(!seal_target)
			piece.flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR // if we're sealing the helmet, hide the hair
		else
			piece.flags_inv = 0 // otherwise, show it all
	return ..()

/obj/item/clothing/suit/space/rig/light/falcata
	name = "myomer frame"
	body_parts_covered = null
	breach_threshold = 45 // We aren't a real hardsuit, rather a very thick torso plate.
	flags_inv = 0 // Don't hide jumpsuit or tail

/obj/item/clothing/suit/space/rig/light/falcata/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot != slot_wear_suit_str)
		return I

	var/obj/item/rig/rigcontroller = H.get_equipped_item(slot_back)
	if(!istype(rigcontroller, /obj/item/rig) || rigcontroller.offline)
		return I

	var/image/emissive_overlay = emissive_appearance(mob_icon, "falcata_rig_sealed_su-emissive")
	I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/head/helmet/space/rig/light/falcata
	name = "helmet"
	// The helmet's unusually thick, with the fun caveat that it fully blacks out your screen when unpowered.
	flash_protection = FLASH_PROTECTION_MAJOR
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
	)
	flags_inv = 0 // before being sealed, ears eyes etc should not be hidden
