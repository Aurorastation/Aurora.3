/obj/item/trap
	name = "mechanical trap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/item/traps.dmi'
	var/icon_base = "beartrap"
	icon_state = "beartrap0"
	randpixel = 0
	center_of_mass = null
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	var/deployed = FALSE
	var/time_to_escape = 60
	var/activated_armor_penetration = 0

/obj/item/trap/Initialize()
	. = ..()
	update_icon()

/obj/item/trap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/trap/attack_self(mob/user)
	..()
	if(!deployed && can_use(user))
		if(deploy(user))
			user.drop_from_inventory(src)
			anchored = TRUE

/obj/item/trap/proc/deploy(mob/user)
	user.visible_message(
		SPAN_WARNING("\The [user] starts to deploy \the [src]."),
		SPAN_WARNING("You begin deploying \the [src]!"),
		SPAN_WARNING("You hear the slow creaking of a spring.")
		)

	if(do_after(user, 5 SECONDS))
		user.visible_message(
			SPAN_WARNING("\The [user] deploys \the [src]."),
			SPAN_WARNING("You deploy \the [src]!"),
			SPAN_WARNING("You hear a latch click loudly.")
			)

		deployed = TRUE
		update_icon()
		return TRUE
	return FALSE

/obj/item/trap/user_unbuckle(mob/user)
	if(buckled && can_use(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins freeing \the [buckled] from \the [src]..."),
			SPAN_NOTICE("You carefully begin to free \the [buckled] from \the [src]..."),
			SPAN_NOTICE("You hear metal creaking.")
			)
		if(do_after(user, time_to_escape))
			user.visible_message(
				SPAN_NOTICE("\The [user] frees \the [buckled] from \the [src]."),
				SPAN_NOTICE("You free \the [buckled] from \the [src].")
				)
			unbuckle()
			anchored = FALSE

/obj/item/trap/attack_hand(mob/user)
	if(can_use(user))
		if(buckled)
			user_unbuckle(user)
			return
		else if(deployed)
			disarm_trap(user)
			return
	..()

/obj/item/trap/proc/disarm_trap(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] starts to disarm \the [src]..."), SPAN_NOTICE("You begin disarming \the [src]..."), SPAN_WARNING("You hear a latch click followed by the slow creaking of a spring."))
	if(do_after(user, 6 SECONDS))
		user.visible_message(SPAN_NOTICE("\The [user] disarms \the [src]!"), SPAN_NOTICE("You disarm \the [src]!"))
		deployed = FALSE
		anchored = FALSE
		update_icon()

/obj/item/trap/proc/attack_mob(mob/living/L)
	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	var/success = L.apply_damage(30, BRUTE, target_zone, used_weapon = src, armor_pen = activated_armor_penetration)
	if(!success)
		return FALSE

	L.visible_message(SPAN_DANGER("\The [L] steps on \the [src]!"), FONT_LARGE(SPAN_DANGER("You step on \the [src]!")), SPAN_WARNING("<b>You hear a loud metallic snap!</b>"))

	var/did_trap = TRUE
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/external/limb = H.get_organ(check_zone(target_zone))
		if(!limb || limb.is_stump()) // oops, we took the limb clean off
			did_trap = FALSE

	if(did_trap)
		//trap the victim in place
		can_buckle = list(/mob/living)
		buckle(L)
		can_buckle = initial(can_buckle)

	deployed = FALSE
	to_chat(L, FONT_LARGE(SPAN_DANGER("The steel jaws of \the [src] bite into you, [did_trap ? "trapping you in place" : "cleaving your limb clean off"]!")))
	playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, TRUE) //Really loud snapping sound

	if (istype(L, /mob/living/simple_animal/hostile/bear))
		var/mob/living/simple_animal/hostile/bear/bear = L
		bear.anger += 15//traps make bears really angry
		bear.instant_aggro()

	if(!buckled)
		anchored = FALSE
		deployed = FALSE

/obj/item/trap/Crossed(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.shoes?.item_flags & LIGHTSTEP)
			return
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		attack_mob(L)
		update_icon()
		shake_animation()

/obj/item/trap/update_icon()
	icon_state = "[icon_base][deployed]"

/obj/item/trap/sharpened
	name = "sharpened mechanical trap"
	desc_antag = "This device has an even higher chance of penetrating armor and locking foes in place."
	activated_armor_penetration = 100

