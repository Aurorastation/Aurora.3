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
	cannot_break = 1



/obj/item/organ/external/chest/diona
	name = "core trunk"
	limb_name = "chest"
	icon_name = "torso"
	max_damage = 200
	min_broken_damage = 50
	w_class = 5
	body_part = UPPER_TORSO
	vital = 1
	cannot_amputate = 1
	parent_organ = null
	cannot_break = 1
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
	parent_organ = "chest"
	cannot_break = 1
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
	parent_organ = "chest"
	can_grasp = 1
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/arm/right/diona
	name = "right upper tendril"
	limb_name = "r_arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	cannot_break = 1
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
	parent_organ = "groin"
	can_stand = 1
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/leg/right/diona
	name = "right lower tendril"
	limb_name = "r_leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	cannot_break = 1
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
	parent_organ = "l_leg"
	can_stand = 1
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/foot/right/diona
	name = "right foot"
	limb_name = "r_foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"
	joint = "right ankle"
	amputation_point = "right ankle"
	cannot_break = 1
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
	parent_organ = "l_arm"
	can_grasp = 1
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/hand/right/diona
	name = "right grasper"
	limb_name = "r_hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = "r_arm"
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"

/obj/item/organ/external/head/diona
	limb_name = "head"
	icon_name = "head"
	name = "head"
	max_damage = 50
	min_broken_damage = 25
	w_class = 3
	body_part = HEAD
	parent_organ = "chest"
	cannot_break = 1
	dislocated = -1
	joint = "structural ligament"
	amputation_point = "branch"
	vital = FALSE // Lore team requested this, not vital organ. We can still live without it.

/obj/item/organ/diona/process()
	return

/obj/item/organ/diona/strata
	name = "neural strata"
	parent_organ = "chest"
	organ_tag = "neural strata"


/obj/item/organ/diona/bladder
	name = "gas bladder"
	parent_organ = "head"
	organ_tag = "gas bladder"

/obj/item/organ/diona/polyp
	name = "polyp segment"
	parent_organ = "groin"
	organ_tag = "polyp segment"

/obj/item/organ/diona/ligament
	name = "anchoring ligament"
	parent_organ = "groin"
	organ_tag = "anchoring ligament"

/obj/item/organ/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/diona/removed(var/mob/living/user)
	var/mob/living/carbon/human/H = owner
	..()
	if(!istype(H) || !H.organs || !H.organs.len)
		H.death()
	if(prob(50) && spawn_diona_nymph(get_turf(src)))
		qdel(src)

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/diona/nutrients
	name = "nutrient channel"
	parent_organ = "chest"
	organ_tag = "nutrient channel"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/nutrients/removed()
	return

/obj/item/organ/diona/node
	name = "response node"
	parent_organ = "head"
	organ_tag = "response node"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/node/removed()
	return
