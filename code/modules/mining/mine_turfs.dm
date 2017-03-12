/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = 1

/turf/simulated/mineral //wall piece
	name = "Rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/simulated/floor/asteroid
	var/ore/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find

	has_resources = 1

/turf/simulated/mineral/New()
	spawn(0)
		MineralSpread()
	spawn(2)
		updateMineralOverlays(1)

/turf/simulated/mineral/proc/updateMineralOverlays(var/update_neighbors)
	var/list/step_overlays = list("s" = NORTH, "n" = SOUTH, "w" = EAST, "e" = WEST)
	for(var/direction in step_overlays)
		var/turf/turf_to_check = get_step(src,step_overlays[direction])
		if(update_neighbors && istype(turf_to_check,/turf/simulated/floor/asteroid))
			var/turf/simulated/floor/asteroid/T = turf_to_check
			T.updateMineralOverlays()
		else if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor))
			turf_to_check.overlays += image('icons/turf/walls.dmi', "rock_side", dir = turn(step_overlays[direction], 180))

/turf/simulated/mineral/examine(mob/user)
	..()
	if(mineral)
		switch(mined_ore)
			if(0)
				user << "<span class='info'>It is ripe with [mineral.display_name].</span>"
			if(1)
				user << "<span class='info'>Its [mineral.display_name] looks a little depleted.</span>"
			if(2)
				user << "<span class='warning'>Its [mineral.display_name] looks very depleted!</span>"
	else
		user << "<span class='info'>It is devoid of any valuable minerals.</span>"
	switch(emitter_blasts_taken)
		if(0)
			user << "<span class='info'>It is in pristine condition.</span>"
		if(1)
			user << "<span class='info'>It appears a little damaged.</span>"
		if(2)
			user << "<span class='warning'>It is crumbling!</span>"
		if(3)
			user << "<span class='danger'>It looks ready to collapse at any moment!</span>"

/turf/simulated/mineral/ex_act(severity)
	switch(severity)
		if(2.0)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
			else
				emitter_blasts_taken += 2
		if(1.0)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj)

	// Emitter blasts
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		emitter_blasts_taken++

	if(emitter_blasts_taken > 2) // 3 blasts per tile
		GetDrilled()

