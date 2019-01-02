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
	desc = "A small mechanical trap thas is used to catch small animals like mice, lizards, chick and spiderlings."
	throwforce = 2
	force = 1
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1750)
	deployed = 0
	time_to_escape = 3 // Minutes
	var/breakout = FALSE
	var/last_shake = 0
	var/list/allowed_mobs = list(/mob/living/simple_animal/mouse, /mob/living/simple_animal/chick, /mob/living/simple_animal/lizard)
	var/release_time = 0
	var/list/resources = list(rods = 6)
	var/spider = TRUE
	health = 100

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
	if(world.time - release_time < 50) // If we just released the animal, not to let it get caught again right away
		return

	if(contents.len) // It is full
		return
	capture(AM)

/obj/item/weapon/trap/animal/proc/capture(var/mob/AM)
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
				deployed = 1
				update_icon()
				src.animate_shake()

	else if(istype(AM, /obj/effect/spider/spiderling) && spider) // for spiderlings
		var/obj/effect/spider/spiderling/S = AM
		S.forceMove(src)
		STOP_PROCESSING(SSprocessing, S)
		playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
		deployed = 1
		update_icon()
		src.animate_shake()

/obj/item/weapon/trap/animal/proc/req_breakout()
	if(!deployed)
		return 0 // Cage is open... wait, why are you in it's contents then?
	if(breakout)
		return -1 //Already breaking out.
	return 1

/obj/item/weapon/trap/animal/proc/breakout_callback(var/mob/living/escapee)
	if (QDELETED(escapee))
		return FALSE

	if ((world.time - last_shake) > 5 SECONDS)
		playsound(loc, "sound/effects/grillehit.ogg", 100, 1)
		animate_shake()
		last_shake = world.time

	return TRUE

// If we are stuck, and need to get out
/obj/item/weapon/trap/animal/proc/mob_breakout(var/mob/living/escapee)
	if (req_breakout() < 1)
		return

	escapee.next_move = world.time + 100
	escapee.last_special = world.time + 100
	to_chat(escapee, "<span class='warning'>You to shake and bump the lock of \the [src]. (this will take about [time_to_escape] minutes).</span>")
	visible_message("<span class='danger'>\The [src] begins to shake violently! Something is attempting to escape it!</span>")

	var/time = 360 * time_to_escape * 2
	breakout = TRUE

	if (!do_after(escapee, time, act_target = src, extra_checks = CALLBACK(src, .proc/breakout_callback, escapee)))
		breakout = FALSE
		return

	breakout = FALSE
	to_chat(escapee, "<span class='warning'>You successfully break out!</span>")
	visible_message("<span class='danger'>\the [escapee] successfully broke out of \the [src]!</span>")
	playsound(loc, "sound/effects/grillehit.ogg", 100, 1)
	if(!contents.len)
		return

	release()

/obj/item/weapon/trap/animal/Collide(AM as mob|obj)
	if(isliving(AM))
		Crossed(AM)
	else
		..()

/obj/item/weapon/trap/animal/CollidedWith(atom/AM)
	if(isliving(AM))
		Crossed(AM)
	else
		..()

/obj/item/weapon/trap/animal/verb/release_animal()
	set src in oview(1)
	set category = "Object"
	set name = "Release animal"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(!ishuman(usr))
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")
		return

	if(deployed)
		var/open = alert("Do you want to open the cage and free what is inside?",,"No","Yes")

		if(open == "No")
			return

		if(!can_use(usr))
			to_chat(usr, "<span class='warning'>You cannot use \the [src].</span>")
			return
		if(!contents.len)
			return

		var/turf/T_cage = get_turf(src)
		var/turf/T_user= get_turf(usr)

		if(!T_cage)
			attack_self(src)
			return

		var/turf/target = get_turf(locate(T_cage.x + (T_cage.x - T_user.x), T_cage.y + (T_cage.y - T_user.y), T_cage.z))
		if(!target)
			attack_self(src)
			return

		release(usr, target)

