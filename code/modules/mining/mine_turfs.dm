/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = TRUE
	density = TRUE
	gender = PLURAL
	opacity = TRUE

// This is a global list so we can share the same list with all mineral turfs; it's the same for all of them anyways.
var/list/mineral_can_smooth_with = list(
	/turf/simulated/mineral,
	/turf/simulated/wall,
	/turf/unsimulated/wall
)

// Some extra types for the surface to keep things pretty.
/turf/simulated/mineral/surface
	mined_turf = /turf/unsimulated/floor/asteroid/ash

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
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	temperature = T0C
	var/mined_turf = /turf/unsimulated/floor/asteroid/ash/rocky
	var/ore/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/archaeo_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find

	var/obj/effect/mineral/my_mineral

	var/rock_health = 20 //10 to 20, in initialize

	has_resources = TRUE

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
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	if(icon != actual_icon)
		icon = actual_icon

	initialized = TRUE

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	has_opaque_atom = TRUE

	if(smooth)
		canSmoothWith = mineral_can_smooth_with
		pixel_x = -4
		pixel_y = -4
		queue_smooth(src)

	if(!mapload)
		queue_smooth_neighbors(src)

	rock_health = rand(10,20)

	return INITIALIZE_HINT_NORMAL

/turf/simulated/mineral/examine(mob/user)
	..()
	if(mineral)
		switch(mined_ore)
			if(0)
				to_chat(user, span("info", "It is ripe with [mineral.display_name]."))
			if(1)
				to_chat(user, span("info", "Its [mineral.display_name] looks a little depleted."))
			if(2)
				to_chat(user, span("info", "Its [mineral.display_name] looks very depleted!"))
	else
		to_chat(user, span("info", "It is devoid of any valuable minerals."))
	switch(emitter_blasts_taken)
		if(0)
			to_chat(user, span("info", "It is in pristine condition."))
		if(1)
			to_chat(user, span("info", "It appears a little damaged."))
		if(2)
			to_chat(user, span("info", "It is crumbling!"))
		if(3)
			to_chat(user, span("info", "It looks ready to collapse at any moment!"))

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
		if((istype(H.l_hand,/obj/item/pickaxe)) && (!H.hand))
			var/obj/item/pickaxe/P = H.l_hand
			if(P.autodrill)
				attackby(H.l_hand,H)

		else if((istype(H.r_hand,/obj/item/pickaxe)) && H.hand)
			var/obj/item/pickaxe/P = H.r_hand
			if(P.autodrill)
				attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			attackby(R.module_active,R)

//For use in non-station z-levels as decoration.
/turf/unsimulated/mineral/asteroid
	name = "rock"
	icon = 'icons/turf/map_placeholders.dmi'
	icon_state = "rock"
	desc = "It's a greyish rock. Exciting."
	opacity = TRUE
	var/icon/actual_icon = 'icons/turf/smooth/rock_wall.dmi'
	layer = 2.01
	var/list/asteroid_can_smooth_with = list(
		/turf/unsimulated/mineral,
		/turf/unsimulated/mineral/asteroid
	)
	smooth = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE

/turf/unsimulated/mineral/asteroid/Initialize(mapload)
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	if(icon != actual_icon)
		icon = actual_icon

	initialized = TRUE

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	has_opaque_atom = TRUE

	if(smooth)
		canSmoothWith = asteroid_can_smooth_with
		pixel_x = -4
		pixel_y = -4
		queue_smooth(src)

	if(!mapload)
		queue_smooth_neighbors(src)

	return INITIALIZE_HINT_NORMAL

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

