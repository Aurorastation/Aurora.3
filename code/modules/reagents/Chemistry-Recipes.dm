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
	var/list/required_temperatures_min = list() //Format: reagent name = required_kelvin. Temperatures must exceed this value to trigger.
	var/list/required_temperatures_max = list() //Format: reagent name = required_kelvin. Temperatures must be less than this value to trigger.
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

	if(!holder.has_all_temperatures(required_temperatures_min, required_temperatures_max))
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
			reaction_limit = (holder.get_reagent_amount(reactant) / required_reagents[reactant]) of the limiting reagent.
		*/
		var/yield_ratio = yield/(1-yield)
		var/max_product = yield_ratio * reaction_limit * result_amount //rearrange to obtain max_product
		var/yield_limit = max(0, max_product - holder.get_reagent_amount(result))/result_amount

		progress = min(progress, yield_limit) //apply yield limit

	//apply min reaction progress - wasn't sure if this should go before or after applying yield
	//I guess people can just have their miniscule reactions go to completion regardless of yield.
	for(var/reactant in required_reagents)
		var/remainder = holder.get_reagent_amount(reactant) - progress*required_reagents[reactant]
		if(remainder <= min_reaction*required_reagents[reactant])
			progress = reaction_limit
			break

	return progress

/datum/chemical_reaction/process(var/datum/reagents/holder)
	//determine how far the reaction can proceed
	var/list/reaction_limits = list()
	for(var/reactant in required_reagents)
		reaction_limits += holder.get_reagent_amount(reactant) / required_reagents[reactant]

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
		var/datum/reagent/removing_reagent = holder.get_reagent(reactant)
		var/energy_transfered = removing_reagent.get_thermal_energy() * (amt_used / removing_reagent.volume)
		total_thermal_energy += energy_transfered
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1, thermal_energy = total_thermal_energy)

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
	result = /datum/reagent/inaprovaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "dylovene"
	result = /datum/reagent/dylovene
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/mortaphenyl
	name = "Mortaphenyl"
	id = "mortaphenyl"
	result = /datum/reagent/mortaphenyl
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/alcohol/ethanol = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/perconol
	name = "Perconol"
	id = "perconol"
	result = /datum/reagent/perconol
	required_reagents = list(/datum/reagent/mortaphenyl = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/oxycomorphine
	name = "Oxycomorphine"
	id = "oxycomorphine"
	result = /datum/reagent/oxycomorphine
	required_reagents = list(/datum/reagent/alcohol/ethanol = 1, /datum/reagent/mortaphenyl = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = list(/datum/reagent/alcohol/ethanol = 1, /datum/reagent/dylovene = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = /datum/reagent/silicate
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = /datum/reagent/mutagen
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = /datum/reagent/thermite
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/iron = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = /datum/reagent/space_drugs
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/sugar = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = /datum/reagent/acid/polyacid
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/acid/hydrochloric = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = list(/datum/reagent/hyronalin = 1, /datum/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = /datum/reagent/kelotane
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = list(/datum/reagent/bicaridine = 1, /datum/reagent/clonexadone = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = /datum/reagent/nutriment/virusfood
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/milk = 1, /datum/reagent/sugar = 1)
	result_amount = 6

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	result = /datum/reagent/leporazine
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = /datum/reagent/cryptobiolin
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = /datum/reagent/alkysine
	required_reagents = list(/datum/reagent/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = "dexalin"
	result = /datum/reagent/dexalin
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/phoron = 0.1)
	catalysts = list(/datum/reagent/toxin/phoron = 1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = "dermaline"
	result = /datum/reagent/dermaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/kelotane = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	result = /datum/reagent/dexalin/plus
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/carbon = 1, /datum/reagent/iron = 1)
	result_amount = 3

/datum/chemical_reaction/butazoline
	name = "Butazoline"
	id = "butazoline"
	result = /datum/reagent/butazoline
	required_reagents = list(/datum/reagent/bicaridine = 1, /datum/reagent/aluminum = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/carbon = 1)
	inhibitors = list(/datum/reagent/sugar = 1) //Messes with inaprovaline
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = list(/datum/reagent/arithrazine = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/water = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1, /datum/reagent/toxin/phoron = 0.1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/thetamycin
	name = "Thetamycin"
	id = "thetamycin"
	result = /datum/reagent/thetamycin
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/cetahydramine
	name = "Cetahydramine"
	id = "cetahydramine"
	result = /datum/reagent/cetahydramine
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/asinodryl
	name = "Asinodryl"
	id = "asinodryl"
	result = /datum/reagent/asinodryl
	required_reagents = list(/datum/reagent/cetahydramine = 1, /datum/reagent/synaptizine = 1, /datum/reagent/water = 3)
	catalysts = list(/datum/reagent/tungsten = 5)
	result_amount = 3

/datum/chemical_reaction/oculine
	name = "oculine"
	id = "oculine"
	result = /datum/reagent/oculine
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/dylovene = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/verunol
	name = "Verunol Syrup"
	id = "verunol"
	result = /datum/reagent/verunol
	required_reagents = list(/datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1, /datum/reagent/alcohol/ethanol = 1)
	result_amount = 3

/datum/chemical_reaction/adipemcina
	name = "Adipemcina"
	id = "adipemcina"
	result = /datum/reagent/adipemcina
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/dylovene = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	id = "stoxin"
	result = /datum/reagent/soporific
	required_reagents = list(/datum/reagent/polysomnine = 1, /datum/reagent/sugar = 4)
	inhibitors = list(/datum/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/polysomnine
	name = "Polysomnine"
	id = "polysomnine"
	result = /datum/reagent/polysomnine
	required_reagents = list(/datum/reagent/alcohol/ethanol = 1, /datum/reagent/acid/hydrochloric = 3, /datum/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/potassium = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = list(/datum/reagent/toxin/potassium_chloride = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/polysomnine = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/soporific = 5, /datum/reagent/copper = 5)
	result_amount = 2

/datum/chemical_reaction/dextrotoxin
	name = "Dextrotoxin"
	id = "dextrotoxin"
	result = /datum/reagent/toxin/dextrotoxin
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 3, /datum/reagent/soporific = 10, /datum/reagent/toxin/phoron = 5)
	result_amount = 5

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = /datum/reagent/mindbreaker
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = /datum/reagent/lipozine
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/alcohol/ethanol = 1, /datum/reagent/radium = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	id = "surfactant"
	result = /datum/reagent/surfactant
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/acid = 1)
	result_amount = 5

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/alcohol/ethanol = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = /datum/reagent/spacecleaner
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = /datum/reagent/foaming_agent
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrazine = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/triglyceride = 1, /datum/reagent/alcohol/ethanol = 2) // transesterification of triglycerides into butanol and glycerol
	catalysts = list(/datum/reagent/acid = 5) // using acid as a catalyst
	result_amount = 3 //each triglyceride has 3 glycerin chains.

/datum/chemical_reaction/glycerol/butanol
	name = "Glycerol"
	id = "glycerol-butane"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/triglyceride = 1, /datum/reagent/alcohol/butanol = 2)

/datum/chemical_reaction/glycerol/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.add_reagent(/datum/reagent/acetone, 2 * created_volume / 3) // closest we can get to biofuel, sorry

/datum/chemical_reaction/glucose
	name = "Glucose"
	id = "glucose"
	result = /datum/reagent/nutriment/glucose
	required_reagents = list(/datum/reagent/nutriment = 5) // thank you, Gottlieb Kirchhoff
	catalysts = list(/datum/reagent/acid = 5 )//starch into sugar with sulfuric acid catalyst

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = /datum/reagent/coolant
	required_reagents = list(/datum/reagent/tungsten = 1, /datum/reagent/acetone = 1, /datum/reagent/water = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = /datum/reagent/rezadone
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/cryptobiolin = 1, /datum/reagent/copper = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = /datum/reagent/lexorin
	required_reagents = list(/datum/reagent/tungsten = 1, /datum/reagent/hydrazine = 1, /datum/reagent/ammonia = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 3

/datum/chemical_reaction/fluvectionem
	name = "Fluvectionem"
	id = "fluvectionem"
	result = /datum/reagent/fluvectionem
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/sodiumchloride = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/cardox
	name = "Cardox"
	id = "cardox"
	result = /datum/reagent/toxin/cardox
	required_reagents = list(/datum/reagent/platinum = 1, /datum/reagent/carbon = 1, /datum/reagent/sterilizine = 1)
	result_amount = 3

/datum/chemical_reaction/cardox_removal
	name = "Cardox Removal"
	id = "cardox_removal"
	result = /datum/reagent/carbon
	required_reagents = list(/datum/reagent/toxin/cardox = 0.1, /datum/reagent/toxin/phoron = 1)
	result_amount = 0

/datum/chemical_reaction/monoammoniumphosphate
	name = "Monoammoniumphosphate"
	id = "monoammoniumphosphate"
	result = /datum/reagent/toxin/fertilizer/monoammoniumphosphate
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/acid = 1, /datum/reagent/sodium = 1, /datum/reagent/phosphorus = 1)
	result_amount = 4

/datum/chemical_reaction/koispasteclean
	name = "Filtered K'ois"
	id = "koispasteclean"
	result = /datum/reagent/kois/clean
	required_reagents = list(/datum/reagent/kois = 2,/datum/reagent/toxin/cardox = 0.1)
	catalysts = list(/datum/reagent/toxin/cardox = 5)
	result_amount = 1

/datum/chemical_reaction/pulmodeiectionem
	name = "Pulmodeiectionem"
	id = "pulmodeiectionem"
	result = /datum/reagent/pulmodeiectionem
	required_reagents = list(/datum/reagent/fluvectionem = 1, /datum/reagent/lexorin = 1)
	result_amount = 2

/datum/chemical_reaction/pneumalin
	name = "Pneumalin"
	id = "pneumalin"
	result = /datum/reagent/pneumalin
	required_reagents = list(/datum/reagent/coughsyrup = 1, /datum/reagent/copper = 1, /datum/reagent/pulmodeiectionem = 1)
	result_amount = 2

/datum/chemical_reaction/saline
	name = "Saline Plus"
	id = "saline"
	result = /datum/reagent/saline
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/sugar = 0.2, /datum/reagent/sodiumchloride = 0.4)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/cataleptinol
	name = "Cataleptinol"
	id = "cataleptinol"
	result = /datum/reagent/cataleptinol
	required_reagents = list(/datum/reagent/toxin/phoron = 0.1, /datum/reagent/alkysine = 1, /datum/reagent/cryoxadone = 0.1)
	result_amount = 1

/datum/chemical_reaction/coughsyrup
	name = "Cough Syrup"
	id = "coughsyrup"
	result = /datum/reagent/coughsyrup
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 3

//Mental Medication

/datum/chemical_reaction/corophenidate
	name = "Corophenidate"
	id = "corophenidate"
	result = /datum/reagent/mental/corophenidate
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/minaphobin
	name = "Minaphobin"
	id = "minaphobin"
	result = /datum/reagent/mental/minaphobin
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /datum/reagent/adrenaline
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/hyperzine = 1, /datum/reagent/dexalin/plus = 1)
	result_amount = 3

/datum/chemical_reaction/neurostabin
	name = "Neurostabin"
	id = "neurostabin"
	result = /datum/reagent/mental/neurostabin
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/iron = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/parvosil
	name = "Parvosil"
	id = "parvosil"
	result = /datum/reagent/mental/parvosil
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/aluminum = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/emoxanyl
	name = "Emoxanyl"
	id = "emoxanyl"
	result = /datum/reagent/mental/emoxanyl
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/silicon = 1, /datum/reagent/alcohol/ethanol = 1)
	result_amount = 3

/datum/chemical_reaction/orastabin
	name = "Orastabin"
	id = "orastabin"
	result = /datum/reagent/mental/orastabin
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/sodium = 1, /datum/reagent/tungsten = 1)
	result_amount = 3

