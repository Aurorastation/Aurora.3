/* SURGERY COMPLICATIONS */

/**
 * Evaluates and applies additional surgical complications after a failed step.
 * Standard complications scale in likelihood with fail_margin.
 * Losing the roll by SURGERY_COMPLICATION_CRITICAL_MARGIN+ triggers a critical complication,
 * and SURGERY_COMPLICATION_CATASTROPHIC_MARGIN+ can trigger multiple severe complications.
 */
/singleton/surgery_step/proc/handle_complications(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, fail_margin = 0)
	if(!can_cause_complications || QDELETED(target) || !tool)
		return FALSE

	if(isslime(target))
		return handle_slime_complications(user, target, tool, fail_margin)

	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/H = target
	var/obj/item/organ/external/affected = H.get_organ(target_zone)
	if(!affected || affected.is_stump())
		return FALSE

	var/is_robotic = BP_IS_ROBOTIC(affected)
	if(fail_margin >= SURGERY_COMPLICATION_CRITICAL_MARGIN)
		trigger_critical_complication(user, H, affected, target_zone, tool, is_robotic, fail_margin)
		if(fail_margin >= SURGERY_COMPLICATION_CATASTROPHIC_MARGIN)
			// Catastrophic botch: roll an extra standard or critical complication.
			if(prob(50))
				trigger_critical_complication(user, H, affected, target_zone, tool, is_robotic, fail_margin)
			else
				trigger_standard_complication(user, H, affected, target_zone, tool, is_robotic)
		return TRUE

	var/complication_chance = clamp(SURGERY_COMPLICATION_BASE_CHANCE + (fail_margin * SURGERY_COMPLICATION_MARGIN_BONUS), 0, 95)
	if(prob(complication_chance))
		trigger_standard_complication(user, H, affected, target_zone, tool, is_robotic)
		return TRUE

	return FALSE

/singleton/surgery_step/proc/handle_slime_complications(mob/living/user, mob/living/carbon/target, obj/item/tool, fail_margin = 0)
	if(fail_margin >= SURGERY_COMPLICATION_CRITICAL_MARGIN)
		user.visible_message(
			SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user]'s clumsy handling with \the [tool] ruptures [target]'s outer membrane, spraying caustic slime!"),
			SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> Your clumsy handling with \the [tool] ruptures [target]'s outer membrane, spraying caustic slime!")
		)
		target.apply_damage(rand(25, 40), DAMAGE_BRUTE)
		user.apply_damage(rand(12, 22), DAMAGE_TOXIN)
		user.Weaken(2)
		return TRUE

	if(prob(clamp(SURGERY_COMPLICATION_BASE_CHANCE + (fail_margin * SURGERY_COMPLICATION_MARGIN_BONUS), 0, 95)))
		user.visible_message(
			SPAN_WARNING("[target] convulses violently from [user]'s slip, splashing acidic jelly onto [user]!"),
			SPAN_WARNING("[target] convulses violently from your slip, splashing acidic jelly onto you!")
		)
		target.apply_damage(rand(10, 18), DAMAGE_BRUTE)
		user.apply_damage(rand(5, 10), DAMAGE_TOXIN)
		return TRUE

	return FALSE

/singleton/surgery_step/proc/trigger_standard_complication(mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool, is_robotic)
	if(is_robotic)
		var/list/candidates = get_standard_robotic_complications(target, affected)
		if(length(candidates))
			apply_robotic_complication(pick(candidates), user, target, affected, target_zone, tool)
		return

	var/list/candidates = get_standard_organic_complications(target, affected, target_zone)
	if(length(candidates))
		apply_organic_complication(pick(candidates), user, target, affected, target_zone, tool)

/singleton/surgery_step/proc/trigger_critical_complication(mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool, is_robotic, fail_margin = 0)
	if(is_robotic)
		var/list/candidates = get_critical_robotic_complications(target, affected, target_zone)
		if(length(candidates))
			apply_critical_robotic_complication(pick(candidates), user, target, affected, target_zone, tool)
		return

	var/list/candidates = get_critical_organic_complications(target, affected, target_zone, fail_margin)
	if(length(candidates))
		apply_critical_organic_complication(pick(candidates), user, target, affected, target_zone, tool)

/* ORGANIC COMPLICATION POOLS */

