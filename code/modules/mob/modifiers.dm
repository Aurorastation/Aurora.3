// This is a datum that tells the mob that something is affecting them.
// The advantage of using this datum verses just setting a variable on the mob directly, is that there is no risk of two different procs overwriting
// each other, or other weirdness.  An excellent example is adjusting max health.

/datum/modifier
	var/name = null						// Mostly used to organize, might show up on the UI in the Future(tm)
	var/desc = null						// Ditto.
	var/icon_state = null				// See above.
	var/mob/living/holder = null		// The mob that this datum is affecting.
	var/weakref/origin = null			// A weak reference to whatever caused the modifier to appear.  THIS NEEDS TO BE A MOB/LIVING.  It's a weakref to not interfere with qdel().
	var/expire_at = null				// world.time when holder's Life() will remove the datum.  If null, it lasts forever or until it gets deleted by something else.
	var/on_created_text = null			// Text to show to holder upon being created.
	var/on_expired_text = null			// Text to show to holder when it expires.
	var/hidden = FALSE					// If true, it will not show up on the HUD in the Future(tm)
	var/stacks = MODIFIER_STACK_FORBID	// If true, attempts to add a second instance of this type will refresh expire_at instead.
	var/flags = 0						// Flags for the modifier, see mobs.dm defines for more details.

	var/light_color = null				// If set, the mob possessing the modifier will glow in this color.  Not implemented yet.
	var/light_range = null				// How far the light for the above var goes. Not implemented yet.
	var/light_intensity = null			// Ditto. Not implemented yet.
	var/mob_overlay_state = null		// Icon_state for an overlay to apply to a (human) mob while this exists.  This is actually implemented.

	// Now for all the different effects.
	// Percentage modifiers are expressed as a multipler. (e.g. +25% damage should be written as 1.25)
	var/max_health_flat					// Adjusts max health by a flat (e.g. +20) amount.  Note this is added to base health.
	var/max_health_percent				// Adjusts max health by a percentage (e.g. -30%).
	var/disable_duration_percent		// Adjusts duration of 'disables' (stun, weaken, paralyze, confusion, sleep, halloss, etc)  Setting to 0 will grant immunity.
	var/incoming_damage_percent			// Adjusts all incoming damage.
	var/incoming_brute_damage_percent	// Only affects bruteloss.
	var/incoming_fire_damage_percent	// Only affects fireloss.
	var/incoming_tox_damage_percent		// Only affects toxloss.
	var/incoming_oxy_damage_percent		// Only affects oxyloss.
	var/incoming_clone_damage_percent	// Only affects cloneloss.
	var/incoming_hal_damage_percent		// Only affects halloss.
	var/incoming_healing_percent		// Adjusts amount of healing received.
	var/outgoing_melee_damage_percent	// Adjusts melee damage inflicted by holder by a percentage.  Affects attacks by melee weapons and hand-to-hand.
	var/slowdown						// Negative numbers speed up, positive numbers slow down movement.
	var/haste							// If set to 1, the mob will be 'hasted', which makes it ignore slowdown and go really fast.
	var/evasion							// Positive numbers reduce the odds of being hit by 15% each.  Negative numbers increase the odds.

/datum/modifier/New(var/new_holder, var/new_origin)
	holder = new_holder
	if(new_origin)
		origin = weakref(new_origin)
	else // We assume the holder caused the modifier if not told otherwise.
		origin = weakref(holder)
	..()

// Checks to see if this datum should continue existing.
/datum/modifier/proc/check_if_valid()
	if(expire_at && expire_at < world.time) // Is our time up?
		src.expire()

/datum/modifier/proc/expire(var/silent = FALSE)
	if(on_expired_text && !silent)
		to_chat(holder, on_expired_text)
	on_expire()
	holder.modifiers.Remove(src)
	if(mob_overlay_state) // We do this after removing ourselves from the list so that the overlay won't remain.
		holder.update_modifier_visuals()
	qdel(src)

// Override this for special effects when it gets removed.
/datum/modifier/proc/on_expire()
	return

// Called every Life() tick.  Override for special behaviour.
/datum/modifier/proc/tick()
	return

/mob/living
	var/list/modifiers = list() // A list of modifier datums, which can adjust certain mob numbers.

/mob/living/Destroy()
	remove_all_modifiers(TRUE)
	return ..()

// Called by Life().
/mob/living/proc/handle_modifiers()
	if(!modifiers.len) // No work to do.
		return
	// Get rid of anything we shouldn't have.
	for(var/datum/modifier/M in modifiers)
		M.check_if_valid()
	// Remaining modifiers will now receive a tick().  This is in a second loop for safety in order to not tick() an expired modifier.
	for(var/datum/modifier/M in modifiers)
		M.tick()

// Call this to add a modifier to a mob. First argument is the modifier type you want, second is how long it should last, in ticks.
// Third argument is the 'source' of the modifier, if it's from someone else.  If null, it will default to the mob being applied to.
// The SECONDS/MINUTES macro is very helpful for this.  E.g. M.add_modifier(/datum/modifier/example, 5 MINUTES)
/mob/living/proc/add_modifier(var/modifier_type, var/expire_at = null, var/mob/living/origin = null)
	// First, check if the mob already has this modifier.
	for(var/datum/modifier/M in modifiers)
		if(ispath(modifier_type, M))
			switch(M.stacks)
				if(MODIFIER_STACK_FORBID)
					return // Stop here.
				if(MODIFIER_STACK_ALLOWED)
					break // No point checking anymore.
				if(MODIFIER_STACK_EXTEND)
					// Not allow to add a second instance, but we can try to prolong the first instance.
					if(expire_at && world.time + expire_at > M.expire_at)
						M.expire_at = world.time + expire_at
					return

	// If we're at this point, the mob doesn't already have it, or it does but stacking is allowed.
	var/datum/modifier/mod = new modifier_type(src, origin)
	if(expire_at)
		mod.expire_at = world.time + expire_at
	if(mod.on_created_text)
		to_chat(src, mod.on_created_text)
	modifiers.Add(mod)
	if(mod.mob_overlay_state)
		update_modifier_visuals()

	return mod

// Removes a specific instance of modifier
/mob/living/proc/remove_specific_modifier(var/datum/modifier/M, var/silent = FALSE)
	M.expire(silent)

// Removes all modifiers of a type
/mob/living/proc/remove_modifiers_of_type(var/modifier_type, var/silent = FALSE)
	for(var/datum/modifier/M in modifiers)
		if(istype(M, modifier_type))
			M.expire(silent)

// Removes all modifiers, useful if the mob's being deleted
/mob/living/proc/remove_all_modifiers(var/silent = FALSE)
	for(var/datum/modifier/M in modifiers)
		M.expire(silent)

// Checks if the mob has a modifier type.
/mob/living/proc/has_modifier_of_type(var/modifier_type)
	for(var/datum/modifier/M in modifiers)
		if(istype(M, modifier_type))
			return TRUE
	return FALSE