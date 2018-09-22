/datum/bounty/item/random/
	name = "random bounty"
	description = "something went wrong..."

/datum/bounty/item/random/proc/generate_description()
	return "%BOSSSHORT wishes to obtain a [name]. Ship [required_count] over and we'll reward you."

/datum/bounty/item/random/compatible_with(other_bounty)
	if(istype(other_bounty,/datum/bounty/item))
		var/datum/bounty/item/other_bounty_casted = other_bounty
		for(var/item in wanted_types)
			if(item in other_bounty_casted.wanted_types)
				return FALSE
		return TRUE
	return ..()

/datum/bounty/item/random/random_research
	name = "random research item"

/datum/bounty/item/random/random_research/generate_description()
	return pick(list(
		"Executives at %BOSSSHORT wish to see the scientific progress of your station by specifically requesting a [name]. Please provide them with [required_count] in order to fulfill their request.",
		"A sister station of %BOSSSHORT requires a [name] in order to boost their own research levels. Please ship [required_count] to central so it gets there.",
		"%BOSSSHORT requires a [name] for security purposes. Please ship [required_count] in the name of corporate security.",
		"One of our science interns lost a valuable [name]. Please ship [required_count] of them so this doesn't happen again.",
		"One of the visitors at our station stole and destoyed a [name]. We need [required_count] of them to make up for this loss.",
		"One of %BOSSSHORT's chefs accidentally cooked a [name] thinking it was meat. Please send [required_count] to central as a replacement."
	))

/datum/bounty/item/random/random_research/New()
	var/datum/design/datum_design = pick(SScargo.researchables_list)
	name = datum_design.name
	wanted_types = list(datum_design.build_path)
	for(var/key in datum_design.req_tech)
		var/value = datum_design.req_tech[key]
		reward += value*250

	required_count = rand(1,3)
	reward *= required_count
	reward = max(1000,round(reward,100))

	description = generate_description()

	..()

/datum/bounty/item/random/random_cooking
	name = "random cooking item"

/datum/bounty/item/random/random_cooking/New()
	var/datum/recipe/datum_recipe = pick(RECIPE_LIST(MICROWAVE) + RECIPE_LIST(OVEN))
	var/obj/item/final_food = new datum_recipe.result
	name = final_food.name
	wanted_types = list(datum_recipe.result)

	reward = 250
	required_count = pick(list(1,4,6,10,12))
	reward *= required_count
	reward = max(100,round(reward,100))
	reward += 500

	description = generate_description()

	qdel(final_food)

	..()

/datum/bounty/item/random/random_cooking/generate_description()
	return pick(list(
		"%BOSSSHORT is hosting a potluck with the other corporations, however one of our chefs suffered an accident while preparing [name]. Please try to do better than them, and send [required_count] [name] to central.",
		"Some executives from %BOSSSHORT are visiting Central. Please provide them with some of their favorite food; [name].",
		"%BOSSSHORT is competeting to see which station has the best cook. Please send your variation of [name] and contact us in one year to see if your station won or not.",
		"One of the security guards at the ODIN is on a special diet. Please ship [required_count] [name] to satisfy their dietary needs."
	))