/turf/simulated/mineral/Bumped(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
			var/obj/item/weapon/pickaxe/P = H.l_hand
			if(P.autodrill)
				attackby(H.l_hand,H)

		else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
			var/obj/item/weapon/pickaxe/P = H.r_hand
			if(P.autodrill)
				attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/pickaxe))
			attackby(R.module_active,R)

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.selected.action(src)

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral && mineral.spread)
		for(var/trydir in cardinal)
			if(prob(mineral.spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && !target_turf.mineral)
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()


/turf/simulated/mineral/proc/UpdateMineral()
	clear_ore_effects()
	if(!mineral)
		name = "\improper Rock"
		icon_state = "rock"
		return
	name = "\improper [mineral.display_name] deposit"
	new /obj/effect/mineral(src, mineral)

//Not even going to touch this pile of spaghetti
/turf/simulated/mineral/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	if (istype(W, /obj/item/device/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
		return

	if (istype(W, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = W
		C.scan_atom(user, src)
		return

	if (istype(W, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = W
		user.visible_message("\blue[user] extends [P] towards [src].","\blue You extend [P] towards [src].")
		if(do_after(user,25))
			user << "\blue \icon[P] [src] has been excavated to a depth of [2*excavation_level]cm."
		return

	if (istype(W, /obj/item/weapon/pickaxe))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		var/obj/item/weapon/pickaxe/P = W
		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time

		playsound(user, P.drill_sound, 20, 1)

		//handle any archaeological finds we might uncover
		var/fail_message
		if(finds && finds.len)
			var/datum/find/F = finds[1]
			if(excavation_level + P.excavation_amount > F.excavation_required)
				//Chance to destroy / extract any finds here
				fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"

		user << "\red You start [P.drill_verb][fail_message ? fail_message : ""]."

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(5, finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		if(do_after(user,P.digspeed))
			user << "\blue You finish [P.drill_verb] the rock."

			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(round(excavation_level + P.excavation_amount) == F.excavation_required)
					//Chance to extract any items here perfectly, otherwise just pull them out along with the rock surrounding them
					if(excavation_level + P.excavation_amount > F.excavation_required)
						//if you can get slightly over, perfect extraction
						excavate_find(100, F)
					else
						excavate_find(80, F)

				else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)
					//just pull the surrounding rock out
					excavate_find(0, F)

			if( excavation_level + P.excavation_amount >= 100 )
				//if players have been excavating this turf, leave some rocky debris behind
				var/obj/structure/boulder/B
				if(artifact_find)
					if( excavation_level > 0 || prob(15) )
						//boulder with an artifact inside
						B = new(src)
						if(artifact_find)
							B.artifact_find = artifact_find
					else
						artifact_debris(1)
				else if(prob(15))
					//empty boulder
					B = new(src)

				if(B)
					GetDrilled(0)
				else
					GetDrilled(1)
				return

			excavation_level += P.excavation_amount

			//archaeo overlays
			if(!archaeo_overlay && finds && finds.len)
				var/datum/find/F = finds[1]
				if(F.excavation_required <= excavation_level + F.view_range)
					archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					overlays += archaeo_overlay

			//there's got to be a better way to do this
			var/update_excav_overlay = 0
			if(excavation_level >= 75)
				if(excavation_level - P.excavation_amount < 75)
					update_excav_overlay = 1
			else if(excavation_level >= 50)
				if(excavation_level - P.excavation_amount < 50)
					update_excav_overlay = 1
			else if(excavation_level >= 25)
				if(excavation_level - P.excavation_amount < 25)
					update_excav_overlay = 1

			//update overlays displaying excavation level
			if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
				var/excav_quadrant = round(excavation_level / 25) + 1
				excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
				overlays += excav_overlay

			//drop some rocks
			next_rock += P.excavation_amount * 10
			while(next_rock > 100)
				next_rock -= 100
				var/obj/item/weapon/ore/O = new(src)
				geologic_data.UpdateNearbyArtifactInfo(src)
				O.geologic_data = geologic_data

	else
		return attack_hand(user)

/turf/simulated/mineral/proc/clear_ore_effects()
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/weapon/ore/O = new mineral.ore (src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)
	//var/destroyed = 0 //used for breaking strange rocks
	if (mineral && mineral.result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			M << "<font color='red'><b>[pick("A high pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</b></font>"
			if(pain)
				flick("pain",M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				flick("flash",M.flash)
				if(prob(50))
					M.Stun(5)
			M.apply_effect(25, IRRADIATE)
			if(prob(3))
				excavate_find(prob(5), finds[1])

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)

	//Add some rubble,  you did just clear out a big chunk of rock.

	var/turf/simulated/floor/asteroid/N = ChangeTurf(mined_turf)

	// Kill and update the space overlays around us.
	for(var/direction in step_overlays)
		var/turf/space/T = get_step(src, step_overlays[direction])
		if(istype(T))
			T.overlays.Cut()
			for(var/next_direction in step_overlays)
				if(istype(get_step(T, step_overlays[next_direction]),/turf/simulated/mineral))
					T.overlays += image('icons/turf/walls.dmi', "rock_side", dir = step_overlays[next_direction])

	if(rand(1,500) == 1)
		visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
		new /obj/structure/closet/crate/secure/loot(src)

	if(istype(N))
		N.overlay_detail = rand(0,9)
		N.updateMineralOverlays(1)

/turf/simulated/mineral/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/weapon/X
	if(prob_clean)
		X = new /obj/item/weapon/archaeological_find(src, new_item_type = F.find_type)
	else
		X = new /obj/item/weapon/ore/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		X:geologic_data = geologic_data

	//some find types delete the /obj/item/weapon/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S || S.field_type != get_responsive_reagent(F.find_type))
			if(X)
				visible_message("\red<b>[pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</b>")
				qdel(X)

	finds.Remove(F)


/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented not-fucking-retarded overhaul!

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/rods/R = new(src)
				R.amount = rand(5,25)

			if(2)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(3)
				var/obj/item/stack/material/steel/R = new(src)
				R.amount = rand(5,25)

			if(4)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(5)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/weapon/material/shard(src)

			if(6)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/weapon/material/shard/phoron(src)

			if(7)
				var/obj/item/stack/material/uranium/R = new(src)
				R.amount = rand(5,25)

/turf/simulated/mineral/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list(
		ORE_URANIUM = 5,
		ORE_PLATINUM = 5,
		ORE_IRON = 35,
		ORE_COAL = 35,
		ORE_DIAMOND = 1,
		ORE_GOLD = 5,
		ORE_SILVER = 5,
		ORE_PHORON = 10
	)
	var/mineralChance = 15

/turf/simulated/mineral/random/New()
	if (prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name
		if (mineral_name && (mineral_name in ore_data))
			mineral = ore_data[mineral_name]
			UpdateMineral()

	. = ..()

/turf/simulated/mineral/random/high_chance
	mineralSpawnChanceList = list(
		ORE_URANIUM = 10,
		ORE_PLATINUM = 10,
		ORE_IRON = 25,
		ORE_COAL = 25,
		ORE_DIAMOND = 5,
		ORE_GOLD = 10,
		ORE_SILVER = 10,
		ORE_PHORON = 30
	)
	mineralChance = 30

/turf/simulated/mineral/random/higher_chance
	mineralSpawnChanceList = list(
		ORE_URANIUM = 15,
		ORE_PLATINUM = 15,
		ORE_IRON = 15,
		ORE_COAL = 15,
		ORE_DIAMOND = 10,
		ORE_GOLD = 15,
		ORE_SILVER = 15,
		ORE_PHORON = 15
	)
	mineralChance = 50



/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"

	initial_flooring = null
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	var/dug = 0 //Increments by 1 everytime it's dug. 11 is the last integer that should ever be here.
	var/overlay_detail
	var/static/list/overlay_cache
	has_resources = 1
	footstep_sound = "gravelstep"

/turf/simulated/floor/asteroid/New()

	if(prob(20))
		overlay_detail = rand(0,9)

/turf/simulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if (prob(70))
				dug += rand(4,10)
				gets_dug()
			else
				dug += rand(1,3)
				gets_dug()
		if(1.0)
			if(prob(30))
				dug = 11
				gets_dug()
			else
				dug += rand(4,11)
				gets_dug()
	return

/turf/simulated/floor/asteroid/is_plating()
	return 0

/turf/simulated/floor/asteroid/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(!W || !user)
		return 0

	if (istype(W, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = W
		if (R.use(1))
			user << "<span class='notice'>Constructing support lattice ...</span>"
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(W, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = W
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			user << "<span class='warning'>The plating is going to need some support.</span>"
			return

	var/list/usable_tools = list(
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe/diamonddrill,
		/obj/item/weapon/pickaxe/drill,
		/obj/item/weapon/pickaxe/borgdrill
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		var/turf/T = user.loc
		if (!(istype(T)))
			return

		if (dug)
			if(!GetBelow(src))
				return
			user << "<span class='warning'> You start digging deeper.</span>"
			playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
			if(!do_after(user,60))
				return
			playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
			if(prob(33))
				switch(dug)
					if(1)
						user << "<span class='notice'> You've made a little progress.</span>"
					if(2)
						user << "<span class='notice'> You notice the hole is a little deeper.</span>"
					if(3)
						user << "<span class='notice'> You think you're about halfway there.</span>"
					if(4)
						user << "<span class='notice'> You finish up lifting another pile of dirt.</span>"
					if(5)
						user << "<span class='notice'> You dig a bit deeper. You're definitely halfway there now.</span>"
					if(6)
						user << "<span class='notice'> You still have a ways to go.</span>"
					if(7)
						user << "<span class='notice'> The hole looks pretty deep now.</span>"
					if(8)
						user << "<span class='notice'> The ground is starting to feel a lot looser.</span>"
					if(9)
						user << "<span class='notice'> You can almost see the other side.</span>"
					if(10)
						user << "<span class='notice'> Just a little deeper. . .</span>"
					else
						user << "<span class='notice'> You penetrate the virgin earth!</span>"
			else
				if(dug <= 10)
					user << "<span class='notice'> You dig a little deeper.</span>"
				else
					user << "<span class='notice'> You dug a big hole.</span>"

			gets_dug()
			return

		user << "<span class='warning'> You start digging.</span>"
		playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)

		if(!do_after(user,40))
			return

		user << "<span class='notice'> You dug a hole.</span>"
		gets_dug()

	else if(istype(W,/obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/ore/O in contents)
				O.attackby(W,user)
				return
	else if(istype(W,/obj/item/weapon/storage/bag/fossils))
		var/obj/item/weapon/storage/bag/fossils/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/fossil/F in contents)
				F.attackby(W,user)
				return

	else
		..(W,user)
	return

/turf/simulated/floor/asteroid/proc/gets_dug()

	icon_state = "asteroid_dug"

	new/obj/item/weapon/ore/glass(src)

	if(prob(50))
		var/list/ore = list(/obj/item/weapon/ore/coal = 8,
		/obj/item/weapon/ore/iron = 6,
		/obj/item/weapon/ore/phoron = 3,
		/obj/item/weapon/ore/silver = 3,
		/obj/item/weapon/ore/gold = 2,
		/obj/item/weapon/ore/osmium = 3,
		/obj/item/weapon/ore/hydrogen = 2,
		/obj/item/weapon/ore/uranium = 1,
		/obj/random/junk = 1,
		/obj/item/weapon/ore/diamond = 0.5,
		/obj/random/powercell = 0.2,
		/obj/random/coin = 0.2,
		/obj/random/loot = 0.1,
		/obj/random/action_figure = 0.1)
		var/ore_path = pickweight(ore)
		if(ore)
			new ore_path(src)
			user << "<span class='notice'>You unearth something amidst the sand!<span>"

	if(dug <= 10)
		dug += 1
	else
		if(GetBelow(src))
			ChangeTurf(/turf/simulated/open)
	return

/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(istype(get_step(src, step_overlays[direction]), /turf/space))
			overlays += image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays[direction])

		if(istype(get_step(src, step_overlays[direction]), /turf/simulated/mineral))
			overlays += image('icons/turf/walls.dmi', "rock_side", dir = step_overlays[direction])

	if (!overlay_cache)
		overlay_cache = list()
		overlay_cache.len = 10
		for (var/i = 1; i <= overlay_cache.len; i++)
			overlay_cache[i] = image('icons/turf/flooring/decals.dmi', "asteroid[i - 1]")

	if(overlay_detail) 
		overlays += overlay_cache[overlay_detail + 1]

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()

/turf/simulated/floor/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			if(istype(R.module_state_1,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/weapon/storage/bag/ore))
				attackby(R.module_state_3,R)
			else
				return
