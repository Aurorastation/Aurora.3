/datum/seed/proc/diverge_mutate_gene(var/singleton/plantgene/G, var/turf/T)
	if(!istype(G))
		LOG_DEBUG("Attempted to mutate [src] with a non-plantgene var.")
		return src

	var/datum/seed/S = diverge()	//Let's not modify all of the seeds.
	T.visible_message(SPAN_NOTICE("\The [S.display_name] quivers!"))	//Mimicks the normal mutation.
	G.mutate(S, T)

	return S

/singleton/plantgene
	var/gene_tag

/singleton/plantgene/biochem
	gene_tag = GENE_BIOCHEMISTRY

/singleton/plantgene/hardiness
	gene_tag = GENE_HARDINESS

/singleton/plantgene/environment
	gene_tag = GENE_ENVIRONMENT

/singleton/plantgene/metabolism
	gene_tag = GENE_METABOLISM

/singleton/plantgene/structure
	gene_tag = GENE_STRUCTURE

/singleton/plantgene/diet
	gene_tag = GENE_DIET

/singleton/plantgene/pigment
	gene_tag = GENE_PIGMENT

/singleton/plantgene/output
	gene_tag = GENE_OUTPUT

/singleton/plantgene/atmosphere
	gene_tag = GENE_ATMOSPHERE

/singleton/plantgene/vigour
	gene_tag = GENE_VIGOUR

/singleton/plantgene/fruit
	gene_tag = GENE_FRUIT

/singleton/plantgene/special
	gene_tag = GENE_SPECIAL


/singleton/plantgene/proc/mutate(var/datum/seed/S)
	return

/singleton/plantgene/biochem/mutate(var/datum/seed/S)
	SET_SEED_TRAIT_BOUNDED(S, TRAIT_POTENCY, GET_SEED_TRAIT(S, TRAIT_POTENCY)+rand(-20,20), 200, 0, null)

/singleton/plantgene/hardiness/mutate(var/datum/seed/S)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_TOXINS_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_TOXINS_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_PEST_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_PEST_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_WEED_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_WEED_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_ENDURANCE, GET_SEED_TRAIT(S, TRAIT_ENDURANCE)+rand(-5,5), 100, 0, null)

/singleton/plantgene/environment/mutate(var/datum/seed/S)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_IDEAL_HEAT, GET_SEED_TRAIT(S, TRAIT_IDEAL_HEAT)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_IDEAL_LIGHT, GET_SEED_TRAIT(S, TRAIT_IDEAL_LIGHT)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_LIGHT_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_LIGHT_TOLERANCE)+rand(-5,5), 100, 0, null)

/singleton/plantgene/metabolism/mutate(var/datum/seed/S)
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_REQUIRES_NUTRIENTS, GET_SEED_TRAIT(S, TRAIT_REQUIRES_NUTRIENTS)+rand(-2,2), 10, 0, null)
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_REQUIRES_WATER, GET_SEED_TRAIT(S, TRAIT_REQUIRES_WATER)+rand(-2,2), 10, 0, null)
	if(prob(40))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_ALTER_TEMP, GET_SEED_TRAIT(S, TRAIT_ALTER_TEMP)+rand(-5,5), 100, 0, null)

/singleton/plantgene/diet/mutate(var/datum/seed/S)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_CARNIVOROUS, GET_SEED_TRAIT(S, TRAIT_CARNIVOROUS)+rand(-1,1), 2, 0, null)
	if(prob(60))
		SET_SEED_TRAIT(S, TRAIT_PARASITE, !GET_SEED_TRAIT(S, TRAIT_PARASITE))
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_NUTRIENT_CONSUMPTION, GET_SEED_TRAIT(S, TRAIT_NUTRIENT_CONSUMPTION)+rand(-0.1,0.1), 5, 0, null)
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_WATER_CONSUMPTION, GET_SEED_TRAIT(S, TRAIT_WATER_CONSUMPTION)+rand(-1,1), 50, 0, null)

/singleton/plantgene/output/mutate(var/datum/seed/S, var/turf/T)
	if(prob(50))
		SET_SEED_TRAIT(S, TRAIT_BIOLUM, !GET_SEED_TRAIT(S, TRAIT_BIOLUM))
		if(GET_SEED_TRAIT(S, TRAIT_BIOLUM))
			T.visible_message(SPAN_NOTICE("\The [S.display_name] begins to glow!"))
			if(prob(50))
				SET_SEED_TRAIT(S, TRAIT_BIOLUM_COLOUR, get_random_colour(0,75,190))
				T.visible_message("<span class='notice'>\The [S.display_name]'s glow </span><font color='[GET_SEED_TRAIT(S, TRAIT_BIOLUM_COLOUR)]'>changes colour</font>!")
			else
				T.visible_message(SPAN_NOTICE("\The [S.display_name]'s glow dims..."))
	if(prob(60))
		SET_SEED_TRAIT(S, TRAIT_PRODUCES_POWER, !GET_SEED_TRAIT(S, TRAIT_PRODUCES_POWER))

/singleton/plantgene/atmosphere/mutate(var/datum/seed/S)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_TOXINS_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_TOXINS_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_PEST_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_PEST_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_WEED_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_WEED_TOLERANCE)+rand(-2,2), 10, 0, null)
	if(prob(60))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_ENDURANCE, GET_SEED_TRAIT(S, TRAIT_ENDURANCE)+rand(-5,5), 100, 0, null)

/singleton/plantgene/vigour/mutate(var/datum/seed/S, var/turf/T)
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_PRODUCTION, GET_SEED_TRAIT(S, TRAIT_PRODUCTION)+rand(-1,1), 10, 0, null)
	if(prob(65))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_MATURATION, GET_SEED_TRAIT(S, TRAIT_MATURATION)+rand(-1,1), 30, 0, null)
	if(prob(55))
		SET_SEED_TRAIT_BOUNDED(S, TRAIT_SPREAD, GET_SEED_TRAIT(S, TRAIT_SPREAD)+rand(-1,1), 2, 0, null)
		T.visible_message(SPAN_NOTICE("\The [S.display_name] spasms visibly, shifting in the tray."))

/singleton/plantgene/fruit/mutate(var/datum/seed/S)
	if(prob(65))
		SET_SEED_TRAIT(S, TRAIT_STINGS, !GET_SEED_TRAIT(S, TRAIT_STINGS))
	if(prob(65))
		SET_SEED_TRAIT(S, TRAIT_EXPLOSIVE, !GET_SEED_TRAIT(S, TRAIT_EXPLOSIVE))
	if(prob(65))
		SET_SEED_TRAIT(S, TRAIT_JUICY, !GET_SEED_TRAIT(S, TRAIT_JUICY))

/singleton/plantgene/special/mutate(var/datum/seed/S)
	if(prob(65))
		SET_SEED_TRAIT(S, TRAIT_TELEPORTING, !GET_SEED_TRAIT(S, TRAIT_TELEPORTING))
