/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = 0
	layer = 6
	time_to_live = 300
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS //PASSGLASS is fine here, it's just so the visual effect can "flow" around glass
	var/splash_amount = 10 //atoms moving through a smoke cloud get splashed with up to 10 units of reagent
	var/turf/destination

/obj/effect/effect/smoke/chem/New(var/newloc, smoke_duration, turf/dest_turf = null, icon/cached_icon = null)
	time_to_live = smoke_duration

	..()

	create_reagents(500)

	if(cached_icon)
		icon = cached_icon

	set_dir(pick(cardinal))
	pixel_x = -32 + rand(-8, 8)
	pixel_y = -32 + rand(-8, 8)

	//float over to our destination, if we have one
	destination = dest_turf
	if(destination)
		walk_to(src, destination)

/obj/effect/effect/smoke/chem/Destroy()
	walk(src, 0)
	return ..()

/obj/effect/effect/smoke/chem/Move()
	var/list/oldlocs = view(1, src)
	. = ..()
	if(.)
		for(var/turf/T in view(1, src) - oldlocs)
			for(var/atom/movable/AM in T)
				if(!istype(AM, /obj/effect/effect/smoke/chem))
					reagents.splash(AM, splash_amount, copy = 1)
		if(loc == destination)
			bound_width = 96
			bound_height = 96

/obj/effect/effect/smoke/chem/Crossed(atom/movable/AM)
	..()
	if(!istype(AM, /obj/effect/effect/smoke/chem))
		reagents.splash(AM, splash_amount, copy = 1)

/obj/effect/effect/smoke/chem/proc/initial_splash()
	for(var/turf/T in view(1, src))
		for(var/atom/movable/AM in T)
			if(!istype(AM, /obj/effect/effect/smoke/chem))
				reagents.splash(AM, splash_amount, copy = 1)

/////////////////////////////////////////////
// Chem Smoke Effect System
/////////////////////////////////////////////
/datum/effect/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/effect/smoke/chem
	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density
	var/show_log = 1
	var/show_touch_log = 0 // will show an admin log if the smoke cloud touches someone
	var/duration = 20//time smoke lasts, in deciseconds

/datum/effect/effect/system/smoke_spread/chem/spores
	show_log = 0
	var/datum/seed/seed

/datum/effect/effect/system/smoke_spread/chem/spores/New(seed_name)
	if(seed_name && SSplants)
		seed = SSplants.seeds[seed_name]
	if(!seed)
		qdel(src)
	..()

/datum/effect/effect/system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	chemholder.create_reagents(500)

//Sets up the chem smoke effect
// Calculates the max range smoke can travel, then gets all turfs in that view range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to make
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
/datum/effect/effect/system/smoke_spread/chem/set_up(var/datum/reagents/carry = null, n = 10, c = 0, loca, var/new_duration = 20 )
	range = n * 0.3
	cardinals = c
	duration = new_duration
	carry.trans_to_obj(chemholder, carry.total_volume, copy = 1)

	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(!location)
		return

	targetTurfs = new()

	var/list/mob/touched_mobs = list()

	//build affected area list
	for(var/turf/T in view(range, location))
		//cull turfs to circle
		if(sqrt((T.x - location.x)**2 + (T.y - location.y)**2) <= range)
			targetTurfs += T
		// populates a list of mobs in the smoke for logs
		if (show_touch_log)
			for (var/mob/living/carbon/human/MT in T.contents)
				if (MT.client)
					touched_mobs += get_mob_by_key(MT.ckey)

	wallList = new()

	smokeFlow() //pathing check

	//set the density of the cloud - for diluting reagents
	density = max(1, targetTurfs.len / 4) //clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = carry.get_reagents()
	var/area/A = get_area(location)

	var/where = "[A.name] | [location.x], [location.y]"
	var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

	if(show_log)
		if(carry.my_atom.fingerprintslast)
			var/mob/M = get_mob_by_key(carry.my_atom.fingerprintslast)
			var/more = ""
			if(M)
				more = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</a>)"
			message_admins("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.fingerprintslast][more].", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.fingerprintslast].",ckey=key_name(M))
		else
			message_admins("A chemical smoke reaction has taken place in ([whereLink]). No associated key.", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")
	else if (show_touch_log && touched_mobs.len)
		var/mobnames = ""
		if (touched_mobs.len > 1)
			mobnames += "Affected players: "
			var/i = 1
			do
				mobnames += "<A HREF='?_src_=holder;adminmoreinfo=\ref[touched_mobs[i]]'>?</a>"
				if (touched_mobs[i+1])
					mobnames += ", "
				i++
			while (touched_mobs[i])
			mobnames += "."
		else mobnames += "Affected player: [touched_mobs[1]]."
		var/containing = ""
		if (contained)
			containing += ", containing [contained]"
		message_admins("Chemical smoke[containing] has been released ([whereLink]). [mobnames]", 0, 1)
		log_game("Chemical smoke[containing] has been released ([where]). Affected: [english_list(touched_mobs, "Nobody affected.")]")

//Runs the chem smoke effect
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the moment).
// Also calculates target locations to spawn the visual smoke effect on, so the whole area
// is covered fairly evenly.
/datum/effect/effect/system/smoke_spread/chem/start()
	if(!location)
		return

	if(LAZYLEN(chemholder.reagents.reagent_volumes)) //reagent application - only run if there are extra reagents in the smoke
		for(var/turf/T in wallList)
			chemholder.reagents.touch_turf(T)
		for(var/turf/T in targetTurfs)
			chemholder.reagents.touch_turf(T)
			for(var/atom/A in T.contents)
				if(istype(A, /obj/effect/effect/smoke/chem) || istype(A, /mob))
					continue
				else if(isobj(A) && !A.simulated)
					chemholder.reagents.touch_obj(A)

	var/color = chemholder.reagents.get_color() //build smoke icon
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi')
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")

	//Calculate smoke duration

	var/pressure = 0
	var/datum/gas_mixture/environment = location.return_air()
	if(environment) pressure = environment.return_pressure()
	duration = between(5, (duration*pressure)/(ONE_ATMOSPHERE), duration*2)

	var/const/arcLength = 2.3559 //distance between each smoke cloud

	for(var/i = 0, i < range, i++) //calculate positions for smoke coverage - then spawn smoke
		var/radius = i * 1.5
		if(!radius)
			spawn(0)
				spawnSmoke(location, I, duration, 1)
			continue

		var/offset = 0
		var/points = round((radius * 2 * M_PI) / arcLength)
		var/angle = round(ToDegrees(arcLength / radius), 1)

		if(!IsInteger(radius))
			offset = 45		//degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/T = locate(x,y,location.z)
			if(!T)
				continue
			if(T in targetTurfs)
				spawn(0)
					spawnSmoke(T, I, duration)

