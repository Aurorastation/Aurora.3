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
	var/burst_damage_maximum = 50
	/// The world.time of the first shot to start the burst damage counter.
	var/burst_damage_hit_time
	/// This grace period starts when burst_damage_hit_time is set, and will automatically clear that variable after 10 seconds.
	var/burst_damage_hit_grace_period = 7 SECONDS
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

/datum/component/synthetic_burst_damage/Destroy(force)
	synthetic_owner = null
	posibrain = null
	deltimer(burst_damage_timer)
	return ..()

/datum/component/synthetic_burst_damage/proc/receive_internal_damage(mob/target, amount)
	SIGNAL_HANDLER
	if(!burst_damage_hit_time)
		burst_damage_hit_time = world.time
	burst_damage_counter += amount
	burst_damage_timer = addtimer(CALLBACK(src, PROC_REF(clear_burst_damage)), burst_damage_hit_grace_period, TIMER_UNIQUE|TIMER_OVERRIDE)
	if(burst_damage_counter >= burst_damage_maximum)
		burst_damage_effects()
		burst_damage_hit_time = null

/datum/component/synthetic_burst_damage/proc/clear_burst_damage()
	posibrain.clear_burst_damage_counter()

/datum/component/synthetic_burst_damage/proc/burst_damage_effects()
	posibrain.add_burst_damage_counter()