/obj/item/trap/animal
	name = "small trap"
	desc = "A small mechanical trap that's used to catch small animals like rats, lizards, and chicks."
	icon_base = "small"
	icon_state = "small0"
	throwforce = 2
	force = 1
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1750)
	deployed = FALSE
	time_to_escape = 3 // Minutes
	can_buckle = list(/mob/living)
	var/breakout = FALSE
	var/last_shake = 0
	var/list/allowed_mobs = list(/mob/living/simple_animal/rat, /mob/living/simple_animal/chick, /mob/living/simple_animal/lizard)
	var/release_time = 0
	var/list/resources = list(rods = 6)
	var/spider = TRUE
	health = 100
	var/datum/weakref/captured = null

/obj/item/trap/animal/MouseDrop_T(mob/living/M, mob/living/user)
	if(!istype(M))
		return

	if(!captured)
		if(!is_type_in_list(M, allowed_mobs))
			to_chat(user, SPAN_WARNING("[M] won't fit in there!"))
		else if(do_after(user, 5 SECONDS))
			capture(M)
	else
		to_chat(user, "<span class='warning'>\The [src] is already full!</span>")

/obj/item/trap/animal/update_icon()
	icon_state = "[icon_base][deployed]"

/obj/item/trap/animal/examine(mob/user)
	..()
	if(captured)
		var/datum/L = captured.resolve()
		if (L)
			to_chat(user, "<span class='warning'>[L] is trapped inside!</span>")
			return
	else if(deployed)
		to_chat(user, SPAN_WARNING("It's set up and ready to capture something."))
	else
		to_chat(user, "<span class='notice'>\The [src] is empty and un-deployed.</span>")

/obj/item/trap/animal/Crossed(atom/movable/AM)
	if(!deployed || !anchored)
		return

	if(captured) // just in case but this shouldn't happen
		return

	capture(AM)

