/datum/component/synthetic_endoskeleton
	/// The synthetic that owns this component. Equivalent to `parent`, we just use this for ease of use.
	var/mob/living/carbon/human/owner
	/// The posibrain of our parent.
	var/obj/item/organ/internal/machine/posibrain/posibrain
	/**
	 * The synthetic endoskeleton is our answer to the eternal problem of IPCs being unable to be brainmed complaint because
	 * of a lack of mechanics to represent pain, organ breaking, or bleeding/respiration, which is how humans in brainmed are
	 * taken down nonlethally, or before they die.
	 */
	var/damage = 0
	/// The maximum damage the endoskeleton can take before triggering the safety shutdown.
	var/damage_maximum = 200

/datum/component/synthetic_endoskeleton/Initialize(...)
	. = ..()
	if(isipc(parent))
		owner = parent
		var/obj/item/organ/internal/machine/posibrain/possible_brain = owner.internal_organs_by_name[BP_BRAIN]
		if(!istype(possible_brain))
			log_debug("Synthetic endoskeleton somehow could not find a brain. Deleting.")
			qdel_self()
		else
			posibrain = possible_brain
	else
		log_debug("Synthetic endoskeleton component spawned on non-IPC. Deleting.")
		qdel_self()

	RegisterSignal(owner, COMSIG_EXTERNAL_ORGAN_DAMAGE, PROC_REF(receive_damage))
	RegisterSignal(owner, COMSIG_SYNTH_ENDOSKELETON_REPAIR, PROC_REF(heal_damage))

/datum/component/synthetic_endoskeleton/Destroy(force)
	owner = null
	posibrain = null
	return ..()

/**
 * Signal handler called when an external synthetic limb receives damage.
 */
/datum/component/synthetic_endoskeleton/proc/receive_damage(amount)
	SIGNAL_HANDLER
	damage = max(damage + amount, damage_maximum)
	handle_exoskeleton_damage()

/**
 * Signal handler called when the endoskeleton is repaired.
 */
/datum/component/synthetic_endoskeleton/proc/heal_damage(amount)
	SIGNAL_HANDLER
	damage = max(damage - amount, 0)
	var/damage_ratio = damage_maximum / damage
	switch(damage_ratio)
		if(0 to 0.3)
			owner.remove_movespeed_modifier(/datum/movespeed_modifier/endoskeleton)
		if(0.3 to 0.5)
			owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 1)
		if(0.5 to 0.75)
			owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 2)
		if(0.75 to 1)
			owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 3)
	if(!damage)
		STOP_PROCESSING(SSprocessing, src)

/**
 * The function that handles exoskeleton damage effects.
 */
/datum/component/synthetic_endoskeleton/proc/handle_exoskeleton_damage()
	if(damage)
		START_PROCESSING(SSprocessing, src)
		var/damage_ratio = damage_maximum / damage
		switch(damage_ratio)
			if(0.3 to 0.5)
				to_chat(owner, SPAN_WARNING("Your self-preservation warning system notifies you of moderate damage to your endoskeleton's supports!"))
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 1)
			if(0.5 to 0.75)
				to_chat(owner, SPAN_WARNING("Your self-preservation warning system notifies you of major damage to your endoskeleton!"))
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 2)
			if(0.75 to 1)
				to_chat(owner, SPAN_DANGER(FONT_LARGE("Your self-preservation routines are starting to kick in! Your endoskeleton is falling apart!")))
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 3)
			if(1 to INFINITY)
				owner.visible_message(SPAN_DANGER("[owner]'s limbs seize up and [owner.get_pronoun("he")] falls to the ground!"), SPAN_DANGER(FONT_LARGE("Your self-preservation routines kick in and you enter a safety shutdown mode!")))
				SEND_SIGNAL(owner, COMSIG_SYNTH_SELF_PRESERVATION_TOGGLED)

/datum/component/synthetic_endoskeleton/process()
	var/damage_ratio = damage_maximum / damage
	switch(damage_ratio)
		if(0.3 to 0.5)
			if(prob(5))
				to_chat(owner, SPAN_MACHINE_WARNING("Warning: Endoskeleton integrity at [100 - (damage_ratio * 100)]%."))
		if(0.5 to 0.75)
			if(prob(10))
				to_chat(owner, SPAN_MACHINE_WARNING("WARNING: Endoskeleton integrity at [100 - (damage_ratio * 100)]%!"))
				to_chat(owner, SPAN_WARNING("The mangled and exposed wires in your endoskeleton spark!"))
				spark(owner, 3, GLOB.alldirs)
				owner.bodytemperature += 10
		if(0.75 to 1)
			if(prob(20))
				to_chat(owner, SPAN_MACHINE_DANGER("ENDOSKELETON INTEGRITY CRITICAL. Your self preservation blares at you to return to safety!"))
				to_chat(owner, SPAN_WARNING("Your frame creaks and groans, threatening to break apart at the metallic seams!"))
				spark(owner, 4, GLOB.alldirs)
				owner.bodytemperature += 20