/obj/item/weapon/trap/animal/crush_act()
	for (var/atom/movable/A in src)
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.gib()
		else if(A.simulated)
			A.ex_act(1)
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/item/weapon/trap/animal/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		for (var/atom/movable/A as mob|obj in src)
			A.ex_act(severity + 1)
		new /obj/item/stack/material/steel(get_turf(src))
		qdel(src)

/obj/item/weapon/trap/animal/bullet_act(var/obj/item/projectile/Proj)
	for (var/atom/movable/A in src)
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.bullet_act(Proj)

/obj/item/weapon/trap/animal/proc/release(var/mob/user, var/turf/target)
	if(!target)
		target = src.loc
	if(user)
		visible_message("<span class='notice'>[user] opens \the [src].</span>")
	for(var/mob/living/L in contents)
		L.forceMove(target)
		visible_message("<span class='warning'>[L] runs out of \the [src].</span>")
		animate_shake()
		deployed = 0
		update_icon()
		src.animate_shake()
		release_time = world.time

	for(var/obj/effect/spider/spiderling/S in contents) // for spiderlings
		S.forceMove(target)
		START_PROCESSING(SSprocessing, S)
		visible_message("<span class='warning'>[S] jumps out of \the [src].</span>")
		animate_shake()
		deployed = 0
		update_icon()
		src.animate_shake()
		release_time = world.time

/obj/item/weapon/trap/animal/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers) && contents.len)
		var/mob/living/L = pick(contents)
		W.afterattack(L, user, TRUE)
	else if(iswelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		user.visible_message("<span class='notice'>[user] is trying to slice \the [src]!</span>",
							 "You are trying to slice \the [src]!")

		if (!do_after(user, 3 SECONDS, act_target = src))
			return
		if(WT.remove_fuel(0, user))
			user.visible_message("<span class='notice'>[user] is sliced \the [src]!</span>",
								 "You sliced \the [src]!")
			new /obj/item/stack/rods(src.loc, resources["rods"])
			if(resources.len == 2)
				new /obj/item/stack/material/steel(src.loc, resources["metal"])
			qdel(src)

	else if(istype(W, /obj/item/weapon/screwdriver))
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, "<span class='warning'>There is nothing to secure [src] to!</span>")
			return

		user.visible_message("<span class='notice'>[user] is trying to [anchored ? "un" : "" ]secure \the [src]!</span>",
							 "You are trying to [anchored ? "un" : "" ]secure \the [src]!")
		playsound(src.loc, "sound/items/[pick("Screwdriver", "Screwdriver2")].ogg", 50, 1)

		if (!do_after(user, 3 SECONDS, act_target = src))
			return
		density = !density
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							 "You have [anchored ? "" : "un" ]secured \the [src]!")

	else if(istype(W, /obj/item/weapon) && contents.len)
		var/mob/living/L = pick(contents)
		L.attackby(W, user)
	else
		..()

/obj/item/weapon/trap/animal/attack_hand(mob/user as mob)

	if (!user) return
	if(user.loc == src) // not to pick ourselves
		return

	if(anchored)
		to_chat(user, "<span class='warning'>\The [src] is achorned to the floor!</span>")
		return

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