/obj/item/trap/animal/proc/capture(var/mob/AM, var/msg = 1)
	if(isliving(AM) && is_type_in_list(AM, allowed_mobs))
		var/mob/living/L = AM
		if(msg)
			L.visible_message(
				"<span class='danger'>[L] enters \the [src], and it snaps shut with a clatter!</span>",
				"<span class='danger'>You enter \the [src], and it snaps shut with a clatter!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
		if(AM.loc != loc)
			AM.forceMove(loc)
		captured = WEAKREF(L)
		buckle(L)
		layer = L.layer + 0.1
		playsound(src, 'sound/weapons/beartrap_shut.ogg', 100, 1)
		deployed = FALSE
		src.shake_animation()
		update_icon()

/obj/item/trap/animal/proc/req_breakout()
	if(deployed || !captured)
		return 0 // Trap-door is open, no one is captured.
	if(breakout)
		return -1 //Already breaking out.
	return 1

/obj/item/trap/animal/proc/breakout_callback(var/mob/living/escapee)
	if (QDELETED(escapee))
		return FALSE

	if ((world.time - last_shake) > 5 SECONDS)
		playsound(loc, "sound/effects/grillehit.ogg", 100, 1)
		shake_animation()
		last_shake = world.time

	return TRUE

// If we are stuck, and need to get out
/obj/item/trap/animal/user_unbuckle(var/mob/living/escapee)
	if (req_breakout() < 1)
		return

	escapee.next_move = world.time + 100
	escapee.last_special = world.time + 100
	to_chat(escapee, "<span class='warning'>You begin to shake and bump the lock of \the [src]. (this will take about [time_to_escape] minutes).</span>")
	visible_message("<span class='danger'>\The [src] begins to shake violently! Something is attempting to escape it!</span>")

	var/time = 360 * time_to_escape * 2
	breakout = TRUE

	if (!do_after(escapee, time, act_target = src, extra_checks = CALLBACK(src, .proc/breakout_callback, escapee)))
		breakout = FALSE
		return

	breakout = FALSE
	to_chat(escapee, "<span class='warning'>You successfully break out!</span>")
	visible_message("<span class='danger'>\The [escapee] successfully breaks out of \the [src]!</span>")
	playsound(loc, "sound/effects/grillehit.ogg", 100, 1)

	release()

/obj/item/trap/animal/CollidedWith(atom/AM)
	if(deployed && is_type_in_list(AM, allowed_mobs))
		Crossed(AM)
	else
		..()

/obj/item/trap/animal/verb/release_animal()
	set src in orange(1)
	set category = "Object"
	set name = "Release animal"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(!ishuman(usr))
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")
		return

	var/datum/M = captured ? captured.resolve() : null

	if(M)
		var/open = alert("Do you want to open the cage and free \the [M]?",,"No","Yes")

		if(open == "No")
			return

		if(!can_use(usr))
			to_chat(usr, "<span class='warning'>You cannot use \the [src].</span>")
			return

		if(usr == M)
			to_chat(usr, "<span class='warning'>You can't open \the [src] from the inside! You'll need to force it open.</span>")
			return

		var/adj = src.Adjacent(usr)
		if(!adj)
			attack_self(src)
			return

		release(usr)

/obj/item/trap/animal/crush_act()
	if(captured)
		var/datum/L = captured ? captured.resolve() : null
		if(L && isliving(L))
			var/mob/living/LL = L
			LL.gib()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/item/trap/animal/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		if(captured)
			release()
		new /obj/item/stack/material/steel(get_turf(src))
		qdel(src)

/obj/item/trap/animal/bullet_act(var/obj/item/projectile/Proj)
	for (var/atom/movable/A in src)
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.bullet_act(Proj)

/obj/item/trap/animal/proc/release(var/mob/user, var/turf/target)
	if(!target)
		target = src.loc
	if(user)
		visible_message("<span class='notice'>[user] opens \the [src].</span>")

	var/datum/L = captured ? captured.resolve() : null
	if (!L)
		captured = null
		release_time = world.time
		return

	var/msg
	if (isliving(L))
		var/mob/living/ll = L
		msg = "<span class='warning'>[ll] runs out of \the [src].</span>"

	unbuckle()
	captured = null
	visible_message(msg)
	shake_animation()
	update_icon()
	release_time = world.time
	layer = initial(layer)

/obj/item/trap/animal/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/M = G.affecting

		if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
			to_chat(user, SPAN_NOTICE("You need a better grip on \the [M]!"))
			return

		user.visible_message("<span class='notice'>[user] starts putting [M] into \the [src].</span>", "<span class='notice'>You start putting [M] into \the [src].</span>")

		if (!is_type_in_list(M, allowed_mobs))
			to_chat(user, SPAN_WARNING("[M] won't fit in there!"))
			return

		if (do_mob(user, M, 3 SECONDS, needhand = 0))
			if(captured?.resolve())
				return
			capture(M)

	else if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] is off!"))
			return
		user.visible_message("<span class='notice'>[user] is trying to slice \the [src] open!</span>",
							 "<span class='notice'>You are trying to slice \the [src] open!</span>")

		if(WT.use_tool(src, user, 60, volume = 50))
			if(WT.use(2, user))
				user.visible_message("<span class='notice'>[user] slices \the [src] open!</span>",
									"<span class='notice'>You slice \the [src] open!</span>")
				new /obj/item/stack/rods(src.loc, resources["rods"])
				if(resources.len == 2)
					new /obj/item/stack/material/steel(src.loc, resources["metal"])
				release(user)
				qdel(src)

	else if(W.isscrewdriver())
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, "<span class='warning'>There is nothing to secure [src] to!</span>")
			return

		user.visible_message("<span class='notice'>[user] is trying to [anchored ? "un" : "" ]secure \the [src]!</span>",
							 "<span class='notice'>You are trying to [anchored ? "un" : "" ]secure \the [src]!</span>")
		playsound(src.loc, "sound/items/[pick("Screwdriver", "Screwdriver2")].ogg", 50, 1)

		if(W.use_tool(src, user, 30, volume = 50))
			density = !density
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "" : "un" ]secures \the [src]!</span>",
								"<span class='notice'>You [anchored ? "" : "un" ]secure \the [src]!</span>")
	else
		..()

/obj/item/trap/animal/Move()
	..()
	if(captured)
		var/datum/M = captured.resolve()
		if(isliving(M))
			var/mob/living/L = M
			if(L && buckled.buckled_to == src)
				L.forceMove(loc)
			else if(L)
				captured = null
		else
			captured = null

/obj/item/trap/animal/attack_hand(mob/user)
	if(user.loc == src || captured)
		return

	if(anchored && deployed)
		to_chat(user, SPAN_NOTICE("\The [src] is already anchored and set!"))
	else if(anchored)
		deploy(user)
	else
		..()

