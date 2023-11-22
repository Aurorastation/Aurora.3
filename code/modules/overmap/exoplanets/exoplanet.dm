/obj/effect/overmap/visitable/sector/exoplanet
	name = "exoplanet"
	scanimage = "exoplanet_empty.png"	//Shouldn't be a scarcity of these, but this image would work if there's somehow nothing to give a new planet type
	generic_object = FALSE
	var/area/planetary_area
	var/list/seeds = list()
	var/list/animals = list()
	var/max_animal_count
	var/datum/gas_mixture/atmosphere
	var/list/breathgas = list()	//list of gases animals/plants require to survive
	var/badgas					//id of gas that is toxic to life here

	var/lightlevel = 0 //This default makes turfs not generate light. Adjust to have exoplanents be lit.
	var/night = TRUE

// Fluff, specifically for celestial objects.
	var/massvolume = "0.95~/1.1"							//Should use biesels as measurement as opposed to earths
	var/surfacegravity = "0.99"								//Should use Gs as measurement
	var/charted = "No database entry- likely uncharted."	//If it's on star charts or not, and who found it plus when
	var/geology = "Dormant, unreadable tectonic activity"	//Anything unique about tectonics and its core activity
	var/weather = "No substantial meteorological readings"	//Anything unique about terrestrial weather conditions
	var/surfacewater = "NA/None Visible"					//Water visible on the surface

	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic

	var/list/rock_colors = list(COLOR_ASTEROID_ROCK)
	var/list/plant_colors = list("RANDOM")
	var/grass_color
	var/surface_color = COLOR_ASTEROID_ROCK
	var/water_color = "#436499"
	var/image/skybox_image

	var/list/actors = list() //things that appear in engravings on xenoarch finds.
	var/list/species = list() //list of names to use for simple animals

	var/repopulating = 0
	var/repopulate_types = list() // animals which have died that may come back

	var/list/possible_themes = list(/datum/exoplanet_theme)
	var/datum/exoplanet_theme/theme

	var/features_budget = 4
	var/list/possible_features = list()
	var/list/spawned_features
	/// List of ruin types that can be chosen from; supercedes ruin tags system, ignores TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	var/list/ruin_type_whitelist
	// Ruin tags: used to dynamically select what ruins are valid for this exoplanet, if any
	// See code/__defines/ruin_tags.dm
	var/ruin_planet_type = PLANET_BARREN
	var/ruin_allowed_tags = RUIN_ALL_TAGS

	var/habitability_class

	var/list/mobs_to_tolerate = list()
	var/generated_name = TRUE
	var/ring_chance = 20 //the chance of this exoplanet spawning with a ring on its sprite


/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/Initialize()
	. = ..()
	update_icon()

/obj/effect/overmap/visitable/sector/exoplanet/update_icon()
	icon_state = "globe[rand(1,3)]"