/singleton/surgery_step/proc/get_standard_organic_complications(mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone)
	var/list/candidates = list(COMPLICATION_NERVE_SHOCK, COMPLICATION_SURGEON_FUMBLE)

	if(target.species && !(target.species.flags & NO_BLOOD))
		candidates += COMPLICATION_HEAVY_BLEEDING
	if(can_infect)
		candidates += COMPLICATION_CONTAMINATION
	if(affected.tendon && !(affected.tendon_status() & TENDON_CUT))
		candidates += COMPLICATION_TENDON_TEAR
	if(!ORGAN_IS_DISLOCATED(affected) && !(affected.organ_tag in list(BP_CHEST, BP_GROIN)))
		candidates += COMPLICATION_DISLOCATION
	if(!(affected.status & ORGAN_BROKEN) && (affected.limb_flags & ORGAN_CAN_BREAK))
		candidates += COMPLICATION_HAIRLINE_FRACTURE
	if(length(affected.internal_organs))
		candidates += COMPLICATION_ORGAN_BRUISE
	if(istype(affected, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/H_head = affected
		if(!H_head.disfigured)
			candidates += COMPLICATION_FACIAL_SCARRING
	if(target_zone in list(BP_HEAD, BP_EYES))
		candidates += COMPLICATION_OCULAR_TRAUMA

	return candidates

/singleton/surgery_step/proc/get_critical_organic_complications(mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, fail_margin = 0)
	var/list/candidates = list(COMPLICATION_INCISION_RUPTURE)

	if(!(affected.status & ORGAN_ARTERY_CUT) && target.species && !(target.species.flags & (NO_BLOOD | NO_ARTERIES)))
		candidates += COMPLICATION_SEVERED_ARTERY
	if(affected.tendon && !(affected.tendon_status() & TENDON_CUT))
		candidates += COMPLICATION_SEVERED_TENDON
	if(affected.limb_flags & ORGAN_CAN_BREAK)
		candidates += COMPLICATION_SHATTERED_BONE
	if(length(affected.internal_organs))
		candidates += COMPLICATION_RUPTURED_ORGAN
	if(can_infect)
		candidates += COMPLICATION_SEPTIC_SHOCK
	if(target_zone in list(BP_HEAD, BP_EYES, BP_MOUTH))
		candidates += COMPLICATION_CEREBRAL_TRAUMA
	if(target_zone == BP_CHEST)
		candidates += COMPLICATION_CARDIORESPIRATORY_SHOCK
	if(fail_margin >= SURGERY_COMPLICATION_CATASTROPHIC_MARGIN && (affected.limb_flags & ORGAN_CAN_AMPUTATE) && !(affected.organ_tag in list(BP_CHEST, BP_GROIN, BP_HEAD)))
		candidates += COMPLICATION_ACCIDENTAL_AMPUTATION

	return candidates

/* ROBOTIC COMPLICATION POOLS */

/singleton/surgery_step/proc/get_standard_robotic_complications(mob/living/carbon/human/target, obj/item/organ/external/affected)
	var/list/candidates = list(COMPLICATION_ROBOTIC_POWER_SHORT, COMPLICATION_ROBOTIC_SURGEON_SHOCK)

	if(!ORGAN_IS_DISLOCATED(affected) && !(affected.organ_tag in list(BP_CHEST, BP_GROIN)))
		candidates += COMPLICATION_ROBOTIC_ACTUATOR_JAM
	if(length(affected.internal_organs))
		candidates += COMPLICATION_ROBOTIC_COMPONENT_DAMAGE

	return candidates

/singleton/surgery_step/proc/get_critical_robotic_complications(mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone)
	var/list/candidates = list(COMPLICATION_ROBOTIC_CATASTROPHIC_SHORT, COMPLICATION_ROBOTIC_CHASSIS_COLLAPSE)

	if(length(affected.internal_organs) || target_zone == BP_HEAD)
		candidates += COMPLICATION_ROBOTIC_NEURAL_FEEDBACK

	return candidates

/* ORGANIC COMPLICATION HANDLERS */

/singleton/surgery_step/proc/apply_organic_complication(complication_id, mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool)
	switch(complication_id)
		if(COMPLICATION_HEAVY_BLEEDING)
			user.visible_message(
				SPAN_WARNING("[user] nicks a blood vessel in [target]'s [affected.name], causing heavy bleeding!"),
				SPAN_WARNING("You nick a blood vessel in [target]'s [affected.name], causing heavy bleeding!")
			)
			affected.status |= ORGAN_BLEEDING
			target.apply_damage(rand(4, 9), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
			target.drip(10)
			if(ishuman(user))
				var/mob/living/carbon/human/surgeon = user
				surgeon.bloody_hands(target, 0)

		if(COMPLICATION_CONTAMINATION)
			user.visible_message(
				SPAN_WARNING("Unclean contact during [user]'s slip contaminates the wound in [target]'s [affected.name]!"),
				SPAN_WARNING("Your slip contaminates the open wound in [target]'s [affected.name]!")
			)
			affected.germ_level = max(affected.germ_level + rand(150, 300), INFECTION_LEVEL_ONE + 50)

		if(COMPLICATION_NERVE_SHOCK)
			user.visible_message(
				SPAN_WARNING("[user] brushes an exposed nerve in [target]'s [affected.name], sending a jolt of agony through [target]!"),
				SPAN_WARNING("You brush an exposed nerve in [target]'s [affected.name], sending a jolt of agony through [target]!")
			)
			target.apply_damage(rand(20, 35), DAMAGE_PAIN)
			target.custom_pain("A white-hot spike of nerve pain tears through your [affected.name]!", 120)
			if(target.stat == CONSCIOUS)
				target.Weaken(1)

		if(COMPLICATION_TENDON_TEAR)
			user.visible_message(
				SPAN_WARNING("\The [tool] snags and tears at the [affected.tendon_name] in [target]'s [affected.name]!"),
				SPAN_WARNING("\The [tool] snags and tears at the [affected.tendon_name] in [target]'s [affected.name]!")
			)
			affected.tendon.damage(rand(12, 22))
			target.apply_damage(rand(3, 7), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_DISLOCATION)
			user.visible_message(
				SPAN_WARNING("The awkward wrenching motion pops [target]'s [affected.name] out of joint!"),
				SPAN_WARNING("Your awkward wrenching motion pops [target]'s [affected.name] out of joint!")
			)
			affected.dislocate(TRUE)

		if(COMPLICATION_HAIRLINE_FRACTURE)
			user.visible_message(
				SPAN_WARNING("A sickening crack echoes as [user] fractures the bone in [target]'s [affected.name]!"),
				SPAN_WARNING("You hear a sickening crack as you fracture the bone in [target]'s [affected.name]!")
			)
			affected.fracture()

		if(COMPLICATION_ORGAN_BRUISE)
			var/obj/item/organ/internal/I = pick(affected.internal_organs)
			user.visible_message(
				SPAN_WARNING("[user] accidentally bruises [target]'s [I.name] with \the [tool]!"),
				SPAN_WARNING("You accidentally bruise [target]'s [I.name] with \the [tool]!")
			)
			I.take_damage(rand(4, 8), FALSE)
			I.bruise()

		if(COMPLICATION_FACIAL_SCARRING)
			var/obj/item/organ/external/head/H_head = affected
			user.visible_message(
				SPAN_WARNING("\The [tool] gouges across [target]'s face, leaving a jagged wound!"),
				SPAN_WARNING("\The [tool] gouges across [target]'s face, leaving a jagged wound!")
			)
			H_head.disfigured = TRUE
			target.apply_damage(rand(5, 10), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_OCULAR_TRAUMA)
			user.visible_message(
				SPAN_WARNING("[user] grazes the delicate ocular tissue around [target]'s eyes!"),
				SPAN_WARNING("You graze the delicate ocular tissue around [target]'s eyes!")
			)
			target.eye_blurry = max(target.eye_blurry, rand(10, 20))
			var/obj/item/organ/internal/eyes/E = target.internal_organs_by_name[BP_EYES]
			if(E)
				E.take_damage(rand(4, 8), FALSE)

		if(COMPLICATION_SURGEON_FUMBLE)
			user.visible_message(
				SPAN_WARNING("[user] loses grip of \the [tool], nicking [user == target ? "themself" : "their own hand"] as it clatters!"),
				SPAN_WARNING("You lose grip of \the [tool], nicking yourself as it slips!")
			)
			user.apply_damage(rand(3, 8), DAMAGE_BRUTE, null, 0, tool, damage_flags = tool.damage_flags())
			if(tool in user.contents)
				user.drop_item()

/singleton/surgery_step/proc/apply_critical_organic_complication(complication_id, mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool)
	switch(complication_id)
		if(COMPLICATION_SEVERED_ARTERY)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user]'s botched motion with \the [tool] slices straight through the [affected.artery_name] in [target]'s [affected.name], unleashing a spray of blood!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> Your botched motion with \the [tool] slices straight through the [affected.artery_name] in [target]'s [affected.name]!")
			)
			affected.sever_artery()
			affected.status |= ORGAN_BLEEDING
			target.apply_damage(rand(12, 20), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
			target.drip(25)
			if(ishuman(user))
				var/mob/living/carbon/human/surgeon = user
				surgeon.bloody_body(target, 0)

		if(COMPLICATION_SEVERED_TENDON)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] completely severs the [affected.tendon_name] in [target]'s [affected.name] with \the [tool]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You completely sever the [affected.tendon_name] in [target]'s [affected.name] with \the [tool]!")
			)
			affected.tendon.sever()
			target.apply_damage(rand(10, 18), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_SHATTERED_BONE)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] catastrophically shatters the bone in [target]'s [affected.name] with \the [tool]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You catastrophically shatter the bone in [target]'s [affected.name] with \the [tool]!")
			)
			affected.fracture()
			target.apply_damage(rand(15, 25), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
			if(length(affected.internal_organs))
				var/obj/item/organ/internal/I = pick(affected.internal_organs)
				user.visible_message(SPAN_DANGER("Jagged bone fragments pierce [target]'s [I.name]!"))
				I.take_damage(rand(10, 18), FALSE)
				I.bruise()

		if(COMPLICATION_RUPTURED_ORGAN)
			var/obj/item/organ/internal/I = pick(affected.internal_organs)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] plunges \the [tool] too deep, severely lacerating [target]'s [I.name]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You plunge \the [tool] too deep, severely lacerating [target]'s [I.name]!")
			)
			I.take_damage(rand(18, 30), FALSE)
			I.bruise()
			target.adjustToxLoss(rand(8, 16))
			target.apply_damage(rand(8, 14), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_SEPTIC_SHOCK)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] drives filth deep into [target]'s [affected.name], triggering an acute septic infection!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You drive contaminants deep into [target]'s [affected.name], triggering an acute septic infection!")
			)
			affected.germ_level = max(affected.germ_level + rand(400, 650), INFECTION_LEVEL_TWO + 50)
			if(length(affected.internal_organs))
				var/obj/item/organ/internal/I = pick(affected.internal_organs)
				I.germ_level = max(I.germ_level + rand(250, 450), INFECTION_LEVEL_ONE + 50)
			target.adjustToxLoss(rand(10, 18))

		if(COMPLICATION_CEREBRAL_TRAUMA)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user]'s slip inflicts severe cranial and neurological trauma on [target]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> Your slip inflicts severe cranial and neurological trauma on [target]!")
			)
			target.adjustBrainLoss(rand(12, 25))
			target.confused = max(target.confused, rand(6, 12))
			target.eye_blurry = max(target.eye_blurry, 20)
			target.Paralyse(2)
			target.apply_damage(rand(10, 18), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_CARDIORESPIRATORY_SHOCK)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user]'s blunder sends [target]'s chest cavity into acute cardiorespiratory shock!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> Your blunder sends [target]'s chest cavity into acute cardiorespiratory shock!")
			)
			target.adjustOxyLoss(rand(18, 30))
			target.Paralyse(2)
			if(length(affected.internal_organs))
				var/obj/item/organ/internal/I = pick(affected.internal_organs)
				I.take_damage(rand(10, 20), FALSE)

		if(COMPLICATION_INCISION_RUPTURE)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] violently tears open the surgical site in [target]'s [affected.name]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You violently tear open the surgical site in [target]'s [affected.name]!")
			)
			affected.status |= ORGAN_BLEEDING
			target.apply_damage(rand(15, 25), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
			target.apply_damage(rand(25, 40), DAMAGE_PAIN)
			if(!(affected.organ_tag in list(BP_CHEST, BP_GROIN)))
				affected.dislocate(TRUE)

		if(COMPLICATION_ACCIDENTAL_AMPUTATION)
			user.visible_message(
				SPAN_DANGER("<b>CATASTROPHIC COMPLICATION:</b> [user]'s disastrous slip with \the [tool] completely severs [target]'s [affected.name]!"),
				SPAN_DANGER("<b>CATASTROPHIC COMPLICATION:</b> Your disastrous slip with \the [tool] completely severs [target]'s [affected.name]!")
			)
			affected.droplimb(FALSE, DROPLIMB_EDGE)

/* ROBOTIC COMPLICATION HANDLERS */

/singleton/surgery_step/proc/apply_robotic_complication(complication_id, mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool)
	switch(complication_id)
		if(COMPLICATION_ROBOTIC_POWER_SHORT)
			user.visible_message(
				SPAN_WARNING("[user] shorts a power lead inside [target]'s [affected.name], sending out a shower of sparks!"),
				SPAN_WARNING("You short a power lead inside [target]'s [affected.name], sending out a shower of sparks!")
			)
			spark(get_turf(target), 3, GLOB.alldirs)
			target.apply_damage(rand(6, 12), DAMAGE_BURN, target_zone, 0, tool)

		if(COMPLICATION_ROBOTIC_ACTUATOR_JAM)
			user.visible_message(
				SPAN_WARNING("[user] bends the joint assembly in [target]'s [affected.name], jamming the actuators!"),
				SPAN_WARNING("You bend the joint assembly in [target]'s [affected.name], jamming the actuators!")
			)
			affected.dislocate(TRUE)
			target.apply_damage(rand(6, 12), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

		if(COMPLICATION_ROBOTIC_SURGEON_SHOCK)
			user.visible_message(
				SPAN_WARNING("An exposed capacitor in [target]'s [affected.name] discharges through \the [tool], shocking [user]!"),
				SPAN_WARNING("An exposed capacitor in [target]'s [affected.name] discharges through \the [tool], shocking you!")
			)
			spark(get_turf(target), 2, GLOB.alldirs)
			user.electrocute_act(rand(6, 12), tool)
			if(tool in user.contents)
				user.drop_item()

		if(COMPLICATION_ROBOTIC_COMPONENT_DAMAGE)
			var/obj/item/organ/internal/I = pick(affected.internal_organs)
			user.visible_message(
				SPAN_WARNING("[user] scrapes \the [tool] against [target]'s [I.name], damaging its delicate circuitry!"),
				SPAN_WARNING("You scrape \the [tool] against [target]'s [I.name], damaging its delicate circuitry!")
			)
			I.take_damage(rand(5, 10), FALSE)

/singleton/surgery_step/proc/apply_critical_robotic_complication(complication_id, mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, target_zone, obj/item/tool)
	switch(complication_id)
		if(COMPLICATION_ROBOTIC_CATASTROPHIC_SHORT)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] bridges a high-voltage bus in [target]'s [affected.name], triggering a violent arc discharge!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You bridge a high-voltage bus in [target]'s [affected.name], triggering a violent arc discharge!")
			)
			spark(get_turf(target), 5, GLOB.alldirs)
			affected.emp_act(2)
			target.apply_damage(rand(18, 30), DAMAGE_BURN, target_zone, 0, tool)
			user.electrocute_act(rand(15, 25), tool)

		if(COMPLICATION_ROBOTIC_CHASSIS_COLLAPSE)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user] warps the structural frame of [target]'s [affected.name] with \the [tool]!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> You warp the structural frame of [target]'s [affected.name] with \the [tool]!")
			)
			target.apply_damage(rand(20, 32), DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
			target.apply_damage(rand(8, 15), DAMAGE_BURN, target_zone, 0, tool)
			if(!(affected.organ_tag in list(BP_CHEST, BP_GROIN)))
				affected.dislocate(TRUE)

		if(COMPLICATION_ROBOTIC_NEURAL_FEEDBACK)
			user.visible_message(
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> [user]'s slip sends a destructive surge through [target]'s [affected.name] internal systems!"),
				SPAN_DANGER("<b>CRITICAL COMPLICATION:</b> Your slip sends a destructive surge through [target]'s [affected.name] internal systems!")
			)
			spark(get_turf(target), 4, GLOB.alldirs)
			if(length(affected.internal_organs))
				var/obj/item/organ/internal/I = pick(affected.internal_organs)
				I.take_damage(rand(15, 28), FALSE)
			if(target_zone == BP_HEAD)
				target.adjustBrainLoss(rand(10, 20))
				target.confused = max(target.confused, rand(5, 10))
