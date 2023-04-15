// Softsuits
// Everything in modules/clothing/spacesuits should have the entire suit grouped together.
// Meaning the the suit is defined directly after the corresponding helmet.

/obj/item/clothing/head/helmet/space
	name = "softsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	icon = 'icons/obj/item/clothing/softsuits/softsuit.dmi'
	icon_state = "softsuit_helmet"
	item_state = "softsuit_helmet"
	contained_sprite = TRUE
	item_flags = THICKMATERIAL | INJECTIONPORT | AIRTIGHT
	permeability_coefficient = 0.01
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.5
	species_restricted = list("exclude",BODYTYPE_DIONA,BODYTYPE_GOLEM,BODYTYPE_VAURCA_BULWARK)
	flash_protection = FLASH_PROTECTION_MAJOR
	allow_hair_covering = FALSE

	has_storage = FALSE

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	on = 0

/obj/item/clothing/suit/space
	name = "softsuit"
	desc = "A suit that protects against low pressure environments."
	icon = 'icons/obj/item/clothing/softsuits/softsuit.dmi'
	icon_state = "softsuit"
	item_state = "softsuit"
	contained_sprite = TRUE
	center_of_mass = null
	w_class = ITEMSIZE_LARGE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = THICKMATERIAL|INJECTIONPORT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/device/suit_cooling_unit, /obj/item/tank)
	slowdown = 1
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.5
	species_restricted = list("exclude",BODYTYPE_DIONA,BODYTYPE_GOLEM,BODYTYPE_VAURCA_BULWARK)

	var/list/supporting_limbs //If not-null, automatically splints breaks. Checked when removing the suit.

/obj/item/clothing/suit/space/equipped(mob/M)
	check_limb_support()
	..()

/obj/item/clothing/suit/space/dropped(var/mob/user)
	check_limb_support(user)
	..()

/obj/item/clothing/suit/space/on_slotmove(var/mob/user)
	check_limb_support(user)
	..()

/obj/item/clothing/suit/space/proc/check_limb_support(var/mob/living/carbon/human/user)
	// If this isn't set, then we don't need to care.
	if(!supporting_limbs || !supporting_limbs.len)
		return

	if(!istype(user) || user.wear_suit == src)
		return

	// Otherwise, remove the splints.
	for(var/obj/item/organ/external/E in supporting_limbs)
		E.status &= ~ ORGAN_SPLINTED
		to_chat(user, "The suit stops supporting your [E.name].")
	supporting_limbs = list()

/obj/item/clothing/head/helmet/space/emergency
	name = "emergency softsuit helmet"
	desc = "A simple helmet with a built in light. Smells like mothballs."
	icon = 'icons/obj/item/clothing/softsuits/softsuit_emergency.dmi'
	icon_state = "softsuit_emergency_helmet"
	item_state = "softsuit_emergency_helmet"
	contained_sprite = TRUE
	flags_inv = HIDEMASK | HIDEEARS | BLOCKHAIR
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/head/helmet/space/emergency/marooning_equipment
	name = "marooning softsuit helmet"
	desc = "A simple, cheap helmet with a built in light, designed for issuing to marooned personnel."

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate. It looks pretty fragile."
	icon = 'icons/obj/item/clothing/softsuits/softsuit_emergency.dmi'
	icon_state = "softsuit_emergency"
	item_state = "softsuit_emergency"
	contained_sprite = TRUE
	slowdown = 2

/obj/item/clothing/suit/space/emergency/marooning_equipment
	name = "marooning softsuit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate. Designed for issuing to marooned personnel and it looks pretty fragile."
