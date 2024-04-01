//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/doorint.dmi'
	icon_state = "door_closed"
	anchored = 1
	opacity = 1
	density = 1
	layer = CLOSED_DOOR_LAYER
	dir = SOUTH
	var/open_layer = OPEN_DOOR_LAYER
	var/closed_layer = CLOSED_DOOR_LAYER

	/// Boolean. Whether or not the door blocks vision.
	var/visible = TRUE
	/// Boolean. Whether or not the door's panel is open.
	var/p_open = FALSE
	/// Boolean. The door's operating state.
	var/operating = FALSE
	/// Boolean. Whether or not the door will automatically close.
	var/autoclose = FALSE
	/// Boolean. Whether or not the door is considered a glass door.
	var/glass = FALSE
	/// Boolean. Whether or not the door waits before closing. Generally tied to the timing wire.
	var/normalspeed = TRUE
	/// Boolean. Whether or not the door is heat proof. Affects turf thermal conductivity for non-opaque doors. Provided for mapping use.
	var/heat_proof = FALSE
	/// Instance of material stack that's been added to the door for repairs.
	var/obj/item/stack/material/repairing
	/// Integer. Width of the door in tiles.
	var/width = 1
	var/air_properties_vary_with_direction = 0
	/// Integer. Corresponds to dirs. If opened from this dir, no access is required.
	var/unres_dir = null
	var/maxhealth = 300
	var/health
	/// Integer. How many strong hits it takes to destroy the door.
	var/destroy_hits = 10
	/// Integer. Minimum amount of force needed to damage the door with a melee weapon.
	var/min_force = 10
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/hitsound_light = 'sound/effects/glass_hit.ogg'//Sound door makes when hit very gently
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/open_duration = 150//How long it stays open

	var/hashatch = 0//If 1, this door has hatches, and certain small creatures can move through them without opening the door
	var/hatchstate = 0//0: closed, 1: open
	var/hatch_open_sound = 'sound/machines/hatch_open.ogg'
	var/hatch_close_sound = 'sound/machines/hatch_close.ogg'

	// Integer. Used for intercepting clicks on our turf. Set 0 to disable click interception. Passed directly to `/datum/component/turf_hand`.
	var/turf_hand_priority = 3

	// turf animation
	var/atom/movable/overlay/c_animation = null

	atmos_canpass = CANPASS_PROC

	can_astar_pass = CANASTARPASS_ALWAYS_PROC

/obj/machinery/door/attack_generic(var/mob/user, var/damage)
	if(damage >= 10)
		visible_message("<span class='danger'>\The [user] smashes into the [src]!</span>")
		playsound(src.loc, hitsound, 60, 1)
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
		playsound(src.loc, hitsound_light, 8, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	user.do_attack_animation(src)

/obj/machinery/door/Initialize()
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0

	SetBounds()
	health = maxhealth

	update_nearby_tiles(need_rebuild=1)
	if(turf_hand_priority)
		AddComponent(/datum/component/turf_hand, turf_hand_priority)

/obj/machinery/door/Move(new_loc, new_dir)
	. = ..()
	SetBounds()
	update_nearby_tiles()
	update_icon()

/obj/machinery/door/proc/SetBounds()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

/obj/machinery/door/proc/open_hatch(var/atom/mover = null)
	if (!hatchstate)
		hatchstate = 1
		update_icon()
		playsound(src.loc, hatch_open_sound, 40, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)


	close_hatch_in(29)

	if (istype(mover, /mob/living))
		var/mob/living/S = mover
		S.under_door()


/obj/machinery/door/proc/close_hatch()
	hatchstate = 0//hatch stays open for 3 seconds
	update_icon()
	playsound(src.loc, hatch_close_sound, 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)

/obj/machinery/door/Destroy()
	density = 0
	update_nearby_tiles()

	return ..()

/obj/machinery/door/proc/close_door_in(var/time = 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(close)), time, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/machinery/door/proc/close_hatch_in(var/time = 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(close_hatch)), time, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/machinery/door/proc/can_open()
	if(!density || operating || !ROUND_IS_STARTED)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating || !ROUND_IS_STARTED)
		return 0
	return 1

