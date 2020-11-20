//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet"
		)
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	species_restricted = list("exclude",BODYTYPE_DIONA,BODYTYPE_GOLEM)
	flash_protection = FLASH_PROTECTION_MAJOR
	allow_hair_covering = FALSE

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	on = 0

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments. \"NSS AURORA\" is written in large block letters on the back."
	icon_state = "space"
	randpixel = 0
	center_of_mass = null
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/emergency_oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 3
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	species_restricted = list("exclude",BODYTYPE_DIONA,BODYTYPE_GOLEM)

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

// Some space suits are equipped with reactive membranes that support
// broken limbs - at the time of writing, only the ninja suit, but
// I can see it being useful for other suits as we expand them. ~ Z
// The actual splinting occurs in /obj/item/organ/external/proc/fracture()
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