//Not even going to touch this pile of spaghetti //motherfucker - geeves
/turf/simulated/mineral/attackby(obj/item/W, mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(istype(W, /obj/item/device/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src) // good god
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
		return

	if(istype(W, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = W
		C.scan_atom(user, src)
		return

	if(istype(W, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = W
		user.visible_message(SPAN_NOTICE("\The [user] extends \the [P] towards \the [src].") , SPAN_NOTICE("You extend \the [P] towards \the [src]."))
		if(do_after(user,25))
			if(!istype(src, /turf/simulated/mineral))
				return
			to_chat(user, SPAN_NOTICE("\icon[P] \The [src] has been excavated to a depth of [2 * excavation_level]cm."))
		return

	if(istype(W, /obj/item/pickaxe) && W.simulated)	// Pickaxe offhand is not simulated.
		var/turf/T = user.loc
		if(!(istype(T, /turf)))
			return
		var/obj/item/pickaxe/P = W
		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		if(P.drilling)
			return

		last_act = world.time

		playsound(user, P.drill_sound, 20, TRUE)
		P.drilling = TRUE

		//handle any archaeological finds we might uncover
		var/fail_message
		if(finds?.len)
			var/datum/find/F = finds[1]
			if(excavation_level + P.excavation_amount > F.excavation_required)
				//Chance to destroy / extract any finds here
				fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"

		if(fail_message)
			to_chat(user, SPAN_WARNING("You start [P.drill_verb][fail_message ? fail_message : ""]."))

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(5, finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		if(do_after(user,P.digspeed))
			if(!istype(src, /turf/simulated/mineral))
				return

			P.drilling = FALSE

			if(prob(50))
				var/obj/item/ore/O
				if(prob(25) && (mineral) && (P.excavation_amount >= 30))
					O = new mineral.ore(src)
				else
					O = new /obj/item/ore(src)
				if(istype(O))
					geologic_data.UpdateNearbyArtifactInfo(src)
					O.geologic_data = geologic_data
				addtimer(CALLBACK(O, /atom/movable/.proc/forceMove, user.loc), 1)

			if(finds?.len)
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

			if(excavation_level + P.excavation_amount >= 100)
				//if players have been excavating this turf, leave some rocky debris behind
				var/obj/structure/boulder/B
				if(artifact_find)
					if(excavation_level > 0 || prob(15))
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

		else
			to_chat(user, SPAN_NOTICE("You stop [P.drill_verb] \the [src]."))
			P.drilling = FALSE

	if(istype(W, /obj/item/autochisel))
		if(last_act + 80 > world.time)//prevents message spam
			return
		last_act = world.time

		to_chat(user, SPAN_NOTICE("You start chiselling \the [src] into a sculptable block."))

		if(!do_after(user, 80 / W.toolspeed))
			return

		if(!istype(src, /turf/simulated/mineral))
			return

		to_chat(user, SPAN_NOTICE("You finish chiselling [src] into a sculptable block."))
		new /obj/structure/sculpting_block(src)
		GetDrilled(1)

/turf/simulated/mineral/proc/clear_ore_effects()
	if(my_mineral)
		qdel(my_mineral)

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/ore/O = new mineral.ore(src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src) //whoever named this proc must be shot - geeves
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)
	if(mineral?.result_amount)
		//if the turf has already been excavated, some of it's ore has been removed
		for(var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	//Add some rubble, you did just clear out a big chunk of rock.
	ChangeTurf(mined_turf)

	if(rand(1,500) == 1)
		visible_message(SPAN_NOTICE("An old dusty crate was buried within!"))
		new /obj/structure/closet/crate/secure/loot(src)

/turf/simulated/mineral/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/X
	if(prob_clean)
		X = new /obj/item/archaeological_find(src, new_item_type = F.find_type)
	else
		X = new /obj/item/ore/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src) //AAAAAAAAAAAAAAAAAAAAAAAAAA
		X:geologic_data = geologic_data //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

	//some find types delete the /obj/item/archaeological_find and replace it with something else, this handles when that happens
	//yuck //yuck indeed.
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
				visible_message(SPAN_DANGER("[pick("[display_name] crumbles away into dust","[display_name] breaks apart")]."))
				qdel(X)

	finds.Remove(F)


/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/rods/R = new(src)
				R.amount = rand(5, 25)
			if(2)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5, 25)
			if(3)
				var/obj/item/stack/material/steel/R = new(src)
				R.amount = rand(5, 25)
			if(4)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5, 25)
			if(5)
				var/quantity = rand(1, 3)
				for(var/i = 0, i < quantity, i++)
					new /obj/item/material/shard/shrapnel(src)
			if(6)
				var/quantity = rand(1, 3)
				for(var/i = 0, i < quantity, i++)
					new /obj/item/material/shard/phoron(src)
			if(7)
				var/obj/item/stack/material/uranium/R = new(src)
				R.amount = rand(5, 25)

/turf/simulated/mineral/random
	name = "mineral deposit"
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
	if(prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name
		if(mineral_name && (mineral_name in ore_data))
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
/turf/unsimulated/floor/asteroid
	name = "coder's blight"
	icon = 'icons/turf/map_placeholders.dmi'
	icon_state = ""
	desc = "An exposed developer texture. Someone wasn't paying attention."
	smooth = SMOOTH_FALSE
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	gender = PLURAL
	base_icon = 'icons/turf/map_placeholders.dmi'
	base_icon_state = "ash"

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
	/turf/unsimulated/floor/asteroid/ash,
	/turf/simulated/mineral,
	/turf/simulated/wall
)

// Copypaste parent for performance.
/turf/unsimulated/floor/asteroid/Initialize(mapload)
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE

	if(icon != base_icon)	// Setting icon is an appearance change, so avoid it if we can.
		icon = base_icon

	base_desc = desc
	base_name = name

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if(mapload && permit_ao)
		queue_ao()

	if(smooth)
		canSmoothWith = asteroid_floor_smooth
		pixel_x = -4
		pixel_y = -4
		queue_smooth(src)

	if(!mapload)
		queue_smooth_neighbors(src)

	if(light_range && light_power)
		update_light()

	return INITIALIZE_HINT_NORMAL

/turf/unsimulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if(prob(70))
				dug += rand(4, 10)
				gets_dug() // who's dug
			else
				dug += rand(1, 3)
				gets_dug()
		if(1.0)
			if(prob(30))
				dug = 11
				gets_dug()
			else
				dug += rand(4,11)
				gets_dug()
	return

/turf/unsimulated/floor/asteroid/is_plating()
	return FALSE

/turf/unsimulated/floor/asteroid/attackby(obj/item/W, mob/user)
	if(!W || !user)
		return FALSE

	if(istype(W, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = W
		if(R.use(1))
			to_chat(user, SPAN_NOTICE("Constructing support lattice..."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if(istype(W, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = W
			if(S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, TRUE)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support.")) //turf psychiatrist lmaooo
			return

	var/static/list/usable_tools = typecacheof(list(
		/obj/item/shovel,
		/obj/item/pickaxe/diamonddrill,
		/obj/item/pickaxe/drill,
		/obj/item/pickaxe/borgdrill
	))

	if(is_type_in_typecache(W, usable_tools))
		var/turf/T = get_turf(user)
		if(!istype(T))
			return
		if(digging)
			return
		if(dug)
			if(!GetBelow(src))
				return
			to_chat(user, SPAN_NOTICE("You start digging deeper."))
			playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
			digging = TRUE
			if(!do_after(user, 60 / W.toolspeed))
				if(istype(src, /turf/unsimulated/floor/asteroid))
					digging = FALSE
				return

			// Turfs are special. They don't delete. So we need to check if it's
			// still the same turf as before the sleep.
			if(!istype(src, /turf/unsimulated/floor/asteroid))
				return

			playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
			if(prob(33))
				switch(dug)
					if(1)
						to_chat(user, SPAN_NOTICE("You've made a little progress."))
					if(2)
						to_chat(user, SPAN_NOTICE("You notice the hole is a little deeper."))
					if(3)
						to_chat(user, SPAN_NOTICE("You think you're about halfway there."))
					if(4)
						to_chat(user, SPAN_NOTICE("You finish up lifting another pile of dirt."))
					if(5)
						to_chat(user, SPAN_NOTICE("You dig a bit deeper. You're definitely halfway there now."))
					if(6)
						to_chat(user, SPAN_NOTICE("You still have a ways to go."))
					if(7)
						to_chat(user, SPAN_NOTICE("The hole looks pretty deep now."))
					if(8)
						to_chat(user, SPAN_NOTICE("The ground is starting to feel a lot looser."))
					if(9)
						to_chat(user, SPAN_NOTICE("You can almost see the other side."))
					if(10)
						to_chat(user, SPAN_NOTICE("Just a little deeper..."))
					else
						to_chat(user, SPAN_NOTICE("You penetrate the virgin earth!"))
			else
				if(dug <= 10)
					to_chat(user, SPAN_NOTICE("You dig a little deeper."))
				else
					to_chat(user, SPAN_NOTICE("You dug a big hole.")) // how ceremonious

			gets_dug(user)
			digging = 0
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

		digging = TRUE
		if(!do_after(user, 40))
			if(istype(src, /turf/unsimulated/floor/asteroid))
				digging = FALSE
			return

		// Turfs are special. They don't delete. So we need to check if it's
		// still the same turf as before the sleep.
		if(!istype(src, /turf/unsimulated/floor/asteroid))
			return

		to_chat(user, SPAN_NOTICE("You dug a hole."))
		digging = FALSE

		gets_dug(user)

	else if(istype(W,/obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/ore/O in contents)
				O.attackby(W, user)
				return
	else if(istype(W,/obj/item/storage/bag/fossils))
		var/obj/item/storage/bag/fossils/S = W
		if(S.collection_mode)
			for(var/obj/item/fossil/F in contents)
				F.attackby(W, user)
				return
	else
		..(W, user)
	return

/turf/unsimulated/floor/asteroid/proc/gets_dug(mob/user)
	add_overlay("asteroid_dug", TRUE)

	if(prob(75))
		new /obj/item/ore/glass(src)
	if(prob(25) && has_resources)
		var/list/ore = list()
		for(var/metal in resources)
			switch(metal)
				if("silicates")
					ore += /obj/item/ore/glass
				if("carbonaceous rock")
					ore += /obj/item/ore/coal
				if("iron")
					ore += /obj/item/ore/iron
				if("gold")
					ore += /obj/item/ore/gold
				if("silver")
					ore += /obj/item/ore/silver
				if("diamond")
					ore += /obj/item/ore/diamond
				if("uranium")
					ore += /obj/item/ore/uranium
				if("phoron")
					ore += /obj/item/ore/phoron
				if("osmium")
					ore += /obj/item/ore/osmium
				if("hydrogen")
					ore += /obj/item/ore/hydrogen
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
								ore += /obj/item/ore/glass
					else
						ore += /obj/item/ore/glass
		if(length(ore))
			var/ore_path = pick(ore)
			if(ore)
				new ore_path(src)

	if(dug <= 10)
		dug += 1
		add_overlay("asteroid_dug", TRUE)
	else
		var/turf/below = GetBelow(src)
		if(below)
			var/area/below_area = get_area(below)	// Let's just assume that the turf is not in nullspace.
			if(below_area.station_area)
				if(user)
					to_chat(user, span("alert", "You strike metal!"))
				below.spawn_roof(ROOF_FORCE_SPAWN)
			else
				ChangeTurf(/turf/space)

/turf/unsimulated/floor/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module) // bro wtf this is criminal
			if(istype(R.module_state_1, /obj/item/storage/bag/ore))
				attackby(R.module_state_1, R)
			else if(istype(R.module_state_2, /obj/item/storage/bag/ore))
				attackby(R.module_state_2, R)
			else if(istype(R.module_state_3, /obj/item/storage/bag/ore))
				attackby(R.module_state_3, R)
			else
				return

/turf/simulated/mineral/Destroy()
	clear_ore_effects()
	. = ..()
