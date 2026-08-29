/**
 * Read-only surgery eligibility.
 *
 * FALSE by default is intentional. If Aurora gains a new surgery step and no
 * planner rule is added for it, the operation stays hidden rather than being
 * falsely advertised.
 */
/singleton/surgery_step/proc/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return FALSE


// ---------------------------------------------------------------------------
// Generic organic surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/generic/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(isslime(target))
		return FALSE

	if(target_zone == BP_EYES)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	if(affected.is_stump())
		return FALSE
	if(BP_IS_ROBOTIC(affected))
		return FALSE

	return TRUE

/singleton/surgery_step/generic/cut_with_laser/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/incision_manager/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cut_open/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(isvaurca(target))
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cut_open_vaurca/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(!isvaurca(target))
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/clamp_bleeders/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open > ORGAN_CLOSED && (affected.status & ORGAN_BLEEDING)

/singleton/surgery_step/generic/retract_skin/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_OPEN_INCISION

/singleton/surgery_step/generic/cauterize/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open > ORGAN_CLOSED && target_zone != BP_MOUTH


// ---------------------------------------------------------------------------
// Organic facial surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/generic/cut_face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target_zone == BP_MOUTH \
		&& target.op_stage.face == FACE_NORMAL

/singleton/surgery_step/generic/prepare_face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target_zone == BP_MOUTH \
		&& target.op_stage.face == FACE_CUT_OPEN

/singleton/surgery_step/generic/alter_face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target_zone == BP_MOUTH \
		&& target.op_stage.face == FACE_RETRACTED

/singleton/surgery_step/face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || BP_IS_ROBOTIC(affected))
		return FALSE

	return target_zone == BP_MOUTH

/singleton/surgery_step/face/cauterize/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() && target.op_stage.face > FACE_NORMAL


// ---------------------------------------------------------------------------
// Bone repair
// ---------------------------------------------------------------------------

/singleton/surgery_step/glue_bone/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& !BP_IS_ROBOTIC(affected) \
		&& affected.open >= ORGAN_OPEN_RETRACTED \
		&& affected.open < ORGAN_ENCASED_RETRACTED \
		&& affected.stage == BONE_PRE_OP \
		&& (affected.status & ORGAN_BROKEN)

/singleton/surgery_step/set_bone/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& affected.name != BP_HEAD \
		&& !BP_IS_ROBOTIC(affected) \
		&& affected.open >= ORGAN_OPEN_RETRACTED \
		&& affected.stage == BONE_GLUED

/singleton/surgery_step/mend_skull/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& affected.name == BP_HEAD \
		&& !BP_IS_ROBOTIC(affected) \
		&& affected.open >= ORGAN_OPEN_RETRACTED \
		&& affected.stage == BONE_GLUED

/singleton/surgery_step/finish_bone/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& affected.open >= ORGAN_OPEN_RETRACTED \
		&& affected.open < ORGAN_ENCASED_RETRACTED \
		&& !BP_IS_ROBOTIC(affected) \
		&& affected.stage == BONE_SET


// ---------------------------------------------------------------------------
// Encased organs: skull, ribcage, etc.
// ---------------------------------------------------------------------------

/singleton/surgery_step/open_encased/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& !BP_IS_ROBOTIC(affected) \
		&& affected.encased \
		&& affected.open >= ORGAN_OPEN_RETRACTED

/singleton/surgery_step/open_encased/saw/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_OPEN_RETRACTED

/singleton/surgery_step/open_encased/retract/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_OPEN

/singleton/surgery_step/open_encased/close/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_RETRACTED

/singleton/surgery_step/open_encased/mend/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_OPEN


// ---------------------------------------------------------------------------
// Body cavities / embedded objects
// ---------------------------------------------------------------------------

/singleton/surgery_step/cavity/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& surgery_planner_fully_open(affected) \
		&& !(affected.status & ORGAN_BLEEDING)

/singleton/surgery_step/cavity/make_space/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !affected.cavity

/singleton/surgery_step/cavity/close_space/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.cavity

/singleton/surgery_step/cavity/place_item/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(istype(user, /mob/living/silicon/robot))
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || !affected.cavity)
		return FALSE

	// The exact object size is tool-dependent. Only advertise this step if
	// there is at least some capacity left for a valid item.
	var/occupied = 0
	for(var/obj/item/I in affected.implants)
		if(istype(I, /obj/item/implant))
			continue
		occupied += I.w_class

	return occupied < get_max_wclass(affected)

/singleton/surgery_step/cavity/implant_removal/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	// Aurora's live can_use() technically permits probing an empty cavity.
	// The planner only advertises the procedure when something can actually
	// be removed.
	return affected && length(affected.implants)


// ---------------------------------------------------------------------------
// Internal organ surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/internal/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE

	if(affected.encased)
		return surgery_planner_fully_open(affected)

	if(BP_IS_ROBOTIC(affected))
		return affected.augment_limit && affected.open == ORGAN_ENCASED_RETRACTED

	return affected.augment_limit && affected.open == ORGAN_OPEN_RETRACTED

