// Slime limbs.
/obj/item/organ/external/chest/unbreakable
	dislocated = -1
	limb_flags = 0

/obj/item/organ/external/groin/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE

/obj/item/organ/external/arm/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP

/obj/item/organ/external/arm/right/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP

/obj/item/organ/external/leg/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE

/obj/item/organ/external/leg/right/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE

/obj/item/organ/external/foot/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND

/obj/item/organ/external/foot/right/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND

/obj/item/organ/external/hand/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP

/obj/item/organ/external/hand/right/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP

/obj/item/organ/external/head/unbreakable
	dislocated = -1
	limb_flags = ORGAN_CAN_AMPUTATE

/obj/item/organ/external/head/unbreakable/revenant/get_additional_images(var/mob/living/carbon/human/H)
	var/image/return_image = image(H.species.eyes_icons, H, "[H.species.eyes]_glow", EFFECTS_ABOVE_LIGHTING_LAYER)
	return_image.appearance_flags = KEEP_APART
	return list(return_image)