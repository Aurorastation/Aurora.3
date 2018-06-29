//Most of the things like charging and power supply were stolen from energy gun code.
/mob/proc/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)
	//It is possible that can be no attacker (See: mounted flash)
	//Generate logs
	if(attacker.ckey && src.ckey) //Only give a shit if both the attacker and the src have a ckey
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashblinded with \the [weapon.name]  by [attacker.name] ([attacker.ckey]) with a severity of [severity].</font>")
		attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Used \the [weapon.name] to flashblind [src.name] ([src.ckey]) with a severity of [severity].</font>")
		msg_admin_attack("[attacker.name] ([attacker.ckey]) used \the [weapon.name] to flashblind [src.name] ([src.ckey]) with a severity of [severity]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[attacker.x];Y=[attacker.y];Z=[attacker.z]'>JMP</a>)",ckey=key_name(attacker),ckey_target=key_name(src))

/mob/living/carbon/human/on_flash(var/mob/living/attacker as mob, var/obj/weapon, var/severity = 1)
	. = ..()
	flick("flash", src.flash)


