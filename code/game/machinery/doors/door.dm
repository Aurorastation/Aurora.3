//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = 1
	opacity = 1
	density = 1
	layer = DOOR_OPEN_LAYER
	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER

	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 300
	var/health
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/obj/item/stack/material/steel/repairing
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible

	var/hashatch = 0//If 1, this door has hatches, and certain small creatures can move through them without opening the door
	var/hatchstate = 0//0: closed, 1: open
	var/hatchstyle = "1x1"
	var/hatch_offset_x = 0
	var/hatch_offset_y = 0
	var/hatch_colour = "#FFFFFF"
	var/hatch_open_sound = 'sound/machines/hatch_open.ogg'
	var/hatch_close_sound = 'sound/machines/hatch_close.ogg'

	var/hatchclosetime //A world.time value to tell us when the hatch should close

	var/image/hatch_image

	//Multi-tile doors
	dir = EAST
	var/width = 1

	// turf animation
	var/atom/movable/overlay/c_animation = null

/obj/machinery/door/attack_generic(var/mob/user, var/damage)
	if(damage >= 10)
		visible_message("<span class='danger'>\The [user] smashes into the [src]!</span>")
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	user.do_attack_animation(src)

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	health = maxhealth

	update_nearby_tiles(need_rebuild=1)
	if (hashatch)
		setup_hatch()
	return

/obj/machinery/door/proc/setup_hatch()

	if (overlays != null)
		hatch_image = image('icons/obj/doors/hatches.dmi', src, hatchstyle, closed_layer+0.1)
		hatch_image.color = hatch_colour
		hatch_image.pixel_x = hatch_offset_x
		hatch_image.pixel_y = hatch_offset_y

		overlays += hatch_image
		update_icon()
	else
		spawn(10)
			setup_hatch()

/obj/machinery/door/proc/open_hatch(var/atom/mover = null)
	if (!hatchstate)
		hatchstate = 1
		update_icon()
		playsound(src.loc, hatch_open_sound, 40, 1, -1)
	hatchclosetime = world.time + 29

	if (istype(mover, /mob/living))
		var/mob/living/S = mover
		S.under_door()


/obj/machinery/door/proc/close_hatch()
	hatchstate = 0//hatch stays open for 3 seconds
	update_icon()
	playsound(src.loc, hatch_close_sound, 30, 1, -1)

/obj/machinery/door/Destroy()
	density = 0
	update_nearby_tiles()
	..()
	return

/obj/machinery/door/process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			close()
		else
			close_door_at = 0
	if (hatchstate && world.time > hatchclosetime)
		close_hatch()

/obj/machinery/door/proc/can_open()
	if(!density || operating || !ticker)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating || !ticker)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && !M.small)
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

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				do_animate("deny")
		return
	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
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


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))	open()
		else				do_animate("deny")
	return

/obj/machinery/door/meteorhit(obj/M as obj)
	src.open()
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	//Tasers and the like should not damage doors. Nor should TOX, OXY, CLONE, etc damage types
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (Proj.damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message("\red <B>\The [src.name] disintegrates!</B>")
			switch (Proj.damage_type)
				if(BRUTE)
					new /obj/item/stack/material/steel(src.loc, 2)
					PoolOrNew(/obj/item/stack/rods, list(src.loc, 3))
				if(BURN)
					new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(Proj.damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(Proj.damage, 100))



/obj/machinery/door/hitby(AM as mob|obj, var/speed=5)

	..()
	visible_message("\red <B>[src.name] was hit by [AM].</B>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 15 * (speed/5)
	else
		tforce = AM:throwforce * (speed/5)
	playsound(src.loc, hitsound, 100, 1)
	take_damage(tforce)
	return

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			user << "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>"
			return
		if(health >= maxhealth)
			user << "<span class='notice'>Nothing to fix!</span>"
			return
		if(!density)
			user << "<span class='warning'>\The [src] must be closed before you can repair it.</span>"
			return

		//figure out how much metal we need
		var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
		amount_needed = (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1 //Why does BYOND not have a ceiling proc?

		var/obj/item/stack/stack = I
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				user << "<span class='warning'>You must weld or remove \the [repairing] from \the [src] before you can add anything else.</span>"
		else
			repairing = stack.split(amount_needed)
			if (repairing)
				repairing.loc = src
				transfer = repairing.amount

		if (transfer)
			user << "<span class='notice'>You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>"

		return

	if(repairing && istype(I, /obj/item/weapon/weldingtool))
		if(!density)
			user << "<span class='warning'>\The [src] must be closed before you can repair it.</span>"
			return

		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			user << "<span class='notice'>You start to fix dents and weld \the [repairing] into place.</span>"
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 5 * repairing.amount) && welder && welder.isOn())
				user << "<span class='notice'>You finish repairing the damage to \the [src].</span>"
				health = between(health, health + repairing.amount*DOOR_REPAIR_AMOUNT, maxhealth)
				update_icon()
				qdel(repairing)
				repairing = null
		return

	if(repairing && istype(I, /obj/item/weapon/crowbar))
		user << "<span class='notice'>You remove \the [repairing].</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		repairing.loc = user.loc
		repairing = null
		return

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message("\red <B>\The [user] hits \the [src] with \the [W] with no visible effect.</B>" )
			else
				user.visible_message("\red <B>\The [user] forcefully strikes \the [src] with \the [W]!</B>" )
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force)
		return

	if(src.operating > 0 || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating) return

	if(src.density && (operable() && istype(I, /obj/item/weapon/card/emag)))
		do_animate("spark")
		sleep(6)
		open()
		operating = -1
		return 1

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate("deny")
	return

/obj/machinery/door/proc/take_damage(var/damage)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
	else if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()
	return


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health < src.maxhealth / 4)
		user << "\The [src] looks like it's about to break!"
	else if(src.health < src.maxhealth / 2)
		user << "\The [src] looks seriously damaged!"
	else if(src.health < src.maxhealth * 3/4)
		user << "\The [src] shows signs of damage!"


/obj/machinery/door/proc/set_broken()
	stat |= BROKEN
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name] breaks!" )
	update_icon()
	return


/obj/machinery/door/blob_act()
	if(prob(40))
		qdel(src)
	return


/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		spawn(0)
			open()
	..()


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
				take_damage(damage)
		if(2.0)
			if((!bolted && prob(25)) || prob(20))
				qdel(src)
			else
				var/damage = rand(150,300)
				if (bolted)
					damage *= 0.8 //Bolted doors are a bit tougher
				take_damage(damage)
		if(3.0)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
			var/damage = rand(100,150)
			if (bolted)
				damage *= 0.8
			take_damage(damage)

	if (health <= 0)
		qdel(src)
	return


/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
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
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
	return


/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return
	operating = 1

	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	sleep(3)
	src.density = 0
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	operating = 0

	if(autoclose)
		close_door_at = next_close_time()

	return 1

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(var/forced = 0)
	if(!can_close(forced))
		return
	operating = 1

	close_door_at = 0
	do_animate("closing")
	sleep(3)
	src.density = 1
	explosion_resistance = initial(explosion_resistance)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(7)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		air_master.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	//update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'
