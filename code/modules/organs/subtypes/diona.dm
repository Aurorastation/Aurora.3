/proc/spawn_diona_nymph(var/turf/target)
	if(!istype(target))
		return 0

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = SSplants.seeds["diona"]
	if(!diona)
		return 0

	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/alien/diona/D = new(target)
		var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
		P.request_player(D, "A diona nymph has split off from its gestalt. ")
		spawn(60)
			if(D)
				if(!D.ckey || !D.client)
					D.death()
		return 1


//Probable future TODO: Refactor diona organs to be /obj/item/organ/external/bodypart/diona
//Having them not inherit from specific bodypart classes is a problem

/obj/item/organ/external/diona
	name = "tendril"
	limb_flags = 0

/obj/item/organ/external/diona/removed(var/mob/living/user)
	..()
	if(spawn_diona_nymph(get_turf(src)))
		qdel(src)

/obj/item/organ/external/chest/diona
	name = "core trunk"
	limb_name = "chest"
	icon_name = "torso"
	max_damage = 200
	min_broken_damage = 50
	w_class = 5
	body_part = UPPER_TORSO
	vital = 1
	parent_organ = null
	limb_flags = 0
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"
//------
/obj/item/organ/external/groin/diona
	name = "fork"
	limb_name = "groin"
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 50
	w_class = 4
	body_part = LOWER_TORSO
	parent_organ = BP_CHEST
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/arm/diona
	name = "left upper tendril"
	limb_name = "l_arm"
	icon_name = "l_arm"
	max_damage = 35
	min_broken_damage = 20
	w_class = 3
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/arm/right/diona
	name = "right upper tendril"
	limb_name = "r_arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/leg/diona
	name = "left lower tendril"
	limb_name = "l_leg"
	icon_name = "l_leg"
	max_damage = 35
	min_broken_damage = 20
	w_class = 3
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/leg/right/diona
	name = "right lower tendril"
	limb_name = "r_leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/foot/diona
	name = "left foot"
	limb_name = "l_foot"
	icon_name = "l_foot"
	max_damage = 20
	min_broken_damage = 10
	w_class = 2
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/foot/right/diona
	name = "right foot"
	limb_name = "r_foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_STAND
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/hand/diona
	name = "left grasper"
	limb_name = "l_hand"
	icon_name = "l_hand"
	max_damage = 30
	min_broken_damage = 15
	w_class = 2
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/hand/right/diona
	name = "right grasper"
	limb_name = "r_hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE | ORGAN_CAN_GRASP
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/head/diona
	limb_name = "head"
	icon_name = "head"
	name = BP_HEAD
	max_damage = 50
	min_broken_damage = 25
	w_class = 3
	body_part = HEAD
	parent_organ = BP_CHEST
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"
	vital = FALSE // Lore team requested this, not vital organ. We can still live without it.
