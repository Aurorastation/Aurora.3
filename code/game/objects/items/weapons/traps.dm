/obj/item/weapon/trap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	var/icon_base = "beartrap"
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	var/deployed = 0
	var/time_to_escape = 60

/obj/item/weapon/trap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/trap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1

/obj/item/weapon/trap/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob && can_use(user))
		user.visible_message(
			"<span class='notice'>\The [user] begins freeing \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)
		if(do_after(user, time_to_escape))
			user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
			unbuckle_mob()
			anchored = 0

/obj/item/weapon/trap/attack_hand(mob/user as mob)
	if(buckled_mob && can_use(user))
		user.visible_message(
			"<span class='notice'>[user] begins freeing [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free [buckled_mob] from \the [src].</span>"
			)
		if(do_after(user, time_to_escape))
			user.visible_message("<span class='notice'>[buckled_mob] has been freed from \the [src] by [user].</span>")
			unbuckle_mob()
			anchored = 0
	else if(deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to disarm \the [src].</span>",
			"<span class='notice'>You begin disarming \the [src]!</span>",
			"You hear a latch click followed by the slow creaking of a spring."
			)
		if(do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has disarmed \the [src].</span>",
				"<span class='notice'>You have disarmed \the [src]!</span>"
				)
			deployed = 0
			anchored = 0
			update_icon()
	else
		..()

/obj/item/weapon/trap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_foot", "r_foot", "l_leg", "r_leg")

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	if(blocked >= 100)
		return

	var/success = L.apply_damage(30, BRUTE, target_zone, blocked, src)
	if(!success)
		return 0

	//trap the victim in place
	set_dir(L.dir)
	can_buckle = 1
	buckle_mob(L)
	L << "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>"
	deployed = 0
	can_buckle = initial(can_buckle)
	playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)//Really loud snapping sound

	if (istype(L, /mob/living/simple_animal/hostile/bear))
		var/mob/living/simple_animal/hostile/bear/bear = L
		bear.anger += 15//traps make bears really angry
		bear.instant_aggro()

/obj/item/weapon/trap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		L.visible_message(
			"<span class='danger'>[L] steps on \the [src].</span>",
			"<span class='danger'>You step on \the [src]!</span>",
			"<b>You hear a loud metallic snap!</b>"
			)
		attack_mob(L)
		if(!buckled_mob)
			anchored = 0
		deployed = 0
		update_icon()
	..()


/obj/item/weapon/trap/update_icon()
	icon_state = "[icon_base][deployed]"

/obj/item/weapon/trap/animal
	name = "small trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_base = "small"
	icon_state = "small0"
	desc = "A small mechanical trap thas is used to catch small animals like mice and spiderlings."
	throwforce = 2
	force = 1
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1750)
	deployed = 0
	time_to_escape = 60
	var/list/allowed_mobs = list(/mob/living/simple_animal/mouse)

/obj/item/weapon/trap/animal/examine(mob/user)
	..()
	if(contents.len && isliving(contents[1]))
		var/message = "<span class='notice'>\The [src] has [contents[1].name] and it is "
		if(contents[1].stat == DEAD)
			message += "<span class='danger'>dead</span>"
		else if(contents[1].stat == UNCONSCIOUS)
			message += "<span class='warning'>unconscious</span>"
		else if((contents[1].maxHealth / contents[1].health) == 1)
			message += "<span class='good'>healthy</span>"
		else
			message += "<span class='warning'>wounded</span>"
		message += ".</span>"
		to_chat(user, message)
	else if(contents.len) // spiderling
		to_chat(user, "<span class='notice'>\The [src] has [contents[1].name] and it is alive.</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")

/obj/item/weapon/trap/animal/Crossed(AM as mob|obj)
	if(contents.len) // It is full
		return

	if(isliving(AM))
		var/mob/living/L = AM
		for(var/f in allowed_mobs)
			if(istype(AM, f))
				L.visible_message(
					"<span class='danger'>[L] enters \the [src], and it snaps shut with a clatter!</span>",
					"<span class='danger'>You enters \the [src], and it snaps shut with a clatter!</span>",
					"<b>You hear a loud metallic snap!</b>"
					)
				L.forceMove(src)
				playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
				animate_shake()
				deployed = 1
				update_icon()
	else if(istype(AM, /obj/effect/spider/spiderling)) // for spiderlings
		var/obj/effect/spider/spiderling/S = AM
		S.forceMove(src)
		STOP_PROCESSING(SSprocessing, S)
		playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
		animate_shake()
		deployed = 1
		update_icon()


/obj/item/weapon/trap/animal/attack_hand(mob/user as mob)
	if (!user) return
	if (hasorgans(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (user.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			user << "<span class='notice'>You try to move your [temp.name], but cannot!</span>"
			return
		if(!temp)
			user << "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>"
			return
	src.pickup(user)
	if (istype(src.loc, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = src.loc
		S.remove_from_storage(src)

	src.throwing = 0
	if (src.loc == user)
		if(!user.prepare_for_slotmove(src))
			return
	else if(isliving(src.loc))
		return

	// If equipping onto active hand fails, drop it on the floor.
	if (!user.put_in_active_hand(src))
		forceMove(user.loc)
	return

/obj/item/weapon/trap/animal/attack_self(mob/user as mob)
	if(!can_use(user))
		to_chat(user, "<span class='warning'>You cannot use \the [src].</span>")
		return
	if(!contents.len)
		return

	visible_message("<span class='notice'>[user] opens \the [src].</span>")
	for(var/mob/living/L in contents)
		L.forceMove(user.loc)
		visible_message("<span class='warning'>[L] runs out of \the [src].</span>")
		animate_shake()
		deployed = 0
		update_icon()

	for(var/obj/effect/spider/spiderling/S in contents) // for spiderlings
		S.forceMove(user.loc)
		START_PROCESSING(SSprocessing, S)
		visible_message("<span class='warning'>[S] jumps out of \the [src].</span>")
		animate_shake()
		deployed = 0
		update_icon()

/obj/item/weapon/trap/animal/attack(mob/living/M, mob/living/user)
	if(contents.len) // It is full
		return
	user.visible_message(
					"<span class='warning'>[user] traps [M] inside of \the [src].</span>",
					"<span class='warning'>You trap [M] inside of the \the [src]!</span>",
					"<b>You hear a loud metallic snap!</b>"
					)
	M.forceMove(src)
	playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
	animate_shake()
	deployed = 1
	update_icon()

/obj/item/weapon/trap/animal/medium
	name = "medium trap"
	icon_base = "small"
	desc = "A medium mechanical trap thas is used to catch small animals like "
	icon_base = "beartrap"
	icon_state = "beartrap0"
	throwforce = 3
	force = 2
	w_class = 4
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 5750)
	deployed = 0
	time_to_escape = 60

/obj/item/weapon/trap/animal/medium/Initialize()
	allowed_mobs = list(
						/mob/living/simple_animal/cat, /mob/living/simple_animal/hostile/diyaab, /mob/living/carbon/human/monkey, /mob/living/simple_animal/yithian,
						/mob/living/carbon/alien/diona, /mob/living/silicon/robot/drone, /mob/living/silicon/pai)
	var/i = 1
	var/mob/living/L
	while(i != allowed_mobs.len)
		L = new (allowed_mobs[i])
		desc += "[L.name] "
		i++
	L = allowed_mobs[i + 1]
	desc += "[L.name]."
