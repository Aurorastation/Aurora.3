#define NOMINAL    0
#define FIRSTRUN   1
#define POWER      2
#define DAMAGE     3
#define IMAGE      4
#define WEAPONDOWN 5

/obj/mecha/combat/tank
	name = "light adhomian tank"
	desc = "The Ha'rron MK.IV light tank is an armored vehicle commonly used by tajaran military forces."
	icon = 'icons/mecha/mecha_64x64.dmi'
	icon_state = "tank"
	initial_icon = "tank"
	pixel_x = -16
	step_in = 5
	dir_in = 1
	health = 800
	deflect_chance = 20
	damage_absorption = list("brute"=0.4,"fire"=1.1,"bullet"=0.5,"laser"=0.8,"energy"=0.8,"bomb"=0.7)
	max_temperature = 30000
	force = 40
	w_class = 35
	infra_luminosity = 4
	wreckage = /obj/effect/decal/mecha_wreckage/tank
	stepsound = 'sound/mecha/tanktread.ogg'
	turnsound = 'sound/mecha/tanktread.ogg'

/obj/mecha/combat/tank/Initialize()
	.= ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster
	ME.attach(src)
	return

/obj/mecha/combat/tank/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air/cold(src)
	return internal_tank

/obj/mecha/combat/tank/Collide(var/atom/movable/AM)
	. = ..()
	if(!occupant)
		return
	if(isliving(AM))
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
			occupant.attack_log += text("\[[time_stamp()]\] <font color='red'>rammed[occupant.name] ([occupant.ckey]) rammed [H.name] ([H.ckey]) with the [src].</font>")
			msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
			src.visible_message("<span class='danger'>\The [src] smashes into \the [H]!</span>")
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			H.apply_damage(30, BRUTE)
			H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
			H.apply_effect(4, WEAKEN)
			return TRUE

		if(isanimal(AM))
			var/mob/living/simple_animal/C = AM
			if(issmall(C))
				src.visible_message("<span class='danger'>\The [src] runs over \the [C]!</span>")
				C.gib()
				return TRUE
			else
				src.visible_message("<span class='danger'>\The [src] smashes into \the [C]!</span>")
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				C.apply_damage(40, BRUTE)
				return TRUE

		else
			var/mob/living/L = AM
			src.visible_message("<span class='danger'>\The [src] smashes into \the [L]!</span>")
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
			L.apply_damage(30, BRUTE)
			return TRUE

	else
		AM.ex_act(2)

/obj/mecha/combat/tank/trample(var/mob/living/H)
	if(!occupant)
		return
	if(isliving(H))
		if(ishuman(H))
			var/mob/living/carbon/human/D = H
			if(D.lying)
				D.attack_log += "\[[time_stamp()]\]<font color='orange'> Was trampled by [src]</font>"
				occupant.attack_log += text("\[[time_stamp()]\] <font color='red'>rammed[occupant.name] ([occupant.ckey]) trampled [D.name] ([D.ckey]) with the [src].</font>")
				msg_admin_attack("[src] trampled [key_name(D)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[D.x];Y=[D.y];Z=[D.z]'>JMP</a>)" )
				src.visible_message("<span class='danger'>\The [src] runs over \the [D]!</span>")
				D.apply_effect(8, WEAKEN)
				D.apply_damage(60, BRUTE)
				return TRUE

		if(isanimal(H))
			var/mob/living/simple_animal/C = H
			if(issmall(C) || (C.stat == DEAD))
				src.visible_message("<span class='danger'>\The [src] runs over \the [C]!</span>")
				C.gib()
				return TRUE

		else
			var/mob/living/L = H
			src.visible_message("<span class='danger'>\The [src] runs over \the [L]!</span>")
			L.apply_damage(60, BRUTE)
			return TRUE

/obj/mecha/combat/tank/narrator_message(var/state)
	var/file
	switch(state)
		if(NOMINAL)
			file = 'sound/mecha/hatch-door-close.ogg'
		if(FIRSTRUN)
			file = 'sound/mecha/hatch-door-close.ogg'
		if(POWER)
			file = 'sound/mecha/lowpower.ogg'
		if(DAMAGE)
			file = 'sound/mecha/critdestr.ogg'
		if(WEAPONDOWN)
			file = 'sound/mecha/weapdestr.ogg'
		else

	playsound(src.loc, file, 100, 0, -6.6, environment=1)


/obj/mecha/combat/tank/jotun
	name = "Jotun"
	desc = "A heavy armored vehicle. Commonly produced by the Sol Alliance and fielded by the forces of the Tau Ceti Foreign Legion."
	icon = 'icons/mecha/mecha_114x59.dmi'
	icon_state = "jotun"
	initial_icon = "jotun"
	pixel_x = -41
	health = 950
	w_class = 45

/obj/mecha/combat/tank/jotun/Initialize()
	.= ..()

	var/obj/item/mecha_parts/mecha_equipment/ME
	if(equipment.len)//Now to remove it and equip anew.
		for(ME in equipment)
			ME.detach(src)
			qdel(ME)

	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster
	ME.attach(src)
	return

#undef NOMINAL
#undef FIRSTRUN
#undef POWER
#undef DAMAGE
#undef IMAGE
#undef WEAPONDOWN