/datum/chemical_reaction/neurapan
	name = "Neurapan"
	id = "neurapan"
	result = /datum/reagent/mental/neurapan
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/space_drugs = 1, /datum/reagent/alcohol/ethanol = 1)
	result_amount = 3

/datum/chemical_reaction/nerospectan
	name = "Nerospectan"
	id = "nerospectan"
	result = /datum/reagent/mental/nerospectan
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/space_drugs = 1, /datum/reagent/silicon = 1)
	result_amount = 3

/datum/chemical_reaction/truthserum
	name = "Truthserum"
	id = "truthserum"
	result = /datum/reagent/mental/truthserum
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/synaptizine = 1, /datum/reagent/toxin/phoron = 0.1)
	result_amount = 2

/datum/chemical_reaction/pacifier
	name = "Paxazide"
	id = "paxazide"
	result = /datum/reagent/pacifier
	required_reagents = list(/datum/reagent/mental/truthserum = 1, /datum/reagent/mental/parvosil = 1)
	result_amount = 1

/datum/chemical_reaction/berserk
	name = "Red Nightshade"
	id = "berserk"
	result = /datum/reagent/toxin/berserk
	required_reagents = list(/datum/reagent/psilocybin = 1, /datum/reagent/alcohol/ethanol/moonshine = 1)
	result_amount = 1

/* Makeshift Chemicals and Drugs */

/datum/chemical_reaction/stimm
	name = "Stimm"
	id = "stimm"
	result = /datum/reagent/toxin/stimm
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/drink/rewriter = 5)
	result_amount = 6

/datum/chemical_reaction/lean
	name = "Lean"
	id = "lean"
	result = /datum/reagent/toxin/lean
	required_reagents = list(/datum/reagent/drink/spaceup = 2, /datum/reagent/coughsyrup = 2, /datum/reagent/sugar = 1)
	result_amount = 5

/datum/chemical_reaction/krokjuice
	name = "Krok Juice"
	id = "krok"
	result = /datum/reagent/toxin/krok
	required_reagents = list(/datum/reagent/drink/orangejuice = 2, /datum/reagent/fuel = 1, /datum/reagent/iron = 1)
	result_amount = 4

/datum/chemical_reaction/raskara_dust
	name = "Raskara Dust"
	id = "raskara_dust"
	result = /datum/reagent/raskara_dust
	required_reagents = list(/datum/reagent/toxin/fertilizer/monoammoniumphosphate = 1, /datum/reagent/spacecleaner = 1, /datum/reagent/sodiumchloride = 2) // extinguisher, cleaner, salt
	required_temperatures_min = list(/datum/reagent/toxin/fertilizer/monoammoniumphosphate = 400, /datum/reagent/spacecleaner = 400, /datum/reagent/sodiumchloride = 400) // barely over boiling point of water
	result_amount = 2

/datum/chemical_reaction/nightjuice
	name = "Nightlife"
	id = "night_juice"
	result = /datum/reagent/night_juice
	required_reagents = list(/datum/reagent/mental/corophenidate = 1, /datum/reagent/synaptizine = 1, /datum/reagent/nitroglycerin = 1)
	required_temperatures_min = list(/datum/reagent/mental/corophenidate = T0C+200, /datum/reagent/synaptizine = T0C+200, /datum/reagent/nitroglycerin = T0C+200)
	result_amount = 3

/* Solidification */

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	id = "solidphoron"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/frostoil = 5, /datum/reagent/toxin/phoron = 20)
	result_amount = 1

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)
	return

/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/toxin/plasticide = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return
	
/datum/chemical_reaction/uraniumsolidification
    name = "Uranium"
    id = "soliduranium"
    result = null
    required_reagents = list(/datum/reagent/potassium = 5, /datum/reagent/frostoil = 5, /datum/reagent/uranium = 20)
    result_amount = 1

/datum/chemical_reaction/uraniumsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
    new /obj/item/stack/material/uranium(get_turf(holder.my_atom), created_volume)
    return

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
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
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
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
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
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
	result = /datum/reagent/nitroglycerin
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/acid/polyacid = 1, /datum/reagent/acid = 1)
	result_amount = 2

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/acid = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(GAS_PHORON, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent(/datum/reagent/fuel/napalm)
	return

/datum/chemical_reaction/zoragel
	name = "Inert Gel"
	id = "zoragel"
	result = /datum/reagent/fuel/zoragel
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/aluminum = 1, /datum/reagent/sugar = 1, /datum/reagent/surfactant = 3)
	result_amount = 1

/datum/chemical_reaction/zorafire
	name = "Zo'rane Fire"
	id = "greekfire"
	result = /datum/reagent/fuel/napalm
	required_reagents = list(/datum/reagent/nitroglycerin = 2, /datum/reagent/pyrosilicate = 2, /datum/reagent/toxin/phoron = 3, /datum/reagent/fuel/zoragel = 3)
	result_amount = 1
	log_is_important = 1

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1)
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
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/water = 1)
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
	required_reagents = list(/datum/reagent/aluminum = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
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
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
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
	result = /datum/reagent/luminol
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/ammonia = 2)
	result_amount = 6

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	id = "red_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/red = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#FE191A"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/orange = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#FFBE4F"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/yellow = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#FDFE7D"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	id = "green_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/green = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18A31A"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/blue = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247CFF"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/purple = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#CC0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/grey = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/brown = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846F35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/blood = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data(/datum/reagent/blood)
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/milk = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#F0F8FF"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/orangejuice = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#E78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/tomatojuice = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/limejuice = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365E30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/carrotjuice = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/berryjuice = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/grapejuice = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/toxin/poisonberryjuice = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/watermelonjuice = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#B83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/lemonjuice = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#AFAF00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/banana = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#C3AF00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/potatojuice = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/aluminum = 1)
	result_amount = 5

/datum/chemical_reaction/aluminum_paint/send_data()
	return "#F0F8FF"

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
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
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
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	new /obj/effect/portal/spawner/monkey_cube(get_turf(holder.my_atom))
	..()

//Green
/datum/chemical_reaction/slime/teleportation
	name = "Slime Teleportation"
	id = "slimeteleportation"
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/green

/datum/chemical_reaction/slime/teleportation/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(src, .proc/do_reaction, holder), 50)

