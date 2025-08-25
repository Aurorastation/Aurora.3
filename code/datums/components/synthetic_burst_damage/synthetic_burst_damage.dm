/datum/component/synthetic_burst_damage
	/// The synthetic that owns this component. Equivalent to `parent`, we just use this for ease of use.
	var/mob/living/carbon/human/synthetic_owner
	/// The posibrain of our parent.
	var/obj/item/organ/internal/machine/posibrain/posibrain
	/**
	 * The burst damage counter is our way to handle a 'pain' mechanic for IPCs.
	 * Conceptually, the problem is that an IPC does not have pain, and thus cannot succumb to short-term damage. You can shoot an IPC 50 times in the chest, but it will ignore it.
	 * It will still die to long-term problems caused by its cooling unit being destroyed and such, but in combat it's important that a threat in front of you can be reasonably disabled.
	 * The burst damage counter is our solution to that. Receiving a lot of damage in a short time can disable the organ, and thus create a severe disabling effect. It holds the current burst damage.
	 * Increased every time the organ is damaged, automatically clears after some time.
	 */
	var/burst_damage_counter = 0
	/// The breaking point to trigger a burst damage event.
	var/burst_damage_maximum = 30
	/// This is how long it takes to clear the burst damage timer.
	var/burst_damage_clear_time = 7 SECONDS
	/// Once the damage is cleared, we have this long to go without suffering burst damage effects.
	var/burst_damage_grace_period = 5 SECONDS
	/// If the grace period is on or not.
	var/burst_damage_grace_period_granted = FALSE
	/// When our grace period starts.
	var/burst_damage_grace_period_start_time = 0
	/// Timer ID of the burst damage clearing timer.
	var/burst_damage_timer

/datum/component/synthetic_burst_damage/Initialize(...)
	. = ..()
	if(isipc(parent))
		synthetic_owner = parent
		var/obj/item/organ/internal/machine/posibrain/possible_brain = synthetic_owner.internal_organs_by_name[BP_BRAIN]
		if(!istype(possible_brain))
			log_debug("Synthetic burst damage component somehow could not find a brain. Deleting.")
			qdel_self()
		else
			posibrain = possible_brain
	else
		log_debug("Synthetic burst damage component spawned on non-IPC. Deleting.")
		qdel_self()

	RegisterSignal(synthetic_owner, COMSIG_MACHINE_INTERNAL_DAMAGE, PROC_REF(receive_internal_damage))
	RegisterSignal(synthetic_owner, COMSIG_SYNTH_BURST_DAMAGE_CLEARED, PROC_REF(posibrain_clear_burst_damage))

/datum/component/synthetic_burst_damage/Destroy(force)
	synthetic_owner = null
	posibrain = null
	if(burst_damage_timer)
		deltimer(burst_damage_timer)
	return ..()

/datum/component/synthetic_burst_damage/proc/receive_internal_damage(mob/target, amount)
	SIGNAL_HANDLER
	if(burst_damage_grace_period_granted && (burst_damage_grace_period_start_time > world.time + burst_damage_grace_period))
		return
	burst_damage_counter += amount
	burst_damage_timer = addtimer(CALLBACK(src, PROC_REF(clear_burst_damage)), burst_damage_clear_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	if(burst_damage_counter >= burst_damage_maximum)
		burst_damage_effects()

/datum/component/synthetic_burst_damage/proc/clear_burst_damage()
	burst_damage_counter = 0
	posibrain.clear_burst_damage_counter()
	begin_grace_period()
	synthetic_owner.remove_movespeed_modifier(/datum/movespeed_modifier/burst_damage)

/datum/component/synthetic_burst_damage/proc/burst_damage_effects()
	if(!posibrain && synthetic_owner)
		var/obj/item/organ/internal/machine/posibrain/possible_brain = synthetic_owner.internal_organs_by_name[BP_BRAIN]
		if(!istype(possible_brain))
			log_debug("Synthetic burst damage component somehow could not find a brain. Deleting.")
			qdel_self()
		else
			posibrain = possible_brain
	posibrain.add_burst_damage_counter()

/datum/component/synthetic_burst_damage/proc/posibrain_clear_burst_damage()
	SIGNAL_HANDLER
	begin_grace_period()

/datum/component/synthetic_burst_damage/proc/begin_grace_period()
	burst_damage_grace_period_granted = TRUE
	burst_damage_grace_period_start_time = world.time