/obj/item/trap/animal/proc/pass_without_trace(mob/user, pct = 100)
	if(!is_type_in_list(user, allowed_mobs))
		user.forceMove(loc)
		user.visible_message("<span class='notice'>[user] passes over \the [src] without triggering it.</span>",
						"<span class='notice'>You pass over \the [src] without triggering it.</span>"
		)
	else
		user.visible_message("<span class='notice'>[user] attempts to pass through \the [src] without triggering it.</span>",
							"<span class='notice'>You attempt to pass through \the [src] without triggering it. </span>"
		)
		if(do_after(user, 2 SECONDS, act_target = src))
			if(prob(pct))
				user.forceMove(loc)
				user.visible_message("<span class='notice'>[user] passes through \the [src] without triggering it.</span>",
								"<span class='notice'>You pass through \the [src] without triggering it.</span>"
				)
			else
				user.forceMove(loc)
				user.visible_message("<span class='warning'>[user] accidentally triggers \the [src]!</span>",
								"<span class='warning'>You accidentally trigger \the [src]!</span>"
				)
				capture(user)

/obj/item/trap/animal/MouseDrop(over_object, src_location, over_location)
	if(!isliving(usr) || !src.Adjacent(usr))
		return

	if(captured)
		pass_without_trace(usr) // It's full

	if((usr.isMonkey() && (/mob/living/carbon/human/monkey in allowed_mobs)) || is_type_in_list(usr, allowed_mobs)) // Because monkeys can be of type of just human.
		pass_without_trace(usr, 50)
		return

	else if(iscarbon(usr))
		pass_without_trace(usr)

	else
		..()

/obj/item/trap/animal/attack_self(mob/user)
	if(!can_use(user))
		to_chat(user, "<span class='warning'>You cannot use \the [src].</span>")
		return

	if(captured)
		release(user, user.loc)

/obj/item/trap/animal/attack(var/target, mob/living/user)
	if(!deployed)
		return

	if(captured) // It is full
		return

	if(isliving(target))
		var/mob/living/M = target
		if(is_type_in_list(M, allowed_mobs))
			user.visible_message(
							"<span class='warning'>[user] traps [M] inside of \the [src].</span>",
							"<span class='warning'>You trap [M] inside of the \the [src]!</span>",
							"<b>You hear a loud metallic snap!</b>"
							)
			capture(M, msg = 0)
	else
		..()

/obj/item/trap/animal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/item/trap/animal/medium
	name = "medium trap"
	desc = "A medium mechanical trap that is used to catch moderately-sized animals like cats, monkeys, nymphs, and wayward maintenance drones."
	icon_base = "medium"
	icon_state = "medium0"
	throwforce = 4
	force = 5
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5750)
	deployed = FALSE
	resources = list(rods = 12)
	spider = FALSE

/obj/item/trap/animal/medium/Initialize()
	. = ..()
	allowed_mobs = list(
						/mob/living/simple_animal/cat, /mob/living/simple_animal/corgi, /mob/living/simple_animal/hostile/retaliate/diyaab, /mob/living/carbon/human/monkey, /mob/living/simple_animal/penguin, /mob/living/simple_animal/crab,
						/mob/living/simple_animal/chicken, /mob/living/simple_animal/yithian, /mob/living/carbon/alien/diona, /mob/living/silicon/robot/drone, /mob/living/silicon/pai,
						/mob/living/simple_animal/spiderbot, /mob/living/simple_animal/hostile/tree)

/obj/item/trap/animal/large
	name = "large trap"
	desc = "A large mechanical trap that is used to catch larger animals, from spiders and dogs to bears and even larger mammals."
	icon_base = "large"
	icon_state = "large0"
	throwforce = 6
	force = 10
	w_class = 6
	density = 1
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 15750)
	deployed = FALSE
	resources = list(rods = 12, metal = 4)
	spider = FALSE

/obj/item/trap/animal/large/Initialize()
	. = ..()
	allowed_mobs = list(
						/mob/living/simple_animal/hostile/retaliate/goat, /mob/living/simple_animal/cow, /mob/living/simple_animal/corgi/fox,
						/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/giant_spider,
						/mob/living/simple_animal/hostile/commanded/dog, /mob/living/simple_animal/hostile/retaliate/cavern_dweller, /mob/living/carbon/human,
						/mob/living/simple_animal/pig)

/obj/item/trap/animal/large/attack_hand(mob/user)
	if(user == buckled)
		return
	else if(!anchored)
		to_chat(user, SPAN_WARNING("You need to anchor \the [src] first!"))
	else if(captured)
		to_chat(user, SPAN_WARNING("You can't deploy \the [src] with something caught!"))
	else
		..()

