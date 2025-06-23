/mob/living/silicon/ai/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if (src.stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		var/ai_status_desc
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				ai_status_desc += "It looks slightly dented."
			else
				ai_status_desc += "<B>It looks severely dented!</B>"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				ai_status_desc += "It looks slightly charred."
			else
				ai_status_desc += "<B>Its casing is melted and heat-warped!</B>"
		if (src.getOxyLoss() && (ai_restore_power_routine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				ai_status_desc += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>"
			else if(src.getOxyLoss() > 100)
				ai_status_desc += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>"
			else
				ai_status_desc += "It seems to be running on backup power."

		if (src.stat == UNCONSCIOUS)
			ai_status_desc += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\"."
		. += SPAN_WARNING(ai_status_desc)

	if(hardware && (hardware.owner == src))
		. += "<br>"
		. += hardware.get_examine_desc()

	. += user.examine_laws(src)

/mob/proc/examine_laws(var/mob/living/silicon/S)
	return

/mob/abstract/ghost/observer/examine_laws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		return S.laws.get_laws(src)
