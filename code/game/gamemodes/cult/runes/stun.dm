/datum/rune/stun
	name = "incapacitation rune"
	desc = "This rune is used to deafen, silence, flash and confuse the unbelievers in a radius around us. The talisman variant will be less effective against eye protection."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/stun/do_rune_action(mob/living/user, atom/movable/rune_object)
	do_stun(user, rune_object, 5, TRUE)

/datum/rune/stun/do_talisman_action(mob/living/user, atom/movable/rune_object)
	do_stun(user, rune_object, 3, FALSE)

/datum/rune/stun/proc/do_stun(mob/living/user, atom/movable/rune_object, radius, is_rune)
	user.say("Fuu ma'jin!")
	for(var/mob/living/rune_target in viewers(radius, get_turf(rune_object)))
		if(iscultist(rune_target))
			continue

		var/flash_intensity = is_rune ? FLASH_PROTECTION_MAJOR : FLASH_PROTECTION_MODERATE
		var/has_flashed = rune_target.flash_act(intensity = flash_intensity, affect_silicon = TRUE)
		if(has_flashed)
			to_chat(rune_target, SPAN_DANGER("You are blinded by a bright flash of light flaring from \the [rune_object]!"))
			if(iscarbon(rune_target))
				rune_target.stuttering = max(rune_target.stuttering, 1)
				rune_target.confused = 10
				if(is_rune)
					rune_target.Weaken(8)
					rune_target.Stun(8)
				else
					rune_target.Weaken(5)
					rune_target.Stun(5)
			else if(issilicon(rune_target))
				rune_target.Weaken(5)
		else
			to_chat(rune_target, SPAN_WARNING("You see a flash of light flaring from \the [rune_object], but your vision is shielded!"))

		rune_target.silent += 15
		admin_attack_log(user, rune_target, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")

	qdel(rune_object)
