//helper that ensures the reaction rate holds after iterating
//Ex. REACTION_RATE(0.3) means that 30% of the reagents will react each chemistry tick (~2 seconds by default).
#define REACTION_RATE(rate) (1.0 - (1.0-rate)**(1.0/PROCESS_REACTION_ITER))

//helper to define reaction rate in terms of half-life
//Ex.
//HALF_LIFE(0) -> Reaction completes immediately (default chems)
//HALF_LIFE(1) -> Half of the reagents react immediately, the rest over the following ticks.
//HALF_LIFE(2) -> Half of the reagents are consumed after 2 chemistry ticks.
//HALF_LIFE(2.2) -> Half of the reagents are consumed after 2.2 chemistry ticks.
#define HALF_LIFE(ticks) (ticks? 1.0 - (0.5)**(1.0/(ticks*PROCESS_REACTION_ITER)) : 1.0)

/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/list/required_reagents = list()
	var/required_temperature_min // Temperatures must exceed this value to trigger.
	var/required_temperature_max // Temperatures must be less than this value to trigger.
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0

	//how far the reaction proceeds each time it is processed. Used with either REACTION_RATE or HALF_LIFE macros.
	var/reaction_rate = HALF_LIFE(0)

	//if less than 1, the reaction will be inhibited if the ratio of products/reagents is too high.
	//0.5 = 50% yield -> reaction will only proceed halfway until products are removed.
	var/yield = 1.0

	//If limits on reaction rate would leave less than this amount of any reagent (adjusted by the reaction ratios),
	//the reaction goes to completion. This is to prevent reactions from going on forever with tiny reagent amounts.
	var/min_reaction = 2

	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	var/temp = holder.get_temperature()
	if(required_temperature_min && (temp < required_temperature_min))
		return 0

	if(required_temperature_max && (temp > required_temperature_max))
		return 0

	return 1

/datum/chemical_reaction/proc/calc_reaction_progress(var/datum/reagents/holder, var/reaction_limit)
	var/progress = reaction_limit * reaction_rate //simple exponential progression

	//calculate yield
	if(1-yield > 0.001) //if yield ratio is big enough just assume it goes to completion
		/*
			Determine the max amount of product by applying the yield condition:
			(max_product/result_amount) / reaction_limit == yield/(1-yield)

			We make use of the fact that:
			reaction_limit = (REAGENT_VOLUME(holder, reactant) / required_reagents[reactant]) of the limiting reagent.
		*/
		var/yield_ratio = yield/(1-yield)
		var/max_product = yield_ratio * reaction_limit * result_amount //rearrange to obtain max_product
		var/yield_limit = max(0, max_product - REAGENT_VOLUME(holder, result))/result_amount

		progress = min(progress, yield_limit) //apply yield limit

	//apply min reaction progress - wasn't sure if this should go before or after applying yield
	//I guess people can just have their miniscule reactions go to completion regardless of yield.
	for(var/reactant in required_reagents)
		var/remainder = REAGENT_VOLUME(holder, reactant) - progress*required_reagents[reactant]
		if(remainder <= min_reaction*required_reagents[reactant])
			progress = reaction_limit
			break

	return progress

