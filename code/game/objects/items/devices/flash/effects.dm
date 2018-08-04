//Most of the things like charging and power supply were stolen from energy gun code.
/mob/proc/on_flash(var/mob/living/attacker, var/obj/weapon, var/severity = 1)
	//It is possible that can be no attacker (See: mounted flash)
	//Generate logs
	if(attacker.ckey && src.ckey) //Only give a shit if both the attacker and the src have a ckey
		admin_attack_log(attacker, src, "used a flash", "Was subjected to a flash", "used a flash on")

	if(isipc(src))
		return 0

	var/safety = 0

	if(ishuman(src))
		var/mob/living/carbon/human/as_human = src
		safety = as_human.eyecheck(TRUE)

		as_human.confused = max(as_human.confused,(8/2) * severity)

		if(isvaurca(src))
			as_human.druggy = max(as_human.druggy,(60/2) * severity)
			var/obj/item/organ/eyes/E = as_human.get_eyes()
			if(E && !(E.status & ORGAN_ROBOT))
				to_chat(src,"<span class='warning'>Your eyes burn with the intense light of the flash!</span>")
				E.take_damage(5 * severity)
			as_human.Weaken(10 * severity)

		if(is_diona(src))
			var/datum/dionastats/DS = as_human.get_dionastats()
			DS.stored_energy += 10*severity

	if(issilicon(src))
		var/mob/living/silicon/robot/as_robot = src
		if(as_robot.overclocked)
			return 0

		src.Weaken(7*severity)
		to_chat(src,"<span class='warning'>Your optical sensors are overloaded by the bright light!</span>")

	severity -= safety

	if(severity <= 0)
		return 0
	else if(severity >= 1)
		flick("e_flash", src.flash)
	else
		flick("flash", src.flash)

	return severity