// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = 0
	anchored = 1
	density = 0
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0
	var/solid_time = 120
	var/amount = 3
	var/expand = 1
	var/metal = 0

/obj/effect/effect/foam/New(var/loc, var/ismetal = 0)
	..(loc)
	icon_state = "[ismetal? "m" : ""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	addtimer(CALLBACK(src, PROC_REF(tick)), 3 + metal * 3)
	addtimer(CALLBACK(src, PROC_REF(post)), solid_time)

/obj/effect/effect/foam/proc/tick()
	process()
	checkReagents()

/obj/effect/effect/foam/proc/post()
	STOP_PROCESSING(SSprocessing, src)
	sleep(30)
	if(metal)
		var/obj/structure/foamedmetal/M = new /obj/structure/foamedmetal(src.loc)
		M.metal = metal
		M.update_icon()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)
		for(var/obj/O in T)
			reagents.touch_obj(O)

/obj/effect/effect/foam/process()
	if(--amount < 0)
		return

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/_R in reagents.reagent_volumes)
					F.reagents.add_reagent(_R, 1, safety = 1) //added safety check since reagents in the foam have already had a chance to react

/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		QDEL_IN(src, 5)

/obj/effect/effect/foam/Crossed(var/atom/movable/AM)
	if(metal)
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the foam", 6)

/obj/effect/effect/foam/spray
	amount = 1 // only spread a little bit
	solid_time = 3 SECONDS

/obj/effect/effect/foam/spray/initial
	amount = 0 // don't spread

/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0 = foam, 1 = metalfoam, 2 = ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca, var/datum/reagents/carry = null, var/metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/_R in carry.reagent_volumes)
			carried_reagents += _R

/datum/effect/effect/system/foam_spread/start()
	set waitfor = FALSE
	var/obj/effect/effect/foam/F = locate() in location
	if(F)
		F.amount += amount
		return

	F = new /obj/effect/effect/foam(location, metal)
	F.amount = amount

	if(!metal) // don't carry other chemicals if a metal foam
		F.create_reagents(10)

		if(carried_reagents)
			for(var/id in carried_reagents)
				F.reagents.add_reagent(id, 1, safety = 1) //makes a safety call because all reagents should have already reacted anyway
		else
			F.reagents.add_reagent(/singleton/reagent/water, 1, safety = 1)

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = 1
	opacity = 1 // changed in New()
	anchored = 1
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	var/metal = 1 // 1 = aluminum, 2 = iron

/obj/structure/foamedmetal/New()
	..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = 0
	update_nearby_tiles(1)
	set_opacity(0)
	return ..()

/obj/structure/foamedmetal/update_icon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal == 1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, FIST_ATTACK_ANIMATION)
	if ((user.mutations & HULK) || (prob(75 - metal * 25)))
		user.visible_message(SPAN_WARNING("[user] smashes through the foamed metal."), SPAN_NOTICE("You smash through the metal foam wall."))
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You hit the metal foam but bounce off it."))
		shake_animation()

/obj/structure/foamedmetal/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/G = attacking_item
		if(G.state < GRAB_AGGRESSIVE)
			to_chat(user, SPAN_WARNING("You need a stronger grip to do that!"))
			return TRUE
		G.affecting.forceMove(src.loc)
		visible_message(SPAN_WARNING("[G.assailant] smashes [G.affecting] through the foamed metal wall."))
		G.affecting.take_overall_damage(15)
		qdel(attacking_item)
		qdel(src)
		return TRUE

	else if(istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/S = attacking_item
		if(S.get_amount() < 4)
			to_chat(user, SPAN_NOTICE("There isn't enough material here to construct a wall."))
			return TRUE

		var/material/M = SSmaterials.get_material_by_name(S.default_type)
		if(!istype(M))
			return TRUE
		if(M.integrity < 50)
			to_chat(user, SPAN_NOTICE("This material is too soft for use in wall construction."))
			return TRUE
		user.visible_message("<b>[user]</b> starts slotting material into \the [src]...", SPAN_NOTICE("You start slotting material into \the [src], forming it into a wall..."))
		if(!do_after(user, 10 SECONDS) || !S.use(4))
			return TRUE
		var/turf/Tsrc = get_turf(src)
		var/original_type = Tsrc.type
		Tsrc.ChangeTurf(/turf/simulated/wall)
		var/turf/simulated/wall/T = Tsrc
		T.under_turf = original_type
		T.set_material(M)
		T.add_hiddenprint(usr)
		qdel(src)
		return TRUE

	else if(istype(attacking_item, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		if(T.type != /turf/space && !isopenturf(T)) // need to do a hard check here because transit turfs are also space turfs
			to_chat(user, SPAN_WARNING("The tile below \the [src] isn't an open space, or space itself!"))
			return TRUE
		var/obj/item/stack/tile/floor/S = attacking_item
		S.use(1)
		T.ChangeTurf(/turf/simulated/floor/airless)
		qdel(src)
		return TRUE

	user.do_attack_animation(src, attacking_item)
	if(prob(attacking_item.force * 20 - metal * 25))
		user.visible_message(SPAN_WARNING("[user] smashes through the foamed metal."), SPAN_NOTICE("You smash through the foamed metal with \the [attacking_item]."))
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You hit the metal foam to no effect."))
		shake_animation()
	return TRUE

/obj/structure/foamedmetal/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(air_group)
		return 0
	return !density
