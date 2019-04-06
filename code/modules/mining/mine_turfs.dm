/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = 1
	gender = PLURAL

// This is a global list so we can share the same list with all mineral turfs; it's the same for all of them anyways.
var/list/mineral_can_smooth_with = list(
	/turf/simulated/mineral,
	/turf/simulated/wall,
	/turf/unsimulated/wall,
	/turf/simulated/shuttle
)

// Some extra types for the surface to keep things pretty.
/turf/simulated/mineral/surface
	mined_turf = /turf/simulated/floor/asteroid/ash

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/map_placeholders.dmi'
	icon_state = "rock"
	desc = "It's a greyish rock. Exciting."
	gender = PLURAL
	var/icon/actual_icon = 'icons/turf/smooth/rock_wall.dmi'
	layer = 2.01

	// canSmoothWith is set in Initialize().
	smooth = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE

	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/simulated/floor/asteroid/ash/rocky
	var/ore/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/archaeo_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find

	var/obj/effect/mineral/my_mineral

	var/rock_health = 20 //10 to 20, in initialize

	has_resources = 1

/turf/simulated/mineral/proc/kinetic_hit(var/damage,var/direction)

	rock_health -= damage

	if(rock_health <= 0)
		var/turf/simulated/mineral/next_rock = get_step(src,direction)
		if(istype(next_rock))
			new /obj/effect/overlay/temp/kinetic_blast(next_rock)
			next_rock.kinetic_hit(-rock_health,direction)
		GetDrilled(1)

// Copypaste parent call for performance.
/turf/simulated/mineral/Initialize(mapload)
	if (initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	if (icon != actual_icon)
		icon = actual_icon

	initialized = TRUE

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	has_opaque_atom = TRUE

	if (smooth)
		canSmoothWith = mineral_can_smooth_with
		pixel_x = -4
		pixel_y = -4
		queue_smooth(src)

	if (!mapload)
		queue_smooth_neighbors(src)

	rock_health = rand(10,20)

	return INITIALIZE_HINT_NORMAL

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

/turf/simulated/mineral/CollidedWith(AM)
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

#define SPREAD(the_dir) \
	if (prob(mineral.spread_chance)) {                              \
		var/turf/simulated/mineral/target = get_step(src, the_dir); \
		if (istype(target) && !target.mineral) {                    \
			target.mineral = mineral;                               \
			target.UpdateMineral();                                 \
			target.MineralSpread();                                 \
		}                                                           \
	}

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral && mineral.spread)
		SPREAD(NORTH)
		SPREAD(SOUTH)
		SPREAD(EAST)
		SPREAD(WEST)

#undef SPREAD

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

	if (!usr.IsAdvancedToolUser())
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
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
		user.visible_message("<span class='notice'>[user] extends [P] towards [src].</span>","<span class='notice'>You extend [P] towards [src].</span>")
		if(do_after(user,25))
			if (!istype(src, /turf/simulated/mineral))
				return

			user << "<span class='notice'>\icon[P] [src] has been excavated to a depth of [2*excavation_level]cm.</span>"
		return

	if (istype(W, /obj/item/weapon/pickaxe) && W.simulated)	// Pickaxe offhand is not simulated.
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		var/obj/item/weapon/pickaxe/P = W
		if(last_act + P.digspeed > world.time)//prevents message spam
			return

		if(P.drilling)
			return

		last_act = world.time

		playsound(user, P.drill_sound, 20, 1)
		P.drilling = 1

		//handle any archaeological finds we might uncover
		var/fail_message
		if(finds && finds.len)
			var/datum/find/F = finds[1]
			if(excavation_level + P.excavation_amount > F.excavation_required)
				//Chance to destroy / extract any finds here
				fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"

		if(fail_message)
			user << "<span class='warning'>You start [P.drill_verb][fail_message ? fail_message : ""].</span>"

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(5, finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		if(do_after(user,P.digspeed))
			if (!istype(src, /turf/simulated/mineral))
				return

			P.drilling = 0

			if(prob(50))
				var/obj/item/weapon/ore/O
				if(prob(25) && (mineral) && (P.excavation_amount >= 30))
					O = new mineral.ore (src)
				else
					O = new /obj/item/weapon/ore(src)
				if(istype(O))
					geologic_data.UpdateNearbyArtifactInfo(src)
					O.geologic_data = geologic_data
				addtimer(CALLBACK(O, /atom/movable/.proc/forceMove, user.loc), 1)

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
			/*if(!archaeo_overlay && finds && finds.len)
				var/datum/find/F = finds[1]
				if(F.excavation_required <= excavation_level + F.view_range)
					archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					add_overlay(archaeo_overlay)*/

		else
			user << "<span class='notice'> You stop [P.drill_verb] [src].</span>"
			P.drilling = 0

	if (istype(W, /obj/item/weapon/autochisel))

		if(last_act + 80 > world.time)//prevents message spam
			return
		last_act = world.time

		user << "<span class='warning'>You start chiselling [src] into a sculptable block.</span>"

		if(!do_after(user,80))
			return

		if (!istype(src, /turf/simulated/mineral))
			return

		user << "<span class='notice'>You finish chiselling [src] into a sculptable block.</span>"
		new /obj/structure/sculpting_block(src)
		GetDrilled(1)

/turf/simulated/mineral/proc/clear_ore_effects()
	if (my_mineral)
		qdel(my_mineral)

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
			M.apply_effect(25, IRRADIATE, blocked = M.getarmor(null, "rad"))
			if(prob(3))
				excavate_find(prob(5), finds[1])

	//Add some rubble,  you did just clear out a big chunk of rock.

	ChangeTurf(mined_turf)

	if(rand(1,500) == 1)
		visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
		new /obj/structure/closet/crate/secure/loot(src)

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
				visible_message("<span class='danger'>[pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</span>")
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
		ORE_URANIUM = 2,
		ORE_PLATINUM = 2,
		ORE_IRON = 8,
		ORE_COAL = 8,
		ORE_DIAMOND = 1,
		ORE_GOLD = 2,
		ORE_SILVER = 2,
		ORE_PHORON = 5
	)
	var/mineralChance = 55

