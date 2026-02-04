/datum/component/synthetic_endoskeleton
	/// The synthetic that owns this component. Equivalent to `parent`, we just use this for ease of use.
	var/mob/living/carbon/human/owner
	/**
	 * The synthetic endoskeleton is our answer to the eternal problem of IPCs being unable to be brainmed complaint because
	 * of a lack of mechanics to represent pain, organ breaking, or bleeding/respiration, which is how humans in brainmed are
	 * taken down nonlethally, or before they die.
	 */
	var/damage = 0
	/// The maximum damage the endoskeleton can take before triggering the safety shutdown.
	var/max_damage = 200

	/// Time until next message.
	var/message_cooldown = 10 SECONDS
	/// World.time of last message sent.
	var/last_sent_message = 0

/datum/component/synthetic_endoskeleton/Initialize(...)
	. = ..()
	if(isipc(parent))
		owner = parent
	else
		log_debug("Synthetic endoskeleton component spawned on non-IPC. Deleting.")
		qdel_self()

	RegisterSignal(owner, COMSIG_EXTERNAL_ORGAN_DAMAGE, PROC_REF(receive_damage))
	RegisterSignal(owner, COMSIG_SYNTH_ENDOSKELETON_REPAIR, PROC_REF(heal_damage))
	RegisterSignal(owner, COMSIG_SYNTH_ENDOSKELETON_FULL_REPAIR, PROC_REF(full_repair))

/datum/component/synthetic_endoskeleton/Destroy(force)
	owner = null
	return ..()

/**
 * Signal handler called when an external synthetic limb receives damage.
 */
/datum/component/synthetic_endoskeleton/proc/receive_damage(atom/source, amount)
	SIGNAL_HANDLER
	damage = min(damage + amount, max_damage)
	handle_exoskeleton_damage()

/**
 * Signal handler called when the endoskeleton is repaired.
 */
/datum/component/synthetic_endoskeleton/proc/heal_damage(atom/source, amount)
	SIGNAL_HANDLER
	damage = max(damage - amount, 0)
	var/damage_ratio = damage / max_damage
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
 * Does a full repair of the endoskeleton, also restoring max_damage to initial state.
 */
/datum/component/synthetic_endoskeleton/proc/full_repair(atom/source)
	max_damage = initial(max_damage)
	heal_damage(source, max_damage)

/**
 * The function that handles exoskeleton damage effects.
 */
/datum/component/synthetic_endoskeleton/proc/handle_exoskeleton_damage()
	if(damage)
		START_PROCESSING(SSprocessing, src)
		var/damage_ratio = damage / max_damage
		switch(damage_ratio)
			if(0.3 to 0.5)
				notify_owner(owner, SPAN_WARNING("Your self-preservation warning system notifies you of moderate damage to your endoskeleton's supports!"))
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 1)
			if(0.5 to 0.75)
				notify_owner(owner, SPAN_WARNING("Your self-preservation warning system notifies you of major damage to your endoskeleton!"))
				spark(owner, 2, GLOB.alldirs)
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 2)
			if(0.75 to 0.99)
				notify_owner(owner, SPAN_DANGER("Your self-preservation routines are starting to kick in! Your endoskeleton is falling apart!"))
				spark(owner, 3, GLOB.alldirs)
				owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/endoskeleton, multiplicative_slowdown = 3)
			if(1 to INFINITY)
				SEND_SIGNAL(owner, COMSIG_SYNTH_SET_SELF_PRESERVATION, TRUE)

/datum/component/synthetic_endoskeleton/process()
	if(owner.stat)
		return

	var/damage_ratio = damage / max_damage
	switch(damage_ratio)
		if(0.3 to 0.5)
			if(prob(5))
				notify_owner(owner, SPAN_MACHINE_WARNING("Warning: Endoskeleton integrity at [100 - (damage_ratio * 100)]%."))
		if(0.5 to 0.75)
			if(prob(10))
				notify_owner(owner, SPAN_MACHINE_WARNING("WARNING: Endoskeleton integrity at [100 - (damage_ratio * 100)]%!"))
				notify_owner(owner, SPAN_WARNING("The mangled and exposed wires in your endoskeleton spark!"))
				spark(owner, 3, GLOB.alldirs)
				owner.bodytemperature += 10
		if(0.75 to 1)
			if(prob(15))
				notify_owner(owner, SPAN_MACHINE_DANGER(FONT_LARGE("ENDOSKELETON INTEGRITY CRITICAL. Your self preservation blares at you to return to safety!")))
				notify_owner(owner, SPAN_DANGER("Your frame creaks and groans, threatening to break apart at the metallic seams!"))
				spark(owner, 4, GLOB.alldirs)
				owner.bodytemperature += 20

/**
 * Wrapper to_chat proc with a stat check.
 */
/datum/component/synthetic_endoskeleton/proc/notify_owner(mob/living/carbon/human/user, message)
	if(user.is_asystole() || (last_sent_message + message_cooldown > world.time))
		return

	to_chat(user, message)
	last_sent_message = world.time