/obj/item/weapon/trap/animal/MouseDrop(over_object, src_location, over_location)
	if(isliving(usr))
		if(usr.isMonkey() && (/mob/living/carbon/human/monkey in allowed_mobs)) // Because monkeys can be of type of just human.
			usr.visible_message("<span class='notice'>[usr] is attempting to enter \the [src] without triggering it to pass through.</span>",
							"<span class='notice'>You are attempting to enter \the [src] without triggering it to pass through. </span>"
			)
			if (!do_after(usr, 2 SECONDS, act_target = src))
				return
			if(prob(50)) // 50% chance to pass by without getting caught.
				usr.forceMove(src.loc)
				usr.visible_message("<span class='notice'>[usr] pass through \the [src] without triggering it.</span>",
								"<span class='notice'>You pass through \the [src] without triggering it.</span>"
				)
				return
			usr.forceMove(src)

			usr.visible_message("<span class='notice'>[usr] accidentally triggered \the [src]</span>",
							"<span class='notice'>You accidentally triggered \the [src]</span>"
			)
			playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
			deployed = 1
			update_icon()
			src.animate_shake()
			return
		for(var/f in allowed_mobs)
			if(istype(usr, f))
				usr.visible_message("<span class='notice'>[usr] is attempting to enter \the [src] without triggering it to pass through.</span>",
							"<span class='notice'>You are attempting to enter \the [src] without triggering it to pass through. </span>"
				)
				if (!do_after(usr, 2 SECONDS, act_target = src))
					return
				if(prob(50)) // 50% chance to pass by without getting caught.
					usr.forceMove(src.loc)
					usr.visible_message("<span class='notice'>[usr] pass through \the [src] without triggering it.</span>",
								"<span class='notice'>You pass through \the [src] without triggering it.</span>"
					)
					return
				usr.forceMove(src)

				usr.visible_message("<span class='notice'>[usr] accidentally triggered \the [src]</span>",
							"<span class='notice'>You accidentally triggered \the [src]</span>"
				)
				playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
				deployed = 1
				update_icon()
				src.animate_shake()
		if(iscarbon(usr))
			usr.visible_message("<span class='notice'>[usr] is attempting to enter \the [src] without triggering it to pass through.</span>",
							"<span class='notice'>You are attempting to enter \the [src] without triggering it to pass through. </span>"
			)
			if (!do_after(usr, 2 SECONDS, act_target = src))
				return
			usr.forceMove(src.loc)
			usr.visible_message("<span class='notice'>[usr] pass through \the [src] without triggering it.</span>",
								"<span class='notice'>You pass through \the [src] without triggering it.</span>"
			)
	else
		..()

/obj/item/weapon/trap/animal/attack_self(mob/user as mob)
	if(!can_use(user))
		to_chat(user, "<span class='warning'>You cannot use \the [src].</span>")
		return

	if(!contents.len)
		return

	release(user, user.loc)

/obj/item/weapon/trap/animal/attack(var/target, mob/living/user)
	if(world.time - release_time < 50) // If we just released the animal, not to let it get caught again right away
		return

	if(contents.len) // It is full
		return

	if(isliving(target))
		var/mob/living/M = target
		for(var/f in allowed_mobs)
			if(istype(M, f))
				user.visible_message(
								"<span class='warning'>[user] traps [M] inside of \the [src].</span>",
								"<span class='warning'>You trap [M] inside of the \the [src]!</span>",
								"<b>You hear a loud metallic snap!</b>"
								)
				M.forceMove(src)
				playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
				deployed = 1
				update_icon()
				src.animate_shake()

	else if(istype(target, /obj/effect/spider/spiderling) && spider) // for spiderlings
		var/obj/effect/spider/spiderling/S = target
		S.forceMove(src)
		STOP_PROCESSING(SSprocessing, S)
		playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
		deployed = 1
		update_icon()
		src.animate_shake()
	else
		..()

/obj/item/weapon/trap/animal/medium
	name = "medium trap"
	desc = "A medium mechanical trap thas is used to catch medium size animals like cat, corgi, diyaab, monkey, yithian, pengiuns, chicken, nymph. Sometimes even maintainence drones, spiderbots and PAi."
	icon_base = "medium"
	icon_state = "medium0"
	throwforce = 4
	force = 5
	w_class = 4
	origin_tech = list(TECH_MATERIAL = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5750)
	deployed = 0
	resources = list(rods = 12)
	spider = FALSE

/obj/item/weapon/trap/animal/medium/Initialize()
	allowed_mobs = list(
						/mob/living/simple_animal/cat, /mob/living/simple_animal/corgi, /mob/living/simple_animal/hostile/diyaab, /mob/living/carbon/human/monkey, /mob/living/simple_animal/penguin, /mob/living/simple_animal/crab,
						/mob/living/simple_animal/chicken, /mob/living/simple_animal/yithian, /mob/living/carbon/alien/diona, /mob/living/silicon/robot/drone, /mob/living/silicon/pai,
						/mob/living/simple_animal/spiderbot, /mob/living/simple_animal/hostile/tree)

