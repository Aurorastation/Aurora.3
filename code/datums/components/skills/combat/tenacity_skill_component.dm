/datum/action/tenacity
	name = "Self-Triage"
	action_type = 6
	procname = "activate"
	button_icon = 'icons/hud/action_buttons/skills.dmi'
	button_icon_state = "tenacity"

/datum/action/tenacity/proc/activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/datum/component/skill/tenacity/comp = H.GetComponent(TENACITY_SKILL_COMPONENT)
	if(!comp)
		return

	if(isipc(H))
		comp.run_ipc_diagnostic(H)
	else
		comp.run_organic_triage(H)

/**
 * Component used for the Tenacity / Fault-Tolerant Architecture skill.
 * Ranks placed in this skill affect how long a character can survive in critical condition before permanently dying,
 * provide Self-Triage / System Diagnostic at Trained+, and unlock Last Stand / Fail-Safe Kernel at Professional.
 **/
/datum/component/skill/tenacity
	var/bonus_min_efficiency_per_rank = 0.1
	var/bonus_effective_bv_per_rank = 1.25
	var/bonus_pulse_mod_per_rank = 0.05
	var/bonus_bleed_resist_per_rank = 0.075
	var/bonus_arterial_resist_per_rank = 0.0375

	/// Active Self-Triage / Diagnostic action granted at Trained+.
	var/datum/action/tenacity/tenacity_action
	/// Professional capstone: 15s Last Stand / Fail-Safe Kernel window on a 30m cooldown.
	var/emergency_reserve_duration = 15 SECONDS
	var/emergency_reserve_cooldown = 30 MINUTES
	var/emergency_reserve_until = 0
	var/next_emergency_reserve = 0

/datum/component/skill/tenacity/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_HEART_PUMP_EVENT, PROC_REF(stabilize_circulation))
	RegisterSignal(parent, COMSIG_HEART_BLEED_EVENT, PROC_REF(reduce_bloodloss))
	RegisterSignal(parent, COMSIG_HEART_PULSE_EVENT, PROC_REF(handle_heart_pulse))
	RegisterSignal(parent, COMSIG_HUMAN_SHOCK_CHECK, PROC_REF(handle_shock_check))
	RegisterSignal(parent, COMSIG_IPC_INTEGRITY_EVENT_CHECK, PROC_REF(handle_ipc_integrity_check))
	RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)

	if(skill_level >= SKILL_LEVEL_TRAINED)
		tenacity_action = new /datum/action/tenacity()
		if(isipc(parent))
			tenacity_action.name = "System Diagnostic"
		tenacity_action.SetTarget(tenacity_action)
		tenacity_action.Grant(parent)

/datum/component/skill/tenacity/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_HEART_PUMP_EVENT)
	UnregisterSignal(parent, COMSIG_HEART_BLEED_EVENT)
	UnregisterSignal(parent, COMSIG_HEART_PULSE_EVENT)
	UnregisterSignal(parent, COMSIG_HUMAN_SHOCK_CHECK)
	UnregisterSignal(parent, COMSIG_IPC_INTEGRITY_EVENT_CHECK)
	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	tenacity_action?.Remove(parent)
	QDEL_NULL(tenacity_action)
	return ..()

/datum/component/skill/tenacity/proc/setup_action_button()
	astype(parent, /mob)?.update_action_buttons()

/datum/component/skill/tenacity/proc/trigger_last_stand(mob/living/carbon/human/H)
	if(skill_level < SKILL_LEVEL_PROFESSIONAL || world.time < next_emergency_reserve)
		return FALSE
	next_emergency_reserve = world.time + emergency_reserve_cooldown
	emergency_reserve_until = world.time + emergency_reserve_duration
	H.shock_stage = min(H.shock_stage, 100)
	if(H.max_stamina > 0)
		H.stamina = clamp(H.stamina + 15, 0, H.max_stamina)
		H.hud_used?.move_intent?.update_move_icon(H)
	H.visible_message(
		SPAN_WARNING("[H] grits [H.get_pronoun("his")] teeth, refusing to go down just yet!"),
		SPAN_GOOD("You grit your teeth through the agony, clinging to consciousness!")
	)
	H.balloon_alert(H, "Last stand!")
	return TRUE

/datum/component/skill/tenacity/proc/trigger_failsafe(mob/living/carbon/human/H)
	if(skill_level < SKILL_LEVEL_PROFESSIONAL || world.time < next_emergency_reserve)
		return FALSE
	next_emergency_reserve = world.time + emergency_reserve_cooldown
	emergency_reserve_until = world.time + emergency_reserve_duration
	var/obj/item/organ/internal/machine/posibrain/brain = H.internal_organs_by_name[BP_BRAIN]
	if(istype(brain))
		brain.last_patch_time = 0
	H.visible_message(
		SPAN_WARNING("[H]'s chassis chimes softly as emergency fail-safe protocols engage."),
		SPAN_GOOD("Fail-safe kernel engaged: cascading internal failures locked out for 20 seconds!")
	)
	H.balloon_alert(H, "Fail-safe active!")
	return TRUE

