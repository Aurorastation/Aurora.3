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
	use_power = 0
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
	new /obj/item/circuitboard/broken(loc)
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

/obj/machinery/door/window/open()
	if (!ROUND_IS_STARTED)
		return FALSE
	if(can_open())
		operating = TRUE
		flick("[base_state]opening", src)
		playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
		icon_state = "[base_state]open"
		sleep(10)

		explosion_resistance = 0
		src.density = FALSE
		update_nearby_tiles()
		operating = FALSE
		return 1

/obj/machinery/door/window/close()
	if (operating || emagged == 1)
		return FALSE
	operating = TRUE
	flick("[base_state]closing", src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	src.icon_state = src.base_state

	src.density = TRUE
	explosion_resistance = initial(explosion_resistance)
	update_nearby_tiles()

	sleep(10)

	operating = FALSE
	return 1

/obj/machinery/door/window/take_damage(var/damage)
	src.health = max(0, src.health - damage)
	if (src.health <= 0)
		shatter()
		return

/obj/machinery/door/window/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/window/attack_hand(mob/user as mob)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
			user.visible_message("<span class='danger'>[user] smashes against [src].</span>", "<span class='danger'>You smash against [src]!</span>")
			take_damage(25)
			return
	return src.attackby(user, user)

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
			new /obj/item/circuitboard/broken(loc)
			var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
			CC.amount = 2
			var/obj/item/stack/material/glass/reinforced/rglass = new /obj/item/stack/material/glass/reinforced(loc)
			rglass.amount = 5
			qdel(src)
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

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick("[base_state]deny", src)

/obj/machinery/door/window/brigdoor
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(access_security)
	var/id = null
	maxhealth = 300
	health = 300.0 //Stronger doors for prison (regular window door health is 150)


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
