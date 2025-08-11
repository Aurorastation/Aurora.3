// An edit of ablative armor, taken from Baystation12.
/datum/component/armor/synthetic
	full_block_message = "Your external plating absorbs the blow!"
	partial_block_message = "Your external plating dulls the blow!"

	/// Maximum armor values.
	var/list/max_armor_values
	/// How fast armor degrades with blocked damage, with armor value reduced by [coef * damage taken]
	var/armor_degradation_coef = 0.8
	/// Wearer feedback.
	var/list/last_reported_damage

/datum/component/armor/synthetic/Initialize(list/armor, armor_type, _armor_degradation_speed)
	. = ..()
	max_armor_values = armor_values.Copy()
	if(!isnull(_armor_degradation_speed))
		armor_degradation_coef = _armor_degradation_speed

/datum/component/armor/synthetic/on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)
	if (!(damage_type == DAMAGE_BRUTE || damage_type == DAMAGE_BURN))
		return
	if(armor_degradation_coef)
		var/key = get_armor_key(damage_type, damage_flags)
		var/damage_taken
		if(blocked)
			damage_taken = round(damage * blocked)
		else
			damage_taken = damage
		var/new_armor = max(0, get_value(key) - armor_degradation_coef * damage_taken)
		set_value(key, new_armor)
		var/mob/M = parent
		if(istype(M))
			var/list/visible = get_visible_damage()
			for(var/k in visible)
				if(LAZYACCESS(last_reported_damage, k) != visible[k])
					LAZYSET(last_reported_damage, k, visible[k])
					to_chat(M, SPAN_WARNING("Your external plating has [visible[k]] damage now!"))
					playsound(M, 'sound/effects/synth_armor_break.ogg', 50)

/datum/component/armor/synthetic/proc/get_damage()
	for(var/key in armor_values)
		var/damage = max_armor_values[key] - armor_values[key]
		if(damage > 0)
			LAZYSET(., key, damage)

/datum/component/armor/synthetic/proc/get_visible_damage()
	var/list/damages = get_damage()
	if(!LAZYLEN(damages))
		return
	var/result = list()
	for(var/key in damages)
		switch(round(100 * damages[key]/max_armor_values[key]))
			if(5 to 10)
				result[key] = "minor"
			if(11 to 25)
				result[key] = "moderate"
			if(26 to 50)
				result[key] = "serious"
			if(51 to 100)
				result[key] = "catastrophic"
	return result
