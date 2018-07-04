//Most of the things like charging and power supply were stolen from energy gun code.
/mob/proc/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)
	//It is possible that can be no attacker (See: mounted flash)
	//Generate logs
	if(attacker.ckey && src.ckey) //Only give a shit if both the attacker and the src have a ckey
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashblinded with \the [weapon.name]  by [attacker.name] ([attacker.ckey]) with a severity of [severity].</font>")
		attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Used \the [weapon.name] to flashblind [src.name] ([src.ckey]) with a severity of [severity].</font>")
		msg_admin_attack("[attacker.name] ([attacker.ckey]) used \the [weapon.name] to flashblind [src.name] ([src.ckey]) with a severity of [severity]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[attacker.x];Y=[attacker.y];Z=[attacker.z]'>JMP</a>)",ckey=key_name(attacker),ckey_target=key_name(src))

	return severity

/mob/living/carbon/human/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)

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
		if(E)
			E.damage += 5 * severity
			to_chat(src,"<span class='warning'>Your eyes burn with the intense light of the flash!</span>")
		src.Weaken(10 * severity)

	return severity

/mob/living/carbon/human/diona/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)
	. = ..()
	//Dionaea Gestalt
	var/datum/dionastats/DS = src.get_dionastats()
	DS.stored_energy += 10*severity

	return severity

/mob/living/silicon/robot/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)
	. = ..()
	if(overclocked || severity <= 0)
		return 0
	else if(severity >= 1)
		flick("e_flash", src.flash)
	else
		flick("flash", src.flash)

	src.Weaken(7*severity)

	return severity