/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"
	var/base_state = "left"
	min_force = 4
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 150 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file
	health = 150
	visible = 0.0
	flags = ON_BORDER
	opacity = 0
	var/obj/item/airlock_electronics/electronics = null
	explosion_resistance = 5
	air_properties_vary_with_direction = 1

	atmos_canpass = CANPASS_PROC

/obj/machinery/door/window/Initialize(mapload)
	. = ..()
	if (!mapload)
		update_nearby_tiles()

	if (LAZYLEN(req_access))
		icon_state = "[icon_state]"
		base_state = icon_state

/obj/machinery/door/window/proc/shatter(var/display_message = 1)
	new /obj/item/trash/broken_electronics(loc)
	new /obj/item/material/shard(loc)
	var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
	CC.amount = 2
	src.density = FALSE
	playsound(src, /decl/sound_category/glass_break_sound, 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	qdel(src)

/obj/machinery/door/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	return ..()

/obj/machinery/door/window/CollidedWith(atom/movable/AM as mob|obj)
	if(istype(AM, /mob/living/heavy_vehicle))
		var/mob/living/heavy_vehicle/HV = AM
		for(var/user in HV.pilots)
			AM = user
			break
	if (istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				addtimer(CALLBACK(src, .proc/close), 50)
		return
	if(istype(AM, /mob/living/simple_animal/spiderbot))
		var/mob/living/simple_animal/spiderbot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.internal_id))
				open()
				addtimer(CALLBACK(src, .proc/close), 50)
		return
	if (!( ROUND_IS_STARTED ))
		return
	if (src.operating)
		return
	if (src.density && (ishuman(AM) || isrobot(AM)) && src.allowed(AM))
		open()
		//secure doors close faster
		var/time = check_access(null) ? 50 : 20
		addtimer(CALLBACK(src, .proc/close), time)

/obj/machinery/door/window/allowed(mob/M)
	. = ..()
	if(inoperable()) // Unpowered windoors can just be slid open
		return TRUE
	use_power(50) // Just powering the RFID and maybe a weak motor
	if(operable() && . == FALSE)
		flick("[base_state]deny", src)

/obj/machinery/door/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/machinery/door/window/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/machinery/door/window/open(var/forced=FALSE)
	set waitfor = FALSE

	if(!can_open() && !forced)
		return FALSE
	operating = TRUE
	flick("[base_state]opening", src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	icon_state = "[base_state]open"
	sleep(1 SECOND)

	explosion_resistance = 0
	density = FALSE
	update_nearby_tiles()
	operating = FALSE
	return TRUE

/obj/machinery/door/window/close(var/forced=FALSE)
	set waitfor = FALSE

	if (!can_close() && !forced)
		return FALSE
	operating = TRUE
	flick("[base_state]closing", src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	icon_state = base_state

	density = TRUE
	explosion_resistance = initial(explosion_resistance)
	update_nearby_tiles()

	sleep(1 SECOND)

	operating = FALSE
	return 1

/obj/machinery/door/window/take_damage(var/damage)
	src.health = max(0, src.health - damage)
	if (src.health <= 0)
		shatter()
		return

/obj/machinery/door/window/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.species.can_shred(H))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
		user.visible_message("<span class='danger'>[user] smashes against [src].</span>", "<span class='danger'>You smash against [src]!</span>")
		take_damage(25)
		return
	else if(operable())
		return attackby(user, user)

/obj/machinery/door/window/emag_act(var/remaining_charges, var/mob/user)
	if (density && operable())
		emagged = 1
		flick("[src.base_state]spark", src)
		sleep(6)
		open()
		desc = "A strong door. It keeps trying to close, but is jammed."
		return 1

/obj/machinery/door/window/attackby(obj/item/I as obj, mob/user as mob)

	//If it's in the process of opening/closing, ignore the click
	if (operating)
		return

	//Emags and ninja swords? You may pass.
	if (istype(I, /obj/item/melee/energy/blade))
		if(emag_act(10, user))
			spark(src.loc, 5)
			playsound(src.loc, /decl/sound_category/spark_sound, 50, 1)
			playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
			visible_message("<span class='warning'>The glass door was sliced open by [user]!</span>")
		return 1

	//If it's emagged, crowbar can pry electronics out.
	if (emagged == 1 && I.iscrowbar())
		playsound(src.loc, I.usesound, 100, 1)
		user.visible_message("[user] dismantles the windoor.", "You start to dismantle the windoor.")
		if (do_after(user,60/I.toolspeed))
			to_chat(user, SPAN_NOTICE("You dismantled the windoor!"))
			new /obj/item/trash/broken_electronics(loc)
			var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
			CC.amount = 2
			var/obj/item/stack/material/glass/reinforced/rglass = new /obj/item/stack/material/glass/reinforced(loc)
			rglass.amount = 5
			qdel(src)
			return

	if(!isliving(I))
		if(I.iscrowbar() && user.a_intent == I_HELP)
			if(inoperable())
				visible_message("\The [user] forces \the [src] [density ? "open" : "closed"].")
				if(density)
					open(1)
				else
					close(1)
			else
				to_chat(user, SPAN_NOTICE("The windoor's motors resist your efforts to force it."))
			return

	//If it's a weapon, smash windoor. Unless it's an id card, agent card, ect.. then ignore it (Cards really shouldnt damage a door anyway)
	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
		visible_message("<span class='danger'>[src] was hit by [I].</span>")
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	if(!istype(I, /obj/item/forensics))
		src.add_fingerprint(user)

	if(allowed(user))
		if(inoperable())
			user.visible_message("\The [user] begins to manually [density ? "push" : "pull"] \the [src] [density ? "open" : "closed"]!",
				"You begin to manually [density ? "push" : "pull"] \the [src] [density ? "open" : "closed"]!", "You hear the sound of a glass door [density ? "opening" : "closing"].")
			if(!do_after(user, 1 SECOND, TRUE, src))
				return
			visible_message("\The [user] [density ? "pulls" : "pushes"] \the [src] [density ? "closed" : "open"].")
		if (src.density)
			open()
		else
			close()

/obj/machinery/door/window/brigdoor
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(access_security)
	var/id = null
	maxhealth = 300
	health = 300.0 //Stronger doors for prison (regular window door health is 150)


/obj/machinery/door/window/brigdoor/allowed(mob/M)
	if(inoperable()) // Brigdoors are the exception to the "fail open" windoor - they lock closed
		to_chat(M, SPAN_WARNING("\The [src] refuses to budge in its unpowered state."))
		return FALSE
	. = ..()

/obj/machinery/door/window/brigdoor/power_change()
	..()
	if((stat & NOPOWER) && !density)
		close(TRUE)

/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"
