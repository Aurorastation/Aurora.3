/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	item_flags = THICKMATERIAL
	flags_inv = 		 HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	heat_protection =    HEAD|FACE|EYES
	cold_protection =    HEAD|FACE|EYES
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		BODYTYPE_SKRELL = 'icons/mob/species/skrell/helmet.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/helmet.dmi',
		BODYTYPE_IPC = 'icons/mob/species/machine/helmet.dmi',
		BODYTYPE_VOX = 'icons/mob/species/vox/head.dmi'
	)

/obj/item/clothing/gloves/rig
	name = "gauntlets"
	item_flags = THICKMATERIAL
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	species_restricted = null
	gender = PLURAL
	punch_force = 5
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/gloves.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/gloves.dmi',
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/gloves.dmi',
		BODYTYPE_IPC = 'icons/mob/species/machine/gloves.dmi',
		BODYTYPE_VOX = 'icons/mob/species/vox/gloves.dmi'
	)

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	species_restricted = null
	gender = PLURAL
	icon_base = null
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/shoes.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/shoes.dmi',
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/shoes.dmi',
		BODYTYPE_IPC = 'icons/mob/species/machine/shoes.dmi',
		BODYTYPE_VOX = 'icons/mob/species/vox/shoes.dmi'
	)

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv =          HIDEJUMPSUIT|HIDETAIL
	item_flags =              STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	slowdown = 0
	//will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit. Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = 1
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/suit.dmi',
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/suit.dmi',
		BODYTYPE_IPC = 'icons/mob/species/machine/suit.dmi',
		BODYTYPE_VOX = 'icons/mob/species/vox/suit.dmi'
		)

	supporting_limbs = list()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return 0

/obj/item/clothing/gloves/rig/Touch(var/atom/A, var/proximity)

	if(!A || !proximity)
		return 0

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || !H.back)
		return 0

	var/obj/item/rig/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return 0

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A, H))
				return 1

	return 0

//Rig pieces for non-spacesuit based rigs

/obj/item/clothing/head/lightrig
	name = "mask"
	body_parts_covered = HEAD|FACE|EYES
	heat_protection =    HEAD|FACE|EYES
	cold_protection =    HEAD|FACE|EYES
	flags =              THICKMATERIAL|AIRTIGHT

/obj/item/clothing/suit/lightrig
	name = "suit"
	allowed = list(/obj/item/device/flashlight)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv =          HIDEJUMPSUIT
	flags =              THICKMATERIAL

/obj/item/clothing/shoes/lightrig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	species_restricted = null
	gender = PLURAL

/obj/item/clothing/gloves/lightrig
	name = "gloves"
	flags = THICKMATERIAL
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	species_restricted = null
	gender = PLURAL