/datum/chemical_reaction/process(var/datum/reagents/holder)
	//determine how far the reaction can proceed
	var/list/reaction_limits = list()
	for(var/reactant in required_reagents)
		reaction_limits += REAGENT_VOLUME(holder, reactant) / required_reagents[reactant]

	//determine how far the reaction proceeds
	var/reaction_limit = min(reaction_limits)
	var/progress_limit = calc_reaction_progress(holder, reaction_limit)

	var/reaction_progress = min(reaction_limit, progress_limit) //no matter what, the reaction progress cannot exceed the stoichiometric limit.

	//need to obtain the new reagent's data before anything is altered
	var/data = send_data(holder, reaction_progress)

	//remove the reactants
	var/total_thermal_energy = 0
	for(var/reactant in required_reagents)
		var/amt_used = required_reagents[reactant] * reaction_progress
		var/decl/reagent/removing_reagent = decls_repository.get_decl(reactant)
		var/energy_transfered = removing_reagent.get_thermal_energy(holder) * (amt_used / holder.reagent_volumes[reactant])
		total_thermal_energy += energy_transfered
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1, new_thermal_energy = total_thermal_energy)

	on_reaction(holder, amt_produced, total_thermal_energy)

	return reaction_progress

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(container && !ismob(container))
		var/turf/T = get_turf(container)
		if(mix_message)
			var/list/seen = viewers(4, T)
			for(var/mob/M in seen)
				M.show_message("<span class='notice'>[icon2html(container, viewers(get_turf(src)))] [mix_message]</span>", 1)
		if(reaction_sound)
			playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	result = /decl/reagent/inaprovaline
	required_reagents = list(/decl/reagent/acetone = 1, /decl/reagent/carbon = 1, /decl/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "dylovene"
	result = /decl/reagent/dylovene
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/potassium = 1, /decl/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/mortaphenyl
	name = "Mortaphenyl"
	id = "mortaphenyl"
	result = /decl/reagent/mortaphenyl
	required_reagents = list(/decl/reagent/inaprovaline = 1, /decl/reagent/alcohol = 1, /decl/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/perconol
	name = "Perconol"
	id = "perconol"
	result = /decl/reagent/perconol
	required_reagents = list(/decl/reagent/mortaphenyl = 1, /decl/reagent/sugar = 1, /decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/oxycomorphine
	name = "Oxycomorphine"
	id = "oxycomorphine"
	result = /decl/reagent/oxycomorphine
	required_reagents = list(/decl/reagent/alcohol = 1, /decl/reagent/mortaphenyl = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = /decl/reagent/sterilizine
	required_reagents = list(/decl/reagent/alcohol = 1, /decl/reagent/dylovene = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = /decl/reagent/silicate
	required_reagents = list(/decl/reagent/aluminum = 1, /decl/reagent/silicon = 1, /decl/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = /decl/reagent/mutagen
	required_reagents = list(/decl/reagent/radium = 1, /decl/reagent/phosphorus = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = /decl/reagent/thermite
	required_reagents = list(/decl/reagent/aluminum = 1, /decl/reagent/iron = 1, /decl/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Mercury Monolithium Sucrose"
	id = "space_drugs"
	result = /decl/reagent/space_drugs
	required_reagents = list(/decl/reagent/mercury = 1, /decl/reagent/sugar = 1, /decl/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = /decl/reagent/lube
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/silicon = 1, /decl/reagent/acetone = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = /decl/reagent/acid/polyacid
	required_reagents = list(/decl/reagent/acid = 1, /decl/reagent/acid/hydrochloric = 1, /decl/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = /decl/reagent/synaptizine
	required_reagents = list(/decl/reagent/sugar = 1, /decl/reagent/lithium = 1, /decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	result = /decl/reagent/hyronalin
	required_reagents = list(/decl/reagent/radium = 1, /decl/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	result = /decl/reagent/arithrazine
	required_reagents = list(/decl/reagent/hyronalin = 1, /decl/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = /decl/reagent/impedrezene
	required_reagents = list(/decl/reagent/mercury = 1, /decl/reagent/acetone = 1, /decl/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = /decl/reagent/kelotane
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	result = /decl/reagent/peridaxon
	required_reagents = list(/decl/reagent/bicaridine = 1, /decl/reagent/clonexadone = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = /decl/reagent/nutriment/virusfood
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/drink/milk = 1, /decl/reagent/sugar = 1)
	result_amount = 6

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	result = /decl/reagent/leporazine
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/copper = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = /decl/reagent/cryptobiolin
	required_reagents = list(/decl/reagent/potassium = 1, /decl/reagent/acetone = 1, /decl/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = /decl/reagent/tricordrazine
	required_reagents = list(/decl/reagent/inaprovaline = 1, /decl/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = /decl/reagent/alkysine
	required_reagents = list(/decl/reagent/acid/hydrochloric = 1, /decl/reagent/ammonia = 1, /decl/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = "dexalin"
	result = /decl/reagent/dexalin
	required_reagents = list(/decl/reagent/acetone = 2, /decl/reagent/toxin/phoron = 0.1)
	catalysts = list(/decl/reagent/toxin/phoron = 1)
	inhibitors = list(/decl/reagent/water = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = "dermaline"
	result = /decl/reagent/dermaline
	required_reagents = list(/decl/reagent/acetone = 1, /decl/reagent/phosphorus = 1, /decl/reagent/kelotane = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	result = /decl/reagent/dexalin/plus
	required_reagents = list(/decl/reagent/dexalin = 1, /decl/reagent/carbon = 1, /decl/reagent/iron = 1)
	result_amount = 3

/datum/chemical_reaction/butazoline
	name = "Butazoline"
	id = "butazoline"
	result = /decl/reagent/butazoline
	required_reagents = list(/decl/reagent/bicaridine = 1, /decl/reagent/aluminum = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = /decl/reagent/bicaridine
	required_reagents = list(/decl/reagent/inaprovaline = 1, /decl/reagent/carbon = 1)
	inhibitors = list(/decl/reagent/sugar = 1) //Messes with inaprovaline
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = /decl/reagent/hyperzine
	required_reagents = list(/decl/reagent/sugar = 1, /decl/reagent/phosphorus = 1, /decl/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	result = /decl/reagent/ryetalyn
	required_reagents = list(/decl/reagent/arithrazine = 1, /decl/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	result = /decl/reagent/cryoxadone
	required_reagents = list(/decl/reagent/dexalin = 1, /decl/reagent/water = 1, /decl/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	result = /decl/reagent/clonexadone
	required_reagents = list(/decl/reagent/cryoxadone = 1, /decl/reagent/sodium = 1, /decl/reagent/toxin/phoron = 0.1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/thetamycin
	name = "Thetamycin"
	id = "thetamycin"
	result = /decl/reagent/thetamycin
	required_reagents = list(/decl/reagent/cryptobiolin = 1, /decl/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/steramycin
	name = "Steramycin"
	id = "steramycin"
	result = /decl/reagent/steramycin
	required_reagents = list(/decl/reagent/thetamycin = 2, /decl/reagent/sterilizine = 1, /decl/reagent/radium = 1)
	result_amount = 2

/datum/chemical_reaction/cetahydramine
	name = "Cetahydramine"
	id = "cetahydramine"
	result = /decl/reagent/cetahydramine
	required_reagents = list(/decl/reagent/cryptobiolin = 1, /decl/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/asinodryl
	name = "Asinodryl"
	id = "asinodryl"
	result = /decl/reagent/asinodryl
	required_reagents = list(/decl/reagent/cetahydramine = 1, /decl/reagent/synaptizine = 1, /decl/reagent/water = 3)
	catalysts = list(/decl/reagent/tungsten = 5)
	result_amount = 3

/datum/chemical_reaction/oculine
	name = "oculine"
	id = "oculine"
	result = /decl/reagent/oculine
	required_reagents = list(/decl/reagent/carbon = 1, /decl/reagent/hydrazine = 1, /decl/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = /decl/reagent/ethylredoxrazine
	required_reagents = list(/decl/reagent/acetone = 1, /decl/reagent/dylovene = 1, /decl/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/verunol
	name = "Verunol Syrup"
	id = "verunol"
	result = /decl/reagent/verunol
	required_reagents = list(/decl/reagent/hydrazine = 1, /decl/reagent/dylovene = 1, /decl/reagent/alcohol = 1)
	result_amount = 3

/datum/chemical_reaction/adipemcina
	name = "Adipemcina"
	id = "adipemcina"
	result = /decl/reagent/adipemcina
	required_reagents = list(/decl/reagent/lithium = 1, /decl/reagent/dylovene = 1, /decl/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	id = "stoxin"
	result = /decl/reagent/soporific
	required_reagents = list(/decl/reagent/polysomnine = 1, /decl/reagent/sugar = 4)
	inhibitors = list(/decl/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/polysomnine
	name = "Polysomnine"
	id = "polysomnine"
	result = /decl/reagent/polysomnine
	required_reagents = list(/decl/reagent/alcohol = 1, /decl/reagent/acid/hydrochloric = 3, /decl/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = /decl/reagent/toxin/potassium_chloride
	required_reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/potassium = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = /decl/reagent/toxin/potassium_chlorophoride
	required_reagents = list(/decl/reagent/toxin/potassium_chloride = 1, /decl/reagent/toxin/phoron = 1, /decl/reagent/polysomnine = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = /decl/reagent/toxin/zombiepowder
	required_reagents = list(/decl/reagent/toxin/carpotoxin = 5, /decl/reagent/soporific = 5, /decl/reagent/copper = 5)
	result_amount = 2

/datum/chemical_reaction/dextrotoxin
	name = "Dextrotoxin"
	id = "dextrotoxin"
	result = /decl/reagent/toxin/dextrotoxin
	required_reagents = list(/decl/reagent/toxin/carpotoxin = 3, /decl/reagent/soporific = 10, /decl/reagent/toxin/phoron = 5)
	result_amount = 5

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = /decl/reagent/mindbreaker
	required_reagents = list(/decl/reagent/silicon = 1, /decl/reagent/hydrazine = 1, /decl/reagent/dylovene = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = /decl/reagent/lipozine
	required_reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/alcohol = 1, /decl/reagent/radium = 1)
	result_amount = 3

/datum/chemical_reaction/coagzolug
	name = "Coagzolug"
	id = "coagzolug"
	result = /decl/reagent/coagzolug
	required_reagents = list(/decl/reagent/tricordrazine = 1, /decl/reagent/coughsyrup = 1)
	result_amount = 1 // result is 1. i imagine it's because of some whacky reaction

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	id = "surfactant"
	result = /decl/reagent/surfactant
	required_reagents = list(/decl/reagent/hydrazine = 2, /decl/reagent/carbon = 2, /decl/reagent/acid = 1)
	result_amount = 5

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = /decl/reagent/diethylamine
	required_reagents = list(/decl/reagent/ammonia = 1, /decl/reagent/alcohol = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = /decl/reagent/spacecleaner
	required_reagents = list(/decl/reagent/ammonia = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/antifuel
	name = "Antifuel"
	id = "antifuel"
	result = /decl/reagent/antifuel
	required_reagents = list(/decl/reagent/spacecleaner = 1, /decl/reagent/sodium = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = /decl/reagent/toxin/plantbgone
	required_reagents = list(/decl/reagent/toxin = 1, /decl/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = /decl/reagent/foaming_agent
	required_reagents = list(/decl/reagent/lithium = 1, /decl/reagent/hydrazine = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = /decl/reagent/glycerol
	required_reagents = list(/decl/reagent/nutriment/triglyceride = 1, /decl/reagent/alcohol = 2) // transesterification of triglycerides into butanol and glycerol
	catalysts = list(/decl/reagent/acid = 5) // using acid as a catalyst
	result_amount = 3 //each triglyceride has 3 glycerin chains.

/datum/chemical_reaction/glycerol/butanol
	name = "Glycerol"
	id = "glycerol-butane"
	result = /decl/reagent/glycerol
	required_reagents = list(/decl/reagent/nutriment/triglyceride = 1, /decl/reagent/alcohol/butanol = 2)

/datum/chemical_reaction/glycerol/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.add_reagent(/decl/reagent/acetone, 2 * created_volume / 3) // closest we can get to biofuel, sorry

/datum/chemical_reaction/glucose
	name = "Glucose"
	id = "glucose"
	result = /decl/reagent/nutriment/glucose
	required_reagents = list(/decl/reagent/nutriment = 5) // thank you, Gottlieb Kirchhoff
	catalysts = list(/decl/reagent/acid = 5 )//starch into sugar with sulfuric acid catalyst

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = /decl/reagent/sodiumchloride
	required_reagents = list(/decl/reagent/sodium = 1, /decl/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = /decl/reagent/capsaicin/condensed
	required_reagents = list(/decl/reagent/capsaicin = 2)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = /decl/reagent/coolant
	required_reagents = list(/decl/reagent/tungsten = 1, /decl/reagent/acetone = 1, /decl/reagent/water = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = /decl/reagent/rezadone
	required_reagents = list(/decl/reagent/toxin/carpotoxin = 1, /decl/reagent/cryptobiolin = 1, /decl/reagent/copper = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = /decl/reagent/lexorin
	required_reagents = list(/decl/reagent/tungsten = 1, /decl/reagent/hydrazine = 1, /decl/reagent/ammonia = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 3

/datum/chemical_reaction/fluvectionem
	name = "Fluvectionem"
	id = "fluvectionem"
	result = /decl/reagent/fluvectionem
	required_reagents = list(/decl/reagent/mercury = 1, /decl/reagent/sodiumchloride = 1, /decl/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/cardox
	name = "Cardox"
	id = "cardox"
	result = /decl/reagent/toxin/cardox
	required_reagents = list(/decl/reagent/platinum = 1, /decl/reagent/carbon = 1, /decl/reagent/sterilizine = 1)
	result_amount = 3

/datum/chemical_reaction/cardox_removal
	name = "Cardox Removal"
	id = "cardox_removal"
	result = /decl/reagent/carbon
	required_reagents = list(/decl/reagent/toxin/cardox = 0.1, /decl/reagent/toxin/phoron = 1)
	result_amount = 0

/datum/chemical_reaction/monoammoniumphosphate
	name = "Monoammoniumphosphate"
	id = "monoammoniumphosphate"
	result = /decl/reagent/toxin/fertilizer/monoammoniumphosphate
	required_reagents = list(/decl/reagent/ammonia = 1, /decl/reagent/acid = 1, /decl/reagent/sodium = 1, /decl/reagent/phosphorus = 1)
	result_amount = 4

/datum/chemical_reaction/koispasteclean
	name = "Filtered K'ois"
	id = "koispasteclean"
	result = /decl/reagent/kois/clean
	required_reagents = list(/decl/reagent/kois = 2,/decl/reagent/toxin/cardox = 0.1)
	catalysts = list(/decl/reagent/toxin/cardox = 5)
	result_amount = 1

/datum/chemical_reaction/pulmodeiectionem
	name = "Pulmodeiectionem"
	id = "pulmodeiectionem"
	result = /decl/reagent/pulmodeiectionem
	required_reagents = list(/decl/reagent/fluvectionem = 1, /decl/reagent/lexorin = 1)
	result_amount = 2

/datum/chemical_reaction/pneumalin
	name = "Pneumalin"
	id = "pneumalin"
	result = /decl/reagent/pneumalin
	required_reagents = list(/decl/reagent/coughsyrup = 1, /decl/reagent/copper = 1, /decl/reagent/pulmodeiectionem = 1)
	result_amount = 2

/datum/chemical_reaction/saline
	name = "Saline Plus"
	id = "saline"
	result = /decl/reagent/saline
	required_reagents = list(/decl/reagent/water = 2, /decl/reagent/sugar = 0.5, /decl/reagent/sodiumchloride = 1)
	catalysts = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/cataleptinol
	name = "Cataleptinol"
	id = "cataleptinol"
	result = /decl/reagent/cataleptinol
	required_reagents = list(/decl/reagent/toxin/phoron = 0.1, /decl/reagent/alkysine = 1, /decl/reagent/cryoxadone = 0.1)
	result_amount = 1

/datum/chemical_reaction/coughsyrup
	name = "Cough Syrup"
	id = "coughsyrup"
	result = /decl/reagent/coughsyrup
	required_reagents = list(/decl/reagent/carbon = 1, /decl/reagent/tungsten = 1, /decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/inacusiate
	name = "Inacusiate"
	id = "inacusiate"
	result = /decl/reagent/inacusiate
	required_reagents = list(/decl/reagent/dylovene = 1, /decl/reagent/carbon = 1, /decl/reagent/sulfur = 1)
	result_amount = 2

//Mental Medication

/datum/chemical_reaction/corophenidate
	name = "Corophenidate"
	id = "corophenidate"
	result = /decl/reagent/mental/corophenidate
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/minaphobin
	name = "Minaphobin"
	id = "minaphobin"
	result = /decl/reagent/mental/minaphobin
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/reagent/adrenaline
	required_reagents = list(/decl/reagent/inaprovaline = 1, /decl/reagent/hyperzine = 1, /decl/reagent/dexalin/plus = 1)
	result_amount = 3

/datum/chemical_reaction/neurostabin
	name = "Neurostabin"
	id = "neurostabin"
	result = /decl/reagent/mental/neurostabin
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/iron = 1, /decl/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/parvosil
	name = "Parvosil"
	id = "parvosil"
	result = /decl/reagent/mental/parvosil
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/aluminum = 1, /decl/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/emoxanyl
	name = "Emoxanyl"
	id = "emoxanyl"
	result = /decl/reagent/mental/emoxanyl
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/silicon = 1, /decl/reagent/alcohol = 1)
	result_amount = 3

/datum/chemical_reaction/orastabin
	name = "Orastabin"
	id = "orastabin"
	result = /decl/reagent/mental/orastabin
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/sodium = 1, /decl/reagent/tungsten = 1)
	result_amount = 3

/datum/chemical_reaction/neurapan
	name = "Neurapan"
	id = "neurapan"
	result = /decl/reagent/mental/neurapan
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/space_drugs = 1, /decl/reagent/alcohol = 1)
	result_amount = 3

/datum/chemical_reaction/nerospectan
	name = "Nerospectan"
	id = "nerospectan"
	result = /decl/reagent/mental/nerospectan
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/space_drugs = 1, /decl/reagent/silicon = 1)
	result_amount = 3

/datum/chemical_reaction/truthserum
	name = "Truthserum"
	id = "truthserum"
	result = /decl/reagent/mental/truthserum
	required_reagents = list(/decl/reagent/mindbreaker = 1, /decl/reagent/synaptizine = 1, /decl/reagent/toxin/phoron = 0.1)
	result_amount = 2

/datum/chemical_reaction/pacifier
	name = "Paxazide"
	id = "paxazide"
	result = /decl/reagent/pacifier
	required_reagents = list(/decl/reagent/mental/truthserum = 1, /decl/reagent/mental/parvosil = 1)
	result_amount = 1

/datum/chemical_reaction/berserk
	name = "Red Nightshade"
	id = "berserk"
	result = /decl/reagent/toxin/berserk
	required_reagents = list(/decl/reagent/toxin/stimm = 1, /decl/reagent/synaptizine = 1, /decl/reagent/toxin/phoron = 0.1)
	result_amount = 1

/datum/chemical_reaction/joy
	name = "Joy"
	id = "joy"
	result = /decl/reagent/joy
	required_reagents = list(/decl/reagent/mental/neurapan = 1, /decl/reagent/oxycomorphine = 2)
	result_amount = 1

/datum/chemical_reaction/xuxigas
	name = "Xu'Xi Gas"
	id = "xuxigas"
	result = /decl/reagent/xuxigas
	required_reagents = list(/decl/reagent/dexalin = 2, /decl/reagent/space_drugs = 2, /decl/reagent/mental/truthserum = 1)
	required_temperature_min = T0C + 134
	result_amount = 5

/datum/chemical_reaction/skrell_nootropic
	name = "Co'qnixq Wuxi"
	id = "skrell_nootropic"
	result = /decl/reagent/skrell_nootropic
	required_reagents = list(/decl/reagent/wulumunusha = 1, /decl/reagent/synaptizine = 1, /decl/reagent/mental/emoxanyl = 1)
	result_amount = 3

/* Makeshift Chemicals and Drugs */

/datum/chemical_reaction/stimm
	name = "Stimm"
	id = "stimm"
	result = /decl/reagent/toxin/stimm
	required_reagents = list(/decl/reagent/fuel = 1, /decl/reagent/drink/rewriter = 5)
	result_amount = 6

/datum/chemical_reaction/krokjuice
	name = "Krok Juice"
	id = "krok"
	result = /decl/reagent/toxin/krok
	required_reagents = list(/decl/reagent/drink/orangejuice = 2, /decl/reagent/fuel = 1, /decl/reagent/iron = 1)
	result_amount = 4

/datum/chemical_reaction/raskara_dust
	name = "Raskara Dust"
	id = "raskara_dust"
	result = /decl/reagent/raskara_dust
	required_reagents = list(/decl/reagent/toxin/fertilizer/monoammoniumphosphate = 1, /decl/reagent/spacecleaner = 1, /decl/reagent/sodiumchloride = 2) // extinguisher, cleaner, salt
	required_temperature_min = T0C + 127 // barely over boiling point of water, 400C
	result_amount = 2

/datum/chemical_reaction/nightjuice
	name = "Nightlife"
	id = "night_juice"
	result = /decl/reagent/night_juice
	required_reagents = list(/decl/reagent/mental/corophenidate = 1, /decl/reagent/synaptizine = 1, /decl/reagent/nitroglycerin = 1)
	required_temperature_min = T0C + 200
	result_amount = 3

/* Solidification */

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	id = "solidphoron"
	result = null
	required_reagents = list(/decl/reagent/iron = 5, /decl/reagent/frostoil = 5, /decl/reagent/toxin/phoron = 20)
	result_amount = 1

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)
	return

/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list(/decl/reagent/acid/polyacid = 1, /decl/reagent/toxin/plasticide = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/datum/chemical_reaction/uraniumsolidification
    name = "Uranium"
    id = "soliduranium"
    result = null
    required_reagents = list(/decl/reagent/potassium = 5, /decl/reagent/frostoil = 5, /decl/reagent/uranium = 20)
    result_amount = 1

/datum/chemical_reaction/uraniumsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
    new /obj/item/stack/material/uranium(get_turf(holder.my_atom), created_volume)
    return

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/potassium = 1)
	result_amount = 2
	mix_message = null

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	var/turf/location = get_turf(holder.my_atom)
	e.set_up(round (created_volume/10, 1), location, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list(/decl/reagent/aluminum = 1, /decl/reagent/potassium = 1, /decl/reagent/sulfur = 1 )
	result_amount = null

/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	spark(location, 2, alldirs)
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list(/decl/reagent/uranium = 1, /decl/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = ~1 heavy range & ~2 light range.
	// 200 created volume = ~2 heavy range & ~4 light range.
	empulse(location, round(created_volume / 6), round(created_volume / 3), 1)
	holder.clear_reagents()
	return

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = /decl/reagent/nitroglycerin
	required_reagents = list(/decl/reagent/glycerol = 1, /decl/reagent/acid/polyacid = 1, /decl/reagent/acid = 1)
	result_amount = 2

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list(/decl/reagent/aluminum = 1, /decl/reagent/toxin/phoron = 1, /decl/reagent/acid = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(GAS_PHORON, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent(/decl/reagent/fuel/napalm)
	return

/datum/chemical_reaction/zoragel
	name = "Inert Gel"
	id = "zoragel"
	result = /decl/reagent/fuel/zoragel
	required_reagents = list(/decl/reagent/acid = 1, /decl/reagent/aluminum = 1, /decl/reagent/sugar = 1, /decl/reagent/surfactant = 3)
	result_amount = 1

/datum/chemical_reaction/zorafire
	name = "Zo'rane Fire"
	id = "greekfire"
	result = /decl/reagent/fuel/napalm
	required_reagents = list(/decl/reagent/nitroglycerin = 2, /decl/reagent/pyrosilicate = 2, /decl/reagent/toxin/phoron = 3, /decl/reagent/fuel/zoragel = 3)
	result_amount = 1
	log_is_important = 1

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list(/decl/reagent/potassium = 1, /decl/reagent/sugar = 1, /decl/reagent/phosphorus = 1)
	result_amount = 0.4

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location, 80)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list(/decl/reagent/surfactant = 1, /decl/reagent/water = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list(/decl/reagent/aluminum = 3, /decl/reagent/foaming_agent = 1, /decl/reagent/acid/polyacid = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list(/decl/reagent/iron = 3, /decl/reagent/foaming_agent = 1, /decl/reagent/acid/polyacid = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = "luminol"
	result = /decl/reagent/luminol
	required_reagents = list(/decl/reagent/hydrazine = 2, /decl/reagent/carbon = 2, /decl/reagent/ammonia = 2)
	result_amount = 6

/* Paint */

/datum/chemical_reaction/paint
	name = "Paint"
	id = "paint"
	result = /decl/reagent/paint
	required_reagents = list(/decl/reagent/toxin/plasticide = 1, /decl/reagent/water = 3)
	result_amount = 4

/* Slime cores */

/datum/chemical_reaction/slime
	var/required = null

/datum/chemical_reaction/slime/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.uses > 0)
			return ..()
	return FALSE

/datum/chemical_reaction/slime/on_reaction(var/datum/reagents/holder)
	var/obj/item/slime_extract/T = holder.my_atom
	T.uses--
	if(T.uses <= 0)
		T.visible_message("[icon2html(T, viewers(get_turf(src)))]<span class='notice'>\The [T]'s power is consumed in the reaction.</span>")
		T.name = "used slime extract"
		T.desc = "This extract has been used up."

//Grey
/datum/chemical_reaction/slime/spawn
	name = "Slime Spawn"
	id = "m_spawn"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/spawn/on_reaction(var/datum/reagents/holder)
	holder.my_atom.visible_message(SPAN_WARNING("Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!"))
	new /mob/living/carbon/slime(get_turf(holder.my_atom))
	..()

/datum/chemical_reaction/slime/monkey
	name = "Slime Monkey"
	id = "m_monkey"
	result = null
	required_reagents = list(/decl/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	new /obj/effect/portal/spawner/monkey_cube(get_turf(holder.my_atom))
	..()

//Green
/datum/chemical_reaction/slime/teleportation
	name = "Slime Teleportation"
	id = "slimeteleportation"
	required_reagents = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1
	required = /obj/item/slime_extract/green

/datum/chemical_reaction/slime/teleportation/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(src, .proc/do_reaction, holder), 50)

/datum/chemical_reaction/slime/teleportation/proc/do_reaction(var/datum/reagents/holder)
	for(var/atom/movable/AM in circle_range(get_turf(holder.my_atom),7))
		if(AM.anchored)
			continue
		var/area/A = random_station_area()
		var/turf/target = A.random_space()
		to_chat(AM, SPAN_WARNING("Bluespace energy teleports you somewhere else!"))
		do_teleport(AM, target)
		AM.visible_message("\The [AM] phases in!")

/datum/chemical_reaction/slime/bluespace_crystal
	name = "Slime Bluespace Crystal"
	id = "slime_bscrystal"
	required_reagents = list(/decl/reagent/carbon = 10, /decl/reagent/silver = 10)
	result_amount = 1
	required = /obj/item/slime_extract/green

/datum/chemical_reaction/slime/bluespace_crystal/on_reaction(var/datum/reagents/holder)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck(TRUE) <= 0)
			M.flash_eyes()

	new /obj/item/bluespace_crystal(get_turf(holder.my_atom))
	..()

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	id = "m_metal"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/datum/chemical_reaction/slime/metal/on_reaction(var/datum/reagents/holder)
	new /obj/effect/portal/spawner/metal(get_turf(holder.my_atom))
	..()

//Gold - added back in
/datum/chemical_reaction/slime/crit
	name = "Slime Crit"
	id = "m_tele"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 10)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/datum/chemical_reaction/slime/crit/on_reaction(var/datum/reagents/holder)
	var/blocked = list(
		/mob/living/simple_animal/hostile,
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/pirate/ranged,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/syndicate,
		/mob/living/simple_animal/hostile/syndicate/melee,
		/mob/living/simple_animal/hostile/syndicate/melee/space,
		/mob/living/simple_animal/hostile/syndicate/ranged,
		/mob/living/simple_animal/hostile/syndicate/ranged/space,
		/mob/living/simple_animal/hostile/faithless,
		/mob/living/simple_animal/hostile/retaliate,
		/mob/living/simple_animal/hostile/retaliate/clown,
		/mob/living/simple_animal/hostile/true_changeling,
		/mob/living/simple_animal/hostile/commanded,
		/mob/living/simple_animal/hostile/commanded/dog,
		/mob/living/simple_animal/hostile/commanded/dog/amaskan,
		/mob/living/simple_animal/hostile/commanded/dog/columbo,
		/mob/living/simple_animal/hostile/commanded/dog/pug,
		/mob/living/simple_animal/hostile/commanded/bear,
		/mob/living/simple_animal/hostile/commanded/baby_harvester,
		/mob/living/simple_animal/hostile/greatworm,
		/mob/living/simple_animal/hostile/lesserworm,
		/mob/living/simple_animal/hostile/greatwormking,
		/mob/living/simple_animal/hostile/krampus,
		/mob/living/simple_animal/hostile/gift,
		/mob/living/simple_animal/hostile/hivebotbeacon,
		/mob/living/simple_animal/hostile/hivebotbeacon/incendiary,
		/mob/living/simple_animal/hostile/republicon,
		/mob/living/simple_animal/hostile/republicon/ranged,
		/mob/living/simple_animal/hostile/spider_queen
	)
	//exclusion list for things you don't want the reaction to create.
	var/list/critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck(TRUE) <= 0)
			M.flash_eyes()

	for(var/i = 1, i <= 5, i++)
		var/chosen = pick(critters)
		var/mob/living/simple_animal/hostile/C = new chosen
		C.faction = "slimesummon"
		C.forceMove(get_turf(holder.my_atom))
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()

//Silver
/datum/chemical_reaction/slime/bork
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/datum/chemical_reaction/slime/bork/on_reaction(var/datum/reagents/holder)
	var/list/blocked = list(
	/obj/item/reagent_containers/food/snacks,
	/obj/item/reagent_containers/food/snacks/meat/undead,
	/obj/item/reagent_containers/food/snacks/meatbreadslice,
	/obj/item/reagent_containers/food/snacks/xenomeatbreadslice,
	/obj/item/reagent_containers/food/snacks/bananabreadslice,
	/obj/item/reagent_containers/food/snacks/tofubreadslice,
	/obj/item/reagent_containers/food/snacks/cakeslice/carrot,
	/obj/item/reagent_containers/food/snacks/cakeslice/brain,
	/obj/item/reagent_containers/food/snacks/cakeslice/cheese,
	/obj/item/reagent_containers/food/snacks/cakeslice/plain,
	/obj/item/reagent_containers/food/snacks/cakeslice/orange,
	/obj/item/reagent_containers/food/snacks/cakeslice/lime,
	/obj/item/reagent_containers/food/snacks/cakeslice/lemon,
	/obj/item/reagent_containers/food/snacks/cakeslice/chocolate,
	/obj/item/reagent_containers/food/snacks/cheesewedge,
	/obj/item/reagent_containers/food/snacks/cakeslice/birthday,
	/obj/item/reagent_containers/food/snacks/sliceable/bread,
	/obj/item/reagent_containers/food/snacks/breadslice,
	/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread,
	/obj/item/reagent_containers/food/snacks/creamcheesebreadslice,
	/obj/item/reagent_containers/food/snacks/watermelonslice,
	/obj/item/reagent_containers/food/snacks/cakeslice/apple,
	/obj/item/reagent_containers/food/snacks/pumpkinpieslice,
	/obj/item/reagent_containers/food/snacks/keylimepieslice,
	/obj/item/reagent_containers/food/snacks/quicheslice,
	/obj/item/reagent_containers/food/snacks/browniesslice,
	/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice,
	/obj/item/reagent_containers/food/snacks/margheritaslice,
	/obj/item/reagent_containers/food/snacks/meatpizzaslice,
	/obj/item/reagent_containers/food/snacks/mushroompizzaslice,
	/obj/item/reagent_containers/food/snacks/vegetablepizzaslice,
	/obj/item/reagent_containers/food/snacks/pineappleslice
	)
	var/list/borks = typesof(/obj/item/reagent_containers/food/snacks) - blocked
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck(TRUE) < FLASH_PROTECTION_MODERATE)
			M.flash_eyes()

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.forceMove(get_turf(holder.my_atom))
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))
	..()

//Blue
/datum/chemical_reaction/slime/frost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = /decl/reagent/frostoil
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkblue
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/freeze/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(src, .proc/do_reaction, holder), 50)

/datum/chemical_reaction/slime/freeze/proc/do_reaction(var/datum/reagents/holder)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range(7, get_turf(holder.my_atom)))
		M.bodytemperature -= 140
		to_chat(M, SPAN_WARNING("You feel a cold chill!"))

//Orange
/datum/chemical_reaction/slime/casp
	name = "Slime Capsaicin Oil"
	id = "m_capsaicinoil"
	result = /decl/reagent/capsaicin
	required_reagents = list(/decl/reagent/blood = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/fire/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(src, .proc/do_reaction, holder), 50)

/datum/chemical_reaction/slime/fire/proc/do_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.my_atom)
	for(var/turf/simulated/floor/target_tile in range(1, location))
		target_tile.assume_gas(GAS_PHORON, 25, 1400)
		target_tile.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slime/overload
	name = "Slime EMP"
	id = "m_emp"
	result = null
	required_reagents = list(/decl/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/overload/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/empulse, get_turf(holder.my_atom), 3, 7), 50)

/datum/chemical_reaction/slime/cell
	name = "Slime Powercell"
	id = "m_cell"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "A small sparking part of the extract core falls onto the floor."

/datum/chemical_reaction/slime/cell/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/cell/slime(get_turf(holder.my_atom))
	..()

/datum/chemical_reaction/slime/glow
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The contents of the slime core harden and begin to emit a warm, bright light."

/datum/chemical_reaction/slime/glow/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/device/flashlight/slime(get_turf(holder.my_atom))

//Purple
/datum/chemical_reaction/slime/psteroid
	name = "Slime Steroid"
	id = "m_steroid"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/slimesteroid(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	id = "m_jam"
	result = /decl/reagent/slimejelly
	required_reagents = list(/decl/reagent/sugar = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple

/datum/chemical_reaction/slime/rare_metal
	name = "Slime Rare Metal"
	id = "rm_metal"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/rare_metal/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/rare_metal(get_turf(holder.my_atom))

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = /decl/reagent/glycerol
	required_reagents = list(/decl/reagent/sugar = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	id = "m_bloodlust"
	result = null
	required_reagents = list(/decl/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = TRUE
		slime.visible_message(SPAN_WARNING("[icon2html(slime, viewers(get_turf(slime)))] \The [slime] is driven into a frenzy!"))

/datum/chemical_reaction/slime/nightshade
	name = "Slime Nightshade"
	id = "slime_nightshade"
	result = /decl/reagent/toxin/berserk
	required_reagents = list(/decl/reagent/toxin/phoron = 10)
	result_amount = 1
	required = /obj/item/slime_extract/red

//Pink
/datum/chemical_reaction/slime/docility_serum
	name = "Docility Serum"
	id = "docility_serum"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/docility_serum/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/docility_serum(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/paxazide
	name = "Slime Paxazide"
	id = "slime_paxazide"
	result = /decl/reagent/pacifier
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 5
	required = /obj/item/slime_extract/pink

//Black
/datum/chemical_reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	id = "mutationtoxin2"
	result = /decl/reagent/aslimetoxin
	required_reagents = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slime/explosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/explosion/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, get_turf(holder.my_atom), 1, 3, 6), 50)

/datum/chemical_reaction/slime/plasticglass
	name = "Slime Plastic & Glass"
	id = "slime_plasticglass"
	result = null
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil

/datum/chemical_reaction/slime/plasticglass/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/plasticglass(get_turf(holder.my_atom))

//Light Pink
/datum/chemical_reaction/slime/advanced_docility_serum
	name = "Advanced Docility Serum"
	id = "advanced_docility_serum"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(/decl/reagent/toxin/phoron = 5)

/datum/chemical_reaction/slime/advanced_docility_serum/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/advanced_docility_serum(get_turf(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	id = "m_golem"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 5)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine
	mix_message = "A soft fizzle is heard within the slime extract, and mystic runes suddenly appear on the floor beneath it!"

/datum/chemical_reaction/slime/golem/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/golemrune(get_turf(holder.my_atom))

//Sepia
/datum/chemical_reaction/slime/wood
	name = "Slime Wood"
	id = "slime_wood"
	result = null
	required_reagents = list(/decl/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/wood/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/wood(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/hide
	name = "Slime Hides"
	id = "slime_hide"
	result = null
	required_reagents = list(/decl/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/hide/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/hide(get_turf(holder.my_atom))

//Pyrite
/datum/chemical_reaction/slime/pyrite/cryo_to_clonex
	name = "Pyrite Transmutation: Cryoxadone to Clonexadone"
	id = "cryo_to_clonex"
	result = /decl/reagent/clonexadone
	required_reagents = list(/decl/reagent/cryoxadone = 5)
	result_amount = 5
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/inap_to_coag
	name = "Pyrite Transmutation: Inaprovaline to Coagzolug"
	id = "inap_to_coag"
	result = /decl/reagent/coagzolug
	required_reagents = list(/decl/reagent/inaprovaline = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/kelo_to_derm
	name = "Pyrite Transmutation: Kelotane to Dermaline"
	id = "kelo_to_derm"
	result = /decl/reagent/dermaline
	required_reagents = list(/decl/reagent/kelotane = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/bica_to_buta
	name = "Pyrite Transmutation: Bicaridine_to_Butazoline"
	id = "bica_to_buta"
	result = /decl/reagent/butazoline
	required_reagents = list(/decl/reagent/bicaridine = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/dex_to_plus
	name = "Pyrite Transmutation: Dexalin to Dexalin Plus"
	id = "dex_to_plus"
	result = /decl/reagent/dexalin/plus
	required_reagents = list(/decl/reagent/dexalin = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/merc_to_dextro
	name = "Pyrite Transmutation: Mercury to Dextrotoxin"
	id = "merc_to_dextro"
	result = /decl/reagent/toxin/dextrotoxin
	required_reagents = list(/decl/reagent/mercury = 5)
	result_amount = 1
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/ez_to_diethyl
	name = "Pyrite Transmutation: EZ Nutrient to Diethylamine"
	id = "ez_to_diethyl"
	result = /decl/reagent/diethylamine
	required_reagents = list(/decl/reagent/toxin/fertilizer/eznutrient = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/radium_to_mutagen
	name = "Pyrite Transmutation: Radium to Mutagen"
	id = "radium_to_mutagen"
	result = /decl/reagent/mutagen
	required_reagents = list(/decl/reagent/radium = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/pyrite/sugar_to_hyperzine
	name = "Pyrite Transmutation: Sugar to Hyperzine"
	id = "sugar_to_hyper"
	result = /decl/reagent/hyperzine
	required_reagents = list(/decl/reagent/sugar = 5)
	result_amount = 10
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/soap_key
	name = "Soap Key"
	id = "skey"
	result = null
	required_reagents = list(/decl/reagent/nutriment/triglyceride = 2, /decl/reagent/water = 2, /decl/reagent/spacecleaner = 3)
	var/strength = 3

/datum/chemical_reaction/soap_key/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/soap))
		return ..()
	return 0

/datum/chemical_reaction/soap_key/on_reaction(var/datum/reagents/holder)
	var/obj/item/soap/S = holder.my_atom
	if(S.key_data)
		var/obj/item/key/soap/key = new(get_turf(holder.my_atom), S.key_data)
		key.uses = strength
	..()

//Cerulean
/datum/chemical_reaction/slime/extract_enhancer
	name = "Extract Enhancer"
	id = "extract_enhancer"
	result = null
	required_reagents = list(/decl/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/cerulean

/datum/chemical_reaction/slime/extract_enhancer/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/extract_enhancer(get_turf(holder.my_atom))

/*
====================
	Food
====================
*/

/datum/chemical_reaction/tofu
	name = "Tofu"
	id = "tofu"
	result = null
	required_reagents = list(/decl/reagent/drink/milk/soymilk = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	inhibitors = list(/decl/reagent/sodiumchloride = 1) // To prevent conflict with Soy Sauce recipe.
	result_amount = 1

/datum/chemical_reaction/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/tofu(location)
	return

/datum/chemical_reaction/chocolate_bar
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list(/decl/reagent/drink/milk/soymilk = 2, /decl/reagent/nutriment/coco = 2, /decl/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/chocolate_bar2
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list(/decl/reagent/drink/milk = 2, /decl/reagent/nutriment/coco = 2, /decl/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	id = "hot_coco"
	result = /decl/reagent/drink/hot_coco
	required_reagents = list(/decl/reagent/water = 5, /decl/reagent/nutriment/coco = 1)
	result_amount = 5

/datum/chemical_reaction/grapejuice
	name = "Grape Juice"
	result = /decl/reagent/drink/grapejuice
	required_reagents = list(/decl/reagent/water = 3, /decl/reagent/nutriment/instantjuice/grape = 1)
	result_amount = 3
	mix_message = "The solution settles into a purplish-red beverage."

/datum/chemical_reaction/orangejuice
	name = "Orange Juice"
	result = /decl/reagent/drink/orangejuice
	required_reagents = list(/decl/reagent/water = 3, /decl/reagent/nutriment/instantjuice/orange = 1)
	result_amount = 3
	mix_message = "The solution settles into an orange beverage."

/datum/chemical_reaction/watermelonjuice
	name = "Watermelon Juice"
	result = /decl/reagent/drink/watermelonjuice
	required_reagents = list(/decl/reagent/water = 3, /decl/reagent/nutriment/instantjuice/watermelon = 1)
	result_amount = 3
	mix_message = "The solution settles into a red beverage."

/datum/chemical_reaction/applejuice
	name = "Apple Juice"
	result = /decl/reagent/drink/applejuice
	required_reagents = list(/decl/reagent/water = 3, /decl/reagent/nutriment/instantjuice/apple = 1)
	result_amount = 3
	mix_message = "The solution settles into a clear brown beverage."

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = /decl/reagent/nutriment/soysauce
	required_reagents = list(/decl/reagent/drink/milk/soymilk = 4, /decl/reagent/sodiumchloride = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = /decl/reagent/nutriment/ketchup
	required_reagents = list(/decl/reagent/drink/tomatojuice = 2, /decl/reagent/water = 1, /decl/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/barbecue
	name = "Barbecue Sauce"
	id = "barbecue"
	result = /decl/reagent/nutriment/barbecue
	required_reagents = list(/decl/reagent/nutriment/ketchup = 2, /decl/reagent/nutriment/garlicsauce = 1, /decl/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/garlicsauce
	name = "Garlic Sauce"
	id = "garlicsauce"
	result = /decl/reagent/nutriment/garlicsauce
	required_reagents = list(/decl/reagent/drink/garlicjuice = 1, /decl/reagent/nutriment/triglyceride/oil/corn = 1)
	result_amount = 2

/datum/chemical_reaction/peanutbutter // Yes, this doesn't make sense. No, I don't know how to do this better
	name = "Peanut Butter"
	id = "peanutbutter"
	result = /decl/reagent/nutriment/peanutbutter
	required_reagents = list(/decl/reagent/nutriment/groundpeanuts = 5, /decl/reagent/sugar = 1, /decl/reagent/sodiumchloride = 1)
	result_amount = 5

/datum/chemical_reaction/mayonnaise
	name = "Mayonnaise"
	id = "mayonnaise"
	result = /decl/reagent/nutriment/mayonnaise
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/drink/lemonjuice = 2, /decl/reagent/nutriment/triglyceride/oil/corn = 10)
	result_amount = 15

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list(/decl/reagent/drink/milk = 40)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 1

/datum/chemical_reaction/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel(location)
	return

/datum/chemical_reaction/meatball
	name = "Meatball"
	id = "meatball"
	result = null
	required_reagents = list(/decl/reagent/nutriment/protein = 3, /decl/reagent/nutriment/flour = 5)
	result_amount = 3

/datum/chemical_reaction/meatball/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/rawmeatball(location)
	return

/datum/chemical_reaction/dough
	name = "Dough"
	id = "dough"
	result = null
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/nutriment/flour = 10)
	inhibitors = list(/decl/reagent/water = 1, /decl/reagent/alcohol/beer = 1, /decl/reagent/sugar = 1) //To prevent it messing with batter and pie recipes
	result_amount = 1

/datum/chemical_reaction/dough/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/dough(location)
	return

/datum/chemical_reaction/syntiflesh
	name = "Syntiflesh"
	id = "syntiflesh"
	result = null
	required_reagents = list(/decl/reagent/blood = 5, /decl/reagent/clonexadone = 1)
	result_amount = 1

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = /decl/reagent/drink/hot_ramen
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/drink/dry_ramen = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = /decl/reagent/drink/hell_ramen
	required_reagents = list(/decl/reagent/capsaicin = 1, /decl/reagent/drink/hot_ramen = 6)
	result_amount = 6

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = "batter"
	result = /decl/reagent/nutriment/coating/batter
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/nutriment/flour = 10, /decl/reagent/water = 5, /decl/reagent/sodiumchloride = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = /decl/reagent/nutriment/coating/beerbatter
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/nutriment/flour = 10, /decl/reagent/alcohol/beer = 5, /decl/reagent/sodiumchloride = 2)
	result_amount = 20

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = /decl/reagent/browniemix
	required_reagents = list(/decl/reagent/nutriment/flour = 5, /decl/reagent/nutriment/coco = 5, /decl/reagent/sugar = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list(/decl/reagent/drink/milk/cream = 20, /decl/reagent/sodiumchloride = 1)
	result_amount = 1

/datum/chemical_reaction/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/spreads/butter(location)
	return

/*
	Todo in future:
		Cornmeal batter for corndogs
		KFC style coating for chicken
		breadcrumbs
*/

/*
	Food: Coatings
========================
*/








/*
====================
	Alcohol
====================
*/

/datum/chemical_reaction/drink
	name = "Goldschlager"
	id = "goldschlager"
	result = /decl/reagent/alcohol/goldschlager
	required_reagents = list(/decl/reagent/alcohol/vodka = 10, /decl/reagent/gold = 1)
	mix_message = null
	reaction_sound = /decl/sound_category/generic_pour_sound
	result_amount = 10

/datum/chemical_reaction/drink/patron
	name = "Patron"
	id = "patron"
	result = /decl/reagent/alcohol/patron
	required_reagents = list(/decl/reagent/alcohol/tequila = 10, /decl/reagent/silver = 1)
	result_amount = 10

/datum/chemical_reaction/drink/bilk
	name = "Bilk"
	id = "bilk"
	result = /decl/reagent/alcohol/bilk
	required_reagents = list(/decl/reagent/drink/milk = 1, /decl/reagent/alcohol/beer = 1)
	result_amount = 2

/datum/chemical_reaction/drink/tea
	name = "Tea"
	id = "tea"
	result = /decl/reagent/drink/tea
	required_reagents = list(/decl/reagent/nutriment/teagrounds = 1, /decl/reagent/water = 5)
	result_amount = 5

/datum/chemical_reaction/drink/greentea
	name = "Green Tea"
	id = "greentea"
	result = /decl/reagent/drink/tea/greentea
	required_reagents = list(/decl/reagent/drink/tea = 5, /decl/reagent/nutriment/mint = 2)
	result_amount = 5

/datum/chemical_reaction/drink/icetea
	name = "Iced Tea"
	id = "icetea"
	result = /decl/reagent/drink/icetea
	required_reagents = list(/decl/reagent/drink/ice = 1, /decl/reagent/drink/tea = 2)
	result_amount = 3

/datum/chemical_reaction/drink/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	result = /decl/reagent/drink/coffee/icecoffee
	required_reagents = list(/decl/reagent/drink/ice = 1, /decl/reagent/drink/coffee = 2)
	result_amount = 3

/datum/chemical_reaction/drink/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	result = /decl/reagent/drink/nuka_cola
	required_reagents = list(/decl/reagent/uranium = 1, /decl/reagent/drink/space_cola = 5)
	result_amount = 5

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = /decl/reagent/alcohol/moonshine
	required_reagents = list(/decl/reagent/nutriment = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/butanol
	name = "Butanol"
	id = "butanol"
	result = /decl/reagent/alcohol/butanol
	required_reagents = list(/decl/reagent/nutriment/triglyceride/oil/corn = 10, /decl/reagent/sugar = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	result = /decl/reagent/drink/grenadine
	required_reagents = list(/decl/reagent/drink/berryjuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	id = "wine"
	result = /decl/reagent/alcohol/wine
	required_reagents = list(/decl/reagent/drink/grapejuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/whitewine
	name = "White Wine"
	id = "whitewine"
	result = /decl/reagent/alcohol/whitewine
	required_reagents = list(/decl/reagent/drink/whitegrapejuice = 5)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/blushwine
	name = "Blush Wine"
	id = "blushwine"
	result = /decl/reagent/alcohol/blushwine
	required_reagents = list(/decl/reagent/alcohol/whitewine = 1, /decl/reagent/alcohol/wine = 1)
	result_amount = 2

/datum/chemical_reaction/melonwine
	name = "Melon Wine"
	id = "melonwine"
	result = /decl/reagent/alcohol/melonwine
	required_reagents = list(/decl/reagent/alcohol/wine = 1, /decl/reagent/alcohol/melonliquor = 1)
	result_amount = 2

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	id = "pwine"
	result = /decl/reagent/alcohol/pwine
	required_reagents = list(/decl/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = /decl/reagent/alcohol/melonliquor
	required_reagents = list(/decl/reagent/drink/watermelonjuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = /decl/reagent/alcohol/bluecuracao
	required_reagents = list(/decl/reagent/drink/orangejuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = /decl/reagent/alcohol/beer
	required_reagents = list(/decl/reagent/nutriment/triglyceride/oil/corn = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/vodka
	name = "Vodka"
	id = "vodka"
	result = /decl/reagent/alcohol/vodka
	required_reagents = list(/decl/reagent/drink/potatojuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	id = "sake"
	result = /decl/reagent/alcohol/sake
	required_reagents = list(/decl/reagent/nutriment/rice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = /decl/reagent/alcohol/coffee/kahlua
	required_reagents = list(/decl/reagent/drink/coffee = 5, /decl/reagent/sugar = 5)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/drink/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = /decl/reagent/alcohol/gintonic
	required_reagents = list(/decl/reagent/alcohol/gin = 2, /decl/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/rumandcola
	name = "Rum and Cola"
	id = "rumandcola"
	result = /decl/reagent/alcohol/rumandcola
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/martini
	name = "Classic Martini"
	id = "martini"
	result = /decl/reagent/alcohol/martini
	required_reagents = list(/decl/reagent/alcohol/gin = 2, /decl/reagent/alcohol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = /decl/reagent/alcohol/vodkamartini
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/alcohol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = /decl/reagent/alcohol/white_russian
	required_reagents = list(/decl/reagent/alcohol/blackrussian = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = /decl/reagent/alcohol/whiskeycola
	required_reagents = list(/decl/reagent/alcohol/whiskey = 2, /decl/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = /decl/reagent/alcohol/screwdrivercocktail
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/sidewinderfang
	name = "Sidewinder Fang"
	id = "sidewinderfang"
	result = /decl/reagent/alcohol/sidewinderfang
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/drink/sodawater = 2, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/limejuice = 1)

/datum/chemical_reaction/drink/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = /decl/reagent/alcohol/bloodymary
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/drink/tomatojuice = 3, /decl/reagent/drink/limejuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = /decl/reagent/alcohol/gargleblaster
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/alcohol/gin = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/alcohol/cognac = 1, /decl/reagent/drink/limejuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = /decl/reagent/alcohol/coffee/brave_bull
	required_reagents = list(/decl/reagent/alcohol/tequila = 2, /decl/reagent/alcohol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tequila_sunrise
	name = "Tequila Sunrise"
	id = "tequilasunrise"
	result = /decl/reagent/alcohol/tequila_sunrise
	required_reagents = list(/decl/reagent/alcohol/tequila = 2, /decl/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = /decl/reagent/alcohol/toxins_special
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/alcohol/vermouth = 2, /decl/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/drink/beepsky_smash
	name = "Beepsky Smash"
	id = "beepksysmash"
	result = /decl/reagent/alcohol/beepsky_smash
	required_reagents = list(/decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = /decl/reagent/drink/doctorsdelight
	required_reagents = list(/decl/reagent/drink/limejuice = 1, /decl/reagent/drink/tomatojuice = 1, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/milk/cream = 2, /decl/reagent/tricordrazine = 1)
	result_amount = 6

/datum/chemical_reaction/drink/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = /decl/reagent/alcohol/irishcream
	required_reagents = list(/decl/reagent/alcohol/whiskey = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = /decl/reagent/alcohol/manly_dorf
	required_reagents = list(/decl/reagent/alcohol/beer = 1, /decl/reagent/alcohol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/drink/hooch
	name = "Hooch"
	id = "hooch"
	result = /decl/reagent/alcohol/hooch
	required_reagents = list(/decl/reagent/sugar = 1, /decl/reagent/alcohol/moonshine = 1, /decl/reagent/fuel = 1)
	result_amount = 3

/datum/chemical_reaction/drink/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = /decl/reagent/alcohol/coffee/irishcoffee
	required_reagents = list(/decl/reagent/alcohol/irishcream = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/b52
	name = "B-52"
	id = "b52"
	result = /decl/reagent/alcohol/coffee/b52
	required_reagents = list(/decl/reagent/alcohol/irishcream = 1, /decl/reagent/alcohol/coffee/kahlua = 1, /decl/reagent/alcohol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/drink/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = /decl/reagent/alcohol/atomicbomb
	required_reagents = list(/decl/reagent/alcohol/coffee/b52 = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/margarita
	name = "Margarita"
	id = "margarita"
	result = /decl/reagent/alcohol/margarita
	required_reagents = list(/decl/reagent/alcohol/tequila = 2, /decl/reagent/drink/limejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = /decl/reagent/alcohol/longislandicedtea
	required_reagents = list(/decl/reagent/alcohol/vodka = 1, /decl/reagent/alcohol/gin = 1, /decl/reagent/alcohol/tequila = 1, /decl/reagent/alcohol/cubalibre = 3)
	result_amount = 6

/datum/chemical_reaction/drink/icedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = /decl/reagent/alcohol/longislandicedtea
	required_reagents = list(/decl/reagent/alcohol/vodka = 1, /decl/reagent/alcohol/gin = 1, /decl/reagent/alcohol/tequila = 1, /decl/reagent/alcohol/cubalibre = 3)
	result_amount = 6

/datum/chemical_reaction/drink/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = /decl/reagent/alcohol/threemileisland
	required_reagents = list(/decl/reagent/alcohol/longislandicedtea = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = /decl/reagent/alcohol/whiskeysoda
	required_reagents = list(/decl/reagent/alcohol/whiskey = 2, /decl/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/drink/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = /decl/reagent/alcohol/blackrussian
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/alcohol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = /decl/reagent/alcohol/manhattan
	required_reagents = list(/decl/reagent/alcohol/whiskey = 2, /decl/reagent/alcohol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = /decl/reagent/alcohol/manhattan_proj
	required_reagents = list(/decl/reagent/alcohol/manhattan = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = /decl/reagent/alcohol/vodkatonic
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = /decl/reagent/alcohol/ginfizz
	required_reagents = list(/decl/reagent/alcohol/gin = 1, /decl/reagent/drink/sodawater = 1, /decl/reagent/drink/limejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = /decl/reagent/alcohol/bahama_mama
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/drink/orangejuice = 2, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/singulo
	name = "Singulo"
	id = "singulo"
	result = /decl/reagent/alcohol/singulo
	required_reagents = list(/decl/reagent/alcohol/vodka = 5, /decl/reagent/radium = 1, /decl/reagent/alcohol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/drink/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = /decl/reagent/alcohol/alliescocktail
	required_reagents = list(/decl/reagent/alcohol/martini = 1, /decl/reagent/alcohol/vodka = 1)
	result_amount = 2

/datum/chemical_reaction/drink/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = /decl/reagent/alcohol/demonsblood
	required_reagents = list(/decl/reagent/alcohol/rum = 3, /decl/reagent/drink/spacemountainwind = 1, /decl/reagent/blood = 1, /decl/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/booger
	name = "Booger"
	id = "booger"
	result = /decl/reagent/alcohol/booger
	required_reagents = list(/decl/reagent/drink/milk/cream = 2, /decl/reagent/drink/banana = 1, /decl/reagent/alcohol/rum = 1, /decl/reagent/drink/watermelonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = /decl/reagent/alcohol/antifreeze
	required_reagents = list(/decl/reagent/alcohol/vodka = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/ice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = /decl/reagent/alcohol/barefoot
	required_reagents = list(/decl/reagent/drink/berryjuice = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/alcohol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	result = /decl/reagent/drink/grapesoda
	required_reagents = list(/decl/reagent/drink/grapejuice = 2, /decl/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = /decl/reagent/alcohol/sbiten
	required_reagents = list(/decl/reagent/alcohol/mead = 10, /decl/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/drink/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = /decl/reagent/alcohol/red_mead
	required_reagents = list(/decl/reagent/blood = 1, /decl/reagent/alcohol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mead
	name = "Mead"
	id = "mead"
	result = /decl/reagent/alcohol/mead
	required_reagents = list(/decl/reagent/sugar = 1, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/drink/iced_beer
	name = "Iced Beer"
	id = "frosted_beer"
	result = /decl/reagent/alcohol/iced_beer
	required_reagents = list(/decl/reagent/alcohol/beer = 10, /decl/reagent/frostoil = 1)
	result_amount = 10

/datum/chemical_reaction/drink/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = /decl/reagent/alcohol/iced_beer
	required_reagents = list(/decl/reagent/alcohol/beer = 5, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/grog
	name = "Grog"
	id = "grog"
	result = /decl/reagent/alcohol/grog
	required_reagents = list(/decl/reagent/alcohol/rum = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	result = /decl/reagent/drink/coffee/soy_latte
	required_reagents = list(/decl/reagent/drink/coffee = 1, /decl/reagent/drink/milk/soymilk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	result = /decl/reagent/drink/coffee/cafe_latte
	required_reagents = list(/decl/reagent/drink/coffee = 1, /decl/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_espresso
	name = "Freddo Espresso"
	id = "freddo_espresso"
	result = /decl/reagent/drink/coffee/freddo_espresso
	required_reagents = list(/decl/reagent/drink/coffee/espresso = 1, /decl/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/caffe_americano
	name = "Caffe Americano"
	id = "caffe_americano"
	result = /decl/reagent/drink/coffee/caffe_americano
	required_reagents = list(/decl/reagent/drink/coffee/espresso = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/flat_white
	name = "Flat White"
	id = "flat_white"
	result = /decl/reagent/drink/coffee/flat_white
	required_reagents = list(/decl/reagent/drink/coffee/espresso = 1, /decl/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/latte
	name = "Latte"
	id = "latte"
	result = /decl/reagent/drink/coffee/latte
	required_reagents = list(/decl/reagent/drink/coffee/flat_white = 1, /decl/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cappuccino
	name = "Cappuccino"
	id = "cappuccino"
	result = /decl/reagent/drink/coffee/cappuccino
	required_reagents = list(/decl/reagent/drink/coffee/espresso = 1, /decl/reagent/drink/milk/cream = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_cappuccino
	name = "Freddo cappuccino"
	id = "freddo_cappuccino"
	result = /decl/reagent/drink/coffee/freddo_cappuccino
	required_reagents = list(/decl/reagent/drink/coffee/cappuccino = 1, /decl/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/macchiato
	name = "Macchiato"
	id = "macchiato"
	result = /decl/reagent/drink/coffee/macchiato
	required_reagents = list(/decl/reagent/drink/coffee/cappuccino = 1, /decl/reagent/drink/coffee/espresso = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mocacchino
	name = "Mocacchino"
	id = "mocacchino"
	result = /decl/reagent/drink/coffee/mocacchino
	required_reagents = list(/decl/reagent/drink/coffee/flat_white = 1, /decl/reagent/drink/syrup_chocolate = 1)
	result_amount = 2

/datum/chemical_reaction/drink/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = /decl/reagent/alcohol/acid_spit
	required_reagents = list(/decl/reagent/acid = 1, /decl/reagent/alcohol/wine = 5)
	result_amount = 6

/datum/chemical_reaction/drink/amasec
	name = "Amasec"
	id = "amasec"
	result = /decl/reagent/alcohol/amasec
	required_reagents = list(/decl/reagent/iron = 1, /decl/reagent/alcohol/wine = 5, /decl/reagent/alcohol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/drink/gibsonpunch
	name = "Gibson Punch"
	id = "gibsonpunch"
	result = /decl/reagent/alcohol/gibsonpunch
	required_reagents = list(/decl/reagent/alcohol/screwdrivercocktail = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aloe
	name = "Aloe"
	id = "aloe"
	result = /decl/reagent/alcohol/aloe
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/drink/watermelonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = /decl/reagent/alcohol/andalusia
	required_reagents = list(/decl/reagent/alcohol/rum = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = /decl/reagent/alcohol/neurotoxin
	required_reagents = list(/decl/reagent/alcohol/gargleblaster = 1, /decl/reagent/soporific = 1)
	result_amount = 2

/datum/chemical_reaction/drink/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = /decl/reagent/alcohol/snowwhite
	required_reagents = list(/decl/reagent/alcohol/beer = 1, /decl/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/drink/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = /decl/reagent/alcohol/irishcarbomb
	required_reagents = list(/decl/reagent/alcohol/ale = 1, /decl/reagent/alcohol/irishcream = 1)
	result_amount = 2

/datum/chemical_reaction/drink/gibsonhooch
	name = "Gibson Hooch"
	id = "gibsonhooch"
	result = /decl/reagent/alcohol/gibsonhooch
	required_reagents = list(/decl/reagent/alcohol/beer = 1, /decl/reagent/alcohol/whiskeycola = 1)
	result_amount = 2

/datum/chemical_reaction/drink/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = /decl/reagent/alcohol/erikasurprise
	required_reagents = list(/decl/reagent/alcohol/ale = 2, /decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/drink/banana = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = /decl/reagent/alcohol/devilskiss
	required_reagents = list(/decl/reagent/blood = 1, /decl/reagent/alcohol/coffee/kahlua = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = /decl/reagent/alcohol/hippiesdelight
	required_reagents = list(/decl/reagent/psilocybin = 1, /decl/reagent/alcohol/gargleblaster = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = /decl/reagent/alcohol/bananahonk
	required_reagents = list(/decl/reagent/drink/banana = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/silencer
	name = "Silencer"
	id = "silencer"
	result = /decl/reagent/alcohol/silencer
	required_reagents = list(/decl/reagent/drink/nothing = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = /decl/reagent/alcohol/driestmartini
	required_reagents = list(/decl/reagent/drink/nothing = 1, /decl/reagent/alcohol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/drink/lemonade
	name = "Lemonade"
	id = "lemonade"
	result = /decl/reagent/drink/lemonade
	required_reagents = list(/decl/reagent/drink/lemonjuice = 1, /decl/reagent/sugar = 1, /decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/drink/lemonade/pink
	name = "Pink Lemonade"
	id = "pinklemonade"
	result = /decl/reagent/drink/lemonade/pink
	required_reagents = list(/decl/reagent/drink/lemonade = 8, /decl/reagent/drink/grenadine = 2)
	result_amount = 10


/datum/chemical_reaction/drink/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	result = /decl/reagent/drink/kiraspecial
	required_reagents = list(/decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/drink/brownstar
	name = "Brown Star"
	id = "brownstar"
	result = /decl/reagent/drink/brownstar
	required_reagents = list(/decl/reagent/drink/orangejuice = 2, /decl/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/milkshake
	name = "Milkshake"
	id = "milkshake"
	result = /decl/reagent/drink/milkshake
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/ice = 2, /decl/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/drink/cmojito
	name = "Champagne Mojito"
	id = "cmojito"
	result = /decl/reagent/alcohol/cmojito
	required_reagents = list(/decl/reagent/drink/mintsyrup = 1, /decl/reagent/alcohol/champagne = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/classic
	name = "The Classic"
	id = "classic"
	result = /decl/reagent/alcohol/classic
	required_reagents = list(/decl/reagent/alcohol/champagne = 2, /decl/reagent/alcohol/bitters = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 4

/datum/chemical_reaction/drink/corkpopper
	name = "Cork Popper"
	id = "corkpopper"
	result = /decl/reagent/alcohol/corkpopper
	required_reagents = list(/decl/reagent/alcohol/whiskey = 1, /decl/reagent/alcohol/champagne = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/french75
	name = "French 75"
	id = "french75"
	result = /decl/reagent/alcohol/french75
	required_reagents = list(/decl/reagent/alcohol/champagne = 2, /decl/reagent/alcohol/gin = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 4

/datum/chemical_reaction/drink/muscmule
	name = "Muscovite Mule"
	id = "muscmule"
	result = /decl/reagent/alcohol/muscmule
	required_reagents = list(/decl/reagent/alcohol/vodka = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/mintsyrup = 1)
	result_amount = 3

/datum/chemical_reaction/drink/omimosa
	name = "Orange Mimosa"
	id = "omimosa"
	result = /decl/reagent/alcohol/omimosa
	required_reagents = list(/decl/reagent/drink/orangejuice = 1, /decl/reagent/alcohol/champagne = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pinkgin
	name = "Pink Gin"
	id = "pinkgin"
	result = /decl/reagent/alcohol/pinkgin
	required_reagents = list(/decl/reagent/alcohol/gin = 2, /decl/reagent/alcohol/bitters = 1)
	result_amount = 3

/datum/chemical_reaction/drink/pinkgintonic
	name = "Pink Gin and Tonic"
	id = "pinkgintonic"
	result = /decl/reagent/alcohol/pinkgintonic
	required_reagents = list(/decl/reagent/alcohol/pinkgin = 2, /decl/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/piratepunch
	name = "Pirate's Punch"
	id = "piratepunch"
	result = /decl/reagent/alcohol/piratepunch
	required_reagents = list(/decl/reagent/alcohol/rum = 1, /decl/reagent/drink/lemonjuice = 1, /decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/grenadine = 1, /decl/reagent/alcohol/bitters = 1)
	result_amount = 5

/datum/chemical_reaction/drink/planterpunch
	name = "Planter's Punch"
	id = "planterpunch"
	result = /decl/reagent/alcohol/planterpunch
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 4

/datum/chemical_reaction/drink/ssroyale
	name = "Southside Royale"
	id = "ssroyale"
	result = /decl/reagent/alcohol/ssroyale
	required_reagents = list(/decl/reagent/drink/mintsyrup = 1, /decl/reagent/alcohol/gin = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/champagne = 1)
	result_amount = 4

/datum/chemical_reaction/drink/rewriter
	name = "Rewriter"
	id = "rewriter"
	result = /decl/reagent/drink/rewriter
	required_reagents = list(/decl/reagent/drink/spacemountainwind = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/suidream
	name = "Sui Dream"
	id = "suidream"
	result = /decl/reagent/alcohol/suidream
	required_reagents = list(/decl/reagent/drink/spaceup = 1, /decl/reagent/alcohol/bluecuracao = 1, /decl/reagent/alcohol/melonliquor = 1)
	result_amount = 3

//aurora's drinks

/datum/chemical_reaction/drink/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = /decl/reagent/alcohol/daiquiri
	required_reagents = list(/decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 2

/datum/chemical_reaction/drink/icepick
	name = "Ice Pick"
	id = "icepick"
	result = /decl/reagent/alcohol/icepick
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/alcohol/vodka = 1)
	result_amount = 2

/datum/chemical_reaction/drink/poussecafe
	name = "Pousse-Cafe"
	id = "poussecafe"
	result = /decl/reagent/alcohol/poussecafe
	required_reagents = list(/decl/reagent/alcohol/brandy = 1, /decl/reagent/alcohol/chartreusegreen = 1, /decl/reagent/alcohol/chartreuseyellow = 1, /decl/reagent/alcohol/cremewhite = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = /decl/reagent/alcohol/mintjulep
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/johncollins
	name = "John Collins"
	id = "johncollins"
	result = /decl/reagent/alcohol/johncollins
	required_reagents = list(/decl/reagent/alcohol/whiskeysoda = 2, /decl/reagent/drink/lemonjuice = 1, /decl/reagent/drink/grenadine = 1, /decl/reagent/drink/ice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/gimlet
	name = "Gimlet"
	id = "gimlet"
	result = /decl/reagent/alcohol/gimlet
	required_reagents = list(/decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/gin = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/starsandstripes
	name = "Stars and Stripes"
	id = "starsandstripes"
	result = /decl/reagent/alcohol/starsandstripes
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/alcohol/cremeyvette = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/metropolitan
	name = "Metropolitan"
	id = "metropolitan"
	result = /decl/reagent/alcohol/metropolitan
	required_reagents = list(/decl/reagent/alcohol/brandy = 1, /decl/reagent/alcohol/vermouth = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/caruso
	name = "Caruso"
	id = "caruso"
	result = /decl/reagent/alcohol/caruso
	required_reagents = list(/decl/reagent/alcohol/martini = 2, /decl/reagent/alcohol/cremewhite = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aprilshower
	name = "April Shower"
	id = "aprilshower"
	result = /decl/reagent/alcohol/aprilshower
	required_reagents = list(/decl/reagent/alcohol/brandy = 1, /decl/reagent/alcohol/chartreuseyellow = 1, /decl/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/carthusiansazerac
	name = "Carthusian Sazerac"
	id = "carthusiansazerac"
	result = /decl/reagent/alcohol/carthusiansazerac
	required_reagents = list(/decl/reagent/alcohol/whiskey = 1, /decl/reagent/alcohol/chartreusegreen = 1, /decl/reagent/drink/grenadine = 1, /decl/reagent/alcohol/absinthe = 1)
	result_amount = 4

/datum/chemical_reaction/drink/deweycocktail
	name = "Dewey Cocktail"
	id = "deweycocktail"
	result = /decl/reagent/alcohol/deweycocktail
	required_reagents = list(/decl/reagent/alcohol/cremeyvette = 1, /decl/reagent/alcohol/gin = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/rustynail
	name = "Rusty Nail"
	id = "rustynail"
	result = /decl/reagent/alcohol/rustynail
	required_reagents = list(/decl/reagent/alcohol/whiskey = 1, /decl/reagent/alcohol/drambuie = 1)
	result_amount = 2

/datum/chemical_reaction/drink/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = /decl/reagent/alcohol/oldfashioned
	required_reagents = list(/decl/reagent/alcohol/whiskeysoda = 3, /decl/reagent/alcohol/bitters = 1, /decl/reagent/sugar = 1)
	result_amount = 5

/datum/chemical_reaction/drink/blindrussian
	name = "Blind Russian"
	id = "blindrussian"
	result = /decl/reagent/alcohol/blindrussian
	required_reagents = list(/decl/reagent/alcohol/coffee/kahlua = 1, /decl/reagent/alcohol/irishcream = 1, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tallrussian
	name = "Tall Black Russian"
	id = "tallrussian"
	result = /decl/reagent/alcohol/tallrussian
	required_reagents = list(/decl/reagent/alcohol/blackrussian = 1, /decl/reagent/drink/space_cola = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cold_gate
	name = "Cold Gate"
	id = "cold_gate"
	result = /decl/reagent/drink/toothpaste/cold_gate
	result_amount = 3
	required_reagents = list(/decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/ice = 1, /decl/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/waterfresh
	name = "Waterfresh"
	id = "waterfresh"
	result = /decl/reagent/drink/toothpaste/waterfresh
	result_amount = 3
	required_reagents = list(/decl/reagent/drink/tonic = 1, /decl/reagent/drink/sodawater = 1, /decl/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/sedantian_firestorm
	name = "Sedantian Firestorm"
	id = "sedantian_firestorm"
	result = /decl/reagent/drink/toothpaste/sedantian_firestorm
	result_amount = 2
	required_reagents = list(/decl/reagent/toxin/phoron = 1, /decl/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/kois_odyne
	name = "Kois Odyne"
	id = "kois_odyne"
	result = /decl/reagent/drink/toothpaste/kois_odyne
	result_amount = 3
	required_reagents = list(/decl/reagent/drink/tonic = 1, /decl/reagent/kois = 1, /decl/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/adhomai_milk
	name = "Fermented Fatshouters Milk"
	id = "adhomai_milk"
	result = /decl/reagent/drink/milk/adhomai/fermented
	required_reagents = list(/decl/reagent/drink/milk/adhomai = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 1

// Synnono Meme Drinks
//==============================
// Organized here because why not.

/datum/chemical_reaction/drink/badtouch
	name = "Bad Touch"
	id = "badtouch"
	result = /decl/reagent/alcohol/badtouch
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/alcohol/rum = 2, /decl/reagent/alcohol/absinthe = 1, /decl/reagent/drink/lemon_lime = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bluelagoon
	name = "Blue Lagoon"
	id = "bluelagooon"
	result = /decl/reagent/alcohol/bluelagoon
	required_reagents = list(/decl/reagent/drink/lemonade = 3, /decl/reagent/alcohol/vodka = 1, /decl/reagent/alcohol/bluecuracao = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/cherrytreefireball
	name = "Cherry Tree Fireball"
	id = "cherrytreefireball"
	result = /decl/reagent/alcohol/cherrytreefireball
	required_reagents = list(/decl/reagent/drink/lemonade = 3, /decl/reagent/alcohol/fireball = 1, /decl/reagent/nutriment/cherryjelly = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cobaltvelvet
	name = "Cobalt Velvet"
	id = "cobaltvelvet"
	result = /decl/reagent/alcohol/cobaltvelvet
	required_reagents = list(/decl/reagent/alcohol/champagne = 3, /decl/reagent/alcohol/bluecuracao = 2, /decl/reagent/drink/space_cola = 1)
	result_amount = 6

/datum/chemical_reaction/drink/fringeweaver
	name = "Fringe Weaver"
	id = "fringeweaver"
	result = /decl/reagent/alcohol/fringeweaver
	required_reagents = list(/decl/reagent/alcohol = 2, /decl/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/junglejuice
	name = "Jungle Juice"
	id = "junglejuice"
	result = /decl/reagent/alcohol/junglejuice
	required_reagents = list(/decl/reagent/drink/lemonjuice = 1, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/lemon_lime = 1, /decl/reagent/alcohol/vodka = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 5

/datum/chemical_reaction/drink/marsarita
	name = "Marsarita"
	id = "marsarita"
	result = /decl/reagent/alcohol/marsarita
	required_reagents = list(/decl/reagent/alcohol/margarita = 4, /decl/reagent/alcohol/bluecuracao = 1, /decl/reagent/capsaicin = 1)
	result_amount = 6

/datum/chemical_reaction/drink/meloncooler
	name = "Melon Cooler"
	id = "meloncooler"
	result = /decl/reagent/drink/meloncooler
	required_reagents = list(/decl/reagent/drink/watermelonjuice = 2, /decl/reagent/drink/sodawater = 2, /decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/midnightkiss
	name = "Midnight Kiss"
	id = "midnightkiss"
	result = /decl/reagent/alcohol/midnightkiss
	required_reagents = list(/decl/reagent/alcohol/champagne = 3, /decl/reagent/alcohol/vodka = 1, /decl/reagent/alcohol/bluecuracao = 1)
	result_amount = 5

/datum/chemical_reaction/drink/millionairesour
	name = "Millionaire Sour"
	id = "millionairesour"
	result = /decl/reagent/drink/millionairesour
	required_reagents = list(/decl/reagent/drink/spacemountainwind = 3, /decl/reagent/drink/grenadine = 1, /decl/reagent/drink/limejuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/olympusmons
	name = "Olympus Mons"
	id = "olympusmons"
	result = /decl/reagent/alcohol/olympusmons
	required_reagents = list(/decl/reagent/alcohol/blackrussian = 1, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/europanail
	name = "Europa Nail"
	id = "europanail"
	result = /decl/reagent/alcohol/europanail
	required_reagents = list(/decl/reagent/alcohol/rustynail = 2, /decl/reagent/alcohol/coffee/kahlua = 2, /decl/reagent/drink/milk/cream = 2)
	result_amount = 6

/datum/chemical_reaction/drink/portsvilleminttea
	name = "Portsville Mint Tea"
	id = "portsvilleminttea"
	result = /decl/reagent/drink/tea/portsvilleminttea
	required_reagents = list(/decl/reagent/drink/icetea = 3, /decl/reagent/drink/berryjuice = 1, /decl/reagent/drink/mintsyrup = 1, /decl/reagent/sugar = 1)
	result_amount = 6

/datum/chemical_reaction/drink/shirleytemple
	name = "Shirley Temple"
	id = "shirleytemple"
	result = /decl/reagent/drink/shirleytemple
	required_reagents = list(/decl/reagent/drink/spaceup = 4, /decl/reagent/drink/grenadine = 2)
	result_amount = 6

/datum/chemical_reaction/drink/sugarrush
	name = "Sugar Rush"
	id = "sugarrush"
	result = /decl/reagent/alcohol/sugarrush
	required_reagents = list(/decl/reagent/drink/brownstar = 4, /decl/reagent/drink/grenadine = 1, /decl/reagent/alcohol/vodka = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sangria
	name = "Sangria"
	id = "sangria"
	result = /decl/reagent/alcohol/sangria
	required_reagents = list(/decl/reagent/alcohol/wine = 3, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/lemonjuice = 1, /decl/reagent/alcohol/brandy = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bassline
	name = "Bassline"
	id = "bassline"
	result = /decl/reagent/alcohol/bassline
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/alcohol/bluecuracao = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/grapejuice = 2)
	result_amount = 6

/datum/chemical_reaction/drink/bluebird
	name = "Bluebird"
	id = "bluebird"
	result = /decl/reagent/alcohol/bluebird
	required_reagents = list(/decl/reagent/alcohol/gintonic = 3, /decl/reagent/alcohol/bluecuracao = 1)
	result_amount = 4

//Snowflake drinks
/datum/chemical_reaction/drink/dr_gibb_diet
	name = "Diet Dr. Gibb"
	id = "dr_gibb_diet"
	result = /decl/reagent/drink/dr_gibb_diet
	required_reagents = list(/decl/reagent/drink/dr_gibb = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/dr_daniels
	name = "Dr. Daniels"
	id = "dr_daniels"
	result = /decl/reagent/alcohol/drdaniels
	required_reagents = list(/decl/reagent/drink/dr_gibb_diet = 3, /decl/reagent/alcohol/whiskey = 1, /decl/reagent/nutriment/honey = 1)
	result_amount = 5

/datum/chemical_reaction/drink/meatshake
	name = "Meatshake"
	id = "meatshake"
	result = /decl/reagent/drink/meatshake
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/nutriment/protein = 1,/decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/drink/crocodile_booze
	name = "Crocodile Guwan"
	id = "crocodile_booze"
	result = /decl/reagent/alcohol/butanol/crocodile_booze
	required_reagents = list(/decl/reagent/alcohol/butanol/sarezhiwine = 5, /decl/reagent/toxin = 1)
	result_amount = 6

/datum/chemical_reaction/drink/messa_mead
	name = "Messa's Mead"
	id = "messa_mead"
	result = /decl/reagent/alcohol/messa_mead
	required_reagents = list(/decl/reagent/nutriment/honey = 1, /decl/reagent/drink/earthenrootjuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/winter_offensive
	name = "Winter Offensive"
	id = "winter_offensive"
	result = /decl/reagent/alcohol/winter_offensive
	required_reagents = list(/decl/reagent/drink/ice = 1, /decl/reagent/alcohol/victorygin = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mars_coffee
	name = "Martian Special"
	id = "mars_coffee"
	result = /decl/reagent/drink/coffee/mars
	required_reagents = list(/decl/reagent/drink/coffee = 4, /decl/reagent/blackpepper = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mountain_marauder
	name = "Mountain Marauder"
	id = "mountain_marauder"
	result = /decl/reagent/alcohol/mountain_marauder
	required_reagents = list(/decl/reagent/drink/milk/adhomai/fermented = 1, /decl/reagent/alcohol/victorygin = 1)
	result_amount = 2

//Kaed's Unathi cocktails
//========

/datum/chemical_reaction/drink/moghesmargarita
	name = "Moghes Margarita"
	id = "moghesmargarita"
	result = /decl/reagent/alcohol/butanol/moghesmargarita
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 2, /decl/reagent/drink/limejuice = 3)
	result_amount = 5

/datum/chemical_reaction/drink/bahamalizard
	name = "Bahama Lizard"
	id = "bahamalizard"
	result = /decl/reagent/alcohol/butanol/bahamalizard
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 2, /decl/reagent/drink/lemonjuice = 2, /decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cactuscreme
	name = "Cactus Creme"
	id = "cactuscreme"
	result = /decl/reagent/alcohol/butanol/cactuscreme
	required_reagents = list(/decl/reagent/drink/berryjuice = 2, /decl/reagent/drink/milk/cream = 1, /decl/reagent/alcohol/butanol/xuizijuice = 2)
	result_amount = 5

/datum/chemical_reaction/drink/lizardplegm
	name = "Lizard Phlegm"
	id = "lizardphlegm"
	result = /decl/reagent/alcohol/butanol/lizardphlegm
	required_reagents = list(/decl/reagent/drink/milk/cream = 2, /decl/reagent/drink/banana = 1, /decl/reagent/alcohol/butanol/xuizijuice = 1, /decl/reagent/drink/watermelonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cactustea
	name = "Cactus Tea"
	id = "cactustea"
	result = /decl/reagent/alcohol/butanol/cactustea
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/alcohol/butanol/xuizijuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/moghespolitan
	name = "Moghespolitan"
	id = "moghespolitan"
	result = /decl/reagent/alcohol/butanol/moghespolitan
	required_reagents = list(/decl/reagent/alcohol/butanol/sarezhiwine = 2, /decl/reagent/alcohol/butanol/xuizijuice = 1, /decl/reagent/drink/grenadine = 5)
	result_amount = 5

/datum/chemical_reaction/drink/wastelandheat
	name = "Wasteland Heat"
	id = "wastelandheat"
	result = /decl/reagent/alcohol/butanol/wastelandheat
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 10, /decl/reagent/capsaicin = 3)
	result_amount = 10

/datum/chemical_reaction/drink/sandgria
	name = "Sandgria"
	id = "sandgria"
	result = /decl/reagent/alcohol/butanol/sandgria
	required_reagents = list(/decl/reagent/alcohol/butanol/sarezhiwine = 3, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/lemonjuice = 1, /decl/reagent/alcohol/butanol/xuizijuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/contactwine
	name = "Contact Wine"
	id = "contactwine"
	result = /decl/reagent/alcohol/butanol/contactwine
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 5, /decl/reagent/radium = 1, /decl/reagent/alcohol/butanol/sarezhiwine = 5)
	result_amount = 10

/datum/chemical_reaction/drink/hereticblood
	name = "Heretics' Blood"
	id = "hereticblood"
	result = /decl/reagent/alcohol/butanol/hereticblood
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 3, /decl/reagent/drink/spacemountainwind = 1, /decl/reagent/blood = 1, /decl/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sandpit
	name = "Sandpit"
	id = "sandpit"
	result = /decl/reagent/alcohol/butanol/sandpit
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 2, /decl/reagent/drink/orangejuice = 2)
	result_amount = 4

/datum/chemical_reaction/drink/cactuscola
	name = "Cactus Cola"
	id = "cactuscola"
	result = /decl/reagent/alcohol/butanol/cactuscola
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 2, /decl/reagent/drink/space_cola = 2, /decl/reagent/drink/ice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/bloodwine
	name = "Bloodwine"
	id = "bloodwine"
	result = /decl/reagent/alcohol/butanol/bloodwine
	required_reagents = list(/decl/reagent/blood = 2, /decl/reagent/alcohol/butanol/sarezhiwine = 3)
	result_amount = 5

/datum/chemical_reaction/pumpkinspice
	name = "Pumpkin Spice"
	id = "pumpkinspce"
	result = /decl/reagent/spacespice/pumpkinspice
	mix_message = "The spice brightens up."
	required_reagents = list(/decl/reagent/spacespice = 8, /decl/reagent/nutriment/pumpkinpulp = 2)
	result_amount = 10

/datum/chemical_reaction/drink/psfrappe
	name = "Pumpkin Spice Frappe"
	id = "psfrappe"
	result = /decl/reagent/drink/coffee/icecoffee/psfrappe
	required_reagents = list(/decl/reagent/drink/coffee/icecoffee = 6, /decl/reagent/drink/syrup_pumpkin = 2, /decl/reagent/drink/milk/cream = 2)
	result_amount = 10

/datum/chemical_reaction/drink/pslatte
	name = "Pumpkin Spice Latte"
	id = "pslatte"
	result = /decl/reagent/drink/coffee/latte/pumpkinspice
	required_reagents = list(/decl/reagent/drink/coffee = 6, /decl/reagent/drink/syrup_pumpkin = 2, /decl/reagent/drink/milk/cream = 2)
	result_amount = 10

/datum/chemical_reaction/drink/caramel_latte
	name = "Caramel latte"
	id = "caramellatte"
	result = /decl/reagent/drink/coffee/latte/caramel
	required_reagents = list(/decl/reagent/drink/coffee/latte = 4, /decl/reagent/drink/syrup_caramel = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mocha_latte
	name = "Mocha latte"
	id = "mochalatte"
	result = /decl/reagent/drink/coffee/latte/mocha
	required_reagents = list(/decl/reagent/drink/coffee/latte = 4, /decl/reagent/drink/syrup_chocolate = 1)
	result_amount = 5

/datum/chemical_reaction/drink/vanilla_latte
	name = "Vanilla latte"
	id = "vanillalatte"
	result = /decl/reagent/drink/coffee/latte/vanilla
	required_reagents = list(/decl/reagent/drink/coffee/latte = 4, /decl/reagent/drink/syrup_vanilla = 1)
	result_amount = 5

//Skrell drinks. Bring forth the culture.
//===========================================

/datum/chemical_reaction/drink/thirdincident
	name = "The Third Incident"
	id = "thirdincident"
	result = /decl/reagent/alcohol/thirdincident
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/alcohol/bluecuracao = 10, /decl/reagent/drink/grapejuice = 10)
	result_amount = 20

/datum/chemical_reaction/drink/upsidedowncup
	name = "Upside-Down Cup"
	id = "upsidedowncup"
	result = /decl/reagent/drink/upsidedowncup
	required_reagents = list(/decl/reagent/drink/dr_gibb = 3, /decl/reagent/drink/ice = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cigarettelizard
	name = "Cigarette Lizard"
	id = "cigarettelizard"
	result = /decl/reagent/drink/smokinglizard
	required_reagents = list(/decl/reagent/drink/limejuice = 2, /decl/reagent/drink/sodawater = 2, /decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sromshine
	name = "Sromshine"
	id = "sromshine"
	result = /decl/reagent/drink/coffee/sromshine
	required_reagents = list(/decl/reagent/drink/coffee = 2, /decl/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/cbsc
	name = "Complex Bluespace Calculation"
	id = "cbsc"
	result = /decl/reagent/alcohol/cbsc
	required_reagents = list(/decl/reagent/alcohol/wine = 4, /decl/reagent/alcohol/vodka = 2, /decl/reagent/drink/sodawater = 3, /decl/reagent/radium = 1 )
	result_amount = 10

/datum/chemical_reaction/drink/dynhot
	name = "Dyn Tea"
	id = "dynhot"
	result = /decl/reagent/drink/dynjuice/hot
	required_reagents = list(/decl/reagent/drink/dynjuice = 1, /decl/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/drink/dyncold
	name = "Dyn Ice Tea"
	id = "dyncold"
	result = /decl/reagent/drink/dynjuice/cold
	required_reagents = list(/decl/reagent/drink/dynjuice = 1, /decl/reagent/drink/ice = 2, /decl/reagent/drink/sodawater = 2)
	result_amount = 5

/datum/chemical_reaction/drink/algaesuprise
	name = "Pl'iuop Algae Surprise"
	id = "algaesuprise"
	result = /decl/reagent/drink/algaesuprise
	required_reagents = list(/decl/reagent/nutriment/virusfood = 2, /decl/reagent/drink/banana = 1)
	result_amount = 3

/datum/chemical_reaction/drink/xrim
	name = "Xrim Garden"
	id = "xrim"
	result = /decl/reagent/drink/xrim
	required_reagents = list(/decl/reagent/nutriment/virusfood = 2, /decl/reagent/drink/watermelonjuice = 1, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/zorasoda/cthur = 1)
	result_amount = 6

/datum/chemical_reaction/drink/rixulin_sundae
	name = "Rixulin Sundae"
	id = "rixulin_sundae"
	result = /decl/reagent/alcohol/rixulin_sundae
	required_reagents = list(/decl/reagent/nutriment/virusfood = 3, /decl/reagent/wulumunusha = 1, /decl/reagent/alcohol/whitewine = 2)
	result_amount = 6

//Tea and cider
//=======================

/datum/chemical_reaction/drink/cidercheap
	name = "Apple Cider Juice"
	id = "cidercheap"
	result = /decl/reagent/drink/cidercheap
	required_reagents = list(/decl/reagent/drink/applejuice = 2, /decl/reagent/sugar = 1, /decl/reagent/spacespice = 1)
	result_amount = 4

/datum/chemical_reaction/cinnamonapplewhiskey
	name = "Cinnamon Apple Whiskey"
	id = "cinnamonapplewhiskey"
	result = /decl/reagent/alcohol/cinnamonapplewhiskey
	required_reagents = list(/decl/reagent/drink/ciderhot = 3, /decl/reagent/alcohol/fireball = 1)
	result_amount = 4

/datum/chemical_reaction/drink/chailatte
	name = "Chai Latte"
	id = "chailatte"
	result = /decl/reagent/drink/tea/chaitealatte
	required_reagents = list(/decl/reagent/drink/tea/chaitea = 1, /decl/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/chailatte/soy
	id = "chailattesoy"
	required_reagents = list(/decl/reagent/drink/tea/chaitea = 1, /decl/reagent/drink/milk/soymilk = 1)

/datum/chemical_reaction/drink/coco_chaitea
	name = "Chocolate Chai"
	id = "coco_chaitea"
	result = /decl/reagent/drink/tea/coco_chaitea
	required_reagents = list(/decl/reagent/drink/tea/chaitea = 2, /decl/reagent/nutriment/coco = 1)
	result_amount = 3

/datum/chemical_reaction/drink/coco_chailatte
	name = "Chocolate Chai Latte"
	id = "coco_chailatte"
	result = /decl/reagent/drink/tea/coco_chailatte
	required_reagents = list(/decl/reagent/drink/tea/coco_chaitea = 1, /decl/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/coco_chailatte/soy
	id = "coco_chailatte_soy"
	required_reagents = list(/decl/reagent/drink/tea/coco_chaitea = 1, /decl/reagent/drink/milk/soymilk = 1)

/datum/chemical_reaction/drink/cofftea
	name = "Cofftea"
	id = "cofftea"
	result = /decl/reagent/drink/tea/cofftea
	required_reagents = list(/decl/reagent/drink/tea = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bureacratea
	name = "Bureacratea"
	id = "bureacratea"
	result = /decl/reagent/drink/tea/bureacratea
	required_reagents = list(/decl/reagent/drink/tea = 1, /decl/reagent/drink/coffee/espresso = 1)
	result_amount = 2

/datum/chemical_reaction/drink/desert_tea
	name = "Desert Blossom Tea"
	id = "desert_tea"
	result = /decl/reagent/drink/tea/desert_tea
	required_reagents = list(/decl/reagent/drink/tea/greentea = 2, /decl/reagent/alcohol/butanol/xuizijuice = 1, /decl/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/drink/halfandhalf
	name = "Half and Half"
	id = "halfandhalf"
	result = /decl/reagent/drink/tea/halfandhalf
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/drink/lemonade = 1)
	result_amount = 2

/datum/chemical_reaction/drink/heretic_tea
	name = "Heretics Tea"
	id = "heretic_tea"
	result = /decl/reagent/drink/tea/heretic_tea
	required_reagents = list(/decl/reagent/drink/icetea = 3, /decl/reagent/blood = 1, /decl/reagent/drink/spacemountainwind = 1, /decl/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/kira_tea
	name = "Kira tea"
	id = "kira_tea"
	result = /decl/reagent/drink/tea/kira_tea
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/drink/kiraspecial = 1)
	result_amount = 2

/datum/chemical_reaction/drink/librarian_special
	name = "Librarian Special"
	id = "librarian_special"
	result = /decl/reagent/drink/tea/librarian_special
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/nothing = 1)
	result_amount = 3

/datum/chemical_reaction/drink/mars_tea
	name = "Martian Tea"
	id = "mars_tea"
	result = /decl/reagent/drink/tea/mars_tea
	required_reagents = list(/decl/reagent/drink/tea = 4, /decl/reagent/blackpepper = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mars_tea/green
	required_reagents = list(/decl/reagent/drink/tea/greentea = 4, /decl/reagent/blackpepper = 1)

/datum/chemical_reaction/drink/mendell_tea
	name = "Mendell Afternoon Tea"
	id = "mendell_tea"
	result = /decl/reagent/drink/tea/mendell_tea
	required_reagents = list(/decl/reagent/drink/tea/greentea = 4, /decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/berry_tea
	name = "Mixed Berry Tea"
	id = "berry_tea"
	result = /decl/reagent/drink/tea/berry_tea
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/berryjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/berry_tea/green
	required_reagents = list(/decl/reagent/drink/tea/greentea = 2, /decl/reagent/drink/berryjuice = 1)

/datum/chemical_reaction/drink/pomegranate_icetea
	name = "Pomegranate Iced Tea"
	id = "pomegranate_icetea"
	result = /decl/reagent/drink/tea/pomegranate_icetea
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 2

/datum/chemical_reaction/drink/potatea
	name = "Potatea"
	id = "potatea"
	result = /decl/reagent/drink/tea/potatea
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/potatojuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea
	name = "Securitea"
	id = "securitea"
	result = /decl/reagent/drink/tea/securitea
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea/red
	id = "securitea_red"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/red = 1)
/datum/chemical_reaction/drink/securitea/orange
	id = "securitea_orange"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/orange = 1)
/datum/chemical_reaction/drink/securitea/yellow
	id = "securitea_yellow"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/yellow = 1)
/datum/chemical_reaction/drink/securitea/green
	id = "securitea_green"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/green = 1)
/datum/chemical_reaction/drink/securitea/blue
	id = "securitea_blue"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/blue = 1)
/datum/chemical_reaction/drink/securitea/purple
	id = "securitea_purple"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/purple = 1)
/datum/chemical_reaction/drink/securitea/grey
	id = "securitea_grey"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/grey = 1)
/datum/chemical_reaction/drink/securitea/brown
	id = "securitea_brown"
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/crayon_dust/brown = 1)

/datum/chemical_reaction/drink/sleepytime_tea
	name = "Sleepytime Tea"
	id = "sleepytime_tea"
	result = /decl/reagent/drink/tea/sleepytime_tea
	required_reagents = list(/decl/reagent/drink/tea = 5, /decl/reagent/soporific = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sleepytime_tea/green
	id = "sleepytime_greentea"
	required_reagents = list(/decl/reagent/drink/tea/greentea = 5, /decl/reagent/soporific = 1)

/datum/chemical_reaction/drink/hakhma_tea
	name = "Spiced Hakhma Tea"
	id = "hakhma_tea"
	result = /decl/reagent/drink/tea/hakhma_tea
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/milk/beetle = 2, /decl/reagent/spacespice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/sweet_tea
	name = "Sweet Tea"
	id = "sweet_tea"
	result = /decl/reagent/drink/tea/sweet_tea
	required_reagents = list(/decl/reagent/drink/icetea = 1, /decl/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/drink/teathpaste
	name = "Teathpaste"
	id = "teathpaste"
	result = /decl/reagent/drink/toothpaste/teathpaste
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/toothpaste = 1)
	result_amount = 3

/datum/chemical_reaction/drink/thewake
	name = "The Wake"
	id = "thewake"
	result = /decl/reagent/drink/dynjuice/thewake
	required_reagents = list(/decl/reagent/drink/dynjuice = 1, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/tea = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tomatea
	name = "Tomatea"
	id = "tomatea"
	result = /decl/reagent/drink/tea/tomatea
	required_reagents = list(/decl/reagent/drink/tea = 2, /decl/reagent/drink/tomatojuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/trizkizki_tea
	name = "Trizkizki Tea"
	id = "trizkizki_tea"
	result = /decl/reagent/alcohol/butanol/trizkizki_tea
	required_reagents = list(/decl/reagent/drink/tea/greentea = 1, /decl/reagent/alcohol/butanol/sarezhiwine = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tropical_icetea
	name = "Tropical Iced Tea"
	id = "tropical_icetea"
	result = /decl/reagent/drink/tea/tropical_icetea
	required_reagents = list(/decl/reagent/drink/icetea = 3, /decl/reagent/drink/limejuice = 1, /decl/reagent/drink/orangejuice = 1, /decl/reagent/drink/watermelonjuice = 1)
	result_amount = 6

//transmutation

/datum/chemical_reaction/transmutation_silver
	name = "Transmutation: Silver"
	id = "transmutation_silver"
	result = null
	required_reagents = list(/decl/reagent/iron = 5, /decl/reagent/copper = 5)
	catalysts = list(/decl/reagent/philosopher_stone = 1)
	result_amount = 1

/datum/chemical_reaction/transmutation_silver/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/material/silver(location)
	return

/datum/chemical_reaction/transmutation_gold
	name = "Transmutation: Gold"
	id = "transmutation_gold"
	result = null
	required_reagents = list(/decl/reagent/aluminum = 5, /decl/reagent/silver = 5)
	catalysts = list(/decl/reagent/philosopher_stone = 1)
	result_amount = 1

/datum/chemical_reaction/transmutation_gold/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/material/gold(location)
	return

/datum/chemical_reaction/transmutation_diamond
	name = "Transmutation: Diamond"
	id = "transmutation_diamond"
	result = null
	required_reagents = list(/decl/reagent/carbon = 5, /decl/reagent/gold = 5)
	catalysts = list(/decl/reagent/philosopher_stone = 1)
	result_amount = 1

/datum/chemical_reaction/transmutation_diamond/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/material/diamond(location)
	return

//Temperature Additions
/datum/chemical_reaction/water_to_ice
	name = "Water to Ice"
	id = "water_to_ice"
	result = /decl/reagent/drink/ice
	required_reagents = list(/decl/reagent/water = 1)
	required_temperature_max = T0C
	result_amount = 1
	mix_message = "The water freezes."
	reaction_sound = ""

/datum/chemical_reaction/ice_to_water
	name = "Ice to Water"
	id = "ice_to_water"
	result = /decl/reagent/water
	required_reagents = list(/decl/reagent/drink/ice = 1)
	required_temperature_min = T0C + 25 // stop-gap fix to allow recipes requiring ice to be made without breaking the server with HALF_LIFE
	result_amount = 1
	mix_message = "The ice melts."
	reaction_sound = ""

/datum/chemical_reaction/pyrosilicate
	name = "Pyrosilicate"
	id = "pyrosilicate"
	result = /decl/reagent/pyrosilicate
	result_amount = 4
	required_reagents = list(/decl/reagent/silicate = 1, /decl/reagent/acid = 1, /decl/reagent/hydrazine = 1, /decl/reagent/iron = 1)

/datum/chemical_reaction/cryosurfactant
	name = "Cryosurfactant"
	id = "cryosurfactant"
	result = /decl/reagent/cryosurfactant
	result_amount = 3
	required_reagents = list(/decl/reagent/surfactant = 1, /decl/reagent/drink/ice = 1, /decl/reagent/sodium = 1)

//WATER
/datum/chemical_reaction/cryosurfactant_cooling_water
	name = "Cryosurfactant Cooling Water"
	id = "cryosurfactant_cooling_water"
	result = null
	result_amount = 1
	required_reagents = list(/decl/reagent/cryosurfactant = 1)
	inhibitors = list(/decl/reagent/pyrosilicate = 1)
	catalysts = list(/decl/reagent/water = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_water/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent(/decl/reagent/cryosurfactant)
	holder.add_thermal_energy(-created_volume*500)

//ICE
/datum/chemical_reaction/cryosurfactant_cooling_ice
	name = "Cryosurfactant Cooling Ice"
	id = "cryosurfactant_cooling_ice"
	result = null
	result_amount = 1
	required_reagents = list(/decl/reagent/cryosurfactant = 1)
	inhibitors = list(/decl/reagent/pyrosilicate = 1)
	catalysts = list(/decl/reagent/drink/ice = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_ice/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent(/decl/reagent/cryosurfactant)
	holder.add_thermal_energy(-created_volume*500)

/datum/chemical_reaction/pyrosilicate_heating
	name = "Pyrosilicate Heating"
	id = "pyrosilicate_heating"
	result = null
	result_amount = 1
	required_reagents = list(/decl/reagent/pyrosilicate = 1)
	inhibitors = list(/decl/reagent/cryosurfactant = 1)
	catalysts = list(/decl/reagent/sodiumchloride = 1)

/datum/chemical_reaction/pyrosilicate_heating/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.del_reagent(/decl/reagent/pyrosilicate)
	holder.add_thermal_energy(created_volume*1000)

/datum/chemical_reaction/pyrosilicate_cryosurfactant
	name = "Pyrosilicate Cryosurfactant Reaction"
	id = "pyrosilicate_cryosurfactant"
	result = null
	required_reagents = list(/decl/reagent/pyrosilicate = 1, /decl/reagent/cryosurfactant = 1)
	required_temperature_min = T0C //Does not react when below these temperatures.
	result_amount = 1

/datum/chemical_reaction/pyrosilicate_cryosurfactant/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	if(created_volume)
		var/turf/simulated/floor/T = get_turf(holder.my_atom.loc)
		if(istype(T))
			T.assume_gas(GAS_OXYGEN, created_volume*10, (created_thermal_energy/created_volume) )

/datum/chemical_reaction/rmt
	name = "RMT"
	id = "rmt"
	result = /decl/reagent/rmt
	result_amount = 2
	required_reagents = list(/decl/reagent/potassium = 1, /decl/reagent/inaprovaline = 1)

/datum/chemical_reaction/gunpowder
	name = "Gunpowder"
	id = "gunpowder"
	result = /decl/reagent/gunpowder
	result_amount = 1
	required_reagents = list(/decl/reagent/sulfur = 1, /decl/reagent/carbon = 1, /decl/reagent/potassium = 1)

//Coffee expansion
//=======================
/datum/chemical_reaction/drink/coffee
	name = "Coffee"
	id = "coffee"
	result = /decl/reagent/drink/coffee
	required_reagents = list(/decl/reagent/nutriment/coffeegrounds = 1, /decl/reagent/water = 5)
	result_amount = 5

/datum/chemical_reaction/drink/espresso
	name = "Espresso"
	id = "espresso"
	result = /decl/reagent/drink/coffee/espresso
	required_reagents = list(/decl/reagent/nutriment/darkcoffeegrounds = 1, /decl/reagent/water = 5)
	result_amount = 5

/datum/chemical_reaction/caramelisation
	name = "Caramelised Sugar"
	result = /decl/reagent/nutriment/caramel
	required_reagents = list(/decl/reagent/sugar = 1)
	result_amount = 1
	required_temperature_min = T0C + 82 // no maximum! i mean technically it should burn at some point but ehh
	mix_message = "The sugar melts into a sticky, brown liquid."

/datum/chemical_reaction/caramelsauce
	name = "Caramel Sauce"
	id = "caramelsauce"
	result = /decl/reagent/drink/caramel
	required_reagents = list(/decl/reagent/nutriment/caramel = 2, /decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/syrup_simple = 2)
	result_amount = 5
	mix_message = "The solution thickens into a glossy, brown sauce."
	required_temperature_max = T0C + 82 // You don't want the syrup to crystallise/caramelise; that'd just make more caramel...

/datum/chemical_reaction/simplesyrup
	name = "Simple Syrup"
	id = "simplesyrup"
	result = /decl/reagent/drink/syrup_simple
	required_reagents = list(/decl/reagent/sugar = 2, /decl/reagent/water = 2) // simple syrup, the sugar dissolves and doesn't change the volume too much
	result_amount = 2
	required_temperature_min = T0C + 30
	required_temperature_max = T0C + 100 // Sugar caramelises after 82C, water boils at 100C.
	mix_message = "The sugar dissolves into the solution."

/datum/chemical_reaction/vanillasyrup
	name = "Vanilla Syrup"
	id = "vanillasyrup"
	result = /decl/reagent/drink/syrup_vanilla
	required_reagents = list(/decl/reagent/nutriment/vanilla = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on a pale yellow hue and the aroma of vanilla."

/datum/chemical_reaction/caramelsyrup
	name = "Caramel Syrup"
	id = "caramelsyrup"
	result = /decl/reagent/drink/syrup_caramel
	required_reagents = list(/decl/reagent/nutriment/caramel = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on a light brown hue and the aroma of caramel."

/datum/chemical_reaction/chocosyrup
	name = "Chocolate Syrup"
	id = "chocolatesyrup"
	result = /decl/reagent/drink/syrup_chocolate
	required_reagents = list(/decl/reagent/nutriment/coco = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on a brown hue and the aroma of chocolate."

/datum/chemical_reaction/pumpkinsyrup
	name = "Pumpkin Spice Syrup"
	id = "pumpkinsyrup"
	result = /decl/reagent/drink/syrup_pumpkin
	required_reagents = list(/decl/reagent/spacespice/pumpkinspice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on an orange hue and the aroma of pumpkin spice."

/datum/chemical_reaction/mintsyrup
	name = "Mint Syrup"
	id = "mintsyrup"
	result = /decl/reagent/drink/mintsyrup
	required_reagents = list(/decl/reagent/nutriment/mint = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

//
/datum/chemical_reaction/berrysyrup
	name = "Berry Syrup"
	id = "berrysyrup"
	result = /decl/reagent/drink/syrup_berry
	required_reagents = list(/decl/reagent/drink/berryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/strawberrysyrup
	name = "Strawberry Syrup"
	id = "strawberrysyrup"
	result = /decl/reagent/drink/syrup_strawberry
	required_reagents = list(/decl/reagent/drink/strawberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/blueberrysyrup
	name = "Blueberry Syrup"
	id = "blueberrysyrup"
	result = /decl/reagent/drink/syrup_blueberry
	required_reagents = list(/decl/reagent/drink/blueberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/raspberrysyrup
	name = "Raspberry Syrup"
	id = "raspberrysyrup"
	result = /decl/reagent/drink/syrup_raspberry
	required_reagents = list(/decl/reagent/drink/raspberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/blueraspberrysyrup
	name = "Blue Raspberry Syrup"
	id = "blueraspberrysyrup"
	result = /decl/reagent/drink/syrup_blueraspberry
	required_reagents = list(/decl/reagent/drink/blueraspberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/blackraspberrysyrup
	name = "Black Raspberry Syrup"
	id = "blackraspberrysyrup"
	result = /decl/reagent/drink/syrup_blackraspberry
	required_reagents = list(/decl/reagent/drink/blackraspberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/poisonberrysyrup
	name = "Poison Berry Syrup"
	id = "poisonberrysyrup"
	result = /decl/reagent/drink/syrup_poisonberry
	required_reagents = list(/decl/reagent/toxin/poisonberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/deathberrysyrup
	name = "Death Berry Syrup"
	id = "deathberrysyrup"
	result = /decl/reagent/drink/syrup_deathberry
	required_reagents = list(/decl/reagent/toxin/deathberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/glowberrysyrup
	name = "Glowberry Syrup"
	id = "glowberrysyrup"
	result = /decl/reagent/drink/syrup_glowberry
	required_reagents = list(/decl/reagent/drink/glowberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/ylphaberrysyrup
	name = "Ylpha Berry Syrup"
	id = "ylphaberrysyrup"
	result = /decl/reagent/drink/syrup_ylphaberry
	required_reagents = list(/decl/reagent/drink/ylphaberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

/datum/chemical_reaction/dirtberrysyrup
	name = "Dirt Berry Syrup"
	id = "dirtberrysyrup"
	result = /decl/reagent/drink/syrup_dirtberry
	required_reagents = list(/decl/reagent/drink/dirtberryjuice = 2, /decl/reagent/drink/syrup_simple = 3)
	result_amount = 5

//
/datum/chemical_reaction/drink/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = /decl/reagent/alcohol/cubalibre
	required_reagents = list(/decl/reagent/alcohol/rumandcola = 2, /decl/reagent/drink/limejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/solarian_white
	name = "Solarian White"
	id = "solarian_white"
	result = /decl/reagent/alcohol/solarian_white
	required_reagents = list(/decl/reagent/alcohol/vodka = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/limejuice =1)
	result_amount = 3

/datum/chemical_reaction/drink/solarian_marine
	name = "Solarian Marine"
	id = "solarian_marine"
	result = /decl/reagent/alcohol/solarian_marine
	required_reagents = list(/decl/reagent/drink/tea/securitea = 1, /decl/reagent/alcohol/whiskey = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cloudyeridani
	name = "Cloudy Eridani"
	id = "cloudyeridani"
	result = /decl/reagent/alcohol/cloudyeridani
	required_reagents = list(/decl/reagent/alcohol/sake = 1, /decl/reagent/drink/tea/greentea = 1, /decl/reagent/drink/milk/soymilk = 1)
	result_amount = 3

/datum/chemical_reaction/drink/djinntea
	name = "Djinn Tea"
	id = "djinntea"
	result = /decl/reagent/alcohol/djinntea
	required_reagents = list(/decl/reagent/drink/dynjuice/cold = 1, /decl/reagent/alcohol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/drink/permanent_revolution
	name = "Permanent Revolution"
	id = "permanent_revolution"
	result = /decl/reagent/alcohol/permanent_revolution
	required_reagents = list(/decl/reagent/alcohol/absinthe = 1, /decl/reagent/alcohol/vodka/mushroom = 1)
	result_amount = 2

/datum/chemical_reaction/drink/internationale
	name = "Internationale"
	id = "internationale"
	result = /decl/reagent/alcohol/internationale
	required_reagents = list(/decl/reagent/alcohol/victorygin = 1, /decl/reagent/alcohol/vodka/mushroom = 1)
	result_amount = 2

/datum/chemical_reaction/drink/diona_mama
	name = "Diona Mama"
	id = "diona_mama"
	result = /decl/reagent/alcohol/diona_mama
	required_reagents = list(/decl/reagent/alcohol/absinthe = 2, /decl/reagent/drink/limejuice = 2, /decl/reagent/radium = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/jovian_storm
	name = "Jovian Storm"
	id = "jovian_storm"
	result = /decl/reagent/alcohol/jovian_storm
	required_reagents = list(/decl/reagent/alcohol/rum = 2, /decl/reagent/drink/grenadine = 2, /decl/reagent/drink/lemonjuice = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/primeminister
	name = "Prime Minister"
	id = "primeminister"
	result = /decl/reagent/alcohol/primeminister
	required_reagents = list(/decl/reagent/alcohol/rum = 4, /decl/reagent/alcohol/vermouth = 1, /decl/reagent/drink/grenadine = 1)
	result_amount = 6

/datum/chemical_reaction/drink/peacetreaty
	name = "Peace Treaty"
	id = "peacetreaty"
	result = /decl/reagent/alcohol/peacetreaty
	required_reagents = list(/decl/reagent/alcohol/victorygin = 1, /decl/reagent/alcohol/messa_mead = 1, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/fiscream
	name = "Fisanduhian Cream"
	id = "fiscream"
	result = /decl/reagent/alcohol/fiscream
	required_reagents = list(/decl/reagent/alcohol/fireball = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/fiscoffee
	name = "Fisanduhian Coffee"
	id = "fiscoffee"
	result = /decl/reagent/alcohol/coffee/fiscoffee
	required_reagents = list(/decl/reagent/alcohol/fiscream = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/fisfirebomb
	name = "Fisanduhian Firebomb"
	id = "fiscarbomb"
	result = /decl/reagent/alcohol/fisfirebomb
	required_reagents = list(/decl/reagent/alcohol/ale = 1, /decl/reagent/alcohol/fiscream = 1)
	result_amount = 2

/datum/chemical_reaction/drink/veterans_choice
	name = "Veteran's Choice"
	id = "veterans_choice"
	result = /decl/reagent/alcohol/veterans_choice
	required_reagents = list(/decl/reagent/alcohol/messa_mead = 1, /decl/reagent/gunpowder = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mutthir
	name = "Mutthir"
	id = "mutthir"
	result = /decl/reagent/drink/milk/adhomai/mutthir
	required_reagents = list(/decl/reagent/drink/milk/adhomai = 1, /decl/reagent/sugar = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/drink/treebark_firewater
	name = "Tree-Bark Firewater"
	id = "treebark_firewater"
	result = /decl/reagent/alcohol/treebark_firewater
	required_reagents = list(/decl/reagent/drink/earthenrootjuice = 1, /decl/reagent/sugar = 1, /decl/reagent/woodpulp = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 3

/datum/chemical_reaction/drink/caprician_coffee
	name = "Caprician Coffee"
	id = "caprician_coffee"
	result = /decl/reagent/drink/toothpaste/caprician_coffee
	required_reagents = list(/decl/reagent/drink/toothpaste = 1, /decl/reagent/drink/coffee = 2)
	result_amount = 3

/datum/chemical_reaction/drink/mojito
	name = "Mojito"
	id = "mojito"
	result = /decl/reagent/alcohol/mojito
	required_reagents = list(/decl/reagent/drink/mintsyrup = 1, /decl/reagent/drink/limejuice = 1, /decl/reagent/alcohol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/zavodskoi_mule
	name = "Zavodskoi Mule"
	id = "zavodskoi_mule"
	result = /decl/reagent/alcohol/zavdoskoi_mule
	required_reagents = list(/decl/reagent/alcohol/vodka = 2, /decl/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/pina_colada
	name = "Pina Colada"
	id = "pina_colada"
	result = /decl/reagent/alcohol/pina_colada
	required_reagents = list(/decl/reagent/drink/pineapplejuice = 1, /decl/reagent/alcohol/rum = 2)
	result_amount = 3

/datum/chemical_reaction/drink/gibbfloats
	name = "Gibb Floats"
	id = "gibbfloats"
	result = /decl/reagent/drink/gibbfloats
	required_reagents = list(/decl/reagent/drink/dr_gibb = 1, /decl/reagent/drink/ice = 1, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/pulque_dyn
	name = "dyn pulque"
	id = "pulque_dyn"
	result = /decl/reagent/alcohol/pulque/dyn
	required_reagents = list(/decl/reagent/alcohol/pulque = 1, /decl/reagent/drink/dynjuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pulque_banana
	name = "banana pulque"
	id = "pulque_banana"
	result = /decl/reagent/alcohol/pulque/banana
	required_reagents = list(/decl/reagent/alcohol/pulque = 1, /decl/reagent/drink/banana = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pulque_berry
	name = "berry pulque"
	id = "pulque_berry"
	result = /decl/reagent/alcohol/pulque/berry
	required_reagents = list(/decl/reagent/alcohol/pulque = 1, /decl/reagent/drink/berryjuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pulque_coffee
	name = "coffee pulque"
	id = "pulque_coffee"
	result = /decl/reagent/alcohol/pulque/coffee
	required_reagents = list(/decl/reagent/alcohol/pulque = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pulque_butanol
	name = "xuizi pulque"
	id = "pulque_butanol"
	result = /decl/reagent/alcohol/butanol/pulque
	required_reagents = list(/decl/reagent/alcohol/pulque = 1, /decl/reagent/alcohol/butanol/xuizijuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/ichor
	name = "xsain ichor"
	id = "ichor"
	result = /decl/reagent/drink/toothpaste/ichor
	required_reagents = list(/decl/reagent/alcohol/butanol/xuizijuice = 1, /decl/reagent/kois/clean = 1, /decl/reagent/drink/toothpaste = 1)
	result_amount = 3