/singleton/surgery_step/internal/fix_organ/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I.is_damaged() && !BP_IS_ROBOTIC(I))
			return TRUE

	return FALSE

/singleton/surgery_step/internal/fix_organ_robotic/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!surgery_planner_fully_open(affected))
		return FALSE

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I.is_damaged() && BP_IS_ROBOTIC(I))
			return TRUE

	return FALSE

/singleton/surgery_step/internal/detach_organ/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || BP_IS_ROBOTIC(affected))
		return FALSE

	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(!I)
			continue
		if(I.status & ORGAN_ZOMBIFIED)
			continue
		if(!(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/remove_organ/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/replace_organ/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	/*
	 * The live procedure is fundamentally dependent on the concrete donor
	 * organ being used: organ_tag, parent_organ, species restriction, damage,
	 * robotic state, augment status and available augment capacity are all
	 * checked from that item.
	 *
	 * Without a donor item, the planner cannot truthfully say this operation
	 * is currently possible, so it stays hidden rather than producing another
	 * false positive.
	 */
	return FALSE

/singleton/surgery_step/internal/attach_organ/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I \
			&& (I.status & ORGAN_CUT_AWAY) \
			&& !BP_IS_ROBOTIC(I) \
			&& I.parent_organ == target_zone)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/prepare/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name[BP_BRAIN]

	return istype(sponge) \
		&& (sponge in affected.internal_organs) \
		&& sponge.can_prepare \
		&& !sponge.prepared

/singleton/surgery_step/internal/fix_dead_tissue/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	// Live can_use() selects the first dead organic organ, then validates its
	// damage. Do the same here so a later repairable organ cannot create a false
	// positive while an earlier irreparable organ blocks the real procedure.
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if((I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			return I.get_damage() <= I.max_damage

	return FALSE


// ---------------------------------------------------------------------------
// Vascular / tendon / necrosis surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/fix_vein/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& affected.open >= ORGAN_OPEN_RETRACTED \
		&& (affected.status & ORGAN_ARTERY_CUT)

/singleton/surgery_step/fix_tendon/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected \
		&& (affected.tendon_status() & TENDON_CUT) \
		&& affected.open >= ORGAN_OPEN_RETRACTED

/singleton/surgery_step/treat_necrosis/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	// The actual tool must still contain peridaxon; that is an item-specific
	// property and is checked by the live can_use().
	return affected \
		&& surgery_planner_fully_open(affected) \
		&& (affected.status & ORGAN_DEAD)


// ---------------------------------------------------------------------------
// Hardsuit removal / amputation
// ---------------------------------------------------------------------------

/singleton/surgery_step/hardsuit/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return target_zone == BP_CHEST \
		&& istype(target.back, /obj/item/rig) \
		&& !target.back.canremove

/singleton/surgery_step/amputate/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(target_zone == BP_EYES)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.limb_flags & ORGAN_CAN_AMPUTATE)


// ---------------------------------------------------------------------------
// Missing / replaced limbs
// ---------------------------------------------------------------------------

/singleton/surgery_step/limb/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(target.get_organ(target_zone))
		return FALSE

	var/list/organ_data = target.species.has_limbs["[target_zone]"]
	return !isnull(organ_data)

/singleton/surgery_step/limb/connect/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	/*
	 * Mirror the current live hierarchy exactly. /limb/connect calls its
	 * parent /limb/can_use(), which requires the target organ to be absent,
	 * and then requires that same organ to exist and be destroyed. Those
	 * conditions cannot both be true, so the current Aurora implementation
	 * cannot offer this step.
	 */
	if(!..())
		return FALSE

	var/obj/item/organ/external/E = target.get_organ(target_zone)
	return E && !E.is_stump() && (E.status & ORGAN_DESTROYED)

/singleton/surgery_step/limb/mechanize/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	// The exact robot-parts object still decides whether its "part" list
	// includes this zone. Patient-side requirements are inherited from /limb.
	return ..()


// ---------------------------------------------------------------------------
// Robotic external surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/robotics/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(isslime(target))
		return FALSE

	if(target_zone == BP_EYES)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	if(affected.status & ORGAN_DESTROYED)
		return FALSE
	if(!BP_IS_ROBOTIC(affected))
		return FALSE

	return TRUE

/singleton/surgery_step/robotics/unscrew_hatch/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED

/singleton/surgery_step/robotics/screw_hatch/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_OPEN_INCISION

/singleton/surgery_step/robotics/open_hatch/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_OPEN_INCISION

/singleton/surgery_step/robotics/close_hatch/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open > ORGAN_OPEN_INCISION

/singleton/surgery_step/robotics/repair_brute/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected \
		&& affected.open == ORGAN_ENCASED_RETRACTED \
		&& affected.brute_dam > 0 \
		&& target_zone != BP_MOUTH

/singleton/surgery_step/robotics/repair_burn/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected \
		&& affected.open == ORGAN_ENCASED_RETRACTED \
		&& affected.burn_dam > 0 \
		&& target_zone != BP_MOUTH

/singleton/surgery_step/robotics/detach_organ_robotic/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED)
		return FALSE

	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			return TRUE

	return FALSE

/singleton/surgery_step/robotics/attach_organ_robotic/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED)
		return FALSE

	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I \
			&& (I.status & ORGAN_CUT_AWAY) \
			&& (I.status & ORGAN_ROBOT) \
			&& I.parent_organ == target_zone)
			return TRUE

	return FALSE

