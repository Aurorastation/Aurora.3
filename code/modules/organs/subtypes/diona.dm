/turf/proc/spawn_diona_nymph()
	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = SSplants.seeds["diona"]
	if(!diona)
		return 0

	INVOKE_ASYNC(src, .proc/create_diona_nymph)

/turf/proc/create_diona_nymph()
	var/mob/living/carbon/alien/diona/D = new(src)
	SSghostroles.add_spawn_atom("diona_nymph", D)
	addtimer(CALLBACK(src, .proc/kill_diona_nymph, WEAKREF(D)), 3 MINUTES)

/turf/proc/kill_diona_nymph(var/datum/weakref/diona_ref)
	var/mob/living/carbon/alien/diona/D = diona_ref.resolve()
	if(D && (!D.ckey || !D.client))
		SSghostroles.remove_spawn_atom("diona_nymph", D)
		D.death()

//Probable future TODO: Refactor diona organs to be /obj/item/organ/external/bodypart/diona
//Having them not inherit from specific bodypart classes is a problem

/obj/item/organ/external/diona
	name = "tendril"
	limb_flags = 0

/obj/item/organ/external/diona/removed(var/mob/living/user)
	..()
	var/turf/T = get_turf(src)
	if(T.spawn_diona_nymph())
		qdel(src)

/obj/item/organ/external/chest/diona
	name = "core trunk"
	limb_name = "chest"
	icon_name = "torso"
	max_damage = 200
	min_broken_damage = 50
	w_class = ITEMSIZE_HUGE
	body_part = UPPER_TORSO
	vital = TRUE
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
	w_class = ITEMSIZE_LARGE
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
	w_class = ITEMSIZE_NORMAL
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
	w_class = ITEMSIZE_NORMAL
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
	w_class = ITEMSIZE_SMALL
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
	w_class = ITEMSIZE_SMALL
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
	w_class = ITEMSIZE_NORMAL
	body_part = HEAD
	parent_organ = BP_CHEST
	limb_flags = ORGAN_CAN_MAIM | ORGAN_CAN_AMPUTATE
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"
	vital = FALSE // Lore team requested this, not vital organ. We can still live without it.

/obj/item/organ/external/head/diona/flash_act(intensity, override_blindness_check, affect_silicon, ignore_inherent, type)
	if(!owner)
		return

	var/datum/dionastats/DS = owner.get_dionastats()
	var/burnthrough = intensity - owner.get_flash_protection(ignore_inherent)
	if(burnthrough <= 0)
		return

	DS.stored_energy += 5 * burnthrough

	if(burnthrough == 1)
		to_chat(owner, SPAN_WARNING("Your light receptors sting."))
		owner.eye_blurry += rand(5, 10)
		take_damage(0, rand(1, 2))
	else if(burnthrough == 2)
		to_chat(owner, SPAN_WARNING("Your light receptors burn!"))
		take_damage(0, rand(2, 4))
	else if(burnthrough >= 3)
		to_chat(owner, SPAN_DANGER("[FONT_HUGE("Your light receptors are burning up!")]"))
		take_damage(0, rand(4, 8))

	if(burnthrough > 1)
		owner.Weaken(5 * (burnthrough - 1))
		if(!(owner.disabilities & NEARSIGHTED))
			to_chat(owner, SPAN_DANGER("It's getting harder to see!"))
			owner.disabilities |= NEARSIGHTED
			addtimer(CALLBACK(owner, /mob/proc/remove_nearsighted), 10 SECONDS)

	return TRUE