/obj/effect/overmap/visitable/sector/exoplanet/New(nloc, max_x, max_y)
	if(!current_map.use_overmap)
		return

	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy
	planetary_area = new planetary_area()

	if(generated_name)
		name = "[generate_planet_name()], \a [name]"

	world.maxz++
	forceMove(locate(1,1,world.maxz))
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_Z, world.maxz)

	pre_ruin_preparation()
	if(LAZYLEN(possible_themes))
		var/datum/exoplanet_theme/T = pick(possible_themes)
		theme = new T
	if(ruin_type_whitelist)
		for(var/T in ruin_type_whitelist)
			var/datum/map_template/ruin/exoplanet/ruin = T
			possible_features += new ruin
	else
		for(var/T in subtypesof(/datum/map_template/ruin/exoplanet))
			var/datum/map_template/ruin/exoplanet/ruin = T
			if((initial(ruin.template_flags) & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
				continue
			if(!(ruin_planet_type & initial(ruin.planet_types)))
				continue
			var/filtered_tags = initial(ruin.ruin_tags) & ruin_allowed_tags
			if(filtered_tags != initial(ruin.ruin_tags))
				continue
			possible_features += new ruin
	..()

/obj/effect/overmap/visitable/sector/exoplanet/proc/build_level()
	generate_habitability()
	generate_atmosphere()
	generate_map()
	generate_features()
	generate_landing(2)
	update_biome()
	generate_planet_image()
	START_PROCESSING(SSprocessing, src)

/obj/effect/overmap/visitable/sector/exoplanet/proc/pre_ruin_preparation()
	switch(habitability_class)
		if(HABITABILITY_IDEAL)
			if(prob(75))
				ruin_allowed_tags |= RUIN_HIGHPOP
			ruin_allowed_tags &= ~RUIN_AIRLESS
		if(HABITABILITY_OKAY)
			if(prob(25))
				ruin_allowed_tags |= RUIN_HIGHPOP
			ruin_allowed_tags &= ~RUIN_AIRLESS
		if(HABITABILITY_BAD)
			ruin_allowed_tags |= RUIN_AIRLESS

//attempt at more consistent history generation for xenoarch finds.
/obj/effect/overmap/visitable/sector/exoplanet/proc/get_engravings()
	if(!actors.len)
		actors += pick("alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")
		actors += pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")

	var/engravings = "[actors[1]] \
	[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
	[actors[2]]"
	if(prob(50))
		engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
	engravings += "."
	return engravings

/obj/effect/overmap/visitable/sector/exoplanet/process(wait, tick)
	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)
	for(var/zlevel in map_z)
		if(repopulating)
			for(var/i = 1 to round(max_animal_count - animals.len))
				if(prob(10))
					var/turf/simulated/T = pick_area_turf(planetary_area, list(/proc/not_turf_contains_dense_objects))
					var/mob_type = pick(repopulate_types)
					var/mob/S = new mob_type(T)
					animals += S
					death_event.register(S, src, PROC_REF(remove_animal))
					destroyed_event.register(S, src, PROC_REF(remove_animal))
					adapt_animal(S)
			if(animals.len >= max_animal_count)
				repopulating = 0

		if(!atmosphere)
			continue
		var/zone/Z
		for(var/i = 1 to maxx)
			var/turf/simulated/T = locate(i, 2, zlevel)
			if(istype(T) && T.zone && T.zone.contents.len > (maxx*maxy*0.25)) //if it's a zone quarter of zlevel, good enough odds it's planetary main one
				Z = T.zone
				break
		if(Z && !Z.fire_tiles.len && !atmosphere.compare(Z.air)) //let fire die out first if there is one
			var/datum/gas_mixture/daddy = new() //make a fake 'planet' zone gas
			daddy.copy_from(atmosphere)
			daddy.group_multiplier = Z.air.group_multiplier
			Z.air.equalize(daddy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal(var/mob/M)
	animals -= M
	death_event.unregister(M, src)
	destroyed_event.unregister(M, src)
	repopulate_types |= M.type

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_map()
	if(!istype(theme))
		CRASH("Exoplanet [src] attempted to generate without valid theme!")
	if(plant_colors)
		var/list/grasscolors = plant_colors.Copy()
		grasscolors -= "RANDOM"
		if(length(grasscolors))
			grass_color = pick(grasscolors)

	theme.before_map_generation(src)
	theme.generate_map(src, map_z[1], 1 + TRANSITIONEDGE, 1 + TRANSITIONEDGE, maxx - (1 + TRANSITIONEDGE), maxy - (1 + TRANSITIONEDGE))

	for (var/zlevel in map_z)
		var/list/edges
		edges += block(locate(1, 1, zlevel), locate(TRANSITIONEDGE, maxy, zlevel))
		edges |= block(locate(maxx-TRANSITIONEDGE, 1, zlevel),locate(maxx, maxy, zlevel))
		edges |= block(locate(1, 1, zlevel), locate(maxx, TRANSITIONEDGE, zlevel))
		edges |= block(locate(1, maxy-TRANSITIONEDGE, zlevel),locate(maxx, maxy, zlevel))
		for (var/turf/T in edges)
			T.ChangeTurf(/turf/unsimulated/planet_edge)

	theme.cleanup(src, map_z[1], 1 + TRANSITIONEDGE, 1 + TRANSITIONEDGE, maxx - (1 + TRANSITIONEDGE), maxy - (1 + TRANSITIONEDGE))

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_features()
	spawned_features = seedRuins(map_z, features_budget, possible_features, /area/exoplanet, maxx, maxy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/update_biome()
	for(var/datum/seed/S as anything in seeds)
		adapt_seed(S)

	for(var/mob/living/simple_animal/A as anything in animals)
		adapt_animal(A)

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)
	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
	S.set_trait(TRAIT_SPREAD,0)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(atmosphere)
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in atmosphere.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_animal(var/mob/living/simple_animal/A)
	if(species[A.type])
		A.name = species[A.type]
		A.real_name = species[A.type]
	else
		A.name = "alien creature"
		A.real_name = "alien creature"
		add_verb(A, /mob/living/simple_animal/proc/name_species)
		if(istype(A, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/AH = A
			AH.tolerated_types = mobs_to_tolerate.Copy()
	if(atmosphere)
		//Set up gases for living things
		if(!LAZYLEN(breathgas))
			var/list/goodgases = gas_data.gases.Copy()
			var/gasnum = min(rand(1,3), goodgases.len)
			for(var/i = 1 to gasnum)
				var/gas = pick(goodgases)
				breathgas[gas] = round(0.4*goodgases[gas], 0.1)
				goodgases -= gas
		if(!badgas)
			var/list/badgases = gas_data.gases.Copy()
			badgases -= atmosphere.gas
			badgas = pick(badgases)

		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_random_species_name()
	return pick("nol","shan","can","fel","xor")+pick("a","e","o","t","ar")+pick("ian","oid","ac","ese","inian","rd")

/obj/effect/overmap/visitable/sector/exoplanet/proc/rename_species(var/species_type, var/newname, var/force = FALSE)
	if(species[species_type] && !force)
		return FALSE

	species[species_type] = newname
	log_and_message_admins("renamed [species_type] to [newname]")
	for(var/mob/living/simple_animal/A in animals)
		if(istype(A,species_type))
			A.name = newname
			A.real_name = newname
			remove_verb(A, /mob/living/simple_animal/proc/name_species)
	return TRUE

//This tries to generate "num" landing spots on the map.
// A landing spot is a 20x20 zone where the shuttle can land where each tile has a area of /area/exoplanet and no ruins on top of it
// It makes num*20 attempts to pick a landing spot, during which it attempts to find a area which meets the above criteria.
// If it that does not work, it tries to clear the area
//There is also a sanity check to ensure that the map isnt too small to handle the landing spot
/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_landing(num = 1)
	var/places = list()
	var/attempts = 20
	var/new_type = landmark_type

	//sanity-check map size
	var/lm_min_x = TRANSITIONEDGE+LANDING_ZONE_RADIUS
	var/lm_max_x = maxx-TRANSITIONEDGE-LANDING_ZONE_RADIUS
	var/lm_min_y = TRANSITIONEDGE+LANDING_ZONE_RADIUS
	var/lm_max_y = maxy-TRANSITIONEDGE-LANDING_ZONE_RADIUS
	if (lm_max_x < lm_min_x || lm_max_y < lm_min_y)
		log_and_message_admins("Map Size is too small to Support Away Mission Shuttle Landmark. [lm_min_x] [lm_max_x] [lm_min_y] [lm_max_y]")
		return

	while(num)
		attempts--
		var/turf/T = locate(rand(lm_min_x, lm_max_x), rand(lm_min_y, lm_max_y),map_z[map_z.len])
		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue
		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are no repeats.
			var/valid = TRUE
			var/list/block_to_check = block(locate(T.x - LANDING_ZONE_RADIUS, T.y - LANDING_ZONE_RADIUS, T.z), locate(T.x + LANDING_ZONE_RADIUS, T.y + LANDING_ZONE_RADIUS, T.z))
			// Ruins check - try to avoid blowing up ruins with our LZ
			// We do this until we run out of attempts
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), /area/exoplanet) || check.flags & TURF_NORUINS)
					valid = FALSE
					break
			// Landability check - try to find an already-open space for an LZ
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check))
					valid = FALSE
			else // If we're running low on attempts we try to make our own LZ, ignoring landability but still checking for ruins
				new_type = /obj/effect/shuttle_landmark/automatic/clearing

			if(!valid)
				continue

		num--
		places += T
		new new_type(T)
		attempts = 20

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = gas_data.gases.Copy()
		if(prob(90)) //all phoron planet should be rare
			newgases -= GAS_PHORON
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= GAS_ALIEN
		newgases -= GAS_STEAM

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if(habitability_class == HABITABILITY_OKAY)
			atmosphere.gas[GAS_OXYGEN] += MOLES_O2STANDARD
			total_moles -= MOLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while(i <= gasnum && total_moles && newgases.len)
			if(badflag && sanity)
				for(var/g in newgases)
					if(gas_data.flags[g] & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			if(sanity) //make sure atmosphere is not flammable... always
				if(gas_data.flags[ng] & XGM_GAS_OXIDIZER)
					badflag |= XGM_GAS_FUEL
				if(gas_data.flags[ng] & XGM_GAS_FUEL)
					badflag |= XGM_GAS_OXIDIZER
				sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

/obj/effect/overmap/visitable/sector/exoplanet/get_scan_data(mob/user)
	. = ..()
	. += "<br><center><large><b>Scan Details</b></large>"
	. += "<br><large><b>[name]</b></large></center>"
	. += "<br><b>Estimated Mass and Volume: </b><small>[massvolume]BSS(Biesels)</small>"
	. += "<br><b>Surface Gravity: </b><small>[surfacegravity]Gs</small>"
	. += "<br><b>Charted: </b><small>[charted]</small>"
	. += "<br><b>Geological Variables: </b><small>[geology]</small>"
	. += "<br><b>Surface Water Coverage: </b><small>[surfacewater]</small>"
	. += "<br><b>Apparent Weather Data: </b><small>[weather]</small>"
	. += "<hr>"
	. += "<br><center><b>Visible Light Viewport Magnified</b>"
	. += "<br><img src = [scanimage]>"
	. += "<br><small>High-Fidelity Image Capture of [name]</small>"
	. += "<hr>"
	. += "<br><b>Native Database Notes</b></center>"
	. += "<br><small>[desc]</small>"

	var/list/extra_data = list("<hr>")
	if(atmosphere)
		var/list/gases = list()
		for(var/g in atmosphere.gas)
			if(atmosphere.gas[g] > atmosphere.total_moles * 0.05)
				gases += gas_data.name[g]
		extra_data += "<b>Atmosphere composition:</b> [english_list(gases)]"
		var/inaccuracy = rand(8,12)/10
		extra_data += "<b>Atmosphere pressure:</b> [atmosphere.return_pressure()*inaccuracy] kPa, <b>temperature:</b> [atmosphere.temperature*inaccuracy] K"

	if(seeds.len)
		extra_data += "<br>Unrecognized xenoflora detected."

	if(animals.len)
		extra_data += "<br>Unrecognized xenofauna detected."

	else
		extra_data += "<br>No unrecognized biological signatures detected."

	if(LAZYLEN(spawned_features))
		var/ruin_num = 0
		for(var/datum/map_template/ruin/exoplanet/R in spawned_features)
			if(!(R.ruin_tags & RUIN_NATURAL))
				ruin_num++
		if(ruin_num)
			extra_data += "<hr>[ruin_num] possible artificial structure\s detected."

	. += jointext(extra_data, "<br>")

/obj/effect/overmap/visitable/sector/exoplanet/get_skybox_representation()
	return skybox_image


/obj/effect/overmap/visitable/sector/exoplanet/proc/get_surface_color()
	return surface_color

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list()
	for(var/g in atmosphere.gas)
		if(gas_data.tile_overlay_color[g])
			colors += gas_data.tile_overlay_color[g]
	if(colors.len)
		return MixColors(colors)