/obj/machinery/door/CollidedWith(atom/AM)
	. = ..()
	if(p_open || operating) return
	if (!AM.simulated) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && (!issmall(M) || ishuman(M) || istype(M, /mob/living/silicon/robot/drone/mining)))
			bumpopen(M)
		return

	if(istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/living/simple_animal/spiderbot))
		var/mob/living/simple_animal/spiderbot/bot = AM
		if(src.check_access(bot.internal_id))
			if(density)
				open()
		return

	if(istype(AM, /obj/structure/bed/stool/chair/office/wheelchair))
		var/obj/structure/bed/stool/chair/office/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return
	if(istype(AM, /obj/structure/janitorialcart))
		var/obj/structure/janitorialcart/cart = AM
		if(density)
			if(cart.pulling && (src.allowed(cart.pulling)))
				open()
			else
				do_animate("deny")
		return

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		if(density)
			if(V.buckled && (src.allowed(V.buckled)))
				open()
			else
				do_animate("deny")
		return

	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return !block_air_zones
	if (istype(mover))
		if(mover.checkpass(PASSGLASS))
			return !opacity
		if(density && hashatch && mover.checkpass(PASSDOORHATCH))
			if (istype(mover, /mob/living/silicon/pai))
				var/mob/living/silicon/pai/P = mover
				if (allowed(P))
					open_hatch(mover)
					return 1
			else
				open_hatch(mover)
				return 1//If this door is closed, but it has hatches, and this creature can go through hatches. Then we let it through without opening
	return !density

/obj/machinery/door/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	return (check_access_list(pass_info.access) && can_open())


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))	open()
		else				do_animate("deny")
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message("<span class='danger'>\The [src.name] disintegrates!</span>")
			switch (Proj.damage_type)
				if(DAMAGE_BRUTE)
					new /obj/item/stack/material/steel(src.loc, 2)
					new /obj/item/stack/rods(src.loc, 3)
				if(DAMAGE_BURN)
					new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))


/obj/machinery/door/hitby(AM as mob|obj, var/speed=5)
	..()
	var/tforce = 0
	if(ismob(AM))
		tforce = 15 * (speed/5)
	else
		tforce = AM:throwforce * (speed/5)

	if (tforce > 0)
		var/volume = 100
		if (tforce < 20)//No more stupidly loud banging sound from throwing a piece of paper at a door
			volume *= (tforce / 20)
		playsound(src.loc, hitsound, volume, TRUE)
		take_damage(tforce)
		return

/obj/machinery/door/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	if(src.operating > 0 || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating) return

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate("deny")
		return

