//Most of the things like charging and power supply were stolen from energy gun code.
/mob/proc/on_flash(var/mob/living/attacker, var/obj/weapon, var/severity = 1)
	//It is possible that can be no attacker (See: mounted flash)
	//Generate logs
	if(attacker.ckey && src.ckey) //Only give a shit if both the attacker and the src have a ckey
		admin_attack_log(attacker, src, "used a flash", "Was subjected to a flash", "used a flash on")

	return severity

/mob/living/carbon/human/on_flash(var/mob/living/attacker, var/obj/weapon, var/severity = 1)

	. = ..()

	var/safety = src.eyecheck(TRUE)
	severity -= safety

	if(severity <= 0)
		return 0
	else if(severity >= 1)
		flick("e_flash", src.flash)
	else
		flick("flash", src.flash)

	src.confused = max(src.confused,(8/2) * severity)

	if(isvaurca(src)) //I fucking hate using this, but until vaurca aren't different types, this will have to do
		src.druggy = max(src.druggy,(60/2) * severity)
		var/obj/item/organ/eyes/E = src.get_eyes()
		if(E && !(E.status & ORGAN_ROBOT))
			to_chat(src,"<span class='warning'>Your eyes burn with the intense light of the flash!</span>")
			E.take_damage(5 * severity)
		src.Weaken(10 * severity)

	return severity

/mob/living/carbon/human/diona/on_flash(var/mob/living/attacker, var/obj/weapon, var/severity = 1)
	. = ..()
	//Dionaea Gestalt
	var/datum/dionastats/DS = src.get_dionastats()
	DS.stored_energy += 10*severity

	return severity

/mob/living/silicon/robot/on_flash(var/mob/living/attacker, var/obj/weapon, var/severity = 1)
	. = ..()
	if(overclocked || severity <= 0)
		return 0



	if(severity >= 1)
		flick("e_flash", src.flash)
	else
		flick("flash", src.flash)

	src.Weaken(7*severity)
	to_chat(src,"<span class='warning'>Your optical sensors are overloaded by the bright light!</span>")


	return severity