/obj/item/trap/animal/large/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		var/turf/T = get_turf(src)
		if(!T)
			to_chat(user, "<span class='warning'>There is nothing to secure [src] to!</span>")
			return

		if(anchored && deployed)
			to_chat(user, SPAN_WARNING("You can't do that while \the [src] is deployed! Undeploy it first."))
			return

		user.visible_message("<span class='notice'>[user] begins [anchored ? "un" : "" ]securing \the [src]!</span>",
							  "<span class='notice'>You begin [anchored ? "un" : "" ]securing \the [src]!</span>")

		if(W.use_tool(src, user, 30, volume = 50))
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "" : "un" ]secures \the [src]!</span>",
								"<span class='notice'>You [anchored ? "" : "un" ]secure \the [src]!</span>")

	else if(W.isscrewdriver())
		// Unlike smaller traps, screwdriver shouldn't work on this.
		return
	else
		..()

/obj/item/trap/animal/large/MouseDrop(over_object, src_location, over_location)
	if(captured)
		to_chat(usr, SPAN_WARNING("The trap door's down, you can't get through there!"))
		return

	if(!src.Adjacent(usr))
		return

	if(!ishuman(usr))
		..()
		return

	var/pct = 0
	if(usr.a_intent == I_HELP)
		pct = 100
	else if(usr.a_intent != I_HURT)
		pct = 50

	pass_without_trace(usr, pct)

/obj/item/trap/animal/large/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(deployed)
		return TRUE
	return FALSE

/obj/item/large_trap_foundation
	name = "large trap foundation"
	desc = "A metal foundation for large trap, it is missing metals rods to hold the prey."
	icon = 'icons/obj/item/traps.dmi'
	icon_state = "large_foundation"
	throwforce = 4
	force = 5
	w_class = ITEMSIZE_HUGE

/obj/item/large_trap_foundation/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/O = W
		if(O.get_amount() >= 12)

			to_chat(user, "<span class='notice'>You are trying to add metal bars to \the [src].</span>")

			if (!do_after(user, 2 SECONDS, act_target = src))
				return

			to_chat(user, "<span class='notice'>You add metal bars to \the [src].</span>")
			O.use(12)
			new /obj/item/trap/animal/large(src.loc)
			qdel(src)
			return
		else
			to_chat(user, "<span class='warning'>You need at least 12 rods to complete \the [src].</span>")
	else if(istype(W, /obj/item/screwdriver))
		return
	else
		..()


/obj/item/trap/tripwire
	name = "tripwire trap"
	desc = "A piece of cable coil strung between two metal rods. Low-tech, but reliable."
	icon_base = "tripwire"
	color = COLOR_RED
	layer = UNDERDOOR // so you can't cover it with items

/obj/item/trap/tripwire/Initialize(mapload, var/new_cable_color)
	. = ..()
	if(!new_cable_color)
		new_cable_color = COLOR_RED
	color = new_cable_color

/obj/item/trap/tripwire/update_icon()
	underlays = null
	icon_state = "[icon_base][deployed]"
	var/image/I = image(icon, null, "[icon_state]_base")
	I.appearance_flags = RESET_COLOR
	underlays = list(I)

/obj/item/trap/tripwire/deploy(mob/user)
	user.visible_message(SPAN_WARNING("\The [user] starts to deploy \the [src]."), SPAN_WARNING("You begin deploying \the [src]!"))
	if(do_after(user, 5 SECONDS))
		user.visible_message(SPAN_WARNING("\The [user] deploys \the [src]."), SPAN_WARNING("You deploy \the [src]!"))
		deployed = TRUE
		update_icon()
		return TRUE
	return FALSE

/obj/item/trap/tripwire/disarm_trap(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] starts to take \the [src] down..."), SPAN_NOTICE("You begin taking \the [src] down..."), SPAN_WARNING("You hear a latch click followed by the slow creaking of a spring."))
	if(do_after(user, 6 SECONDS))
		deployed = FALSE
		anchored = FALSE
		update_icon()

/obj/item/trap/tripwire/attack_mob(mob/living/L)
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(!H.organs_by_name[BP_L_LEG] && !H.organs_by_name[BP_R_LEG]) // tripwires are triggered by shin, so if you don't have legs, assume you fly or crawl
		return

	if(!L.lying && (L.m_intent == M_RUN) || prob(5))
		L.visible_message(SPAN_DANGER("\The [L] trips over \the [src]!"), FONT_LARGE(SPAN_DANGER("You trip over \the [src]!")))
		L.Weaken(3)
