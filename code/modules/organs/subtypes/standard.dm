/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "upper body"
	limb_name = TARGET_CHEST
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = 5
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"
	can_be_maimed = FALSE

/obj/item/organ/external/groin
	name = "lower body"
	limb_name = TARGET_GROIN
	icon_name = TARGET_GROIN
	max_damage = 100
	min_broken_damage = 35
	w_class = 4
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = TARGET_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = 1
	maim_bonus = 0.25

/obj/item/organ/external/arm
	limb_name = TARGET_L_ARM
	name = "left arm"
	icon_name = TARGET_L_ARM
	max_damage = 50
	min_broken_damage = 30
	w_class = 3
	body_part = ARM_LEFT
	parent_organ = TARGET_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = 1

/obj/item/organ/external/arm/right
	limb_name = TARGET_R_ARM
	name = "right arm"
	icon_name = TARGET_R_ARM
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	limb_name = TARGET_L_LEG
	name = "left leg"
	icon_name = TARGET_L_LEG
	max_damage = 50
	min_broken_damage = 30
	w_class = 3
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = TARGET_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = 1

/obj/item/organ/external/leg/right
	limb_name = TARGET_R_LEG
	name = "right leg"
	icon_name = TARGET_R_LEG
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	limb_name = TARGET_L_FOOT
	name = "left foot"
	icon_name = TARGET_L_FOOT
	max_damage = 30
	min_broken_damage = 15
	w_class = 2
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = TARGET_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = 1
	maim_bonus = 1

/obj/item/organ/external/foot/removed()
	if(owner) owner.drop_from_inventory(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	limb_name = TARGET_R_FOOT
	name = "right foot"
	icon_name = TARGET_R_FOOT
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = TARGET_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	limb_name = TARGET_L_HAND
	name = "left hand"
	icon_name = TARGET_L_HAND
	max_damage = 30
	min_broken_damage = 15
	w_class = 2
	body_part = HAND_LEFT
	parent_organ = TARGET_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = 1
	maim_bonus = 1

/obj/item/organ/external/hand/removed()
	owner.drop_from_inventory(owner.gloves)
	if(body_part == HAND_LEFT)
		owner.drop_l_hand()
	else
		owner.drop_r_hand()
	..()

/obj/item/organ/external/hand/right
	limb_name = TARGET_R_HAND
	name = "right hand"
	icon_name = TARGET_R_HAND
	body_part = HAND_RIGHT
	parent_organ = TARGET_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	limb_name = TARGET_HEAD
	icon_name = TARGET_HEAD
	name = TARGET_HEAD
	max_damage = 75
	min_broken_damage = 35
	w_class = 3
	body_part = HEAD
	vital = 1
	parent_organ = TARGET_CHEST
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"
	var/can_intake_reagents = 1
	maim_bonus = 0.33

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

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
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