/obj/item/weapon/trap/animal/large
	name = "large trap"
	desc = "A large mechanical trap thas is used to catch medium size animals like dog, spider, carp, goat, cow, shark, fox, bear, cavern dwellers, and other kinds of Xenomorphs."
	icon_base = "large"
	icon_state = "large0"
	throwforce = 6
	force = 10
	w_class = 6
	density = 1
	origin_tech = list(TECH_MATERIAL = 4)
	matter = list(DEFAULT_WALL_MATERIAL = 15750)
	deployed = 0
	resources = list(rods = 12, metal = 4)
	spider = FALSE

/obj/item/weapon/trap/animal/large/Initialize()
	allowed_mobs = list(
						/mob/living/simple_animal/hostile/retaliate/goat, /mob/living/simple_animal/cow, /mob/living/simple_animal/corgi/fox,
						/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/alien, /mob/living/simple_animal/hostile/giant_spider,
						/mob/living/simple_animal/hostile/commanded/dog, /mob/living/simple_animal/hostile/retaliate/cavern_dweller, /mob/living/carbon/human/)

/obj/item/weapon/trap/animal/large/attack_hand(mob/user as mob)
	return

/obj/item/weapon/trap/animal/large/attackby(obj/item/W as obj, mob/user as mob)
	if(iswrench(W))
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, "<span class='warning'>There is nothing to secure [src] to!</span>")
			return

		user.visible_message("<span class='notice'>[user] is trying to [anchored ? "un" : "" ]secure \the [src]!</span>",
							  "You are trying to [anchored ? "un" : "" ]secure \the [src]!")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)

		if (!do_after(user, 3 SECONDS, act_target = src))
			return

		anchored = !anchored
		user.visible_message("<span class='notice'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
	else if(istype(W, /obj/item/weapon/screwdriver))
		return
	else
		..()

/obj/item/weapon/trap/animal/large/MouseDrop(over_object, src_location, over_location)
	if(isliving(usr) && ishuman(usr))
		usr.visible_message("<span class='notice'>[usr] is attempting to enter \the [src] without triggering it to pass through.</span>",
							"<span class='notice'>You are attempting to enter \the [src] without triggering it to pass through. </span>"
		)
		if (!do_after(usr, 2 SECONDS, act_target = src))
			return
		if(usr.a_intent == I_HELP || (usr.a_intent != I_HURT && prob(50))) // 50% chance to pass by without getting caught on disarm, drag, 100% on help. Harm will get you caught.
			usr.forceMove(src.loc)
			usr.visible_message("<span class='notice'>[usr] pass through \the [src] without triggering it.</span>",
								"<span class='notice'>You pass through \the [src] without triggering it.</span>"
			)
			return
		usr.forceMove(src)

		usr.visible_message("<span class='notice'>[usr] accidentally triggered \the [src]</span>",
							"<span class='notice'>You accidentally triggered \the [src]</span>"
		)
		playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
		deployed = 1
		update_icon()
		src.animate_shake()
	else
		..()

/obj/item/weapon/large_trap_foundation
	name = "large trap foundation"
	desc = "A metal foundation for large trap, it is missing metals rods to hold the prey."
	icon_state = "large_foundation"
	icon = 'icons/obj/items.dmi'
	throwforce = 4
	force = 5
	w_class = 5

/obj/item/weapon/large_trap_foundation/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/O = W
		if(O.get_amount() >= 12)

			to_chat(user, "<span class='notice'>You are trying to add metal bars to \the [src].</span>")

			if (!do_after(user, 2 SECONDS, act_target = src))
				return

			to_chat(user, "<span class='notice'>You add metal bars to \the [src].</span>")
			O.use(12)
			new /obj/item/weapon/trap/animal/large(src.loc)
			qdel(src)
			return
		else
			to_chat(user, "<span class='warning'>You need at least 12 rods to complete \the [src].</span>")
	else if(istype(W, /obj/item/weapon/screwdriver))
		return
	else
		..()

