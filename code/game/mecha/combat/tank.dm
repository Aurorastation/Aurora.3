/obj/mecha/combat/tank
	name = "light adhomian tank"
	desc = "The Ha'rron MK.IV light tank is an armored vehicle commonly used by tajaran military forces."
	icon = 'icons/mecha/mecha_large.dmi'
	icon_state = "tank"
	initial_icon = "tank"
	pixel_x = -16
	step_in = 5
	dir_in = 1
	health = 800
	deflect_chance = 60
	damage_absorption = list("brute"=0.4,"fire"=1.1,"bullet"=0.5,"laser"=0.8,"energy"=0.8,"bomb"=0.7)
	max_temperature = 30000
	force = 40
	w_class = 35
	infra_luminosity = 4
	wreckage = /obj/effect/decal/mecha_wreckage/tank
	stepsound = 'sound/mecha/tanktread.ogg'
	turnsound = 'sound/mecha/tanktread.ogg'

/obj/mecha/combat/tank/Collide(var/atom/movable/AM)
	. = ..()
	if(isliving(AM))
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
			msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
			H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
			H.apply_effect(4, WEAKEN)
			H.apply_damage(30, BRUTE)
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			src.visible_message("<span class='danger'>\The [src] smashes into \the [H]!</span>")
			return TRUE
		if(isanimal(AM))
			var/mob/living/simple_animal/C = AM
			if(issmall(C))
				C.gib()
				src.visible_message("<span class='danger'>\The [src] tramples \the [C]!</span>")
				return TRUE
			else
				C.apply_damage(40, BRUTE)
				src.visible_message("<span class='danger'>\The [src] smashes into \the [C]!</span>")
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				return TRUE

		else
			var/mob/living/L = AM
			L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
			L.apply_damage(30, BRUTE)
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			src.visible_message("<span class='danger'>\The [src] smashes into \the [L]!</span>")
			return TRUE

	else
		AM.ex_act(2)

/obj/mecha/combat/tank/trample(var/mob/living/H)
	if(isliving(H))
		if(ishuman(H))
			var/mob/living/carbon/human/D = H
			if(D.lying)
				D.attack_log += "\[[time_stamp()]\]<font color='orange'> Was trampled by [src]</font>"
				msg_admin_attack("[src] trampled [key_name(D)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[D.x];Y=[D.y];Z=[D.z]'>JMP</a>)" )
				D.apply_effect(8, WEAKEN)
				D.apply_damage(60, BRUTE)
				src.visible_message("<span class='danger'>\The [src] tramples \the [D]!</span>")
				return TRUE

		if(isanimal(H))
			var/mob/living/simple_animal/C = H
			if(issmall(C) || (C.stat == DEAD))
				src.visible_message("<span class='danger'>\The [src] tramples \the [C]!</span>")
				C.gib()
				return TRUE

		else
			var/mob/living/L = H
			L.apply_damage(60, BRUTE)
			src.visible_message("<span class='danger'>\The [src] tramples \the [L]!</span>")
			return TRUE

