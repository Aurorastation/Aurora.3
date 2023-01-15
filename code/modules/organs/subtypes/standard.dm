/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "upper body"
	limb_name = BP_CHEST
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_HUGE
	body_part = UPPER_TORSO
	vital = TRUE
	amputation_point = "spine"
	joint = "neck"
	artery_name = "internal thoracic artery"
	dislocated = -1
	gendered_icon = 1
	limb_flags = ORGAN_CAN_BREAK
	parent_organ = null
	encased = "ribcage"
	augment_limit = 3

/obj/item/organ/external/chest/body_part_class()
	return UPPER_TORSO

/obj/item/organ/external/chest/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] running down their thighs!"

/obj/item/organ/external/groin
	name = "lower body"
	limb_name = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_LARGE
	body_part = LOWER_TORSO
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	artery_name = "iliac artery"
	dislocated = -1
	gendered_icon = 1
	augment_limit = 3

	var/obj/item/storage/internal/tail/tail_storage

/obj/item/organ/external/groin/Initialize()
	. = ..()
	tail_storage = new /obj/item/storage/internal/tail(src)

/obj/item/organ/external/groin/Destroy()
	QDEL_NULL(tail_storage)
	return ..()

/obj/item/organ/external/groin/removed()
	. = ..()
	for(var/thing in tail_storage)
		tail_storage.remove_from_storage(thing, get_turf(src))

/obj/item/organ/external/groin/body_part_class()
	return UPPER_TORSO

/obj/item/organ/external/groin/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] running down their thighs!"

/obj/item/organ/external/arm
	limb_name = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 65
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_BREAK | ORGAN_CAN_MAIM | ORGAN_HAS_TENDON | ORGAN_CAN_GRASP
	tendon_name = "palmaris longus tendon"
	artery_name = "basilic vein"
	arterial_bleed_severity = 0.75
	amputation_point = "left shoulder"
	augment_limit = 2

/obj/item/organ/external/arm/body_part_class()
	return ARMS

/obj/item/organ/external/arm/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] running down their sleeves!"

/obj/item/organ/external/arm/right
	limb_name = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	tendon_name = "cruciate ligament"
	artery_name = "brachial artery"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	limb_name = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 65
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	tendon_name = "quadriceps tendon"
	artery_name = "femoral artery"
	arterial_bleed_severity = 0.75
	amputation_point = "left hip"
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_BREAK | ORGAN_CAN_MAIM | ORGAN_HAS_TENDON
	augment_limit = 2

/obj/item/organ/external/leg/body_part_class()
	return LEGS

/obj/item/organ/external/leg/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] pooling at their feet!"

/obj/item/organ/external/leg/right
	limb_name = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	limb_name = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_BREAK | ORGAN_CAN_MAIM | ORGAN_CAN_STAND
	augment_limit = 1

/obj/item/organ/external/foot/body_part_class()
	return LEGS

/obj/item/organ/external/foot/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] pooling at their feet!"

/obj/item/organ/external/foot/removed()
	if(owner)
		owner.drop_from_inventory(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	limb_name = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	limb_name = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	tendon_name = "carpal ligament"
	amputation_point = "left wrist"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_BREAK | ORGAN_CAN_MAIM | ORGAN_CAN_GRASP | ORGAN_HAS_TENDON
	augment_limit = 1

/obj/item/organ/external/hand/body_part_class()
	return ARMS

/obj/item/organ/external/hand/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] running down their sleeves!"

/obj/item/organ/external/hand/take_damage(brute, burn, damage_flags, used_weapon, list/forbidden_limbs, silent)
	. = ..()
	owner.update_hud_hands()

/obj/item/organ/external/hand/removed()
	owner.drop_from_inventory(owner.gloves)
	owner.update_hud_hands()
	if(body_part == HAND_LEFT)
		owner.drop_l_hand()
	else
		owner.drop_r_hand()
	..()

/obj/item/organ/external/hand/right
	limb_name = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	limb_name = BP_HEAD
	icon_name = "head"
	name = BP_HEAD
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEMSIZE_NORMAL
	body_part = HEAD | FACE
	vital = TRUE
	parent_organ = BP_CHEST
	joint = "jaw"
	artery_name = "cartoid artery"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"
	augment_limit = 3
	var/can_intake_reagents = 1

/obj/item/organ/external/head/body_part_class()
	return HEAD

/obj/item/organ/external/head/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] running down their neck!"

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, damage_flags, used_weapon = null, list/forbidden_limbs = list(), var/silent)
	. = ..(brute, burn, damage_flags, used_weapon, forbidden_limbs, damage_flags, silent)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/dislocate()
	. = ..()
	if(owner)
		owner.brokejaw = 1

/obj/item/organ/external/head/undislocate()
	. = ..()
	if(owner)
		owner.brokejaw = 0

/obj/item/organ/external/head/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)
	if(iszombie(owner))
		return ..(disintegrate = DROPLIMB_BLUNT)
	return ..()