/obj/machinery/door/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)

	if(attacking_item.ishammer() && user.a_intent != I_HURT)
		var/obj/item/stack/stack = usr.get_inactive_hand()
		if(istype(stack) && stack.get_material_name() == get_material_name())
			if(stat & BROKEN)
				to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
				return TRUE
			if(health >= maxhealth)
				to_chat(user, SPAN_NOTICE("Nothing to fix!"))
				return TRUE
			if(!density)
				to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
				return TRUE

			//figure out how much metal we need
			var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
			amount_needed = (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1 //Why does BYOND not have a ceiling proc?

			var/transfer
			if (repairing)
				transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
				if (!transfer)
					to_chat(user, SPAN_WARNING("You must weld or remove \the [repairing] from \the [src] before you can add anything else."))
			else
				repairing = stack.split(amount_needed)
				if (repairing)
					repairing.forceMove(src)
					transfer = repairing.amount

			if (transfer)
				to_chat(user, SPAN_NOTICE("You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src]."))

			return TRUE

	if(repairing && attacking_item.iswelder())
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return TRUE

		var/obj/item/weldingtool/welder = attacking_item
		if(welder.use(0,user))
			to_chat(user, "<span class='notice'>You start to fix dents and weld \the [repairing] into place.</span>")
			if(welder.use_tool(src, user, 5 * repairing.amount, volume = 50) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to \the [src].</span>")
				health = between(health, health + repairing.amount*DOOR_REPAIR_AMOUNT, maxhealth)
				update_icon()
				qdel(repairing)
				repairing = null
		return TRUE

	if(repairing && attacking_item.iscrowbar())
		to_chat(user, "<span class='notice'>You remove \the [repairing].</span>")
		attacking_item.play_tool_sound(get_turf(src), 50)
		repairing.forceMove(user.loc)
		repairing = null
		return TRUE

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(attacking_item, /obj/item) && user.a_intent == I_HURT && !istype(attacking_item, /obj/item/card))
		var/obj/item/W = attacking_item
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == DAMAGE_BRUTE || W.damtype == DAMAGE_BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
				playsound(src.loc, hitsound, W.get_clamped_volume(), TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE)
				take_damage(W.force)
		return TRUE

	if(src.operating > 0 || isrobot(user))
		return TRUE //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return TRUE

	if(src.density)
		do_animate("deny")

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("emag")
		emagged = 1
		sleep(6)
		stat |= BROKEN
		open(1)
		return 1

/obj/machinery/door/proc/take_damage(var/damage, message = TRUE)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
	else if(message)
		if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
			visible_message(SPAN_WARNING("\The [src] looks like it's about to break!"))
		else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
			visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
		else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
			visible_message(SPAN_WARNING("\The [src] shows signs of damage!"))
	update_icon()
	return

/obj/machinery/door/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(src.health < src.maxhealth / 4)
		. += SPAN_WARNING("\The [src] looks like it's about to break!")
	else if(src.health < src.maxhealth / 2)
		. += SPAN_WARNING("\The [src] looks seriously damaged!")
	else if(src.health < src.maxhealth * 3/4)
		. += SPAN_WARNING("\The [src] shows signs of damage!")

/obj/machinery/door/proc/set_broken()
	stat |= BROKEN
	visible_message(SPAN_WARNING("[src] breaks!"))
	update_icon()
	return

/obj/machinery/door/emp_act(severity)
	. = ..()

	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		open()

/obj/machinery/door/ex_act(severity)
	var/bolted = 0
	if (istype(src, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = src
		bolted = A.locked
	switch(severity)
		if(1.0)
			if((!bolted) || prob(80))
				qdel(src)
			else
				var/damage = rand(300,600)
				if (bolted)
					damage *= 0.8 //Bolted doors are a bit tougher
				take_damage(damage, FALSE)
		if(2.0)
			if((!bolted && prob(25)) || prob(20))
				qdel(src)
			else
				var/damage = rand(150,300)
				if (bolted)
					damage *= 0.8 //Bolted doors are a bit tougher
				take_damage(damage, FALSE)
		if(3.0)
			if(prob(80))
				spark(src, 2, GLOB.alldirs)
			var/damage = rand(100,150)
			if (bolted)
				damage *= 0.8
			take_damage(damage, FALSE)

	if (health <= 0)
		qdel(src)
	return


/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door_closed"
	else
		icon_state = "door_open"
	return


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, FALSE, extrarange = SILENCED_SOUND_EXTRARANGE)
	return

/obj/machinery/door/proc/open(var/forced = 0)
	set waitfor = FALSE

	if(!can_open(forced))
		return
	operating = TRUE

	intent_message(MACHINE_SOUND)

	do_animate("opening")
	icon_state = "door_open"
	set_opacity(0)
	sleep(3)
	src.density = 0
	update_nearby_tiles()
	sleep(2)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	operating = FALSE

	if(autoclose && !QDELETED(src))
		close_door_in(next_close_time())

	return 1

/obj/machinery/door/proc/next_close_time()
	return (normalspeed ? open_duration : 5)

/obj/machinery/door/proc/autoclose()
	if (!QDELETED(src) && can_close(FALSE) && autoclose)
		close()

/obj/machinery/door/proc/close(var/forced = 0)
	set waitfor = FALSE

	if(!can_close(forced))
		if (autoclose)
			for (var/atom/movable/M in get_turf(src))
				if (M.density && M != src)
					addtimer(CALLBACK(src, PROC_REF(autoclose)), 60, TIMER_UNIQUE)
					break
	operating = TRUE

	intent_message(MACHINE_SOUND)

	do_animate("closing")
	sleep(3)
	src.density = 1
	explosion_resistance = initial(explosion_resistance)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(2)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = FALSE

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return TRUE // Door doesn't require an ID. So obviously they're allowed.
	if(unrestricted_side(M))
		return TRUE
	return ..(M)

/obj/machinery/door/proc/unrestricted_side(mob/M) //Allows for specific side of airlocks to be unrestrected (IE, can exit maint freely, but need access to enter)
	if(!unres_dir)
		return FALSE
	return get_dir(src, M) & unres_dir

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	for(var/turf/T in locs)
		if (istype(T, /turf/simulated))
			var/turf/simulated/turf = T
			update_heat_protection(turf)
			SSair.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/proc/is_open(var/invert=0)
	if(invert)
		return src.density
	return !src.density