/datum/chemical_reaction/slime/teleportation/proc/do_reaction(var/datum/reagents/holder)
	for(var/atom/movable/AM in circlerange(get_turf(holder.my_atom),7))
		if(AM.anchored)
			continue
		var/area/A = random_station_area()
		var/turf/target = A.random_space()
		to_chat(AM, SPAN_WARNING("Bluespace energy teleports you somewhere else!"))
		do_teleport(AM, target)
		AM.visible_message("\The [AM] phases in!")

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	id = "m_metal"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
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
	required_reagents = list(/datum/reagent/toxin/phoron = 5)
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
		/mob/living/simple_animal/hostile/alien/queen/large,
		/mob/living/simple_animal/hostile/faithless,
		/mob/living/simple_animal/hostile/faithless/wizard,
		/mob/living/simple_animal/hostile/retaliate,
		/mob/living/simple_animal/hostile/retaliate/clown,
		/mob/living/simple_animal/hostile/alien,
		/mob/living/simple_animal/hostile/alien/drone,
		/mob/living/simple_animal/hostile/alien/sentinel,
		/mob/living/simple_animal/hostile/alien/queen,
		/mob/living/simple_animal/hostile/alien/queen/large,
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
		/mob/living/simple_animal/hostile/hivebotbeacon/toxic,
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
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
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
	result = /datum/reagent/frostoil
	required_reagents = list(/datum/reagent/water = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list(/datum/reagent/water = 1)
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
	result = /datum/reagent/capsaicin
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
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
	required_reagents = list(/datum/reagent/blood = 1)
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
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
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
	required_reagents = list(/datum/reagent/water = 1)
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
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/slimesteroid(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	id = "m_jam"
	result = /datum/reagent/slimejelly
	required_reagents = list(/datum/reagent/sugar = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple

/datum/chemical_reaction/slime/rare_metal
	name = "Slime Rare Metal"
	id = "rm_metal"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/rare_metal/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/rare_metal(get_turf(holder.my_atom))

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	id = "m_bloodlust"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = TRUE
		slime.visible_message(SPAN_WARNING("[icon2html(slime, viewers(get_turf(slime)))] \The [slime] is driven into a frenzy!"))

//Pink
/datum/chemical_reaction/slime/ppotion
	name = "Slime Potion"
	id = "m_potion"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/ppotion/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/slimepotion(get_turf(holder.my_atom))

//Black
/datum/chemical_reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	id = "mutationtoxin2"
	result = /datum/reagent/aslimetoxin
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slime/explosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/explosion/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, get_turf(holder.my_atom), 1, 3, 6), 50)

//Light Pink
/datum/chemical_reaction/slime/potion2
	name = "Slime Potion 2"
	id = "m_potion2"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/slime/potion2/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/slimepotion2(get_turf(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	id = "m_golem"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine
	mix_message = "A soft fizzle is heard within the slime extract, and mystic runes suddenly appear on the floor beneath it!"

/datum/chemical_reaction/slime/golem/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/golemrune(get_turf(holder.my_atom))

/datum/chemical_reaction/soap_key
	name = "Soap Key"
	id = "skey"
	result = null
	required_reagents = list(/datum/reagent/nutriment/triglyceride = 2, /datum/reagent/water = 2, /datum/reagent/spacecleaner = 3)
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

/*
====================
	Food
====================
*/

/datum/chemical_reaction/tofu
	name = "Tofu"
	id = "tofu"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	inhibitors = list(/datum/reagent/sodiumchloride = 1) // To prevent conflict with Soy Sauce recipe.
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
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
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
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	id = "hot_coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/sodiumchloride = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = /datum/reagent/nutriment/ketchup
	required_reagents = list(/datum/reagent/drink/tomatojuice = 2, /datum/reagent/water = 1, /datum/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/barbecue
	name = "Barbecue Sauce"
	id = "barbecue"
	result = /datum/reagent/nutriment/barbecue
	required_reagents = list(/datum/reagent/nutriment/ketchup = 2, /datum/reagent/nutriment/garlicsauce = 1, /datum/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/garlicsauce
	name = "Garlic Sauce"
	id = "garlicsauce"
	result = /datum/reagent/nutriment/garlicsauce
	required_reagents = list(/datum/reagent/drink/garlicjuice = 1, /datum/reagent/nutriment/triglyceride/oil/corn = 1)
	result_amount = 2

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 40)
	catalysts = list(/datum/reagent/enzyme = 5)
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
	required_reagents = list(/datum/reagent/nutriment/protein = 3, /datum/reagent/nutriment/flour = 5)
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
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10)
	inhibitors = list(/datum/reagent/water = 1, /datum/reagent/alcohol/ethanol/beer = 1, /datum/reagent/sugar = 1) //To prevent it messing with batter and pie recipes
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
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/clonexadone = 1)
	result_amount = 1

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = /datum/reagent/drink/hot_ramen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/dry_ramen = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = /datum/reagent/drink/hell_ramen
	required_reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/drink/hot_ramen = 6)
	result_amount = 6

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = "batter"
	result = /datum/reagent/nutriment/coating/batter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 5, /datum/reagent/sodiumchloride = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = /datum/reagent/nutriment/coating/beerbatter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/alcohol/ethanol/beer = 5, /datum/reagent/sodiumchloride = 2)
	result_amount = 20

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = /datum/reagent/browniemix
	required_reagents = list(/datum/reagent/nutriment/flour = 5, /datum/reagent/nutriment/coco = 5, /datum/reagent/sugar = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/cream = 20, /datum/reagent/sodiumchloride = 1)
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
	result = /datum/reagent/alcohol/ethanol/goldschlager
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 10, /datum/reagent/gold = 1)
	mix_message = null
	reaction_sound = 'sound/effects/pour.ogg'
	result_amount = 10

/datum/chemical_reaction/drink/patron
	name = "Patron"
	id = "patron"
	result = /datum/reagent/alcohol/ethanol/patron
	required_reagents = list(/datum/reagent/alcohol/ethanol/tequila = 10, /datum/reagent/silver = 1)
	result_amount = 10

/datum/chemical_reaction/drink/bilk
	name = "Bilk"
	id = "bilk"
	result = /datum/reagent/alcohol/ethanol/bilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/alcohol/ethanol/beer = 1)
	result_amount = 2

/datum/chemical_reaction/drink/icetea
	name = "Iced Tea"
	id = "icetea"
	result = /datum/reagent/drink/icetea
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea = 2)
	result_amount = 3

/datum/chemical_reaction/drink/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3

