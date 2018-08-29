/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = TURF_LAYER+0.2
	anchored = 1
	var/amount = 1

/obj/effect/decal/cleanable/liquid_fuel/Initialize(mapload, amt = 1, nologs = 0)
	. = ..()
	if(!nologs && !mapload)
		message_admins("Liquid fuel has spilled in [loc.loc.name] ([loc.x],[loc.y],[loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
		log_game("Liquid fuel has spilled in [loc.loc.name] ([loc.x],[loc.y],[loc.z])")
	src.amount = amt

	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in loc)
		if(other != src)
			other.amount += src.amount
			other.Spread()
			has_spread = 1
			break

	if(!has_spread)
		Spread()
	else
		qdel(src)

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread(exclude=list())
	//Allows liquid fuels to sometimes flow into other tiles.
	if(amount < 15) return //lets suppose welder fuel is fairly thick and sticky. For something like water, 5 or less would be more appropriate.
	var/turf/simulated/S = loc
	if(!istype(S)) return
	for(var/d in cardinal)
		var/turf/simulated/target = get_step(src,d)
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/liquid_fuel/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.25
				if(!(other_fuel in exclude))
					exclude += src
					other_fuel.Spread(exclude)
			else
				new/obj/effect/decal/cleanable/liquid_fuel(target, amount*0.25,1)
			amount *= 0.75

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = 0

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Initialize(mapload, amt = 1, d = 0)
	set_dir(d) //Setting this direction means you won't get torched by your own flamethrower.
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	if(amount < 0.1) return
	var/turf/simulated/S = loc
	if(!istype(S)) return

	for(var/d in list(turn(dir,90),turn(dir,-90), dir))
		var/turf/simulated/O = get_step(S,d)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O)
			continue
		if(O.CanPass(null, S, 0, 0) && S.CanPass(null, O, 0, 0))
			new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(O,amount*0.25,d)
			O.hotspot_expose((T20C*2) + 380,500) //Light flamethrower fuel on fire immediately.

	amount *= 0.25


/obj/effect/decal/cleanable/liquid_fuel/napalm
	name = "napalm gel"

/obj/effect/decal/cleanable/liquid_fuel/napalm/Initialize(mapload, amt = 1, nologs = 0)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/decal/cleanable/liquid_fuel/napalm/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/decal/cleanable/liquid_fuel/napalm/Spread()
	if(amount < 100)
		return
	var/turf/simulated/S = loc
	if(!istype(S))
		return
	for(var/d in cardinal)
		var/turf/simulated/target = get_step(src,d)
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/liquid_fuel/napalm/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.5
				target.hotspot_expose(2000, 400)
			else
				new/obj/effect/decal/cleanable/liquid_fuel/napalm(target, amount*0.5,1)
				target.hotspot_expose(2000, 400)
			amount *= 0.5
		origin.hotspot_expose(2000, 400) //immediately ignite. its napalm bitch

/obj/effect/decal/cleanable/liquid_fuel/napalm/process()
	for(var/mob/living/L in get_turf(src))
		var/sticky = min(rand(5,25), amount)
		if(sticky > 1)
			L.adjust_fire_stacks(sticky)
			amount = max(1, amount - sticky)

/obj/effect/decal/cleanable/foam //Copied from liquid fuel
	name = "foam"
	desc = "Some kind of extinguishing foam."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/effects.dmi'
	icon_state = "white_foam"
	var/amount = 1

/obj/effect/decal/cleanable/foam/Initialize(mapload, amt = 1, nologs = 0)
	src.amount = amt

	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/foam/other in loc)
		if(other != src)
			other.amount += src.amount
			other.Spread()
			has_spread = 1
			break

	if(!has_spread)
		Spread()
		QDEL_IN(src, 2 MINUTES)
	else
		qdel(src)

/obj/effect/decal/cleanable/foam/proc/Spread(exclude=list())
	if(amount < 15) return
	var/turf/simulated/S = loc
	if(!istype(S)) return
	for(var/d in cardinal)
		var/turf/simulated/target = get_step(src,d)
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/foam/other_foam = locate() in target
			if(other_foam)
				other_foam.amount += amount*0.25
				if(!(other_foam in exclude))
					exclude += src
					other_foam.Spread(exclude)
			else
				new/obj/effect/decal/cleanable/foam(target, amount*0.25,1)
			amount *= 0.75