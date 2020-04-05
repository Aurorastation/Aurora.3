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
				M.show_message("<span class='notice'>\icon[container] [mix_message]</span>", 1)
		if(reaction_sound)
			playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */

/datum/chemical_reaction/norepinephrine
	name = "Norepinephrine"
	id = "norepinephrine"
	result = "norepinephrine"
	required_reagents = list("acetone" = 1, "carbon" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "dylovene"
	result = "dylovene"
	required_reagents = list("silicon" = 1, "potassium" = 1, "ammonia" = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	id = "tramadol"
	result = "tramadol"
	required_reagents = list("norepinephrine" = 1, "ethanol" = 1, "acetone" = 1)
	result_amount = 3

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	result = "paracetamol"
	required_reagents = list("tramadol" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	result = "oxycodone"
	required_reagents = list("ethanol" = 1, "tramadol" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "dylovene" = 1, "hclacid" = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = "silicate"
	required_reagents = list("aluminum" = 1, "silicon" = 1, "acetone" = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "hclacid" = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, "iron" = 1, "acetone" = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "acetone" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "hclacid" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = "synaptizine"
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	result = "hyronalin"
	required_reagents = list("radium" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	result = "arithrazine"
	required_reagents = list("hyronalin" = 1, "hydrazine" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "acetone" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = "kelotane"
	required_reagents = list("silicon" = 1, "carbon" = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	result = "peridaxon"
	required_reagents = list("bicaridine" = 1, "clonexadone" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 1, "milk" = 1)
	result_amount = 5

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	result = "leporazine"
	required_reagents = list("silicon" = 1, "copper" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "acetone" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = "tricordrazine"
	required_reagents = list("norepinephrine" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = "alkysine"
	required_reagents = list("hclacid" = 1, "ammonia" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = "dexalin"
	result = "dexalin"
	required_reagents = list("acetone" = 2, "phoron" = 0.1)
	catalysts = list("phoron" = 1)
	inhibitors = list("water" = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = "dermaline"
	result = "dermaline"
	required_reagents = list("acetone" = 1, "phosphorus" = 1, "kelotane" = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	result = "dexalinp"
	required_reagents = list("dexalin" = 1, "carbon" = 1, "iron" = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = "bicaridine"
	required_reagents = list("norepinephrine" = 1, "carbon" = 1)
	inhibitors = list("sugar" = 1) // Messes with norepinephrine
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = "hyperzine"
	required_reagents = list("sugar" = 1, "phosphorus" = 1, "sulfur" = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	result = "ryetalyn"
	required_reagents = list("arithrazine" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	result = "cryoxadone"
	required_reagents = list("dexalin" = 1, "water" = 1, "acetone" = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	result = "clonexadone"
	required_reagents = list("cryoxadone" = 1, "sodium" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/deltamivir
	name = "Deltamivir"
	id = "deltamivir"
	result = "deltamivir"
	required_reagents = list("cryptobiolin" = 1, "tricordrazine" = 1)
	result_amount = 2

/datum/chemical_reaction/thetamycin
	name = "Thetamycin"
	id = "thetamycin"
	result = "thetamycin"
	required_reagents = list("cryptobiolin" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/antihistamine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	result = "diphenhydramine"
	required_reagents = list("cryptobiolin" = 1, "norepinephrine" = 1)
	result_amount = 2

/datum/chemical_reaction/ondansetron
	name = "Ondansetron"
	id = "ondansetron"
	result = "ondansetron"
	required_reagents = list("diphenhydramine" = 1, "synaptizine" = 1, "water" = 3)
	catalysts = list("tungsten" = 5)
	result_amount = 3

/datum/chemical_reaction/imidazoline
	name = "imidazoline"
	id = "imidazoline"
	result = "imidazoline"
	required_reagents = list("carbon" = 1, "hydrazine" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = "ethylredoxrazine"
	required_reagents = list("acetone" = 1, "dylovene" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/ipecac
	name = "Ipecac"
	id = "ipecac"
	result = "ipecac"
	required_reagents = list("hydrazine" = 1, "dylovene" = 1, "ethanol" = 1)
	result_amount = 3

/datum/chemical_reaction/adipemcina
	name = "Adipemcina"
	id = "adipemcina"
	result = "adipemcina"
	required_reagents = list("lithium" = 1, "dylovene" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("chloralhydrate" = 1, "sugar" = 4)
	inhibitors = list("phosphorus") // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("ethanol" = 1, "hclacid" = 3, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = "potassium_chloride"
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = "potassium_chlorophoride"
	required_reagents = list("potassium_chloride" = 1, "phoron" = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2

/datum/chemical_reaction/dextrotoxin
	name = "Dextrotoxin"
	id = "dextrotoxin"
	result = "dextrotoxin"
	required_reagents = list("carpotoxin" = 3, "stoxin" = 10, "phoron" = 5)
	result_amount = 5

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrazine" = 1, "dylovene" = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = "lipozine"
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, "radium" = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	id = "surfactant"
	result = "surfactant"
	required_reagents = list("hydrazine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrazine" = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("triglyceride" = 1, "ethanol" = 2) // transesterification of triglycerides into butanol and glycerol
	catalysts = list("sacid" = 5) // using acid as a catalyst
	result_amount = 3 //each triglyceride has 3 glycerin chains.

/datum/chemical_reaction/glycerol/butanol
	name = "Glycerol"
	id = "glycerol-butane"
	result = "glycerol"
	required_reagents = list("triglyceride" = 1, "butanol" = 2)

/datum/chemical_reaction/glycerol/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.add_reagent("acetone", 2 * created_volume / 3) // closest we can get to biofuel, sorry

/datum/chemical_reaction/glucose
	name = "Glucose"
	id = "glucose"
	result = "glucose"
	required_reagents = list("nutriment" = 5) // thank you, Gottlieb Kirchhoff
	catalysts = list("sacid" = 5 )//starch into sugar with sulfuric acid catalyst

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("sodium" = 1, "hclacid" = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 2)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = "coolant"
	required_reagents = list("tungsten" = 1, "acetone" = 1, "water" = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list("tungsten" = 1, "hydrazine" = 1, "ammonia" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 3

/datum/chemical_reaction/calomel
	name = "Calomel"
	id = "calomel"
	result = "calomel"
	required_reagents = list("mercury" = 1, "sodiumchloride" = 1, "ammonia" = 1)
	result_amount = 3

/datum/chemical_reaction/cardox
	name = "Cardox"
	id = "cardox"
	result = "cardox"
	required_reagents = list("platinum" = 1, "carbon" = 1, "sterilizine" = 1)
	result_amount = 3

/datum/chemical_reaction/cardox_removal
	name = "Cardox Removal"
	id = "cardox_removal"
	result = "carbon"
	required_reagents = list("cardox" = 0.1, "phoron" = 1)
	result_amount = 0

/datum/chemical_reaction/monoammoniumphosphate
	name = "Monoammoniumphosphate"
	id = "monoammoniumphosphate"
	result = "monoammoniumphosphate"
	required_reagents = list("ammonia" = 1, "sacid" = 1, "sodium" = 1, "phosphorus" = 1)
	result_amount = 4

/datum/chemical_reaction/koispasteclean
	name = "Filtered K'ois"
	id = "koispasteclean"
	result = "koispasteclean"
	required_reagents = list("koispaste" = 2,"cardox" = 0.1)
	catalysts = list("cardox" = 5)
	result_amount = 1

/datum/chemical_reaction/pulmodeiectionem
	name = "Pulmodeiectionem"
	id = "pulmodeiectionem"
	result = "pulmodeiectionem"
	required_reagents = list("calomel" = 1, "lexorin" = 1)
	result_amount = 2

/datum/chemical_reaction/pneumalin
	name = "Pneumalin"
	id = "pneumalin"
	result = "pneumalin"
	required_reagents = list("coughsyrup" = 1, "copper" = 1, "pulmodeiectionem" = 1)
	result_amount = 2

/datum/chemical_reaction/saline
	name = "Saline"
	id = "saline"
	result = "saline"
	required_reagents = list("sugar" = 0.4, "water" = 1, "sodiumchloride" = 0.9)
	result_amount = 1

/datum/chemical_reaction/mannitol
	name = "Mannitol"
	id = "mannitol"
	result = "mannitol"
	required_reagents = list("phoron" = 0.1, "alkysine" = 1, "cryoxadone" = 0.1)
	result_amount = 1

/datum/chemical_reaction/atropine
	name = "Atropine"
	id = "atropine"
	result = "atropine"
	required_reagents = list("tricordrazine" = 1, "phoron" = 0.1, "hydrazine" = 1 )
	result_amount = 2

/datum/chemical_reaction/coughsyrup
	name = "Cough Syrup"
	id = "coughsyrup"
	result = "coughsyrup"
	required_reagents = list("carbon" = 1, "ammonia" = 1, "water" = 1)
	result_amount = 3

//Mental Medication

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	result = "methylphenidate"
	required_reagents = list("mindbreaker" = 1, "hydrazine" = 1)
	result_amount = 2

/datum/chemical_reaction/escitalopram
	name = "Escitalopram"
	id = "escitalopram"
	result = "escitalopram"
	required_reagents = list("mindbreaker" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = "adrenaline"
	required_reagents = list("norepinephrine" = 1, "hyperzine" = 1, "dexalinp" = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "acetone" = 1, "norepinephrine" = 1)
	result_amount = 3

/datum/chemical_reaction/fluvoxamine
	name = "Fluvoxamine"
	id = "fluvoxamine"
	result = "fluvoxamine"
	required_reagents = list("mindbreaker" = 1, "iron" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/sertraline
	name = "Sertraline"
	id = "sertraline"
	result = "sertraline"
	required_reagents = list("mindbreaker" = 1, "aluminum" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "ammonia" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/duloxetine
	name = "Duloxetine"
	id = "duloxetine"
	result = "duloxetine"
	required_reagents = list("mindbreaker" = 1, "silicon" = 1, "ethanol" = 1)
	result_amount = 3

/datum/chemical_reaction/venlafaxine
	name = "Venlafaxine"
	id = "venlafaxine"
	result = "venlafaxine"
	required_reagents = list("mindbreaker" = 1, "sodium" = 1, "tungsten" = 1)
	result_amount = 3

/datum/chemical_reaction/risperidone
	name = "Risperidone"
	id = "risperidone"
	result = "risperidone"
	required_reagents = list("mindbreaker" = 1, "space_drugs" = 1, "ethanol" = 1)
	result_amount = 3

/datum/chemical_reaction/olanzapine
	name = "Olanzapine"
	id = "olanzapine"
	result = "olanzapine"
	required_reagents = list("mindbreaker" = 1, "space_drugs" = 1, "silicon" = 1)
	result_amount = 3

/datum/chemical_reaction/truthserum
	name = "Truthserum"
	id = "truthserum"
	result = "truthserum"
	required_reagents = list("mindbreaker" = 1, "synaptizine" = 1, "phoron" = 0.1)
	result_amount = 2

/datum/chemical_reaction/pacifier
	name = "Paxazide"
	id = "paxazide"
	result = "paxazide"
	required_reagents = list("truthserum" = 1, "sertraline" = 1)
	result_amount = 1

/datum/chemical_reaction/berserk
	name = "Red Nightshade"
	id = "berserk"
	result = "berserk"
	required_reagents = list("psilocybin" = 1, "moonshine" = 1)
	result_amount = 1

/* Makeshift Chemicals and Drugs */

/datum/chemical_reaction/stimm
	name = "Stimm"
	id = "stimm"
	result = "stimm"
	required_reagents = list("fuel" = 1, "rewriter" = 5)
	result_amount = 6

/datum/chemical_reaction/lean
	name = "Lean"
	id = "lean"
	result = "lean"
	required_reagents = list("space_up" = 2, "coughsyrup" = 2, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/krokjuice
	name = "Krok Juice"
	id = "krok"
	result = "krok"
	required_reagents = list("orangejuice" = 2, "fuel" = 1, "iron" = 1)
	result_amount = 4

/datum/chemical_reaction/raskara_dust
	name = "Raskara Dust"
	id = "raskara_dust"
	result = "raskara_dust"
	required_reagents = list("monoammoniumphosphate" = 1, "cleaner" = 1, "sodiumchloride" = 2) // extinguisher, cleaner, salt
	required_temperatures_min = list("monoammoniumphosphate" = 400, "cleaner" = 400, "sodiumchloride" = 400) // barely over boiling point of water
	result_amount = 2

/datum/chemical_reaction/nightjuice
	name = "Nightlife"
	id = "night_juice"
	result = "night_juice"
	required_reagents = list("methylphenidate" = 1, "synaptizine" = 1, "nitroglycerin" = 1)
	required_temperatures_min = list("methylphenidate" = T0C+200, "synaptizine" = T0C+200, "nitroglycerin" = T0C+200)
	result_amount = 3

/* Solidification */

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	id = "solidphoron"
	result = null
	required_reagents = list("iron" = 5, "frostoil" = 5, "phoron" = 20)
	result_amount = 1

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)
	return

/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list("pacid" = 1, "plasticide" = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, "potassium" = 1)
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
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
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

				flick("e_flash", M.flash)
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				flick("e_flash", M.flash)
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()
	return

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list("aluminum" = 1, "phoron" = 1, "sacid" = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("phoron", created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")
	return

/datum/chemical_reaction/zoragel
	name = "Inert Gel"
	id = "zoragel"
	result = "zoragel"
	required_reagents = list("sacid" = 1, "aluminum" = 1, "sugar" = 1, "surfactant" = 3)
	result_amount = 1

/datum/chemical_reaction/zorafire
	name = "Zo'rane Fire"
	id = "greekfire"
	result = "greekfire"
	required_reagents = list("nitroglycerin" = 2, "pyrosilicate" = 2, "phoron" = 3, "zoragel" = 3)
	result_amount = 1
	log_is_important = 1

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
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
	required_reagents = list("surfactant" = 1, "water" = 1)
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
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
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
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
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
	result = "luminol"
	required_reagents = list("hydrazine" = 2, "carbon" = 2, "ammonia" = 2)
	result_amount = 6

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	id = "red_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_red" = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#FE191A"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_orange" = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#FFBE4F"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_yellow" = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#FDFE7D"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	id = "green_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_green" = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18A31A"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_blue" = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247CFF"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_purple" = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#CC0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_grey" = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "crayon_dust_brown" = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846F35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "blood" = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "milk" = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#F0F8FF"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "orangejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#E78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "tomatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "limejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365E30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carrotjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "berryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "grapejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "poisonberryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "watermelonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#B83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "lemonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#AFAF00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "banana" = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#C3AF00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "potatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carbon" = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "aluminum" = 1)
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
		T.visible_message("\icon[T]<span class='notice'>\The [T]'s power is consumed in the reaction.</span>")
		T.name = "used slime extract"
		T.desc = "This extract has been used up."

//Grey
/datum/chemical_reaction/slime/spawn
	name = "Slime Spawn"
	id = "m_spawn"
	result = null
	required_reagents = list("phoron" = 1)
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
	required_reagents = list("blood" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	new /obj/effect/portal/spawner/monkey_cube(get_turf(holder.my_atom))
	..()

//Green
/datum/chemical_reaction/slime/mutate
	name = "Mutation Toxin"
	id = "mutationtoxin"
	result = "mutationtoxin"
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/green

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	id = "m_metal"
	result = null
	required_reagents = list("phoron" = 1)
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
	required_reagents = list("water" = 5)
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
		/mob/living/simple_animal/hostile/greatworm,
		/mob/living/simple_animal/hostile/lesserworm,
		/mob/living/simple_animal/hostile/greatwormking,
		/mob/living/simple_animal/hostile/krampus,
		/mob/living/simple_animal/hostile/gift,
		/mob/living/simple_animal/hostile/hivebotbeacon,
		/mob/living/simple_animal/hostile/hivebotbeacon/toxic,
		/mob/living/simple_animal/hostile/hivebotbeacon/incendiary,
		/mob/living/simple_animal/hostile/republicon,
		/mob/living/simple_animal/hostile/republicon/ranged
	)
	//exclusion list for things you don't want the reaction to create.
	var/list/critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck(TRUE) <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 5, i++)
		var/chosen = pick(critters)
		var/mob/living/simple_animal/hostile/C = new chosen
		C.faction = "slimesummon"
		C.forceMove(get_turf(holder.my_atom))
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()

/datum/chemical_reaction/slime/rare_metal
	name = "Slime Rare Metal"
	id = "rm_metal"
	result = null
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/datum/chemical_reaction/slime/rare_metal/on_reaction(var/datum/reagents/holder)
	new /obj/effect/portal/spawner/rare_metal(get_turf(holder.my_atom))
	..()

//Silver
/datum/chemical_reaction/slime/bork
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("phoron" = 1)
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
			flick("e_flash", M.flash)

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
	result = "frostoil"
	required_reagents = list("phoron" = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list("phoron" = 1)
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
	result = "capsaicin"
	required_reagents = list("blood" = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/fire/on_reaction(var/datum/reagents/holder)
	..()
	addtimer(CALLBACK(src, .proc/do_reaction, holder), 50)

/datum/chemical_reaction/slime/fire/proc/do_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.my_atom)
	for(var/turf/simulated/floor/target_tile in range(1, location))
		target_tile.assume_gas("phoron", 25, 1400)
		target_tile.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slime/overload
	name = "Slime EMP"
	id = "m_emp"
	result = null
	required_reagents = list("blood" = 1)
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
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "A small sparking part of the extract core falls onto the floor."

/datum/chemical_reaction/slime/cell/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/cell/slime(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/glow
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list("water" = 1)
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
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/slimesteroid(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("sugar" = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple
/datum/chemical_reaction/slime/plasma
	name = "Slime Plasma"
	id = "m_plasma"
	result = null
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/plasma/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/effect/portal/spawner/phoron(get_turf(holder.my_atom))

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = "glycerol"
	required_reagents = list("phoron" = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	id = "m_bloodlust"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = TRUE
		slime.visible_message(SPAN_WARNING("\icon[slime] \The [slime] is driven into a frenzy!"))

//Pink
/datum/chemical_reaction/slime/ppotion
	name = "Slime Potion"
	id = "m_potion"
	result = null
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/ppotion/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/slimepotion(get_turf(holder.my_atom))

//Black
/datum/chemical_reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	id = "mutationtoxin2"
	result = "amutationtoxin"
	required_reagents = list("phoron" = 1)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slime/explosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list("phoron" = 1)
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
	required_reagents = list("phoron" = 1)

/datum/chemical_reaction/slime/potion2/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/slimepotion2(get_turf(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	id = "m_golem"
	result = null
	required_reagents = list("phoron" = 1)
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
	required_reagents = list("triglyceride" = 2, "water" = 2, "cleaner" = 3)
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
	required_reagents = list("soymilk" = 10)
	catalysts = list("enzyme" = 5)
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
	required_reagents = list("soymilk" = 2, "coco" = 2, "sugar" = 2)
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
	required_reagents = list("milk" = 2, "coco" = 2, "sugar" = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	id = "hot_coco"
	result = "hot_coco"
	required_reagents = list("water" = 5, "coco" = 1)
	result_amount = 5

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = "soysauce"
	required_reagents = list("soymilk" = 4, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = "ketchup"
	required_reagents = list("tomatojuice" = 2, "water" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/barbecue
	name = "Barbecue Sauce"
	id = "barbecue"
	result = "barbecue"
	required_reagents = list("ketchup" = 2, "garlicsauce" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/garlicsauce
	name = "Garlic Sauce"
	id = "garlicsauce"
	result = "garlicsauce"
	required_reagents = list("garlicjuice" = 1, "cornoil" = 1)
	result_amount = 2

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list("milk" = 40)
	catalysts = list("enzyme" = 5)
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
	required_reagents = list("protein" = 3, "flour" = 5)
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
	required_reagents = list("egg" = 3, "flour" = 10)
	inhibitors = list("water" = 1, "beer" = 1) //To prevent it messing with batter recipes
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
	required_reagents = list("blood" = 5, "clonexadone" = 1)
	result_amount = 1

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = "hot_ramen"
	required_reagents = list("water" = 1, "dry_ramen" = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = "hell_ramen"
	required_reagents = list("capsaicin" = 1, "hot_ramen" = 6)
	result_amount = 6

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = "batter"
	result = "batter"
	required_reagents = list("egg" = 3, "flour" = 10, "water" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = "beerbatter"
	required_reagents = list("egg" = 3, "flour" = 10, "beer" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("cream" = 20, "sodiumchloride" = 1)
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
	result = "goldschlager"
	required_reagents = list("vodka" = 10, MATERIAL_GOLD = 1)
	mix_message = null
	reaction_sound = 'sound/effects/pour.ogg'
	result_amount = 10

/datum/chemical_reaction/drink/patron
	name = "Patron"
	id = "patron"
	result = "patron"
	required_reagents = list("tequilla" = 10, MATERIAL_SILVER = 1)
	result_amount = 10

/datum/chemical_reaction/drink/bilk
	name = "Bilk"
	id = "bilk"
	result = "bilk"
	required_reagents = list("milk" = 1, "beer" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/icetea
	name = "Iced Tea"
	id = "icetea"
	result = "icetea"
	required_reagents = list("ice" = 1, "tea" = 2)
	result_amount = 3

/datum/chemical_reaction/drink/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	result = "icecoffee"
	required_reagents = list("ice" = 1, "coffee" = 2)
	result_amount = 3

/datum/chemical_reaction/drink/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	result = "nuka_cola"
	required_reagents = list("uranium" = 1, "cola" = 5)
	result_amount = 5

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = "moonshine"
	required_reagents = list("nutriment" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/butanol
	name = "Butanol"
	id = "butanol"
	result = "butanol"
	required_reagents = list("cornoil" = 10, "sugar" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	result = "grenadine"
	required_reagents = list("berryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	id = "wine"
	result = "wine"
	required_reagents = list("grapejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	id = "pwine"
	result = "pwine"
	required_reagents = list("poisonberryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = "melonliquor"
	required_reagents = list("watermelonjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = "bluecuracao"
	required_reagents = list("orangejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = "beer"
	required_reagents = list("cornoil" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/vodka
	name = "Vodka"
	id = "vodka"
	result = "vodka"
	required_reagents = list("potato" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	id = "sake"
	result = "sake"
	required_reagents = list("rice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = "kahlua"
	required_reagents = list("coffee" = 5, "sugar" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/drink/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = "gintonic"
	required_reagents = list("gin" = 2, "tonic" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = "cubalibre"
	required_reagents = list("rum" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/martini
	name = "Classic Martini"
	id = "martini"
	result = "martini"
	required_reagents = list("gin" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = "vodkamartini"
	required_reagents = list("vodka" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = "whiterussian"
	required_reagents = list("blackrussian" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = "whiskeycola"
	required_reagents = list("whiskey" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = "screwdrivercocktail"
	required_reagents = list("vodka" = 2, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = "bloodymary"
	required_reagents = list("vodka" = 2, "tomatojuice" = 3, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = "gargleblaster"
	required_reagents = list("vodka" = 2, "gin" = 1, "whiskey" = 1, "cognac" = 1, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = "bravebull"
	required_reagents = list("tequilla" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tequilla_sunrise
	name = "Tequilla Sunrise"
	id = "tequillasunrise"
	result = "tequillasunrise"
	required_reagents = list("tequilla" = 2, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = "phoronspecial"
	required_reagents = list("rum" = 2, "vermouth" = 2, "phoron" = 2)
	result_amount = 6

/datum/chemical_reaction/drink/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = "beepskysmash"
	required_reagents = list("limejuice" = 1, "whiskey" = 1, "iron" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = "doctorsdelight"
	required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 2, "tricordrazine" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = "irishcream"
	required_reagents = list("whiskey" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = "manlydorf"
	required_reagents = list ("beer" = 1, "ale" = 2)
	result_amount = 3

/datum/chemical_reaction/drink/hooch
	name = "Hooch"
	id = "hooch"
	result = "hooch"
	required_reagents = list ("sugar" = 1, "moonshine" = 1, "fuel" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = "irishcoffee"
	required_reagents = list("irishcream" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/b52
	name = "B-52"
	id = "b52"
	result = "b52"
	required_reagents = list("irishcream" = 1, "kahlua" = 1, "cognac" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = "atomicbomb"
	required_reagents = list("b52" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drink/margarita
	name = "Margarita"
	id = "margarita"
	result = "margarita"
	required_reagents = list("tequilla" = 2, "limejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drink/icedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drink/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = "threemileisland"
	required_reagents = list("longislandicedtea" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drink/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = "whiskeysoda"
	required_reagents = list("whiskey" = 2, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = "blackrussian"
	required_reagents = list("vodka" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = "manhattan"
	required_reagents = list("whiskey" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = "manhattan_proj"
	required_reagents = list("manhattan" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drink/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = "vodkatonic"
	required_reagents = list("vodka" = 2, "tonic" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = "ginfizz"
	required_reagents = list("gin" = 1, "sodawater" = 1, "limejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = "bahama_mama"
	required_reagents = list("rum" = 2, "orangejuice" = 2, "limejuice" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/singulo
	name = "Singulo"
	id = "singulo"
	result = "singulo"
	required_reagents = list("vodka" = 5, "radium" = 1, "wine" = 5)
	result_amount = 10

/datum/chemical_reaction/drink/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = "alliescocktail"
	required_reagents = list("martini" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = "demonsblood"
	required_reagents = list("rum" = 3, "spacemountainwind" = 1, "blood" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/booger
	name = "Booger"
	id = "booger"
	result = "booger"
	required_reagents = list("cream" = 2, "banana" = 1, "rum" = 1, "watermelonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = "antifreeze"
	required_reagents = list("vodka" = 1, "cream" = 1, "ice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = "barefoot"
	required_reagents = list("berryjuice" = 1, "cream" = 1, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	result = "grapesoda"
	required_reagents = list("grapejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = "sbiten"
	required_reagents = list("mead" = 10, "capsaicin" = 1)
	result_amount = 10

/datum/chemical_reaction/drink/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = "red_mead"
	required_reagents = list("blood" = 1, "mead" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mead
	name = "Mead"
	id = "mead"
	result = "mead"
	required_reagents = list("sugar" = 1, "water" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 2

/datum/chemical_reaction/drink/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 10, "frostoil" = 1)
	result_amount = 10

/datum/chemical_reaction/drink/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 5, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/grog
	name = "Grog"
	id = "grog"
	result = "grog"
	required_reagents = list("rum" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	result = "soy_latte"
	required_reagents = list("coffee" = 1, "soymilk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	result = "cafe_latte"
	required_reagents = list("coffee" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_espresso
	name = "Freddo Espresso"
	id = "freddo_espresso"
	result = "freddo_espresso"
	required_reagents = list("espresso" = 1, "ice" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/caffe_americano
	name = "Caffe Americano"
	id = "caffe_americano"
	result = "caffe_americano"
	required_reagents = list("espresso" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/flat_white
	name = "Flat White"
	id = "flat_white"
	result = "flat_white"
	required_reagents = list("espresso" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/latte
	name = "Latte"
	id = "latte"
	result = "latte"
	required_reagents = list("flat_white" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cappuccino
	name = "Cappuccino"
	id = "cappuccino"
	result = "cappuccino"
	required_reagents = list("espresso" = 1, "cream" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/freddo_cappuccino
	name = "Freddo cappuccino"
	id = "freddo_cappuccino"
	result = "freddo_cappuccino"
	required_reagents = list("cappuccino" = 1, "ice" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/macchiato
	name = "Macchiato"
	id = "macchiato"
	result = "macchiato"
	required_reagents = list("cappuccino" = 1, "espresso" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mocacchino
	name = "Mocacchino"
	id = "mocacchino"
	result = "mocacchino"
	required_reagents = list("flat_white" = 1, "coco" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = "acidspit"
	required_reagents = list("sacid" = 1, "wine" = 5)
	result_amount = 6

/datum/chemical_reaction/drink/amasec
	name = "Amasec"
	id = "amasec"
	result = "amasec"
	required_reagents = list("iron" = 1, "wine" = 5, "vodka" = 5)
	result_amount = 10

/datum/chemical_reaction/drink/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	result = "changelingsting"
	required_reagents = list("screwdrivercocktail" = 1, "limejuice" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aloe
	name = "Aloe"
	id = "aloe"
	result = "aloe"
	required_reagents = list("cream" = 1, "whiskey" = 1, "watermelonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = "andalusia"
	required_reagents = list("rum" = 1, "whiskey" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = "neurotoxin"
	required_reagents = list("gargleblaster" = 1, "stoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = "snowwhite"
	required_reagents = list("beer" = 1, "lemon_lime" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = "irishcarbomb"
	required_reagents = list("ale" = 1, "irishcream" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	result = "syndicatebomb"
	required_reagents = list("beer" = 1, "whiskeycola" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = "erikasurprise"
	required_reagents = list("ale" = 2, "limejuice" = 1, "whiskey" = 1, "banana" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = "devilskiss"
	required_reagents = list("blood" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = "hippiesdelight"
	required_reagents = list("psilocybin" = 1, "gargleblaster" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = "bananahonk"
	required_reagents = list("banana" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/silencer
	name = "Silencer"
	id = "silencer"
	result = "silencer"
	required_reagents = list("nothing" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = "driestmartini"
	required_reagents = list("nothing" = 1, "gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/lemonade
	name = "Lemonade"
	id = "lemonade"
	result = "lemonade"
	required_reagents = list("lemonjuice" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/lemonade/pink
	name = "Pink Lemonade"
	id = "pinklemonade"
	result = "pinklemonade"
	required_reagents = list("lemonade" = 8, "grenadine" = 2)
	result_amount = 10


/datum/chemical_reaction/drink/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	result = "kiraspecial"
	required_reagents = list("orangejuice" = 1, "limejuice" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/brownstar
	name = "Brown Star"
	id = "brownstar"
	result = "brownstar"
	required_reagents = list("orangejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/milkshake
	name = "Milkshake"
	id = "milkshake"
	result = "milkshake"
	required_reagents = list("cream" = 1, "ice" = 2, "milk" = 2)
	result_amount = 5

/datum/chemical_reaction/drink/cmojito
	name = "Champagne Mojito"
	id = "cmojito"
	result = "cmojito"
	required_reagents = list("mintsyrup" = 1, "champagne" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/classic
	name = "The Classic"
	id = "classic"
	result = "classic"
	required_reagents = list("champagne" = 2, "bitters" = 1, "lemonjuice" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/corkpopper
	name = "Cork Popper"
	id = "corkpopper"
	result = "corkpopper"
	required_reagents = list("whiskey" = 1, "champagne" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/french75
	name = "French 75"
	id = "french75"
	result = "french75"
	required_reagents = list("champagne" = 2, "gin" = 1, "lemonjuice" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/muscmule
	name = "Muscovite Mule"
	id = "muscmule"
	result = "muscmule"
	required_reagents = list("vodka" = 1, "limejuice" = 1, "mintsyrup" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/omimosa
	name = "Orange Mimosa"
	id = "omimosa"
	result = "omimosa"
	required_reagents = list("orangejuice" = 1, "champagne" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/pinkgin
	name = "Pink Gin"
	id = "pinkgin"
	result = "pinkgin"
	required_reagents = list("gin" = 2, "bitters" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/pinkgintonic
	name = "Pink Gin and Tonic"
	id = "pinkgintonic"
	result = "pinkgintonic"
	required_reagents = list("pinkgin" = 2, "tonic" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/piratepunch
	name = "Pirate's Punch"
	id = "piratepunch"
	result = "piratepunch"
	required_reagents = list("rum" = 1, "lemonjuice" = 1, "mintsyrup" = 1, "grenadine" = 1, "bitters" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/planterpunch
	name = "Planter's Punch"
	id = "planterpunch"
	result = "planterpunch"
	required_reagents = list("rum" = 2, "orangejuice" = 1, "grenadine" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/ssroyale
	name = "Southside Royale"
	id = "ssroyale"
	result = "ssroyale"
	required_reagents = list("mintsyrup" = 1, "gin" = 1, "limejuice" = 1, "champagne" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/rewriter
	name = "Rewriter"
	id = "rewriter"
	result = "rewriter"
	required_reagents = list("spacemountainwind" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/suidream
	name = "Sui Dream"
	id = "suidream"
	result = "suidream"
	required_reagents = list("space_up" = 1, "bluecuracao" = 1, "melonliquor" = 1)
	result_amount = 3

//aurora's drinks

/datum/chemical_reaction/drink/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = "daiquiri"
	required_reagents = list("limejuice" = 1, "rum" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/icepick
	name = "Ice Pick"
	id = "icepick"
	result = "icepick"
	required_reagents = list("icetea" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/poussecafe
	name = "Pousse-Cafe"
	id = "poussecafe"
	result = "poussecafe"
	required_reagents = list("brandy" = 1, "chartreusegreen" = 1, "chartreuseyellow" = 1, "cremewhite" = 1, "grenadine" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = "mintjulep"
	required_reagents = list("water" = 1, "whiskey" = 1, "ice" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/johncollins
	name = "John Collins"
	id = "johncollins"
	result = "johncollins"
	required_reagents = list("whiskeysoda" = 2, "lemonjuice" = 1, "grenadine" = 1, "ice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/gimlet
	name = "Gimlet"
	id = "gimlet"
	result = "gimlet"
	required_reagents = list("limejuice" = 1, "gin" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/starsandstripes
	name = "Stars and Stripes"
	id = "starsandstripes"
	result = "starsandstripes"
	required_reagents = list("cream" = 1, "cremeyvette" = 1, "grenadine" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/metropolitan
	name = "Metropolitan"
	id = "metropolitan"
	result = "metropolitan"
	required_reagents = list("brandy" = 1, "vermouth" = 1, "grenadine" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/caruso
	name = "Caruso"
	id = "caruso"
	result = "caruso"
	required_reagents = list("martini" = 2, "cremewhite" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/aprilshower
	name = "April Shower"
	id = "aprilshower"
	result = "aprilshower"
	required_reagents = list("brandy" = 1, "chartreuseyellow" = 1, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/carthusiansazerac
	name = "Carthusian Sazerac"
	id = "carthusiansazerac"
	result = "carthusiansazerac"
	required_reagents = list("whiskey" = 1, "chartreusegreen" = 1, "grenadine" = 1, "absinthe" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/deweycocktail
	name = "Dewey Cocktail"
	id = "deweycocktail"
	result = "deweycocktail"
	required_reagents = list("cremeyvette" = 1, "gin" = 1, "grenadine" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/rustynail
	name = "Rusty Nail"
	id = "rustynail"
	result = "rustynail"
	required_reagents = list("whiskey" = 1, "drambuie" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = "oldfashioned"
	required_reagents = list("whiskeysoda" = 3, "bitters" = 1, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/blindrussian
	name = "Blind Russian"
	id = "blindrussian"
	result = "blindrussian"
	required_reagents = list("kahlua" = 1, "irishcream" = 1, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tallrussian
	name = "Tall Black Russian"
	id = "tallrussian"
	result = "tallrussian"
	required_reagents = list("blackrussian" = 1, "cola" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/cold_gate
	name = "Cold Gate"
	id = "cold_gate"
	result = "cold_gate"
	result_amount = 3
	required_reagents = list("mintsyrup" = 1, "ice" = 1, "toothpaste" = 1)

/datum/chemical_reaction/drink/waterfresh
	name = "Waterfresh"
	id = "waterfresh"
	result = "waterfresh"
	result_amount = 3
	required_reagents = list("tonic" = 1, "sodawater" = 1, "toothpaste" = 1)

/datum/chemical_reaction/drink/sedantian_firestorm
	name = "Sedantian Firestorm"
	id = "sedantian_firestorm"
	result = "sedantian_firestorm"
	result_amount = 2
	required_reagents = list("phoron" = 1, "toothpaste" = 1)

/datum/chemical_reaction/drink/kois_odyne
	name = "Kois Odyne"
	id = "kois_odyne"
	result = "kois_odyne"
	result_amount = 3
	required_reagents = list("tonic" = 1, "koispaste" = 1, "toothpaste" = 1)

/datum/chemical_reaction/adhomai_milk
	name = "Fermented Fatshouters Milk"
	id = "adhomai_milk"
	result = "adhomai_milk"
	required_reagents = list("fatshouter_milk" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 1

// Synnono Meme Drinks
//==============================
// Organized here because why not.

/datum/chemical_reaction/drink/badtouch
	name = "Bad Touch"
	id = "badtouch"
	result = "badtouch"
	required_reagents = list("vodka" = 2, "rum" = 2, "absinthe" = 1, "lemon_lime" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bluelagoon
	name = "Blue Lagoon"
	id = "bluelagooon"
	result = "bluelagoon"
	required_reagents = list("lemonade" = 3, "vodka" = 1, "bluecuracao" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/cherrytreefireball
	name = "Cherry Tree Fireball"
	id = "cherrytreefireball"
	result = "cherrytreefireball"
	required_reagents = list("lemonade" = 3, "fireball" = 1, "cherryjelly" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cobaltvelvet
	name = "Cobalt Velvet"
	id = "cobaltvelvet"
	result = "cobaltvelvet"
	required_reagents = list("champagne" = 3, "bluecuracao" = 2, "cola" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/fringeweaver
	name = "Fringe Weaver"
	id = "fringeweaver"
	result = "fringeweaver"
	required_reagents = list("ethanol" = 2, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/junglejuice
	name = "Jungle Juice"
	id = "junglejuice"
	result = "junglejuice"
	required_reagents = list("lemonjuice" = 1, "orangejuice" = 1, "lemon_lime" = 1, "vodka" = 1, "rum" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/marsarita
	name = "Marsarita"
	id = "marsarita"
	result = "marsarita"
	required_reagents = list("margarita" = 4, "bluecuracao" = 1, "capsaicin" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/meloncooler
	name = "Melon Cooler"
	id = "meloncooler"
	result = "meloncooler"
	required_reagents = list("watermelonjuice" = 2, "sodawater" = 2, "mintsyrup" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/midnightkiss
	name = "Midnight Kiss"
	id = "midnightkiss"
	result = "midnightkiss"
	required_reagents = list("champagne" = 3, "vodka" = 1, "bluecuracao" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/millionairesour
	name = "Millionaire Sour"
	id = "millionairesour"
	result = "millionairesour"
	required_reagents = list("spacemountainwind" = 3, "grenadine" = 1, "limejuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/olympusmons
	name = "Olympus Mons"
	id = "olympusmons"
	result = "olympusmons"
	required_reagents = list("blackrussian" = 1, "whiskey" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/europanail
	name = "Europa Nail"
	id = "europanail"
	result = "europanail"
	required_reagents = list("rustynail" = 2, "kahlua" = 2, "cream" = 2)
	result_amount = 6

/datum/chemical_reaction/drink/portsvilleminttea
	name = "Portsville Mint Tea"
	id = "portsvilleminttea"
	result = "portsvilleminttea"
	required_reagents = list("icetea" = 3, "berryjuice" = 1, "mintsyrup" = 1, "sugar" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/shirleytemple
	name = "Shirley Temple"
	id = "shirleytemple"
	result = "shirleytemple"
	required_reagents = list("space_up" = 4, "grenadine" = 2)
	result_amount = 6

/datum/chemical_reaction/drink/sugarrush
	name = "Sugar Rush"
	id = "sugarrush"
	result = "sugarrush"
	required_reagents = list("brownstar" = 4, "grenadine" = 1, "vodka" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sangria
	name = "Sangria"
	id = "sangria"
	result = "sangria"
	required_reagents = list("wine" = 3, "orangejuice" = 1, "lemonjuice" = 1, "brandy" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/bassline
	name = "Bassline"
	id = "bassline"
	result = "bassline"
	required_reagents = list("vodka" = 2, "bluecuracao" = 1, "limejuice" = 1, "grapejuice" = 2)
	result_amount = 6

/datum/chemical_reaction/drink/bluebird
	name = "Bluebird"
	id = "bluebird"
	result = "bluebird"
	required_reagents = list("gintonic" = 3, "bluecuracao" = 1)
	result_amount = 4

//Snowflake drinks
/datum/chemical_reaction/drink/dr_gibb_diet
	name = "Diet Dr. Gibb"
	id = "dr_gibb_diet"
	result = "dr_gibb_diet"
	required_reagents = list("dr_gibb" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/dr_daniels
	name = "Dr. Daniels"
	id = "dr_daniels"
	result = "dr_daniels"
	required_reagents = list("dr_gibb_diet" = 3, "whiskey" = 1, "honey" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/meatshake
	name = "Meatshake"
	id = "meatshake"
	result = "meatshake"
	required_reagents = list("cream" = 1, "protein" = 1,"water" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/crocodile_booze
	name = "Crocodile Guwan"
	id = "crocodile_booze"
	result = "crocodile_booze"
	required_reagents = list("sarezhiwine" = 5, "toxin" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/messa_mead
	name = "Messa's Mead"
	id = "messa_mead"
	result = "messa_mead"
	required_reagents = list("honey" = 1, "earthenrootjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/winter_offensive
	name = "Winter Offensive"
	id = "winter_offensive"
	result = "winter_offensive"
	required_reagents = list("ice" = 1, "victorygin" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/mars_coffee
	name = "Martian Special"
	id = "mars_coffee"
	result = "mars_coffee"
	required_reagents = list("coffee" = 4, "blackpepper" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mountain_marauder
	name = "Mountain Marauder"
	id = "mountain_marauder"
	result = "mountain_marauder"
	required_reagents = list("adhomai_milk" = 1, "victorygin" = 1)
	result_amount = 2

//Kaed's Unathi cocktails
//========

/datum/chemical_reaction/drink/moghesmargarita
	name = "Moghes Margarita"
	id = "moghesmargarita"
	result = "moghesmargarita"
	required_reagents = list("xuizijuice" = 2, "limejuice" = 3)
	result_amount = 5

/datum/chemical_reaction/drink/bahamalizard
	name = "Bahama Lizard"
	id = "bahamalizard"
	result = "bahamalizard"
	required_reagents = list("xuizijuice" = 2, "lemonjuice" = 2, "cream" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/cactuscreme
	name = "Cactus Creme"
	id = "cactuscreme"
	result = "cactuscreme"
	required_reagents = list("berryjuice" = 2, "cream" = 1, "xuizijuice" = 2)
	result_amount = 5

/datum/chemical_reaction/drink/lizardplegm
	name = "Lizard Phlegm"
	id = "lizardphlegm"
	result = "lizardphlegm"
	required_reagents = list("cream" = 2, "banana" = 1, "xuizijuice" = 1, "watermelonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cactustea
	name = "Cactus Tea"
	id = "cactustea"
	result = "cactustea"
	required_reagents = list("icetea" = 1, "xuizijuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/moghespolitan
	name = "Moghespolitan"
	id = "moghespolitan"
	result = "moghespolitan"
	required_reagents = list("sarezhiwine" = 2, "xuizijuice" = 1, "grenadine" = 5)
	result_amount = 5

/datum/chemical_reaction/drink/wastelandheat
	name = "Wasteland Heat"
	id = "wastelandheat"
	result = "wastelandheat"
	required_reagents = list("xuizijuice" = 10, "capsaicin" = 3)
	result_amount = 10

/datum/chemical_reaction/drink/sandgria
	name = "Sandgria"
	id = "sandgria"
	result = "sandgria"
	required_reagents = list("sarezhiwine" = 3, "orangejuice" = 1, "lemonjuice" = 1, "xuizijuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/contactwine
	name = "Contact Wine"
	id = "contactwine"
	result = "contactwine"
	required_reagents = list("xuizijuice" = 5, "radium" = 1, "sarezhiwine" = 5)
	result_amount = 10

/datum/chemical_reaction/drink/hereticblood
	name = "Heretics' Blood"
	id = "hereticblood"
	result = "hereticblood"
	required_reagents = list("xuizijuice" = 3, "spacemountainwind" = 1, "blood" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sandpit
	name = "Sandpit"
	id = "sandpit"
	result = "sandpit"
	required_reagents = list("xuizijuice" = 2, "orangejuice" = 2)
	result_amount = 4

/datum/chemical_reaction/drink/cactuscola
	name = "Cactus Cola"
	id = "cactuscola"
	result = "cactuscola"
	required_reagents = list("xuizijuice" = 2, "cola" = 2, "ice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/bloodwine
	name = "Bloodwine"
	id = "bloodwine"
	result = "bloodwine"
	required_reagents = list("blood" = 2, "sarezhiwine" = 3)
	result_amount = 5

/datum/chemical_reaction/pumpkinspice
	name = "Pumpkin Spice"
	id = "pumpkinspce"
	result = "pumpkinspice"
	mix_message = "The spice brightens up."
	required_reagents = list("spacespice" = 8, "pumpkinpulp" = 2)
	result_amount = 10

/datum/chemical_reaction/drink/psfrappe
	name = "Pumpkin Spice Frappe"
	id = "psfrappe"
	result = "psfrappe"
	required_reagents = list("icecoffee" = 6, "pumpkinspice" = 2, "cream" = 2)
	result_amount = 10

/datum/chemical_reaction/drink/pslatte
	name = "Pumpkin Spice Latte"
	id = "pslatte"
	result = "pslatte"
	required_reagents = list("coffee" = 6, "pumpkinspice" = 2, "cream" = 2)
	result_amount = 10

//Skrell drinks. Bring forth the culture.
//===========================================

/datum/chemical_reaction/drink/thirdincident
	name = "The Third Incident"
	id = "thirdincident"
	result = "thirdincident"
	required_reagents = list("egg" = 3, "bluecuracao" = 10, "grapejuice" = 10)
	result_amount = 20

/datum/chemical_reaction/drink/upsidedowncup
	name = "Upside-Down Cup"
	id = "upsidedowncup"
	result = "upsidedowncup"
	required_reagents = list("dr_gibb" = 3, "ice" = 1, "lemonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/cigarettelizard
	name = "Cigarette Lizard"
	id = "cigarettelizard"
	result = "cigarettelizard"
	required_reagents = list("limejuice" = 2, "sodawater" = 2, "mintsyrup" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sromshine
	name = "Sromshine"
	id = "sromshine"
	result = "sromshine"
	required_reagents = list("coffee" = 2, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/cbsc
	name = "Complex Bluespace Calculation"
	id = "cbsc"
	result = "cbsc"
	required_reagents = list("wine" = 4, "vodka" = 2, "sodawater" = 3, "radium" = 1 )
	result_amount = 10

/datum/chemical_reaction/drink/dynhot
	name = "Dyn Tea"
	id = "dynhot"
	result = "dynhot"
	required_reagents = list("dynjuice" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/drink/dyncold
	name = "Dyn Ice Tea"
	id = "dyncold"
	result = "dyncold"
	required_reagents = list("dynjuice" = 1, "ice" = 2, "sodawater" = 2)
	result_amount = 5

/datum/chemical_reaction/drink/algaesuprise
	name = "Pl'iuop Algae Surprise"
	id = "algaesuprise"
	result = "algaesuprise"
	required_reagents = list("virusfood" = 2, "banana" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/xrim
	name = "Xrim Garden"
	id = "xrim"
	result = "xrim"
	required_reagents = list("virusfood" = 2, "watermelonjuice" = 1, "orangejuice" = 1, "limejuice" = 1, "zora_cthur" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/rixulin_sundae
	name = "Rixulin Sundae"
	id = "rixulin_sundae"
	result = "rixulin_sundae"
	required_reagents = list("virusfood" = 3, "wulumunusha" = 1, "whitewine" = 2)
	result_amount = 6

//Tea and cider
//=======================

/datum/chemical_reaction/drink/cidercheap
	name = "Apple Cider Juice"
	id = "cidercheap"
	result = "cidercheap"
	required_reagents = list("applejuice" = 2, "sugar" = 1, "spacespice" = 1)
	result_amount = 4

/datum/chemical_reaction/cinnamonapplewhiskey
	name = "Cinnamon Apple Whiskey"
	id = "cinnamonapplewhiskey"
	result = "cinnamonapplewhiskey"
	required_reagents = list("ciderhot" = 3, "fireball" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/chailatte
	name = "Chai Latte"
	id = "chailatte"
	result = "chailatte"
	required_reagents = list("chaitea" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/chailatte/soy
	required_reagents = list("chaitea" = 1, "soymilk" = 1)

/datum/chemical_reaction/drink/coco_chaitea
	name = "Chocolate Chai"
	id = "coco_chaitea"
	result = "coco_chaitea"
	required_reagents = list("chaitea" = 2, "coco" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/coco_chailatte
	name = "Chocolate Chai Latte"
	id = "coco_chailatte"
	result = "coco_chailatte"
	required_reagents = list("coco_chaitea" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/coco_chailatte/soy
	required_reagents = list("coco_chaitea" = 1, "soymilk" = 1)

/datum/chemical_reaction/drink/cofftea
	name = "Cofftea"
	id = "cofftea"
	result = "cofftea"
	required_reagents = list("tea" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/bureacratea
	name = "Bureacratea"
	id = "bureacratea"
	result = "bureacratea"
	required_reagents = list("tea" = 1, "espresso" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/desert_tea
	name = "Desert Blossom Tea"
	id = "desert_tea"
	result = "desert_tea"
	required_reagents = list("greentea" = 2, "xuizijuice" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/drink/halfandhalf
	name = "Half and Half"
	id = "halfandhalf"
	result = "halfandhalf"
	required_reagents = list("icetea" = 1, "lemonade" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/heretic_tea
	name = "Heretics Tea"
	id = "heretic_tea"
	result = "heretic_tea"
	required_reagents = list("icetea" = 3, "blood" = 1, "spacemountainwind" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/kira_tea
	name = "Kira tea"
	id = "kira_tea"
	result = "kira_tea"
	required_reagents = list("icetea" = 1, "kiraspecial" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/librarian_special
	name = "Librarian Special"
	id = "librarian_special"
	result = "librarian_special"
	required_reagents = list("tea" = 2, "nothing" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/mars_tea
	name = "Martian Tea"
	id = "mars_tea"
	result = "mars_tea"
	required_reagents = list("tea" = 4, "blackpepper" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/mars_tea/green
	required_reagents = list("greentea" = 4, "blackpepper" = 1)

/datum/chemical_reaction/drink/mendell_tea
	name = "Mendell Afternoon Tea"
	id = "mendell_tea"
	result = "mendell_tea"
	required_reagents = list("greentea" = 4, "mintsyrup" = 1, "lemonjuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/berry_tea
	name = "Mixed Berry Tea"
	id = "berry_tea"
	result = "berry_tea"
	required_reagents = list("tea" = 2, "berryjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/berry_tea/green
	required_reagents = list("greentea" = 2, "berryjuice" = 1)

/datum/chemical_reaction/drink/pomegranate_icetea
	name = "Pomegranate Iced Tea"
	id = "pomegranate_icetea"
	result = "pomegranate_icetea"
	required_reagents = list("icetea" = 1, "grenadine" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/potatea
	name = "Potatea"
	id = "potatea"
	result = "potatea"
	required_reagents = list("tea" = 2, "potato" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea
	name = "Securitea"
	id = "securitea"
	result = "securitea"
	required_reagents = list("tea" = 2, "crayon_dust" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/securitea/red
	required_reagents = list("tea" = 2, "crayon_dust_red" = 1)
/datum/chemical_reaction/drink/securitea/orange
	required_reagents = list("tea" = 2, "crayon_dust_orange" = 1)
/datum/chemical_reaction/drink/securitea/yellow
	required_reagents = list("tea" = 2, "crayon_dust_yellow" = 1)
/datum/chemical_reaction/drink/securitea/green
	required_reagents = list("tea" = 2, "crayon_dust_green" = 1)
/datum/chemical_reaction/drink/securitea/blue
	required_reagents = list("tea" = 2, "crayon_dust_blue" = 1)
/datum/chemical_reaction/drink/securitea/purple
	required_reagents = list("tea" = 2, "crayon_dust_purple" = 1)
/datum/chemical_reaction/drink/securitea/grey
	required_reagents = list("tea" = 2, "crayon_dust_grey" = 1)
/datum/chemical_reaction/drink/securitea/brown
	required_reagents = list("tea" = 2, "crayon_dust_brown" = 1)

/datum/chemical_reaction/drink/sleepytime_tea
	name = "Sleepytime Tea"
	id = "sleepytime_tea"
	result = "sleepytime_tea"
	required_reagents = list("tea" = 5, "stoxin" = 1)
	result_amount = 6

/datum/chemical_reaction/drink/sleepytime_tea/green
	required_reagents = list("greentea" = 5, "stoxin" = 1)

/datum/chemical_reaction/drink/hakhma_tea
	name = "Spiced Hakhma Tea"
	id = "hakhma_tea"
	result = "hakhma_tea"
	required_reagents = list("tea" = 2, "beetle_milk" = 2, "spacespice" = 1)
	result_amount = 5

/datum/chemical_reaction/drink/sweet_tea
	name = "Sweet Tea"
	id = "sweet_tea"
	result = "sweet_tea"
	required_reagents = list("icetea" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/drink/teathpaste
	name = "Teathpaste"
	id = "teathpaste"
	result = "teathpaste"
	required_reagents = list("tea" = 2, "toothpaste" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/thewake
	name = "The Wake"
	id = "thewake"
	result = "thewake"
	required_reagents = list("dynjuice" = 1, "orangejuice" = 1, "tea" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tomatea
	name = "Tomatea"
	id = "tomatea"
	result = "tomatea"
	required_reagents = list("tea" = 2, "tomatojuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/trizkizki_tea
	name = "Trizkizki Tea"
	id = "trizkizki_tea"
	result = "trizkizki_tea"
	required_reagents = list("greentea" = 1, "sarezhiwine" = 1, "grenadine" = 1)
	result_amount = 3

/datum/chemical_reaction/drink/tropical_icetea
	name = "Tropical Iced Tea"
	id = "tropical_icetea"
	result = "tropical_icetea"
	required_reagents = list("icetea" = 3, "limejuice" = 1, "orangejuice" = 1, "watermelonjuice" = 1)
	result_amount = 6

//transmutation

/datum/chemical_reaction/transmutation_silver
	name = "Transmutation: Silver"
	id = "transmutation_silver"
	result = null
	required_reagents = list("iron" = 5, "copper" = 5)
	catalysts = list("philosopher_stone" = 1)
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
	required_reagents = list("aluminum" = 5, MATERIAL_SILVER = 5)
	catalysts = list("philosopher_stone" = 1)
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
	required_reagents = list("carbon" = 5, MATERIAL_GOLD = 5)
	catalysts = list("philosopher_stone" = 1)
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
	result = "ice"
	required_reagents = list("water" = 1)
	required_temperatures_max = list("water" = T0C)
	result_amount = 1
	mix_message = "The water freezes."
	reaction_sound = ""

/datum/chemical_reaction/ice_to_water
	name = "Ice to Water"
	id = "ice_to_water"
	result = "water"
	required_reagents = list("ice" = 1)
	required_temperatures_min = list("ice" = T0C + 25) // stop-gap fix to allow recipes requiring ice to be made without breaking the server with HALF_LIFE
	result_amount = 1
	mix_message = "The ice melts."
	reaction_sound = ""

/datum/chemical_reaction/phoron_salt
	name = "Phoron Salt"
	id = "phoron_salt"
	result = "phoron_salt"
	required_reagents = list("sodiumchloride" = 1, "phoron" = 2)
	required_temperatures_min = list("sodiumchloride" = 678, "phoron" = 73)
	required_temperatures_max = list("phoron" = 261)

	result_amount = 1

/datum/chemical_reaction/pyrosilicate
	name = "Pyrosilicate"
	id = "pyrosilicate"
	result = "pyrosilicate"
	result_amount = 4
	required_reagents = list("silicate" = 1, "sacid" = 1, "hydrazine" = 1, "iron" = 1)

/datum/chemical_reaction/cryosurfactant
	name = "Cryosurfactant"
	id = "cryosurfactant"
	result = "cryosurfactant"
	result_amount = 3
	required_reagents = list("surfactant" = 1, "ice" = 1, "sodium" = 1)

//WATER
/datum/chemical_reaction/cryosurfactant_cooling_water
	name = "Cryosurfactant Cooling Water"
	id = "cryosurfactant_cooling_water"
	result = null
	result_amount = 1
	required_reagents = list("cryosurfactant" = 1)
	inhibitors = list("pyrosilicate" = 1)
	catalysts = list("water" = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_water/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent("cryosurfactant")
	holder.add_thermal_energy(-created_volume*500)

//ICE
/datum/chemical_reaction/cryosurfactant_cooling_ice
	name = "Cryosurfactant Cooling Ice"
	id = "cryosurfactant_cooling_ice"
	result = null
	result_amount = 1
	required_reagents = list("cryosurfactant" = 1)
	inhibitors = list("pyrosilicate" = 1)
	catalysts = list("ice" = 1)
	mix_message = "The solution begins to freeze."

/datum/chemical_reaction/cryosurfactant_cooling_ice/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	holder.del_reagent("cryosurfactant")
	holder.add_thermal_energy(-created_volume*500)

/datum/chemical_reaction/pyrosilicate_heating
	name = "Pyrosilicate Heating"
	id = "pyrosilicate_heating"
	result = null
	result_amount = 1
	required_reagents = list("pyrosilicate" = 1)
	inhibitors = list("cryosurfactant" = 1)
	catalysts = list("sodiumchloride" = 1)

/datum/chemical_reaction/pyrosilicate_heating/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.del_reagent("pyrosilicate")
	holder.add_thermal_energy(created_volume*1000)

/datum/chemical_reaction/pyrosilicate_cryosurfactant
	name = "Pyrosilicate Cryosurfactant Reaction"
	id = "pyrosilicate_cryosurfactant"
	result = null
	required_reagents = list("pyrosilicate" = 1, "cryosurfactant" = 1)
	required_temperatures_min = list("pyrosilicate" = T0C, "cryosurfactant" = T0C) //Does not react when below these temperatures.
	result_amount = 1

/datum/chemical_reaction/pyrosilicate_cryosurfactant/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	if(created_volume)
		var/turf/simulated/floor/T = get_turf(holder.my_atom.loc)
		if(istype(T))
			T.assume_gas("oxygen", created_volume*10, (created_thermal_energy/created_volume) )

/datum/chemical_reaction/phoron_salt_fire
	name = "Phoron Salt Fire"
	id = "phoron_salt_fire"
	result = null
	result_amount = 1
	required_reagents = list("phoron_salt" = 1)
	required_temperatures_min = list("phoron_salt" = 134) //If it's above this temperature, then cause hellfire.
	mix_message = "The solution begins to vibrate!"

/datum/chemical_reaction/phoron_salt_fire/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	var/turf/location = get_turf(holder.my_atom)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("phoron", created_volume*2, created_thermal_energy / 25) //2 because there is 2 phoron in 1u of phoron salts
		addtimer(CALLBACK(target_tile, /turf/simulated/floor/.proc/hotspot_expose, 700, 400), 1)
	holder.del_reagent("phoron_salt")
	return

/datum/chemical_reaction/phoron_salt_coldfire
	name = "Phoron Salt Coldfire"
	id = "phoron_salt_coldfire"
	result = null
	result_amount = 1
	required_reagents = list("phoron_salt" = 1)
	required_temperatures_max = list("phoron_salt" = 113) //if it's below this temperature, then make a boom
	mix_message = "The solution begins to shrink!"

/datum/chemical_reaction/phoron_salt_coldfire/on_reaction(var/datum/reagents/holder, var/created_volume, var/created_thermal_energy)
	var/turf/location = get_turf(holder.my_atom)
	var/thermal_energy_mod = max(0,1 - (max(0,created_thermal_energy)/28000))
	var/volume_mod = min(1,created_volume/120)
	var/explosion_mod = 3 + (thermal_energy_mod*volume_mod*320)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(explosion_mod, location, 0, 0)
	e.start()
	holder.del_reagent("phoron_salt")
	return

/datum/chemical_reaction/mutone
	name = "Mutone"
	id = "mutone"
	result = "mutone"
	result_amount = 1
	required_reagents = list("phoron_salt" = 1, "mutagen" = 1)

/datum/chemical_reaction/plexium
	name = "Plexium"
	id = "plexium"
	result = "plexium"
	result_amount = 1
	required_reagents = list("phoron_salt" = 1, "alkysine" = 1)

/datum/chemical_reaction/venenum
	name = "Venenum"
	id = "venenum"
	result = "venenum"
	result_amount = 1
	required_reagents = list("phoron_salt" = 1, "ryetalyn" = 1)

/datum/chemical_reaction/rmt
	name = "RMT"
	id = "rmt"
	result = "rmt"
	result_amount = 1
	required_reagents = list("potassium" = 1, "norepinephrine" = 1)
