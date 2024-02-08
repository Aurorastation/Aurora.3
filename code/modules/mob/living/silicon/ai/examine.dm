/mob/living/silicon/ai/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if (src.stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		. += "<span class='warning'>"
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				. += "It looks slightly dented.\n"
			else
				. += "<B>It looks severely dented!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				. += "It looks slightly charred.\n"
			else
				. += "<B>Its casing is melted and heat-warped!</B>\n"
		if (src.getOxyLoss() && (ai_restore_power_routine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(src.getOxyLoss() > 100)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				. += "It seems to be running on backup power.\n"

		if (src.stat == UNCONSCIOUS)
			. += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		. += "</span>"
	. += "*---------*"
	if(hardware && (hardware.owner == src))
		. += "<br>"
		. += hardware.get_examine_desc()
	user.showLaws(src)

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/abstract/observer/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
