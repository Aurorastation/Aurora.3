/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/structure/window/window_panes.dmi'
	icon_state = "left"
	var/base_state = "left"
	alpha = 196
	layer = SIDE_WINDOW_LAYER
	min_force = 4
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 150 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file
	health = 150
	visible = 0.0
	atom_flags = ATOM_FLAG_CHECKS_BORDER
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

/obj/machinery/door/window/update_icon()
	if(!density != !operating) //XOR, baby
		icon_state = base_state
	else
		icon_state = "[base_state]open"

/obj/machinery/door/window/proc/shatter(var/display_message = 1)
	new /obj/item/trash/broken_electronics(loc)
	new /obj/item/material/shard(loc)
	var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
	CC.amount = 2
	CC.update_icon()
	src.density = FALSE
	playsound(src, /singleton/sound_category/glass_break_sound, 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	qdel(src)

/obj/machinery/door/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	return ..()

/obj/machinery/door/window/CollidedWith(atom/movable/AM as mob|obj)
	var/mob/M = AM
	if (!( ROUND_IS_STARTED ) || operating || !density || !istype(M) || !allowed(M))
		return

	if(ishuman(M) || isrobot(M) || isbot(M) || istype(M, /mob/living/simple_animal/spiderbot) || ismech(M))
		if(inoperable())
			if(do_after(M, 1 SECOND, src))
				// The VM here is before open and the wording is backwards because density gets set after a background sleep in open
				visible_message("\The [M] [density ? "pushes" : "pulls"] \the [src] [density ? "open" : "closed"].")
				open()
		else
			open()
			addtimer(CALLBACK(src, PROC_REF(close)), check_access(null) ? 5 SECONDS : 2 SECONDS)

/obj/machinery/door/window/allowed(mob/M)
	. = ..()
	if(inoperable() || !density) // Unpowered windoors can just be slid open, open windoors can always be closed
		return TRUE
	use_power_oneoff(50) // Just powering the RFID and maybe a weak motor
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
	update_icon()
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
	update_icon()

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
	else
		return attackby(user, user)

/obj/machinery/door/window/emag_act(var/remaining_charges, var/mob/user)
	if (density && operable())
		emagged = 1
		flick("[src.base_state]spark", src)
		sleep(6)
		open()
		desc = "A strong door. It keeps trying to close, but is jammed."
		return 1

/obj/machinery/door/window/attackby(obj/item/attacking_item, mob/user)

	//If it's in the process of opening/closing, ignore the click
	if (operating)
		return TRUE

	//Emags and ninja swords? You may pass.
	if (istype(attacking_item, /obj/item/melee/energy/blade))
		if(emag_act(10, user))
			spark(src.loc, 5)
			playsound(src.loc, /singleton/sound_category/spark_sound, 50, 1)
			playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
			visible_message("<span class='warning'>The glass door was sliced open by [user]!</span>")
		return TRUE

	//If it's emagged, crowbar can pry electronics out.
	if (emagged == 1 && attacking_item.iscrowbar())
		user.visible_message("[user] dismantles the windoor.", "You start to dismantle the windoor.")
		if(attacking_item.use_tool(src, user, 60, volume = 50))
			to_chat(user, SPAN_NOTICE("You dismantled the windoor!"))
			new /obj/item/trash/broken_electronics(loc)
			var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
			CC.amount = 2
			var/obj/item/stack/material/glass/reinforced/rglass = new /obj/item/stack/material/glass/reinforced(loc)
			rglass.amount = 5
			qdel(src)
		return TRUE

	if(isobj(attacking_item) && attacking_item.iscrowbar() && user.a_intent == I_HELP)
		if(inoperable())
			visible_message("\The [user] forces \the [src] [density ? "open" : "closed"].")
			if(density)
				open(TRUE)
			else
				close(TRUE)
		else
			to_chat(user, SPAN_NOTICE("\The [src]'s motors resist your efforts to force it."))
		return TRUE

	//If it's a weapon, smash windoor. Unless it's an id card, agent card, ect.. then ignore it (Cards really shouldnt damage a door anyway)
	if(src.density && istype(attacking_item, /obj/item) && !istype(attacking_item, /obj/item/card))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/aforce = attacking_item.force
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
		visible_message("<span class='danger'>[src] was hit by [attacking_item].</span>")
		if(attacking_item.damtype == DAMAGE_BRUTE || attacking_item.damtype == DAMAGE_BURN)
			take_damage(aforce)
		return TRUE

	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)

	if(allowed(user))
		if(inoperable())
			if(!do_after(user, 1 SECOND, src))
				return TRUE
			visible_message("\The [user] [density ? "pushes" : "pulls"] \the [src] [density ? "open" : "closed"].")
		if (src.density)
			open()
		else
			close()
		return TRUE

/obj/machinery/door/window/brigdoor
	name = "secure door"
	icon = 'icons/obj/structure/window/window_panes.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(ACCESS_SECURITY)
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

/obj/machinery/door/window/desk
	name = "desk door"
	icon = 'icons/obj/structure/window/desk_windoors.dmi'

/obj/machinery/door/window/desk/northleft
	dir = NORTH

/obj/machinery/door/window/desk/eastleft
	dir = EAST

/obj/machinery/door/window/desk/westleft
	dir = WEST

/obj/machinery/door/window/desk/southleft
	dir = SOUTH

/obj/machinery/door/window/desk/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/desk/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/desk/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/desk/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"