/turf/simulated/mineral/random/Initialize()
	if (prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name
		if (mineral_name && (mineral_name in ore_data))
			mineral = ore_data[mineral_name]
			UpdateMineral()
		MineralSpread()

	. = ..()

/turf/simulated/mineral/random/high_chance
	mineralSpawnChanceList = list(
		ORE_URANIUM = 2,
		ORE_PLATINUM = 2,
		ORE_IRON = 2,
		ORE_COAL = 2,
		ORE_DIAMOND = 1,
		ORE_GOLD = 2,
		ORE_SILVER = 2,
		ORE_PHORON = 3
	)
	mineralChance = 55

/turf/simulated/mineral/random/higher_chance
	mineralSpawnChanceList = list(
		ORE_URANIUM = 3,
		ORE_PLATINUM = 3,
		ORE_IRON = 1,
		ORE_COAL = 1,
		ORE_DIAMOND = 1,
		ORE_GOLD = 3,
		ORE_SILVER = 3,
		ORE_PHORON = 2
	)
	mineralChance = 75

/turf/simulated/mineral/attack_hand(var/mob/user)
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(ishuman(user) && user.a_intent == I_GRAB)
		var/mob/living/carbon/human/H = user
		var/turf/destination = GetAbove(H)

		if(destination)
			var/turf/start = get_turf(H)
			if(start.CanZPass(H, UP))
				if(destination.CanZPass(H, UP))
					H.climb(UP, src, 20)

/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "coder's blight"
	icon = 'icons/turf/map_placeholders.dmi'
	icon_state = ""
	desc = "An exposed developer texture. Someone wasn't paying attention."
	smooth = SMOOTH_FALSE
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	gender = PLURAL
	base_icon = 'icons/turf/map_placeholders.dmi'
	base_icon_state = "ash"

	initial_flooring = null
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	var/dug = 0 //Increments by 1 everytime it's dug. 11 is the last integer that should ever be here.
	var/digging
	has_resources = 1
	footstep_sound = "gravelstep"

	roof_type = null

// Same as the other, this is a global so we don't have a lot of pointless lists floating around.
// Basalt is explicitly omitted so ash will spill onto basalt turfs.
var/list/asteroid_floor_smooth = list(
	/turf/simulated/floor/asteroid/ash,
	/turf/simulated/mineral,
	/turf/simulated/wall,
	/turf/simulated/shuttle
)

// Copypaste parent for performance.
/turf/simulated/floor/asteroid/Initialize(mapload)
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE

	if (icon != base_icon)	// Setting icon is an appearance change, so avoid it if we can.
		icon = base_icon

	base_desc = desc
	base_name = name

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (mapload && permit_ao)
		queue_ao()

	if (smooth)
		canSmoothWith = asteroid_floor_smooth
		pixel_x = -4
		pixel_y = -4
		queue_smooth(src)

	if (!mapload)
		queue_smooth_neighbors(src)

	if (light_range && light_power)
		update_light()

	return INITIALIZE_HINT_NORMAL

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

	var/static/list/usable_tools = typecacheof(list(
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe/diamonddrill,
		/obj/item/weapon/pickaxe/drill,
		/obj/item/weapon/pickaxe/borgdrill
	))

	if(is_type_in_typecache(W, usable_tools))
		var/turf/T = user.loc
		if (!(istype(T)))
			return
		if(digging)
			return
		if(dug)
			if(!GetBelow(src))
				return
			user << "<span class='warning'>You start digging deeper.</span>"
			playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
			digging = 1
			if(!do_after(user, 60))
				if (istype(src, /turf/simulated/floor/asteroid))
					digging = 0
				return

			// Turfs are special. They don't delete. So we need to check if it's
			// still the same turf as before the sleep.
			if (!istype(src, /turf/simulated/floor/asteroid))
				return

			playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
			if(prob(33))
				switch(dug)
					if(1)
						user << "<span class='notice'>You've made a little progress.</span>"
					if(2)
						user << "<span class='notice'>You notice the hole is a little deeper.</span>"
					if(3)
						user << "<span class='notice'>You think you're about halfway there.</span>"
					if(4)
						user << "<span class='notice'>You finish up lifting another pile of dirt.</span>"
					if(5)
						user << "<span class='notice'>You dig a bit deeper. You're definitely halfway there now.</span>"
					if(6)
						user << "<span class='notice'>You still have a ways to go.</span>"
					if(7)
						user << "<span class='notice'>The hole looks pretty deep now.</span>"
					if(8)
						user << "<span class='notice'>The ground is starting to feel a lot looser.</span>"
					if(9)
						user << "<span class='notice'>You can almost see the other side.</span>"
					if(10)
						user << "<span class='notice'>Just a little deeper. . .</span>"
					else
						user << "<span class='notice'>You penetrate the virgin earth!</span>"
			else
				if(dug <= 10)
					user << "<span class='notice'>You dig a little deeper.</span>"
				else
					user << "<span class='notice'>You dug a big hole.</span>"

			gets_dug(user)
			digging = 0
			return

		user << "<span class='warning'>You start digging.</span>"
		playsound(user.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)

		digging = 1
		if(!do_after(user,40))
			if (istype(src, /turf/simulated/floor/asteroid))
				digging = 0
			return

		// Turfs are special. They don't delete. So we need to check if it's
		// still the same turf as before the sleep.
		if (!istype(src, /turf/simulated/floor/asteroid))
			return

		user << "<span class='notice'> You dug a hole.</span>"
		digging = 0

		gets_dug(user)

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

/turf/simulated/floor/asteroid/proc/gets_dug(mob/user)

	add_overlay("asteroid_dug", TRUE)

	if(prob(75))
		new /obj/item/weapon/ore/glass(src)

	if(prob(25) && has_resources)
		var/list/ore = list()
		for(var/metal in resources)
			switch(metal)
				if("silicates")
					ore += /obj/item/weapon/ore/glass
				if("carbonaceous rock")
					ore += /obj/item/weapon/ore/coal
				if("iron")
					ore += /obj/item/weapon/ore/iron
				if("gold")
					ore += /obj/item/weapon/ore/gold
				if("silver")
					ore += /obj/item/weapon/ore/silver
				if("diamond")
					ore += /obj/item/weapon/ore/diamond
				if("uranium")
					ore += /obj/item/weapon/ore/uranium
				if("phoron")
					ore += /obj/item/weapon/ore/phoron
				if("osmium")
					ore += /obj/item/weapon/ore/osmium
				if("hydrogen")
					ore += /obj/item/weapon/ore/hydrogen
				else
					if(prob(25))
						switch(rand(1,5))
							if(1)
								ore += /obj/random/junk
							if(2)
								ore += /obj/random/powercell
							if(3)
								ore += /obj/random/coin
							if(4)
								ore += /obj/random/loot
							if(5)
								ore += /obj/item/weapon/ore/glass
					else
						ore += /obj/item/weapon/ore/glass
		if (ore.len)
			var/ore_path = pick(ore)
			if(ore)
				new ore_path(src)

	if(dug <= 10)
		dug += 1
		add_overlay("asteroid_dug", TRUE)
	else
		var/turf/below = GetBelow(src)
		if(below)
			var/area/below_area = below.loc		// Let's just assume that the turf is not in nullspace.
			if(below_area.station_area)
				if (user)
					user << "<span class='alert'>You strike metal!</span>"
				below.spawn_roof(ROOF_FORCE_SPAWN)
			else
				ChangeTurf(/turf/space)

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


/turf/simulated/mineral/Destroy()
	clear_ore_effects()
	. = ..()