/datum/effect/effect/system/smoke_spread/chem/spores/start()
	..()
	if(seed.get_trait(TRAIT_SPREAD))
		var/sporecount = 0
		for(var/turf/T in targetTurfs)
			var/bad_turf = 0
			for(var/obj/O in T)
				if(O.density || istype(O, /obj/machinery/portable_atmospherics/hydroponics))
					bad_turf = 1
					break
			if(bad_turf)
				continue
			if(prob(min(seed.get_trait(TRAIT_POTENCY), 50)))
				new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(T,seed)
				sporecount++
			if(sporecount < max(1, round(seed.get_trait(TRAIT_POTENCY) / 20), 1))
				break


//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/proc/spawnSmoke(var/turf/T, var/icon/I, var/smoke_duration, var/dist = 1, var/splash_initial=0, var/obj/effect/effect/smoke/chem/passed_smoke)

	var/obj/effect/effect/smoke/chem/smoke
	if(passed_smoke)
		smoke = passed_smoke
	else
		smoke = new /obj/effect/effect/smoke/chem(location, smoke_duration + rand(smoke_duration*-0.25, smoke_duration*0.25), T, I)

	if(LAZYLEN(chemholder?.reagents?.reagent_volumes))
		chemholder.reagents.trans_to_obj(smoke, chemholder.reagents.total_volume / dist, copy = 1) //copy reagents to the smoke so mob/breathe() can handle inhaling the reagents

	//Kinda ugly, but needed unless the system is reworked
	if(splash_initial)
		smoke.initial_splash()


/datum/effect/effect/system/smoke_spread/chem/spores/spawnSmoke(var/turf/T, var/icon/I, var/smoke_duration, var/dist = 1)
	var/obj/effect/effect/smoke/chem/spores = new /obj/effect/effect/smoke/chem(location)
	spores.name = "cloud of [seed.seed_name] [seed.seed_noun]"
	..(T, I, smoke_duration, dist, spores)


/datum/effect/effect/system/smoke_spread/chem/proc/smokeFlow() // Smoke pathfinder. Uses a flood fill method based on zones to quickly check what turfs the smoke (airflow) can actually reach.

	var/list/pending = new()
	var/list/complete = new()

	pending += location

	while(pending.len)
		for(var/turf/current in pending)
			for(var/D in cardinal)
				var/turf/target = get_step(current, D)
				if(wallList)
					if(istype(target, /turf/simulated/wall))
						if(!(target in wallList))
							wallList += target
						continue

				if(target in pending)
					continue
				if(target in complete)
					continue
				if(!(target in targetTurfs))
					continue
				if(current.c_airblock(target)) //this is needed to stop chemsmoke from passing through thin window walls
					continue
				if(target.c_airblock(current))
					continue
				pending += target

			pending -= current
			complete += current

	targetTurfs = complete

	return
