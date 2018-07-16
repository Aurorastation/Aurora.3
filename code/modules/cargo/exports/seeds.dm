/datum/export/seed
	cost = 50 // Gets multiplied by potency
	k_elasticity = 1	//price inelastic/quantity elastic, only need to export a few samples
	unit_name = "new plant species sample"
	export_types = list(/obj/item/seeds)
	var/needs_discovery = FALSE // Only for undiscovered species
	var/global/list/discoveredPlants = list()

/datum/export/seed/get_cost(obj/O)
	var/obj/item/seeds/S = O
	if(!needs_discovery && (S.type in discoveredPlants))
		return 0
	if(needs_discovery && !(S.type in discoveredPlants))
		return 0
	return ..() // That's right, no bonus for potency. Send a crappy sample first to "show improvement" later.

/datum/export/seed/sell_object(obj/O)
	..()
	var/obj/item/seeds/S = O
	discoveredPlants[S.type] = S.seed.traits[TRAIT_POTENCY]


/datum/export/seed/potency
	cost = 2.5 // Gets multiplied by potency.
	unit_name = "improved plant sample"
	export_types = list(/obj/item/seeds)
	needs_discovery = TRUE // Only for already discovered species

/datum/export/seed/potency/get_cost(obj/O)
	var/obj/item/seeds/S = O
	var/cost = ..()
	if(!cost)
		return 0

	var/potDiff = (S.seed.traits[TRAIT_POTENCY] - discoveredPlants[S.type])

	return round(..() * potDiff)