/singleton/surgery_step/robotics/install_mmi/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(target_zone != BP_HEAD)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED)
		return FALSE
	if(!BP_IS_ROBOTIC(affected))
		return FALSE
	if(!target.isSynthetic())
		return FALSE
	if(!target.species)
		return FALSE
	if(!target.species.has_organ[BP_BRAIN])
		return FALSE
	if(!isnull(target.internal_organs_by_name[BP_BRAIN]))
		return FALSE

	// The MMI itself must still contain a live, client-controlled brain.
	return TRUE


// ---------------------------------------------------------------------------
// Robotic facial surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/robotics/face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() && target_zone == BP_MOUTH

/singleton/surgery_step/robotics/face/synthskin/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target.op_stage.face == FACE_NORMAL \
		&& target.get_species() == SPECIES_IPC_SHELL

/singleton/surgery_step/robotics/face/synthskinopen/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target.op_stage.face == FACE_NORMAL \
		&& target.get_species() == SPECIES_IPC_SHELL

/singleton/surgery_step/robotics/face/prepare_face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target_zone == BP_MOUTH \
		&& target.op_stage.face == FACE_CUT_OPEN

/singleton/surgery_step/robotics/face/alter_synthface/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() \
		&& target_zone == BP_MOUTH \
		&& target.op_stage.face == FACE_RETRACTED

/singleton/surgery_step/robotics/face/seal_face/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	return ..() && target.op_stage.face > FACE_NORMAL


// ---------------------------------------------------------------------------
// Robotic internal surgery
// ---------------------------------------------------------------------------

/singleton/surgery_step/internal/fix_internal_wiring/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED || target_zone == BP_MOUTH)
		return FALSE

	for(var/obj/item/organ/internal/machine/I in affected.internal_organs)
		if(I.wiring.get_status() < 100)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/fix_internal_electronics/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED || target_zone == BP_MOUTH)
		return FALSE

	for(var/obj/item/organ/internal/machine/I in affected.internal_organs)
		if(I.electronics.get_status() < 100)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/fix_internal_plating/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED || target_zone == BP_MOUTH)
		return FALSE

	for(var/obj/item/organ/internal/machine/I in affected.internal_organs)
		var/plating_status = I.plating.get_status()
		if(plating_status > 0 && plating_status < 100)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/replace_internal_plating/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED || target_zone == BP_MOUTH)
		return FALSE

	for(var/obj/item/organ/internal/machine/I in affected.internal_organs)
		if(I.plating.get_status() <= 0)
			return TRUE

	return FALSE

/singleton/surgery_step/internal/replace_external_plating/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	if(fast_repair && !istype(target.species, /datum/species/machine/industrial/hephaestus))
		return FALSE

	var/datum/component/armor/synthetic/synth_armor = target.GetComponent(/datum/component/armor/synthetic)
	if(!synth_armor)
		return FALSE

	var/list/damage = synth_armor.get_damage()
	return length(damage)

/singleton/surgery_step/internal/degunk/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_ENCASED_RETRACTED || target_zone != BP_CHEST)
		return FALSE

	var/obj/item/organ/internal/machine/reactor/bio_reactor = target.internal_organs_by_name[BP_REACTOR]
	if(!bio_reactor || !(bio_reactor.power_supply_type & POWER_SUPPLY_BIOLOGICAL))
		return FALSE

	for(var/reagent_type in bio_reactor.bio_reagents.reagent_volumes)
		if(!ispath(reagent_type, /singleton/reagent/nutriment) \
			&& REAGENT_VOLUME(bio_reactor.bio_reagents, reagent_type) > 0)
			return TRUE

	return FALSE

/singleton/surgery_step/robotics/repair_endoskeleton/can_show_in_surgery_planner(mob/user, mob/living/carbon/human/target, target_zone)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected \
		|| affected.open != ORGAN_ENCASED_RETRACTED \
		|| affected.limb_name != BP_CHEST \
		|| target_zone == BP_MOUTH)
		return FALSE

	var/datum/component/synthetic_endoskeleton/endoskeleton = target.GetComponent(/datum/component/synthetic_endoskeleton)
	return istype(endoskeleton) && endoskeleton.damage > 0