/datum/chemical_reaction/drink/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	result = /datum/reagent/drink/nuka_cola
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/drink/space_cola = 5)
	result_amount = 5

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = /datum/reagent/alcohol/ethanol/moonshine
	required_reagents = list(/datum/reagent/nutriment = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/butanol
	name = "Butanol"
	id = "butanol"
	result = /datum/reagent/alcohol/butanol
	required_reagents = list(/datum/reagent/nutriment/triglyceride/oil/corn = 10, /datum/reagent/sugar = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	result = /datum/reagent/drink/grenadine
	required_reagents = list(/datum/reagent/drink/berryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	id = "wine"
	result = /datum/reagent/alcohol/ethanol/wine
	required_reagents = list(/datum/reagent/drink/grapejuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	id = "pwine"
	result = /datum/reagent/alcohol/ethanol/pwine
	required_reagents = list(/datum/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = /datum/reagent/alcohol/ethanol/melonliquor
	required_reagents = list(/datum/reagent/drink/watermelonjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = /datum/reagent/alcohol/ethanol/bluecuracao
	required_reagents = list(/datum/reagent/drink/orangejuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = /datum/reagent/alcohol/ethanol/beer
	required_reagents = list(/datum/reagent/nutriment/triglyceride/oil/corn = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/vodka
	name = "Vodka"
	id = "vodka"
	result = /datum/reagent/alcohol/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/potatojuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	id = "sake"
	result = /datum/reagent/alcohol/ethanol/sake
	required_reagents = list(/datum/reagent/nutriment/rice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = /datum/reagent/alcohol/ethanol/coffee/kahlua
	required_reagents = list(/datum/reagent/drink/coffee = 5, /datum/reagent/sugar = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/drink/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = /datum/reagent/alcohol/ethanol/gintonic
	required_reagents = list(/datum/reagent/alcohol/ethanol/gin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = /datum/reagent/alcohol/ethanol/cubalibre
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/martini
	name = "Classic Martini"
	id = "martini"
	result = /datum/reagent/alcohol/ethanol/martini
	required_reagents = list(/datum/reagent/alcohol/ethanol/gin = 2, /datum/reagent/alcohol/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = /datum/reagent/alcohol/ethanol/vodkamartini
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/alcohol/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = /datum/reagent/alcohol/ethanol/white_russian
	required_reagents = list(/datum/reagent/alcohol/ethanol/blackrussian = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = /datum/reagent/alcohol/ethanol/whiskeycola
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = /datum/reagent/alcohol/ethanol/screwdrivercocktail
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = /datum/reagent/alcohol/ethanol/bloodymary
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/drink/tomatojuice = 3, /datum/reagent/drink/limejuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = /datum/reagent/alcohol/ethanol/gargleblaster
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/alcohol/ethanol/cognac = 1, /datum/reagent/drink/limejuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = /datum/reagent/alcohol/ethanol/coffee/brave_bull
	required_reagents = list(/datum/reagent/alcohol/ethanol/tequila = 2, /datum/reagent/alcohol/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tequila_sunrise
	name = "Tequila Sunrise"
	id = "tequilasunrise"
	result = /datum/reagent/alcohol/ethanol/tequila_sunrise
	required_reagents = list(/datum/reagent/alcohol/ethanol/tequila = 2, /datum/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = /datum/reagent/alcohol/ethanol/toxins_special
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 2, /datum/reagent/alcohol/ethanol/vermouth = 2, /datum/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/drink/beepsky_smash
	name = "Beepsky Smash"
	id = "beepksysmash"
	result = /datum/reagent/alcohol/ethanol/beepsky_smash
	required_reagents = list(/datum/reagent/drink/limejuice = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = /datum/reagent/drink/doctorsdelight
	required_reagents = list(/datum/reagent/drink/limejuice = 1, /datum/reagent/drink/tomatojuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/milk/cream = 2, /datum/reagent/tricordrazine = 1)
	result_amount = 6

/datum/chemical_reaction/drink/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = /datum/reagent/alcohol/ethanol/irishcream
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = /datum/reagent/alcohol/ethanol/manly_dorf
	required_reagents = list(/datum/reagent/alcohol/ethanol/beer = 1, /datum/reagent/alcohol/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/drink/hooch
	name = "Hooch"
	id = "hooch"
	result = /datum/reagent/alcohol/ethanol/hooch
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/alcohol/ethanol/moonshine = 1, /datum/reagent/fuel = 1)
	result_amount = 3

/datum/chemical_reaction/drink/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = /datum/reagent/alcohol/ethanol/coffee/irishcoffee
	required_reagents = list(/datum/reagent/alcohol/ethanol/irishcream = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/b52
	name = "B-52"
	id = "b52"
	result = /datum/reagent/alcohol/ethanol/coffee/b52
	required_reagents = list(/datum/reagent/alcohol/ethanol/irishcream = 1, /datum/reagent/alcohol/ethanol/coffee/kahlua = 1, /datum/reagent/alcohol/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/drink/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = /datum/reagent/alcohol/ethanol/atomicbomb
	required_reagents = list(/datum/reagent/alcohol/ethanol/coffee/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/margarita
	name = "Margarita"
	id = "margarita"
	result = /datum/reagent/alcohol/ethanol/margarita
	required_reagents = list(/datum/reagent/alcohol/ethanol/tequila = 2, /datum/reagent/drink/limejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = /datum/reagent/alcohol/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/alcohol/ethanol/tequila = 1, /datum/reagent/alcohol/ethanol/cubalibre = 3)
	result_amount = 6

/datum/chemical_reaction/drink/icedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = /datum/reagent/alcohol/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/alcohol/ethanol/tequila = 1, /datum/reagent/alcohol/ethanol/cubalibre = 3)
	result_amount = 6

/datum/chemical_reaction/drink/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = /datum/reagent/alcohol/ethanol/threemileisland
	required_reagents = list(/datum/reagent/alcohol/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = /datum/reagent/alcohol/ethanol/whiskeysoda
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 2, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/drink/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = /datum/reagent/alcohol/ethanol/blackrussian
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/alcohol/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = /datum/reagent/alcohol/ethanol/manhattan
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 2, /datum/reagent/alcohol/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = /datum/reagent/alcohol/ethanol/manhattan_proj
	required_reagents = list(/datum/reagent/alcohol/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/drink/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = /datum/reagent/alcohol/ethanol/vodkatonic
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = /datum/reagent/alcohol/ethanol/ginfizz
	required_reagents = list(/datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/limejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = /datum/reagent/alcohol/ethanol/bahama_mama
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 2, /datum/reagent/drink/orangejuice = 2, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/singulo
	name = "Singulo"
	id = "singulo"
	result = /datum/reagent/alcohol/ethanol/singulo
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 5, /datum/reagent/radium = 1, /datum/reagent/alcohol/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/drink/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = /datum/reagent/alcohol/ethanol/alliescocktail
	required_reagents = list(/datum/reagent/alcohol/ethanol/martini = 1, /datum/reagent/alcohol/ethanol/vodka = 1)
	result_amount = 2

/datum/chemical_reaction/drink/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = /datum/reagent/alcohol/ethanol/demonsblood
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 3, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/blood = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/booger
	name = "Booger"
	id = "booger"
	result = /datum/reagent/alcohol/ethanol/booger
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/banana = 1, /datum/reagent/alcohol/ethanol/rum = 1, /datum/reagent/drink/watermelonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = /datum/reagent/alcohol/ethanol/antifreeze
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = /datum/reagent/alcohol/ethanol/barefoot
	required_reagents = list(/datum/reagent/drink/berryjuice = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/alcohol/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/grapejuice = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = /datum/reagent/alcohol/ethanol/sbiten
	required_reagents = list(/datum/reagent/alcohol/ethanol/mead = 10, /datum/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/drink/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = /datum/reagent/alcohol/ethanol/red_mead
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/alcohol/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mead
	name = "Mead"
	id = "mead"
	result = /datum/reagent/alcohol/ethanol/mead
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/drink/iced_beer
	name = "Iced Beer"
	id = "frosted_beer"
	result = /datum/reagent/alcohol/ethanol/iced_beer
	required_reagents = list(/datum/reagent/alcohol/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10

/datum/chemical_reaction/drink/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = /datum/reagent/alcohol/ethanol/iced_beer
	required_reagents = list(/datum/reagent/alcohol/ethanol/beer = 5, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/grog
	name = "Grog"
	id = "grog"
	result = /datum/reagent/alcohol/ethanol/grog
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_espresso
	name = "Freddo Espresso"
	id = "freddo_espresso"
	result = /datum/reagent/drink/coffee/freddo_espresso
	required_reagents = list(/datum/reagent/drink/coffee/espresso = 1, /datum/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/caffe_americano
	name = "Caffe Americano"
	id = "caffe_americano"
	result = /datum/reagent/drink/coffee/caffe_americano
	required_reagents = list(/datum/reagent/drink/coffee/espresso = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/flat_white
	name = "Flat White"
	id = "flat_white"
	result = /datum/reagent/drink/coffee/flat_white
	required_reagents = list(/datum/reagent/drink/coffee/espresso = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/latte
	name = "Latte"
	id = "latte"
	result = /datum/reagent/drink/coffee/latte
	required_reagents = list(/datum/reagent/drink/coffee/flat_white = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cappuccino
	name = "Cappuccino"
	id = "cappuccino"
	result = /datum/reagent/drink/coffee/cappuccino
	required_reagents = list(/datum/reagent/drink/coffee/espresso = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_cappuccino
	name = "Freddo cappuccino"
	id = "freddo_cappuccino"
	result = /datum/reagent/drink/coffee/freddo_cappuccino
	required_reagents = list(/datum/reagent/drink/coffee/cappuccino = 1, /datum/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/macchiato
	name = "Macchiato"
	id = "macchiato"
	result = /datum/reagent/drink/coffee/macchiato
	required_reagents = list(/datum/reagent/drink/coffee/cappuccino = 1, /datum/reagent/drink/coffee/espresso = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mocacchino
	name = "Mocacchino"
	id = "mocacchino"
	result = /datum/reagent/drink/coffee/mocacchino
	required_reagents = list(/datum/reagent/drink/coffee/flat_white = 1, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 2

/datum/chemical_reaction/drink/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = /datum/reagent/alcohol/ethanol/acid_spit
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/alcohol/ethanol/wine = 5)
	result_amount = 6

/datum/chemical_reaction/drink/amasec
	name = "Amasec"
	id = "amasec"
	result = /datum/reagent/alcohol/ethanol/amasec
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/alcohol/ethanol/wine = 5, /datum/reagent/alcohol/ethanol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/drink/gibsonpunch
	name = "Gibson Punch"
	id = "gibsonpunch"
	result = /datum/reagent/alcohol/ethanol/gibsonpunch
	required_reagents = list(/datum/reagent/alcohol/ethanol/screwdrivercocktail = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aloe
	name = "Aloe"
	id = "aloe"
	result = /datum/reagent/alcohol/ethanol/aloe
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/drink/watermelonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = /datum/reagent/alcohol/ethanol/andalusia
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = /datum/reagent/alcohol/ethanol/neurotoxin
	required_reagents = list(/datum/reagent/alcohol/ethanol/gargleblaster = 1, /datum/reagent/soporific = 1)
	result_amount = 2

/datum/chemical_reaction/drink/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = /datum/reagent/alcohol/ethanol/snowwhite
	required_reagents = list(/datum/reagent/alcohol/ethanol/beer = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/drink/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = /datum/reagent/alcohol/ethanol/irishcarbomb
	required_reagents = list(/datum/reagent/alcohol/ethanol/ale = 1, /datum/reagent/alcohol/ethanol/irishcream = 1)
	result_amount = 2

/datum/chemical_reaction/drink/gibsonhooch
	name = "Gibson Hooch"
	id = "gibsonhooch"
	result = /datum/reagent/alcohol/ethanol/gibsonhooch
	required_reagents = list(/datum/reagent/alcohol/ethanol/beer = 1, /datum/reagent/alcohol/ethanol/whiskeycola = 1)
	result_amount = 2

/datum/chemical_reaction/drink/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = /datum/reagent/alcohol/ethanol/erikasurprise
	required_reagents = list(/datum/reagent/alcohol/ethanol/ale = 2, /datum/reagent/drink/limejuice = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/drink/banana = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = /datum/reagent/alcohol/ethanol/devilskiss
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/alcohol/ethanol/coffee/kahlua = 1, /datum/reagent/alcohol/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = /datum/reagent/alcohol/ethanol/hippiesdelight
	required_reagents = list(/datum/reagent/psilocybin = 1, /datum/reagent/alcohol/ethanol/gargleblaster = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = /datum/reagent/alcohol/ethanol/bananahonk
	required_reagents = list(/datum/reagent/drink/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/silencer
	name = "Silencer"
	id = "silencer"
	result = /datum/reagent/alcohol/ethanol/silencer
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = /datum/reagent/alcohol/ethanol/driestmartini
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/alcohol/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/drink/lemonade
	name = "Lemonade"
	id = "lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/lemonjuice = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/drink/lemonade/pink
	name = "Pink Lemonade"
	id = "pinklemonade"
	result = /datum/reagent/drink/lemonade/pink
	required_reagents = list(/datum/reagent/drink/lemonade = 8, /datum/reagent/drink/grenadine = 2)
	result_amount = 10


/datum/chemical_reaction/drink/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	result = /datum/reagent/drink/kiraspecial
	required_reagents = list(/datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/drink/brownstar
	name = "Brown Star"
	id = "brownstar"
	result = /datum/reagent/drink/brownstar
	required_reagents = list(/datum/reagent/drink/orangejuice = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/drink/milkshake
	name = "Milkshake"
	id = "milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/drink/cmojito
	name = "Champagne Mojito"
	id = "cmojito"
	result = /datum/reagent/alcohol/ethanol/cmojito
	required_reagents = list(/datum/reagent/drink/mintsyrup = 1, /datum/reagent/alcohol/ethanol/champagne = 1, /datum/reagent/alcohol/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/classic
	name = "The Classic"
	id = "classic"
	result = /datum/reagent/alcohol/ethanol/classic
	required_reagents = list(/datum/reagent/alcohol/ethanol/champagne = 2, /datum/reagent/alcohol/ethanol/bitters = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 4

/datum/chemical_reaction/drink/corkpopper
	name = "Cork Popper"
	id = "corkpopper"
	result = /datum/reagent/alcohol/ethanol/corkpopper
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/alcohol/ethanol/champagne = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/french75
	name = "French 75"
	id = "french75"
	result = /datum/reagent/alcohol/ethanol/french75
	required_reagents = list(/datum/reagent/alcohol/ethanol/champagne = 2, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 4

/datum/chemical_reaction/drink/muscmule
	name = "Muscovite Mule"
	id = "muscmule"
	result = /datum/reagent/alcohol/ethanol/muscmule
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/mintsyrup = 1)
	result_amount = 3

/datum/chemical_reaction/drink/omimosa
	name = "Orange Mimosa"
	id = "omimosa"
	result = /datum/reagent/alcohol/ethanol/omimosa
	required_reagents = list(/datum/reagent/drink/orangejuice = 1, /datum/reagent/alcohol/ethanol/champagne = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pinkgin
	name = "Pink Gin"
	id = "pinkgin"
	result = /datum/reagent/alcohol/ethanol/pinkgin
	required_reagents = list(/datum/reagent/alcohol/ethanol/gin = 2, /datum/reagent/alcohol/ethanol/bitters = 1)
	result_amount = 3

/datum/chemical_reaction/drink/pinkgintonic
	name = "Pink Gin and Tonic"
	id = "pinkgintonic"
	result = /datum/reagent/alcohol/ethanol/pinkgintonic
	required_reagents = list(/datum/reagent/alcohol/ethanol/pinkgin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/drink/piratepunch
	name = "Pirate's Punch"
	id = "piratepunch"
	result = /datum/reagent/alcohol/ethanol/piratepunch
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 1, /datum/reagent/drink/lemonjuice = 1, /datum/reagent/drink/mintsyrup = 1, /datum/reagent/drink/grenadine = 1, /datum/reagent/alcohol/ethanol/bitters = 1)
	result_amount = 5

/datum/chemical_reaction/drink/planterpunch
	name = "Planter's Punch"
	id = "planterpunch"
	result = /datum/reagent/alcohol/ethanol/planterpunch
	required_reagents = list(/datum/reagent/alcohol/ethanol/rum = 2, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 4

/datum/chemical_reaction/drink/ssroyale
	name = "Southside Royale"
	id = "ssroyale"
	result = /datum/reagent/alcohol/ethanol/ssroyale
	required_reagents = list(/datum/reagent/drink/mintsyrup = 1, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/alcohol/ethanol/champagne = 1)
	result_amount = 4

/datum/chemical_reaction/drink/rewriter
	name = "Rewriter"
	id = "rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/suidream
	name = "Sui Dream"
	id = "suidream"
	result = /datum/reagent/alcohol/ethanol/suidream
	required_reagents = list(/datum/reagent/drink/spaceup = 1, /datum/reagent/alcohol/ethanol/bluecuracao = 1, /datum/reagent/alcohol/ethanol/melonliquor = 1)
	result_amount = 3

//aurora's drinks

/datum/chemical_reaction/drink/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = /datum/reagent/alcohol/ethanol/daiquiri
	required_reagents = list(/datum/reagent/drink/limejuice = 1, /datum/reagent/alcohol/ethanol/rum = 1)
	result_amount = 2

/datum/chemical_reaction/drink/icepick
	name = "Ice Pick"
	id = "icepick"
	result = /datum/reagent/alcohol/ethanol/icepick
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/alcohol/ethanol/vodka = 1)
	result_amount = 2

/datum/chemical_reaction/drink/poussecafe
	name = "Pousse-Cafe"
	id = "poussecafe"
	result = /datum/reagent/alcohol/ethanol/poussecafe
	required_reagents = list(/datum/reagent/alcohol/ethanol/brandy = 1, /datum/reagent/alcohol/ethanol/chartreusegreen = 1, /datum/reagent/alcohol/ethanol/chartreuseyellow = 1, /datum/reagent/alcohol/ethanol/cremewhite = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = /datum/reagent/alcohol/ethanol/mintjulep
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/drink/ice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/johncollins
	name = "John Collins"
	id = "johncollins"
	result = /datum/reagent/alcohol/ethanol/johncollins
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskeysoda = 2, /datum/reagent/drink/lemonjuice = 1, /datum/reagent/drink/grenadine = 1, /datum/reagent/drink/ice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/gimlet
	name = "Gimlet"
	id = "gimlet"
	result = /datum/reagent/alcohol/ethanol/gimlet
	required_reagents = list(/datum/reagent/drink/limejuice = 1, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/starsandstripes
	name = "Stars and Stripes"
	id = "starsandstripes"
	result = /datum/reagent/alcohol/ethanol/starsandstripes
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/alcohol/ethanol/cremeyvette = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/metropolitan
	name = "Metropolitan"
	id = "metropolitan"
	result = /datum/reagent/alcohol/ethanol/metropolitan
	required_reagents = list(/datum/reagent/alcohol/ethanol/brandy = 1, /datum/reagent/alcohol/ethanol/vermouth = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/caruso
	name = "Caruso"
	id = "caruso"
	result = /datum/reagent/alcohol/ethanol/caruso
	required_reagents = list(/datum/reagent/alcohol/ethanol/martini = 2, /datum/reagent/alcohol/ethanol/cremewhite = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aprilshower
	name = "April Shower"
	id = "aprilshower"
	result = /datum/reagent/alcohol/ethanol/aprilshower
	required_reagents = list(/datum/reagent/alcohol/ethanol/brandy = 1, /datum/reagent/alcohol/ethanol/chartreuseyellow = 1, /datum/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/carthusiansazerac
	name = "Carthusian Sazerac"
	id = "carthusiansazerac"
	result = /datum/reagent/alcohol/ethanol/carthusiansazerac
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/alcohol/ethanol/chartreusegreen = 1, /datum/reagent/drink/grenadine = 1, /datum/reagent/alcohol/ethanol/absinthe = 1)
	result_amount = 4

/datum/chemical_reaction/drink/deweycocktail
	name = "Dewey Cocktail"
	id = "deweycocktail"
	result = /datum/reagent/alcohol/ethanol/deweycocktail
	required_reagents = list(/datum/reagent/alcohol/ethanol/cremeyvette = 1, /datum/reagent/alcohol/ethanol/gin = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/rustynail
	name = "Rusty Nail"
	id = "rustynail"
	result = /datum/reagent/alcohol/ethanol/rustynail
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/alcohol/ethanol/drambuie = 1)
	result_amount = 2

/datum/chemical_reaction/drink/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = /datum/reagent/alcohol/ethanol/oldfashioned
	required_reagents = list(/datum/reagent/alcohol/ethanol/whiskeysoda = 3, /datum/reagent/alcohol/ethanol/bitters = 1, /datum/reagent/sugar = 1)
	result_amount = 5

/datum/chemical_reaction/drink/blindrussian
	name = "Blind Russian"
	id = "blindrussian"
	result = /datum/reagent/alcohol/ethanol/blindrussian
	required_reagents = list(/datum/reagent/alcohol/ethanol/coffee/kahlua = 1, /datum/reagent/alcohol/ethanol/irishcream = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tallrussian
	name = "Tall Black Russian"
	id = "tallrussian"
	result = /datum/reagent/alcohol/ethanol/tallrussian
	required_reagents = list(/datum/reagent/alcohol/ethanol/blackrussian = 1, /datum/reagent/drink/space_cola = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cold_gate
	name = "Cold Gate"
	id = "cold_gate"
	result = /datum/reagent/drink/toothpaste/cold_gate
	result_amount = 3
	required_reagents = list(/datum/reagent/drink/mintsyrup = 1, /datum/reagent/drink/ice = 1, /datum/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/waterfresh
	name = "Waterfresh"
	id = "waterfresh"
	result = /datum/reagent/drink/toothpaste/waterfresh
	result_amount = 3
	required_reagents = list(/datum/reagent/drink/tonic = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/sedantian_firestorm
	name = "Sedantian Firestorm"
	id = "sedantian_firestorm"
	result = /datum/reagent/drink/toothpaste/sedantian_firestorm
	result_amount = 2
	required_reagents = list(/datum/reagent/toxin/phoron = 1, /datum/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/drink/kois_odyne
	name = "Kois Odyne"
	id = "kois_odyne"
	result = /datum/reagent/drink/toothpaste/kois_odyne
	result_amount = 3
	required_reagents = list(/datum/reagent/drink/tonic = 1, /datum/reagent/kois = 1, /datum/reagent/drink/toothpaste = 1)

/datum/chemical_reaction/adhomai_milk
	name = "Fermented Fatshouters Milk"
	id = "adhomai_milk"
	result = /datum/reagent/drink/milk/adhomai/fermented
	required_reagents = list(/datum/reagent/drink/milk/adhomai = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1

// Synnono Meme Drinks
//==============================
// Organized here because why not.

/datum/chemical_reaction/drink/badtouch
	name = "Bad Touch"
	id = "badtouch"
	result = /datum/reagent/alcohol/ethanol/badtouch
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/alcohol/ethanol/rum = 2, /datum/reagent/alcohol/ethanol/absinthe = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bluelagoon
	name = "Blue Lagoon"
	id = "bluelagooon"
	result = /datum/reagent/alcohol/ethanol/bluelagoon
	required_reagents = list(/datum/reagent/drink/lemonade = 3, /datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/alcohol/ethanol/bluecuracao = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/cherrytreefireball
	name = "Cherry Tree Fireball"
	id = "cherrytreefireball"
	result = /datum/reagent/alcohol/ethanol/cherrytreefireball
	required_reagents = list(/datum/reagent/drink/lemonade = 3, /datum/reagent/alcohol/ethanol/fireball = 1, /datum/reagent/nutriment/cherryjelly = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cobaltvelvet
	name = "Cobalt Velvet"
	id = "cobaltvelvet"
	result = /datum/reagent/alcohol/ethanol/cobaltvelvet
	required_reagents = list(/datum/reagent/alcohol/ethanol/champagne = 3, /datum/reagent/alcohol/ethanol/bluecuracao = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 6

/datum/chemical_reaction/drink/fringeweaver
	name = "Fringe Weaver"
	id = "fringeweaver"
	result = /datum/reagent/alcohol/ethanol/fringeweaver
	required_reagents = list(/datum/reagent/alcohol/ethanol = 2, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/drink/junglejuice
	name = "Jungle Juice"
	id = "junglejuice"
	result = /datum/reagent/alcohol/ethanol/junglejuice
	required_reagents = list(/datum/reagent/drink/lemonjuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/lemon_lime = 1, /datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/alcohol/ethanol/rum = 1)
	result_amount = 5

/datum/chemical_reaction/drink/marsarita
	name = "Marsarita"
	id = "marsarita"
	result = /datum/reagent/alcohol/ethanol/marsarita
	required_reagents = list(/datum/reagent/alcohol/ethanol/margarita = 4, /datum/reagent/alcohol/ethanol/bluecuracao = 1, /datum/reagent/capsaicin = 1)
	result_amount = 6

/datum/chemical_reaction/drink/meloncooler
	name = "Melon Cooler"
	id = "meloncooler"
	result = /datum/reagent/drink/meloncooler
	required_reagents = list(/datum/reagent/drink/watermelonjuice = 2, /datum/reagent/drink/sodawater = 2, /datum/reagent/drink/mintsyrup = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/midnightkiss
	name = "Midnight Kiss"
	id = "midnightkiss"
	result = /datum/reagent/alcohol/ethanol/midnightkiss
	required_reagents = list(/datum/reagent/alcohol/ethanol/champagne = 3, /datum/reagent/alcohol/ethanol/vodka = 1, /datum/reagent/alcohol/ethanol/bluecuracao = 1)
	result_amount = 5

/datum/chemical_reaction/drink/millionairesour
	name = "Millionaire Sour"
	id = "millionairesour"
	result = /datum/reagent/drink/millionairesour
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 3, /datum/reagent/drink/grenadine = 1, /datum/reagent/drink/limejuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/olympusmons
	name = "Olympus Mons"
	id = "olympusmons"
	result = /datum/reagent/alcohol/ethanol/olympusmons
	required_reagents = list(/datum/reagent/alcohol/ethanol/blackrussian = 1, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/alcohol/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/drink/europanail
	name = "Europa Nail"
	id = "europanail"
	result = /datum/reagent/alcohol/ethanol/europanail
	required_reagents = list(/datum/reagent/alcohol/ethanol/rustynail = 2, /datum/reagent/alcohol/ethanol/coffee/kahlua = 2, /datum/reagent/drink/milk/cream = 2)
	result_amount = 6

/datum/chemical_reaction/drink/portsvilleminttea
	name = "Portsville Mint Tea"
	id = "portsvilleminttea"
	result = /datum/reagent/drink/tea/portsvilleminttea
	required_reagents = list(/datum/reagent/drink/icetea = 3, /datum/reagent/drink/berryjuice = 1, /datum/reagent/drink/mintsyrup = 1, /datum/reagent/sugar = 1)
	result_amount = 6

/datum/chemical_reaction/drink/shirleytemple
	name = "Shirley Temple"
	id = "shirleytemple"
	result = /datum/reagent/drink/shirleytemple
	required_reagents = list(/datum/reagent/drink/spaceup = 4, /datum/reagent/drink/grenadine = 2)
	result_amount = 6

/datum/chemical_reaction/drink/sugarrush
	name = "Sugar Rush"
	id = "sugarrush"
	result = /datum/reagent/alcohol/ethanol/sugarrush
	required_reagents = list(/datum/reagent/drink/brownstar = 4, /datum/reagent/drink/grenadine = 1, /datum/reagent/alcohol/ethanol/vodka = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sangria
	name = "Sangria"
	id = "sangria"
	result = /datum/reagent/alcohol/ethanol/sangria
	required_reagents = list(/datum/reagent/alcohol/ethanol/wine = 3, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/lemonjuice = 1, /datum/reagent/alcohol/ethanol/brandy = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bassline
	name = "Bassline"
	id = "bassline"
	result = /datum/reagent/alcohol/ethanol/bassline
	required_reagents = list(/datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/alcohol/ethanol/bluecuracao = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/grapejuice = 2)
	result_amount = 6

/datum/chemical_reaction/drink/bluebird
	name = "Bluebird"
	id = "bluebird"
	result = /datum/reagent/alcohol/ethanol/bluebird
	required_reagents = list(/datum/reagent/alcohol/ethanol/gintonic = 3, /datum/reagent/alcohol/ethanol/bluecuracao = 1)
	result_amount = 4

//Snowflake drinks
/datum/chemical_reaction/drink/dr_gibb_diet
	name = "Diet Dr. Gibb"
	id = "dr_gibb_diet"
	result = /datum/reagent/drink/dr_gibb_diet
	required_reagents = list(/datum/reagent/drink/dr_gibb = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/drink/dr_daniels
	name = "Dr. Daniels"
	id = "dr_daniels"
	result = /datum/reagent/alcohol/ethanol/drdaniels
	required_reagents = list(/datum/reagent/drink/dr_gibb_diet = 3, /datum/reagent/alcohol/ethanol/whiskey = 1, /datum/reagent/nutriment/honey = 1)
	result_amount = 5

/datum/chemical_reaction/drink/meatshake
	name = "Meatshake"
	id = "meatshake"
	result = /datum/reagent/drink/meatshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/nutriment/protein = 1,/datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/drink/crocodile_booze
	name = "Crocodile Guwan"
	id = "crocodile_booze"
	result = /datum/reagent/alcohol/butanol/crocodile_booze
	required_reagents = list(/datum/reagent/alcohol/butanol/sarezhiwine = 5, /datum/reagent/toxin = 1)
	result_amount = 6

/datum/chemical_reaction/drink/messa_mead
	name = "Messa's Mead"
	id = "messa_mead"
	result = /datum/reagent/alcohol/ethanol/messa_mead
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/drink/earthenrootjuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/winter_offensive
	name = "Winter Offensive"
	id = "winter_offensive"
	result = /datum/reagent/alcohol/ethanol/winter_offensive
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/alcohol/ethanol/victorygin = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mars_coffee
	name = "Martian Special"
	id = "mars_coffee"
	result = /datum/reagent/drink/coffee/mars
	required_reagents = list(/datum/reagent/drink/coffee = 4, /datum/reagent/blackpepper = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mountain_marauder
	name = "Mountain Marauder"
	id = "mountain_marauder"
	result = /datum/reagent/alcohol/ethanol/mountain_marauder
	required_reagents = list(/datum/reagent/drink/milk/adhomai/fermented = 1, /datum/reagent/alcohol/ethanol/victorygin = 1)
	result_amount = 2

//Kaed's Unathi cocktails
//========

/datum/chemical_reaction/drink/moghesmargarita
	name = "Moghes Margarita"
	id = "moghesmargarita"
	result = /datum/reagent/alcohol/butanol/moghesmargarita
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 2, /datum/reagent/drink/limejuice = 3)
	result_amount = 5

/datum/chemical_reaction/drink/bahamalizard
	name = "Bahama Lizard"
	id = "bahamalizard"
	result = /datum/reagent/alcohol/butanol/bahamalizard
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 2, /datum/reagent/drink/lemonjuice = 2, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cactuscreme
	name = "Cactus Creme"
	id = "cactuscreme"
	result = /datum/reagent/alcohol/butanol/cactuscreme
	required_reagents = list(/datum/reagent/drink/berryjuice = 2, /datum/reagent/drink/milk/cream = 1, /datum/reagent/alcohol/butanol/xuizijuice = 2)
	result_amount = 5

/datum/chemical_reaction/drink/lizardplegm
	name = "Lizard Phlegm"
	id = "lizardphlegm"
	result = /datum/reagent/alcohol/butanol/lizardphlegm
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/banana = 1, /datum/reagent/alcohol/butanol/xuizijuice = 1, /datum/reagent/drink/watermelonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cactustea
	name = "Cactus Tea"
	id = "cactustea"
	result = /datum/reagent/alcohol/butanol/cactustea
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/alcohol/butanol/xuizijuice = 1)
	result_amount = 2

/datum/chemical_reaction/drink/moghespolitan
	name = "Moghespolitan"
	id = "moghespolitan"
	result = /datum/reagent/alcohol/butanol/moghespolitan
	required_reagents = list(/datum/reagent/alcohol/butanol/sarezhiwine = 2, /datum/reagent/alcohol/butanol/xuizijuice = 1, /datum/reagent/drink/grenadine = 5)
	result_amount = 5

/datum/chemical_reaction/drink/wastelandheat
	name = "Wasteland Heat"
	id = "wastelandheat"
	result = /datum/reagent/alcohol/butanol/wastelandheat
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 10, /datum/reagent/capsaicin = 3)
	result_amount = 10

/datum/chemical_reaction/drink/sandgria
	name = "Sandgria"
	id = "sandgria"
	result = /datum/reagent/alcohol/butanol/sandgria
	required_reagents = list(/datum/reagent/alcohol/butanol/sarezhiwine = 3, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/lemonjuice = 1, /datum/reagent/alcohol/butanol/xuizijuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/contactwine
	name = "Contact Wine"
	id = "contactwine"
	result = /datum/reagent/alcohol/butanol/contactwine
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 5, /datum/reagent/radium = 1, /datum/reagent/alcohol/butanol/sarezhiwine = 5)
	result_amount = 10

/datum/chemical_reaction/drink/hereticblood
	name = "Heretics' Blood"
	id = "hereticblood"
	result = /datum/reagent/alcohol/butanol/hereticblood
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 3, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/blood = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sandpit
	name = "Sandpit"
	id = "sandpit"
	result = /datum/reagent/alcohol/butanol/sandpit
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 2, /datum/reagent/drink/orangejuice = 2)
	result_amount = 4

/datum/chemical_reaction/drink/cactuscola
	name = "Cactus Cola"
	id = "cactuscola"
	result = /datum/reagent/alcohol/butanol/cactuscola
	required_reagents = list(/datum/reagent/alcohol/butanol/xuizijuice = 2, /datum/reagent/drink/space_cola = 2, /datum/reagent/drink/ice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/bloodwine
	name = "Bloodwine"
	id = "bloodwine"
	result = /datum/reagent/alcohol/butanol/bloodwine
	required_reagents = list(/datum/reagent/blood = 2, /datum/reagent/alcohol/butanol/sarezhiwine = 3)
	result_amount = 5

/datum/chemical_reaction/pumpkinspice
	name = "Pumpkin Spice"
	id = "pumpkinspce"
	result = /datum/reagent/spacespice/pumpkinspice
	mix_message = "The spice brightens up."
	required_reagents = list(/datum/reagent/spacespice = 8, /datum/reagent/nutriment/pumpkinpulp = 2)
	result_amount = 10

/datum/chemical_reaction/drink/psfrappe
	name = "Pumpkin Spice Frappe"
	id = "psfrappe"
	result = /datum/reagent/drink/coffee/icecoffee/psfrappe
	required_reagents = list(/datum/reagent/drink/coffee/icecoffee = 6, /datum/reagent/drink/syrup_pumpkin = 2, /datum/reagent/drink/milk/cream = 2)
	result_amount = 10

/datum/chemical_reaction/drink/pslatte
	name = "Pumpkin Spice Latte"
	id = "pslatte"
	result = /datum/reagent/drink/coffee/latte/pumpkinspice
	required_reagents = list(/datum/reagent/drink/coffee = 6, /datum/reagent/drink/syrup_pumpkin = 2, /datum/reagent/drink/milk/cream = 2)
	result_amount = 10

/datum/chemical_reaction/drink/caramel_latte
	name = "Caramel latte"
	id = "caramellatte"
	result = /datum/reagent/drink/coffee/latte/caramel
	required_reagents = list(/datum/reagent/drink/coffee/latte = 4, /datum/reagent/drink/syrup_caramel = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mocha_latte
	name = "Mocha latte"
	id = "mochalatte"
	result = /datum/reagent/drink/coffee/latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/latte = 4, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 5

/datum/chemical_reaction/drink/vanilla_latte
	name = "Vanilla latte"
	id = "vanillalatte"
	result = /datum/reagent/drink/coffee/latte/vanilla
	required_reagents = list(/datum/reagent/drink/coffee/latte = 4, /datum/reagent/drink/syrup_vanilla = 1)
	result_amount = 5

//Skrell drinks. Bring forth the culture.
//===========================================

/datum/chemical_reaction/drink/thirdincident
	name = "The Third Incident"
	id = "thirdincident"
	result = /datum/reagent/alcohol/ethanol/thirdincident
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/alcohol/ethanol/bluecuracao = 10, /datum/reagent/drink/grapejuice = 10)
	result_amount = 20

/datum/chemical_reaction/drink/upsidedowncup
	name = "Upside-Down Cup"
	id = "upsidedowncup"
	result = /datum/reagent/drink/upsidedowncup
	required_reagents = list(/datum/reagent/drink/dr_gibb = 3, /datum/reagent/drink/ice = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cigarettelizard
	name = "Cigarette Lizard"
	id = "cigarettelizard"
	result = /datum/reagent/drink/smokinglizard
	required_reagents = list(/datum/reagent/drink/limejuice = 2, /datum/reagent/drink/sodawater = 2, /datum/reagent/drink/mintsyrup = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sromshine
	name = "Sromshine"
	id = "sromshine"
	result = /datum/reagent/drink/coffee/sromshine
	required_reagents = list(/datum/reagent/drink/coffee = 2, /datum/reagent/drink/orangejuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/cbsc
	name = "Complex Bluespace Calculation"
	id = "cbsc"
	result = /datum/reagent/alcohol/ethanol/cbsc
	required_reagents = list(/datum/reagent/alcohol/ethanol/wine = 4, /datum/reagent/alcohol/ethanol/vodka = 2, /datum/reagent/drink/sodawater = 3, /datum/reagent/radium = 1 )
	result_amount = 10

/datum/chemical_reaction/drink/dynhot
	name = "Dyn Tea"
	id = "dynhot"
	result = /datum/reagent/drink/dynjuice/hot
	required_reagents = list(/datum/reagent/drink/dynjuice = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/drink/dyncold
	name = "Dyn Ice Tea"
	id = "dyncold"
	result = /datum/reagent/drink/dynjuice/cold
	required_reagents = list(/datum/reagent/drink/dynjuice = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/sodawater = 2)
	result_amount = 5

/datum/chemical_reaction/drink/algaesuprise
	name = "Pl'iuop Algae Surprise"
	id = "algaesuprise"
	result = /datum/reagent/drink/algaesuprise
	required_reagents = list(/datum/reagent/nutriment/virusfood = 2, /datum/reagent/drink/banana = 1)
	result_amount = 3

/datum/chemical_reaction/drink/xrim
	name = "Xrim Garden"
	id = "xrim"
	result = /datum/reagent/drink/xrim
	required_reagents = list(/datum/reagent/nutriment/virusfood = 2, /datum/reagent/drink/watermelonjuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/zorasoda/cthur = 1)
	result_amount = 6

/datum/chemical_reaction/drink/rixulin_sundae
	name = "Rixulin Sundae"
	id = "rixulin_sundae"
	result = /datum/reagent/alcohol/ethanol/rixulin_sundae
	required_reagents = list(/datum/reagent/nutriment/virusfood = 3, /datum/reagent/wulumunusha = 1, /datum/reagent/alcohol/ethanol/whitewine = 2)
	result_amount = 6

//Tea and cider
//=======================

/datum/chemical_reaction/drink/cidercheap
	name = "Apple Cider Juice"
	id = "cidercheap"
	result = /datum/reagent/drink/cidercheap
	required_reagents = list(/datum/reagent/drink/applejuice = 2, /datum/reagent/sugar = 1, /datum/reagent/spacespice = 1)
	result_amount = 4

/datum/chemical_reaction/cinnamonapplewhiskey
	name = "Cinnamon Apple Whiskey"
	id = "cinnamonapplewhiskey"
	result = /datum/reagent/alcohol/ethanol/cinnamonapplewhiskey
	required_reagents = list(/datum/reagent/drink/ciderhot = 3, /datum/reagent/alcohol/ethanol/fireball = 1)
	result_amount = 4

/datum/chemical_reaction/drink/chailatte
	name = "Chai Latte"
	id = "chailatte"
	result = /datum/reagent/drink/tea/chaitealatte
	required_reagents = list(/datum/reagent/drink/tea/chaitea = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/chailatte/soy
	id = "chailattesoy"
	required_reagents = list(/datum/reagent/drink/tea/chaitea = 1, /datum/reagent/drink/milk/soymilk = 1)

/datum/chemical_reaction/drink/coco_chaitea
	name = "Chocolate Chai"
	id = "coco_chaitea"
	result = /datum/reagent/drink/tea/coco_chaitea
	required_reagents = list(/datum/reagent/drink/tea/chaitea = 2, /datum/reagent/nutriment/coco = 1)
	result_amount = 3

/datum/chemical_reaction/drink/coco_chailatte
	name = "Chocolate Chai Latte"
	id = "coco_chailatte"
	result = /datum/reagent/drink/tea/coco_chailatte
	required_reagents = list(/datum/reagent/drink/tea/coco_chaitea = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/drink/coco_chailatte/soy
	id = "coco_chailatte_soy"
	required_reagents = list(/datum/reagent/drink/tea/coco_chaitea = 1, /datum/reagent/drink/milk/soymilk = 1)

/datum/chemical_reaction/drink/cofftea
	name = "Cofftea"
	id = "cofftea"
	result = /datum/reagent/drink/tea/cofftea
	required_reagents = list(/datum/reagent/drink/tea = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bureacratea
	name = "Bureacratea"
	id = "bureacratea"
	result = /datum/reagent/drink/tea/bureacratea
	required_reagents = list(/datum/reagent/drink/tea = 1, /datum/reagent/drink/coffee/espresso = 1)
	result_amount = 2

/datum/chemical_reaction/drink/desert_tea
	name = "Desert Blossom Tea"
	id = "desert_tea"
	result = /datum/reagent/drink/tea/desert_tea
	required_reagents = list(/datum/reagent/drink/tea/greentea = 2, /datum/reagent/alcohol/butanol/xuizijuice = 1, /datum/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/drink/halfandhalf
	name = "Half and Half"
	id = "halfandhalf"
	result = /datum/reagent/drink/tea/halfandhalf
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/drink/lemonade = 1)
	result_amount = 2

/datum/chemical_reaction/drink/heretic_tea
	name = "Heretics Tea"
	id = "heretic_tea"
	result = /datum/reagent/drink/tea/heretic_tea
	required_reagents = list(/datum/reagent/drink/icetea = 3, /datum/reagent/blood = 1, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/drink/kira_tea
	name = "Kira tea"
	id = "kira_tea"
	result = /datum/reagent/drink/tea/kira_tea
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/drink/kiraspecial = 1)
	result_amount = 2

/datum/chemical_reaction/drink/librarian_special
	name = "Librarian Special"
	id = "librarian_special"
	result = /datum/reagent/drink/tea/librarian_special
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/nothing = 1)
	result_amount = 3

/datum/chemical_reaction/drink/mars_tea
	name = "Martian Tea"
	id = "mars_tea"
	result = /datum/reagent/drink/tea/mars_tea
	required_reagents = list(/datum/reagent/drink/tea = 4, /datum/reagent/blackpepper = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mars_tea/green
	required_reagents = list(/datum/reagent/drink/tea/greentea = 4, /datum/reagent/blackpepper = 1)

/datum/chemical_reaction/drink/mendell_tea
	name = "Mendell Afternoon Tea"
	id = "mendell_tea"
	result = /datum/reagent/drink/tea/mendell_tea
	required_reagents = list(/datum/reagent/drink/tea/greentea = 4, /datum/reagent/drink/mintsyrup = 1, /datum/reagent/drink/lemonjuice = 1)
	result_amount = 6

/datum/chemical_reaction/drink/berry_tea
	name = "Mixed Berry Tea"
	id = "berry_tea"
	result = /datum/reagent/drink/tea/berry_tea
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/berryjuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/berry_tea/green
	required_reagents = list(/datum/reagent/drink/tea/greentea = 2, /datum/reagent/drink/berryjuice = 1)

/datum/chemical_reaction/drink/pomegranate_icetea
	name = "Pomegranate Iced Tea"
	id = "pomegranate_icetea"
	result = /datum/reagent/drink/tea/pomegranate_icetea
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 2

/datum/chemical_reaction/drink/potatea
	name = "Potatea"
	id = "potatea"
	result = /datum/reagent/drink/tea/potatea
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/potatojuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea
	name = "Securitea"
	id = "securitea"
	result = /datum/reagent/drink/tea/securitea
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea/red
	id = "securitea_red"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/red = 1)
/datum/chemical_reaction/drink/securitea/orange
	id = "securitea_orange"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/orange = 1)
/datum/chemical_reaction/drink/securitea/yellow
	id = "securitea_yellow"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/yellow = 1)
/datum/chemical_reaction/drink/securitea/green
	id = "securitea_green"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/green = 1)
/datum/chemical_reaction/drink/securitea/blue
	id = "securitea_blue"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/blue = 1)
/datum/chemical_reaction/drink/securitea/purple
	id = "securitea_purple"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/purple = 1)
/datum/chemical_reaction/drink/securitea/grey
	id = "securitea_grey"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/grey = 1)
/datum/chemical_reaction/drink/securitea/brown
	id = "securitea_brown"
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/crayon_dust/brown = 1)

/datum/chemical_reaction/drink/sleepytime_tea
	name = "Sleepytime Tea"
	id = "sleepytime_tea"
	result = /datum/reagent/drink/tea/sleepytime_tea
	required_reagents = list(/datum/reagent/drink/tea = 5, /datum/reagent/soporific = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sleepytime_tea/green
	id = "sleepytime_greentea"
	required_reagents = list(/datum/reagent/drink/tea/greentea = 5, /datum/reagent/soporific = 1)

/datum/chemical_reaction/drink/hakhma_tea
	name = "Spiced Hakhma Tea"
	id = "hakhma_tea"
	result = /datum/reagent/drink/tea/hakhma_tea
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/milk/beetle = 2, /datum/reagent/spacespice = 1)
	result_amount = 5

/datum/chemical_reaction/drink/sweet_tea
	name = "Sweet Tea"
	id = "sweet_tea"
	result = /datum/reagent/drink/tea/sweet_tea
	required_reagents = list(/datum/reagent/drink/icetea = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/drink/teathpaste
	name = "Teathpaste"
	id = "teathpaste"
	result = /datum/reagent/drink/toothpaste/teathpaste
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/toothpaste = 1)
	result_amount = 3

/datum/chemical_reaction/drink/thewake
	name = "The Wake"
	id = "thewake"
	result = /datum/reagent/drink/dynjuice/thewake
	required_reagents = list(/datum/reagent/drink/dynjuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/tea = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tomatea
	name = "Tomatea"
	id = "tomatea"
	result = /datum/reagent/drink/tea/tomatea
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/tomatojuice = 1)
	result_amount = 3

/datum/chemical_reaction/drink/trizkizki_tea
	name = "Trizkizki Tea"
	id = "trizkizki_tea"
	result = /datum/reagent/alcohol/butanol/trizkizki_tea
	required_reagents = list(/datum/reagent/drink/tea/greentea = 1, /datum/reagent/alcohol/butanol/sarezhiwine = 1, /datum/reagent/drink/grenadine = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tropical_icetea
	name = "Tropical Iced Tea"
	id = "tropical_icetea"
	result = /datum/reagent/drink/tea/tropical_icetea
	required_reagents = list(/datum/reagent/drink/icetea = 3, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/watermelonjuice = 1)
	result_amount = 6

//transmutation

/datum/chemical_reaction/transmutation_silver
	name = "Transmutation: Silver"
	id = "transmutation_silver"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/copper = 5)
	catalysts = list(/datum/reagent/philosopher_stone = 1)
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
	required_reagents = list(/datum/reagent/aluminum = 5, MATERIAL_SILVER = 5)
	catalysts = list(/datum/reagent/philosopher_stone = 1)
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
	required_reagents = list(/datum/reagent/carbon = 5, MATERIAL_GOLD = 5)
	catalysts = list(/datum/reagent/philosopher_stone = 1)
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
	result = /datum/reagent/drink/ice
	required_reagents = list(/datum/reagent/water = 1)
	required_temperatures_max = list(/datum/reagent/water = T0C)
	result_amount = 1
	mix_message = "The water freezes."
	reaction_sound = ""

/datum/chemical_reaction/ice_to_water
	name = "Ice to Water"
	id = "ice_to_water"
	result = /datum/reagent/water
	required_reagents = list(/datum/reagent/drink/ice = 1)
	required_temperatures_min = list(/datum/reagent/drink/ice = T0C + 25) // stop-gap fix to allow recipes requiring ice to be made without breaking the server with HALF_LIFE
	result_amount = 1
	mix_message = "The ice melts."
	reaction_sound = ""

/datum/chemical_reaction/phoron_salt
	name = "Phoron Salt"
	id = "phoron_salt"
	result = /datum/reagent/toxin/phoron_salt
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/toxin/phoron = 2)
	required_temperatures_min = list(/datum/reagent/sodiumchloride = 678, /datum/reagent/toxin/phoron = 73)
	required_temperatures_max = list(/datum/reagent/toxin/phoron = 261)

	result_amount = 1

/datum/chemical_reaction/pyrosilicate
	name = "Pyrosilicate"
	id = "pyrosilicate"
	result = /datum/reagent/pyrosilicate
	result_amount = 4
	required_reagents = list(/datum/reagent/silicate = 1, /datum/reagent/acid = 1, /datum/reagent/hydrazine = 1, /datum/reagent/iron = 1)

/datum/chemical_reaction/cryosurfactant
	name = "Cryosurfactant"
	id = "cryosurfactant"
	result = /datum/reagent/cryosurfactant
	result_amount = 3
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/drink/ice = 1, /datum/reagent/sodium = 1)

//WATER
/datum/chemical_reaction/cryosurfactant_cooling_water
	name = "Cryosurfactant Cooling Water"
	id = "cryosurfactant_cooling_water"
	result = null
	result_amount = 1
	required_reagents = list(/datum/reagent/cryosurfactant = 1)
	inhibitors = list(/datum/reagent/pyrosilicate = 1)
	catalysts = list(/datum/reagent/water = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_water/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent(/datum/reagent/cryosurfactant)
	holder.add_thermal_energy(-created_volume*500)

//ICE
/datum/chemical_reaction/cryosurfactant_cooling_ice
	name = "Cryosurfactant Cooling Ice"
	id = "cryosurfactant_cooling_ice"
	result = null
	result_amount = 1
	required_reagents = list(/datum/reagent/cryosurfactant = 1)
	inhibitors = list(/datum/reagent/pyrosilicate = 1)
	catalysts = list(/datum/reagent/drink/ice = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_ice/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent(/datum/reagent/cryosurfactant)
	holder.add_thermal_energy(-created_volume*500)

/datum/chemical_reaction/pyrosilicate_heating
	name = "Pyrosilicate Heating"
	id = "pyrosilicate_heating"
	result = null
	result_amount = 1
	required_reagents = list(/datum/reagent/pyrosilicate = 1)
	inhibitors = list(/datum/reagent/cryosurfactant = 1)
	catalysts = list(/datum/reagent/sodiumchloride = 1)

/datum/chemical_reaction/pyrosilicate_heating/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.del_reagent(/datum/reagent/pyrosilicate)
	holder.add_thermal_energy(created_volume*1000)

/datum/chemical_reaction/pyrosilicate_cryosurfactant
	name = "Pyrosilicate Cryosurfactant Reaction"
	id = "pyrosilicate_cryosurfactant"
	result = null
	required_reagents = list(/datum/reagent/pyrosilicate = 1, /datum/reagent/cryosurfactant = 1)
	required_temperatures_min = list(/datum/reagent/pyrosilicate = T0C, /datum/reagent/cryosurfactant = T0C) //Does not react when below these temperatures.
	result_amount = 1

/datum/chemical_reaction/pyrosilicate_cryosurfactant/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	if(created_volume)
		var/turf/simulated/floor/T = get_turf(holder.my_atom.loc)
		if(istype(T))
			T.assume_gas(GAS_OXYGEN, created_volume*10, (created_thermal_energy/created_volume) )

/datum/chemical_reaction/phoron_salt_fire
	name = "Phoron Salt Fire"
	id = "phoron_salt_fire"
	result = null
	result_amount = 1
	required_reagents = list(/datum/reagent/toxin/phoron_salt = 1)
	required_temperatures_min = list(/datum/reagent/toxin/phoron_salt = 134) //If it's above this temperature, then cause hellfire.
	mix_message = "The solution begins to vibrate!"

/datum/chemical_reaction/phoron_salt_fire/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	var/turf/location = get_turf(holder.my_atom)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(GAS_PHORON, created_volume*2, created_thermal_energy / 25) //2 because there is 2 phoron in 1u of phoron salts
		addtimer(CALLBACK(target_tile, /turf/simulated/floor/.proc/hotspot_expose, 700, 400), 1)
	holder.del_reagent(/datum/reagent/toxin/phoron_salt)
	return

/datum/chemical_reaction/phoron_salt_coldfire
	name = "Phoron Salt Coldfire"
	id = "phoron_salt_coldfire"
	result = null
	result_amount = 1
	required_reagents = list(/datum/reagent/toxin/phoron_salt = 1)
	required_temperatures_max = list(/datum/reagent/toxin/phoron_salt = 113) //if it's below this temperature, then make a boom
	mix_message = "The solution begins to shrink!"

/datum/chemical_reaction/phoron_salt_coldfire/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	var/turf/location = get_turf(holder.my_atom)
	var/thermal_energy_mod = max(0,1 - (max(0,created_thermal_energy)/28000))
	var/volume_mod = min(1,created_volume/120)
	var/explosion_mod = 3 + (thermal_energy_mod*volume_mod*320)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(explosion_mod, location, 0, 0)
	e.start()
	holder.del_reagent(/datum/reagent/toxin/phoron_salt)
	return

/datum/chemical_reaction/mutone
	name = "Mutone"
	id = "mutone"
	result = /datum/reagent/mutone
	result_amount = 1
	required_reagents = list(/datum/reagent/toxin/phoron_salt = 1, /datum/reagent/mutagen = 1)

/datum/chemical_reaction/plexium
	name = "Plexium"
	id = "plexium"
	result = /datum/reagent/plexium
	result_amount = 1
	required_reagents = list(/datum/reagent/toxin/phoron_salt = 1, /datum/reagent/alkysine = 1)

/datum/chemical_reaction/venenum
	name = "Venenum"
	id = "venenum"
	result = /datum/reagent/venenum
	result_amount = 1
	required_reagents = list(/datum/reagent/toxin/phoron_salt = 1, /datum/reagent/ryetalyn = 1)

/datum/chemical_reaction/rmt
	name = "RMT"
	id = "rmt"
	result = /datum/reagent/rmt
	result_amount = 2
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/inaprovaline = 1)

/datum/chemical_reaction/gunpowder
	name = "Gunpowder"
	id = "gunpowder"
	result = /datum/reagent/gunpowder
	result_amount = 1
	required_reagents = list(/datum/reagent/sulfur = 1, /datum/reagent/carbon = 1, /datum/reagent/potassium = 1)

//Coffee expansion
//=======================
/datum/chemical_reaction/caramelisation
	name = "Caramelised Sugar"
	result = /datum/reagent/nutriment/caramel
	required_reagents = list(/datum/reagent/sugar = 1)
	result_amount = 1
	required_temperatures_min = list(/datum/reagent/sugar = T0C + 82) // no maximum! i mean technically it should burn at some point but ehh
	mix_message = "The sugar melts into a sticky, brown liquid."

/datum/chemical_reaction/caramelsauce
	name = "Caramel Sauce"
	id = "caramelsauce"
	result = /datum/reagent/drink/caramel
	required_reagents = list(/datum/reagent/nutriment/caramel = 2, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/syrup_simple = 2)
	result_amount = 5
	mix_message = "The solution thickens into a glossy, brown sauce."
	required_temperatures_max = list(/datum/reagent/nutriment/caramel = T0C + 82) // You don't want the syrup to crystallise/caramelise; that'd just make more caramel...

/datum/chemical_reaction/simplesyrup
	name = "Simple Syrup"
	id = "simplesyrup"
	result = /datum/reagent/drink/syrup_simple
	required_reagents = list(/datum/reagent/sugar = 2, /datum/reagent/water = 2) // simple syrup, the sugar dissolves and doesn't change the volume too much
	result_amount = 2
	required_temperatures_min = list(/datum/reagent/sugar = T0C + 30, /datum/reagent/water = T0C + 30)
	required_temperatures_max = list(/datum/reagent/sugar = T0C + 82, /datum/reagent/water = T0C + 100) // Sugar caramelises after 82C, water boils at 100C.
	mix_message = "The sugar dissolves into the solution."

/datum/chemical_reaction/caramelsyrup
	name = "Caramel Syrup"
	id = "caramelsyrup"
	result = /datum/reagent/drink/syrup_caramel
	required_reagents = list(/datum/reagent/nutriment/caramel = 2, /datum/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on a light brown hue and the aroma of caramel."

/datum/chemical_reaction/chocosyrup
	name = "Chocolate Syrup"
	id = "chocolatesyrup"
	result = /datum/reagent/drink/syrup_chocolate
	required_reagents = list(/datum/reagent/nutriment/coco = 2, /datum/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on a brown hue and the aroma of chocolate."

/datum/chemical_reaction/pumpkinsyrup
	name = "Pumpkin Spice Syrup"
	id = "pumpkinsyrup"
	result = /datum/reagent/drink/syrup_pumpkin
	required_reagents = list(/datum/reagent/spacespice/pumpkinspice = 2, /datum/reagent/drink/syrup_simple = 3)
	result_amount = 5
	mix_message = "The solution takes on an orange hue and the aroma of pumpkin spice."