/datum/component/skill/tenacity/proc/run_organic_triage(mob/living/carbon/human/H)
	var/list/issues = list()
	for(var/obj/item/organ/external/E in H.organs)
		if(E.status & ORGAN_ARTERY_CUT)
			issues += "severed artery in your [E.name]"
		else if(E.status & ORGAN_BLEEDING)
			issues += "bleeding from your [E.name]"
		else if(E.status & ORGAN_BROKEN)
			issues += "fracture in your [E.name]"

	if(length(issues))
		to_chat(H, SPAN_NOTICE("<b>Self-Triage:</b> You assess [english_list(issues)]."))
	else if(H.shock_stage >= 30)
		to_chat(H, SPAN_NOTICE("<b>Self-Triage:</b> Your body is in shock (stage [H.shock_stage]), though no major external bleeds stand out."))
	else
		to_chat(H, SPAN_NOTICE("<b>Self-Triage:</b> Your vitals feel steady."))

	if(skill_level >= SKILL_LEVEL_PROFESSIONAL && H.shock_stage >= 80 && world.time >= next_emergency_reserve)
		trigger_last_stand(H)

/datum/component/skill/tenacity/proc/run_ipc_diagnostic(mob/living/carbon/human/H)
	var/list/issues = list()
	for(var/obj/item/organ/internal/machine/M in H.internal_organs)
		var/organ_damage = M.get_damage()
		if(organ_damage > 0)
			issues += "[M.name] ([round(organ_damage)] dmg)"
	if(length(issues))
		to_chat(H, SPAN_MACHINE_WARNING("<b>System Diagnostic:</b> Damaged internals detected — [english_list(issues)]."))
		if(skill_level >= SKILL_LEVEL_PROFESSIONAL && world.time >= next_emergency_reserve)
			trigger_failsafe(H)
	else
		to_chat(H, SPAN_NOTICE("<b>System Diagnostic:</b> All internal components report nominal integrity."))

/datum/component/skill/tenacity/proc/stabilize_circulation(owner, obj/item/organ/internal/heart/heart, blood_volume, recent_pump, pulse_mod, min_efficiency)
	SIGNAL_HANDLER
	var/offset_skill = skill_level - 1
	*min_efficiency = *min_efficiency * (1 + (bonus_min_efficiency_per_rank * offset_skill))
	*blood_volume = *blood_volume + (bonus_effective_bv_per_rank * offset_skill)
	*pulse_mod = *pulse_mod * (1 + (bonus_pulse_mod_per_rank * offset_skill))

/datum/component/skill/tenacity/proc/reduce_bloodloss(owner, blood_volume, cut_bloodloss_modifier, arterial_bloodloss_modifier)
	SIGNAL_HANDLER
	var/offset_skill = skill_level - 1
	*cut_bloodloss_modifier = *cut_bloodloss_modifier * (1 - (offset_skill * bonus_bleed_resist_per_rank))
	*arterial_bloodloss_modifier = *arterial_bloodloss_modifier * (1 - (offset_skill * bonus_arterial_resist_per_rank))

/datum/component/skill/tenacity/proc/handle_heart_pulse(owner, pulse_mod, is_stable, oxy, circulation, canceled)
	SIGNAL_HANDLER
	if(skill_level >= SKILL_LEVEL_TRAINED && *pulse_mod > 2)
		*pulse_mod = *pulse_mod - 1
	if(world.time < emergency_reserve_until)
		*is_stable = TRUE

/datum/component/skill/tenacity/proc/handle_shock_check(mob/living/carbon/human/owner, shock_stage, recovery)
	SIGNAL_HANDLER
	if(!istype(owner))
		return
	if(recovery && skill_level >= SKILL_LEVEL_TRAINED)
		*recovery = *recovery + 1
	if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
		if(world.time < emergency_reserve_until)
			*shock_stage = min(*shock_stage, 100)
		else if(*shock_stage >= 120 && world.time >= next_emergency_reserve)
			if(trigger_last_stand(owner))
				*shock_stage = min(*shock_stage, 100)

/datum/component/skill/tenacity/proc/handle_ipc_integrity_check(mob/living/carbon/human/owner, cancelled)
	SIGNAL_HANDLER
	if(skill_level < SKILL_LEVEL_PROFESSIONAL || !istype(owner))
		return
	if(world.time < emergency_reserve_until)
		*cancelled = TRUE
		return
	if(world.time >= next_emergency_reserve)
		if(trigger_failsafe(owner))
			*cancelled = TRUE
