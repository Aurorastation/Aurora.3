//helper that ensures the reaction rate holds after iterating
//Ex. REACTION_RATE(0.3) means that 30% of the reagents will react each chemistry tick (~2 seconds by default).
#define REACTION_RATE(rate) (1.0 - (1.0-rate)**(1.0/PROCESS_REACTION_ITER))

//helper to define reaction rate in terms of half-life
//Ex.
//HALF_LIFE(0) -> Reaction completes immediately (default chems)
//HALF_LIFE(1) -> Half of the reagents react immediately, the rest over the following ticks.
//HALF_LIFE(2) -> Half of the reagents are consumed after 2 chemistry ticks.
//HALF_LIFE(3) -> Half of the reagents are consumed after 3 chemistry ticks.
#define HALF_LIFE(ticks) (ticks? 1.0 - (0.5)**(1.0/(ticks*PROCESS_REACTION_ITER)) : 1.0)

/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/list/required_reagents = list()
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
	for(var/reactant in required_reagents)
		var/amt_used = required_reagents[reactant] * reaction_progress
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced)

	return reaction_progress

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>\icon[container] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	id = REAGENT_INAPROVALINE
	result = REAGENT_INAPROVALINE
	required_reagents = list("acetone" = 1, "carbon" = 1, REAGENT_SUGAR = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = REAGENT_ANTI_TOXIN
	result = REAGENT_ANTI_TOXIN
	required_reagents = list("silicon" = 1, "potassium" = 1, REAGENT_AMMONIA = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	id = REAGENT_TRAMADOL
	result = REAGENT_TRAMADOL
	required_reagents = list("inaprovaline" = 1, "ethanol" = 1, REAGENT_ACETONE = 1)
	result_amount = 3

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	id = REAGENT_PARACETAMOL
	result = REAGENT_PARACETAMOL
	required_reagents = list("tramadol" = 1, "sugar" = 1, REAGENT_WATER = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	id = REAGENT_OXYCODONE
	result = REAGENT_OXYCODONE
	required_reagents = list("ethanol" = 1, REAGENT_TRAMADOL = 1)
	catalysts = list(REAGENT_PHORON = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = REAGENT_STERILIZINE
	result = REAGENT_STERILIZINE
	required_reagents = list("ethanol" = 1, "anti_toxin" = 1, REAGENT_HCLACID = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = REAGENT_SILICATE
	result = REAGENT_SILICATE
	required_reagents = list("aluminum" = 1, "silicon" = 1, REAGENT_ACETONE = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = REAGENT_MUTAGEN
	result = REAGENT_MUTAGEN
	required_reagents = list("radium" = 1, "phosphorus" = 1, REAGENT_HCLACID = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = REAGENT_THERMITE
	result = REAGENT_THERMITE
	required_reagents = list("aluminum" = 1, "iron" = 1, REAGENT_ACETONE = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = REAGENT_SPACE_DRUGS
	result = REAGENT_SPACE_DRUGS
	required_reagents = list("mercury" = 1, "sugar" = 1, REAGENT_LITHIUM = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = REAGENT_LUBE
	result = REAGENT_LUBE
	required_reagents = list("water" = 1, "silicon" = 1, REAGENT_ACETONE = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = REAGENT_PACID
	result = REAGENT_PACID
	required_reagents = list("sacid" = 1, "hclacid" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = REAGENT_SYNAPTIZINE
	result = REAGENT_SYNAPTIZINE
	required_reagents = list("sugar" = 1, "lithium" = 1, REAGENT_WATER = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = REAGENT_HYRONALIN
	result = REAGENT_HYRONALIN
	required_reagents = list("radium" = 1, REAGENT_ANTI_TOXIN = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = REAGENT_ARITHRAZINE
	result = REAGENT_ARITHRAZINE
	required_reagents = list("hyronalin" = 1, REAGENT_HYDRAZINE = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = REAGENT_IMPEDREZENE
	result = REAGENT_IMPEDREZENE
	required_reagents = list("mercury" = 1, "acetone" = 1, REAGENT_SUGAR = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = REAGENT_KELOTANE
	result = REAGENT_KELOTANE
	required_reagents = list("silicon" = 1, REAGENT_CARBON = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = REAGENT_PERIDAXON
	result = REAGENT_PERIDAXON
	required_reagents = list("bicaridine" = 2, REAGENT_CLONEXADONE = 2)
	catalysts = list(REAGENT_PHORON = 5)
	result_amount = 2

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = REAGENT_VIRUSFOOD
	result = REAGENT_VIRUSFOOD
	required_reagents = list("water" = 1, REAGENT_MILK = 1)
	result_amount = 5

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = REAGENT_LEPORAZINE
	result = REAGENT_LEPORAZINE
	required_reagents = list("silicon" = 1, REAGENT_COPPER = 1)
	catalysts = list(REAGENT_PHORON = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = REAGENT_CRYPTOBIOLIN
	result = REAGENT_CRYPTOBIOLIN
	required_reagents = list("potassium" = 1, "acetone" = 1, REAGENT_SUGAR = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = REAGENT_TRICORDRAZINE
	result = REAGENT_TRICORDRAZINE
	required_reagents = list("inaprovaline" = 1, REAGENT_ANTI_TOXIN = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = REAGENT_ALKYSINE
	result = REAGENT_ALKYSINE
	required_reagents = list("hclacid" = 1, "ammonia" = 1, REAGENT_ANTI_TOXIN = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = REAGENT_DEXALIN
	result = REAGENT_DEXALIN
	required_reagents = list("acetone" = 2, REAGENT_PHORON = 0.1)
	catalysts = list(REAGENT_PHORON = 1)
	inhibitors = list(REAGENT_WATER = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = REAGENT_DERMALINE
	result = REAGENT_DERMALINE
	required_reagents = list("acetone" = 1, "phosphorus" = 1, REAGENT_KELOTANE = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = REAGENT_DEXALINP
	result = REAGENT_DEXALINP
	required_reagents = list("dexalin" = 1, "carbon" = 1, REAGENT_IRON = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = REAGENT_BICARIDINE
	result = REAGENT_BICARIDINE
	required_reagents = list("inaprovaline" = 1, REAGENT_CARBON = 1)
	inhibitors = list(REAGENT_SUGAR = 1) // Messes up with inaprovaline
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = REAGENT_HYPERZINE
	result = REAGENT_HYPERZINE
	required_reagents = list("sugar" = 1, "phosphorus" = 1, REAGENT_SULFUR = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = REAGENT_RYETALYN
	result = REAGENT_RYETALYN
	required_reagents = list("arithrazine" = 1, REAGENT_CARBON = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = REAGENT_CRYOXADONE
	result = REAGENT_CRYOXADONE
	required_reagents = list("dexalin" = 1, "water" = 1, REAGENT_ACETONE = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = REAGENT_CLONEXADONE
	result = REAGENT_CLONEXADONE
	required_reagents = list("cryoxadone" = 1, "sodium" = 1, REAGENT_PHORON = 0.1)
	catalysts = list(REAGENT_PHORON = 5)
	result_amount = 2

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	id = REAGENT_SPACEACILLIN
	result = REAGENT_SPACEACILLIN
	required_reagents = list("cryptobiolin" = 1, REAGENT_INAPROVALINE = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "imidazoline"
	id = REAGENT_IMIDAZOLINE
	result = REAGENT_IMIDAZOLINE
	required_reagents = list("carbon" = 1, "hydrazine" = 1, REAGENT_ANTI_TOXIN = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = REAGENT_ETHYLREDOXRAZINE
	result = REAGENT_ETHYLREDOXRAZINE
	required_reagents = list("acetone" = 1, "anti_toxin" = 1, REAGENT_CARBON = 1)
	result_amount = 3

/datum/chemical_reaction/ipecac
	name = "Ipecac"
	id = REAGENT_IPECAC
	result = REAGENT_IPECAC
	required_reagents = list("hydrazine" = 1, "anti_toxin" = 1, REAGENT_ETHANOL = 1)
	result_amount = 3

/datum/chemical_reaction/adipemcina
	name = "Adipemcina"
	id = REAGENT_ADIPEMCINA
	result = REAGENT_ADIPEMCINA
	required_reagents = list("lithium" = 1, "anti_toxin" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	id = REAGENT_STOXIN
	result = REAGENT_STOXIN
	required_reagents = list("chloralhydrate" = 1, REAGENT_SUGAR = 4)
	inhibitors = list(REAGENT_PHOSPHORUS) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = REAGENT_CHLORALHYDRATE
	result = REAGENT_CHLORALHYDRATE
	required_reagents = list("ethanol" = 1, "hclacid" = 3, REAGENT_WATER = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = REAGENT_POTASSIUM_CHLORIDE
	result = REAGENT_POTASSIUM_CHLORIDE
	required_reagents = list("sodiumchloride" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = REAGENT_POTASSIUM_CHLOROPHORIDE
	result = REAGENT_POTASSIUM_CHLOROPHORIDE
	required_reagents = list("potassium_chloride" = 1, "phoron" = 1, REAGENT_CHLORALHYDRATE = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = REAGENT_ZOMBIEPOWDER
	result = REAGENT_ZOMBIEPOWDER
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, REAGENT_COPPER = 5)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = REAGENT_MINDBREAKER
	result = REAGENT_MINDBREAKER
	required_reagents = list("silicon" = 1, "hydrazine" = 1, REAGENT_ANTI_TOXIN = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = REAGENT_LIPOZINE
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, REAGENT_RADIUM = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	id = REAGENT_SURFACTANT
	result = REAGENT_SURFACTANT
	required_reagents = list("hydrazine" = 2, "carbon" = 2, REAGENT_SACID = 1)
	result_amount = 5

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = REAGENT_DIETHYLAMINE
	result = REAGENT_DIETHYLAMINE
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = REAGENT_CLEANER
	result = REAGENT_CLEANER
	required_reagents = list("ammonia" = 1, REAGENT_WATER = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = REAGENT_PLANTBGONE
	result = REAGENT_PLANTBGONE
	required_reagents = list("toxin" = 1, REAGENT_WATER = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = REAGENT_FOAMING_AGENT
	result = REAGENT_FOAMING_AGENT
	required_reagents = list("lithium" = 1, REAGENT_HYDRAZINE = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = REAGENT_GLYCEROL
	result = REAGENT_GLYCEROL
	required_reagents = list("cornoil" = 3, REAGENT_SACID = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = REAGENT_SODIUMCHLORIDE
	result = REAGENT_SODIUMCHLORIDE
	required_reagents = list("sodium" = 1, REAGENT_HCLACID = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = REAGENT_CONDENSEDCAPSAICIN
	result = REAGENT_CONDENSEDCAPSAICIN
	required_reagents = list(REAGENT_CAPSAICIN = 2)
	catalysts = list(REAGENT_PHORON = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = REAGENT_COOLANT
	result = REAGENT_COOLANT
	required_reagents = list("tungsten" = 1, "acetone" = 1, REAGENT_WATER = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = REAGENT_REZADONE
	result = REAGENT_REZADONE
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, REAGENT_COPPER = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = REAGENT_LEXORIN
	result = REAGENT_LEXORIN
	required_reagents = list("phoron" = 1, "hydrazine" = 1, REAGENT_AMMONIA = 1)
	result_amount = 3

//Mental Medication

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = REAGENT_METHYLPHENIDATE
	result = REAGENT_METHYLPHENIDATE
	required_reagents = list("mindbreaker" = 1, REAGENT_HYDRAZINE = 1)
	result_amount = 2

/datum/chemical_reaction/escitalopram
	name = "Escitalopram"
	id = REAGENT_ESCITALOPRAM
	result = REAGENT_ESCITALOPRAM
	required_reagents = list("mindbreaker" = 1, REAGENT_CARBON = 1)
	result_amount = 2

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = REAGENT_PAROXETINE
	result = REAGENT_PAROXETINE
	required_reagents = list("mindbreaker" = 1, "acetone" = 1, REAGENT_INAPROVALINE = 1)
	result_amount = 3

/datum/chemical_reaction/fluvoxamine
	name = "Fluvoxamine"
	id = REAGENT_FLUVOXAMINE
	result = REAGENT_FLUVOXAMINE
	required_reagents = list("mindbreaker" = 1, "iron" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 3

/datum/chemical_reaction/sertraline
	name = "Sertraline"
	id = REAGENT_SERTRALINE
	result = REAGENT_SERTRALINE
	required_reagents = list("mindbreaker" = 1, "aluminum" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = REAGENT_PAROXETINE
	result = REAGENT_PAROXETINE
	required_reagents = list("mindbreaker" = 1, "ammonia" = 1, REAGENT_COPPER = 1)
	result_amount = 3

/datum/chemical_reaction/duloxetine
	name = "Duloxetine"
	id = REAGENT_DULOXETINE
	result = REAGENT_DULOXETINE
	required_reagents = list("mindbreaker" = 1, "silicon" = 1, REAGENT_ETHANOL = 1)
	result_amount = 3

/datum/chemical_reaction/venlafaxine
	name = "Venlafaxine"
	id = REAGENT_VENLAFAXINE
	result = REAGENT_VENLAFAXINE
	required_reagents = list("mindbreaker" = 1, "sodium" = 1, REAGENT_TUNGSTEN = 1)
	result_amount = 3

/datum/chemical_reaction/risperidone
	name = "Risperidone"
	id = REAGENT_RISPERIDONE
	result = REAGENT_RISPERIDONE
	required_reagents = list("mindbreaker" = 1, "space_drugs" = 1, REAGENT_ETHANOL = 1)
	result_amount = 3

/datum/chemical_reaction/olanzapine
	name = "Olanzapine"
	id = REAGENT_OLANZAPINE
	result = REAGENT_OLANZAPINE
	required_reagents = list("mindbreaker" = 1, "space_drugs" = 1, REAGENT_SILICON = 1)
	result_amount = 3

/datum/chemical_reaction/hextrasenil
	name = "Hextrasenil"
	id = REAGENT_HEXTRASENIL
	result = REAGENT_HEXTRASENIL
	required_reagents = list("truthserum" = 1, "risperidone" = 1, REAGENT_MINDBREAKER = 1)
	result_amount = 3

/datum/chemical_reaction/trisyndicotin
	name = "Trisyndicotin"
	id = REAGENT_TRISYNDICOTIN
	result = REAGENT_TRISYNDICOTIN
	required_reagents = list("truthserum" = 1, "risperidone" = 1, REAGENT_SPACE_DRUGS = 1)
	result_amount = 3

/datum/chemical_reaction/truthserum
	name = "Truthserum"
	id = REAGENT_TRUTHSERUM
	result = REAGENT_TRUTHSERUM
	required_reagents = list("mindbreaker" = 1, "synaptizine" = 1, REAGENT_PHORON = 0.1)
	result_amount = 2

/datum/chemical_reaction/cardox
	name = "Cardox"
	id = REAGENT_CARDOX
	result = REAGENT_CARDOX
	required_reagents = list("platinum" = 1, "carbon" = 1, REAGENT_STERILIZINE = 1)
	result_amount = 3

/datum/chemical_reaction/cardox_removal
	name = "Cardox Removal"
	id = "cardox_removal"
	result = REAGENT_CARBON
	required_reagents = list("cardox" = 0.1, REAGENT_PHORON = 1)
	result_amount = 0

/datum/chemical_reaction/koispasteclean
	name = "Filtered K'ois"
	id = REAGENT_KOISPASTECLEAN
	result = REAGENT_KOISPASTECLEAN
	required_reagents = list("koispaste" = 2,REAGENT_CARDOX = 0.1)
	catalysts = list(REAGENT_CARDOX = 5)
	result_amount = 1

/* Solidification */

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	id = "solidphoron"
	result = null
	required_reagents = list("iron" = 5, "frostoil" = 5, REAGENT_PHORON = 20)
	result_amount = 1

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)
	return

/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list("pacid" = 1, REAGENT_PLASTICIDE = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, REAGENT_POTASSIUM = 1)
	result_amount = 2
	mix_message = null

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
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
	required_reagents = list("aluminum" = 1, "potassium" = 1, REAGENT_SULFUR = 1 )
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
	required_reagents = list("uranium" = 1, REAGENT_IRON = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
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
	id = REAGENT_NITROGLYCERIN
	result = REAGENT_NITROGLYCERIN
	required_reagents = list("glycerol" = 1, "pacid" = 1, REAGENT_SACID = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()

	holder.clear_reagents()
	return

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list("aluminum" = 1, "phoron" = 1, REAGENT_SACID = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("phoron", created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")
	return

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, REAGENT_PHOSPHORUS = 1)
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
	required_reagents = list("surfactant" = 1, REAGENT_WATER = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='warning'>The solution spews out foam!</span>"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, REAGENT_PACID = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='warning'>The solution spews out a metalic foam!</span>"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, REAGENT_PACID = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='warning'>The solution spews out a metalic foam!</span>"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	id = "red_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_RED = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#FE191A"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_ORANGE = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#FFBE4F"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_YELLOW = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#FDFE7D"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	id = "green_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_GREEN = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18A31A"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_BLUE = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247CFF"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_PURPLE = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#CC0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_GREY = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CRAYON_DUST_BROWN = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846F35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_BLOOD = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_MILK = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#F0F8FF"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_ORANGEJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#E78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_TOMATOJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_LIMEJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365E30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CARROTJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_BERRYJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_GRAPEJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_POISONBERRYJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_WATERMELONJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#B83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_LEMONJUICE = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#AFAF00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_BANANA = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#C3AF00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, "potatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_CARBON = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = REAGENT_PAINT
	required_reagents = list("plasticide" = 1, "water" = 3, REAGENT_ALUMINUM = 1)
	result_amount = 5

/datum/chemical_reaction/aluminum_paint/send_data()
	return "#F0F8FF"

/* Slime cores */

/datum/chemical_reaction/slime
	var/required = null

/datum/chemical_reaction/slime/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.Uses > 0)
			return ..()
	return 0

/datum/chemical_reaction/slime/on_reaction(var/datum/reagents/holder)
	var/obj/item/slime_extract/T = holder.my_atom
	T.Uses--
	if(T.Uses <= 0)
		T.visible_message("\icon[T]<span class='notice'>\The [T]'s power is consumed in the reaction.</span>")
		T.name = "used slime extract"
		T.desc = "This extract has been used up."

//Grey
/datum/chemical_reaction/slime/spawn
	name = "Slime Spawn"
	id = "m_spawn"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/spawn/on_reaction(var/datum/reagents/holder)
	holder.my_atom.visible_message("<span class='warning'>Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!</span>")
	var/mob/living/carbon/slime/S = new /mob/living/carbon/slime
	S.loc = get_turf(holder.my_atom)
	..()

/datum/chemical_reaction/slime/monkey
	name = "Slime Monkey"
	id = "m_monkey"
	result = null
	required_reagents = list(REAGENT_BLOOD = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	for(var/i = 1, i <= 3, i++)
		var /obj/item/weapon/reagent_containers/food/snacks/monkeycube/M = new /obj/item/weapon/reagent_containers/food/snacks/monkeycube
		M.loc = get_turf(holder.my_atom)
	..()

//Green
/datum/chemical_reaction/slime/mutate
	name = "Mutation Toxin"
	id = REAGENT_MUTATIONTOXIN
	result = REAGENT_MUTATIONTOXIN
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/green

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	id = "m_metal"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/datum/chemical_reaction/slime/metal/on_reaction(var/datum/reagents/holder)
	var/obj/item/stack/material/steel/M = new /obj/item/stack/material/steel
	M.amount = 15
	M.loc = get_turf(holder.my_atom)
	var/obj/item/stack/material/plasteel/P = new /obj/item/stack/material/plasteel
	P.amount = 5
	P.loc = get_turf(holder.my_atom)
	..()

//Gold - added back in
/datum/chemical_reaction/slime/crit
	name = "Slime Crit"
	id = "m_tele"
	result = null
	required_reagents = list(REAGENT_WATER = 5)
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
		/mob/living/simple_animal/hostile/greatwormking
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
		C.loc = get_turf(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))
	..()

//Silver
/datum/chemical_reaction/slime/bork
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/datum/chemical_reaction/slime/bork/on_reaction(var/datum/reagents/holder)
	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck(TRUE) < FLASH_PROTECTION_MODERATE)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))
	..()

//Blue
/datum/chemical_reaction/slime/frost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = REAGENT_FROSTOIL
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkblue
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/freeze/on_reaction(var/datum/reagents/holder)
	..()
	sleep(50)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
		M.bodytemperature -= 140
		M << "<span class='warning'>You feel a chill!</span>"

//Orange
/datum/chemical_reaction/slime/casp
	name = "Slime Capsaicin Oil"
	id = "m_capsaicinoil"
	result = REAGENT_CAPSAICIN
	required_reagents = list(REAGENT_BLOOD = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/fire/on_reaction(var/datum/reagents/holder)
	..()
	sleep(50)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0, location))
		target_tile.assume_gas("phoron", 25, 1400)
		spawn (0)
			target_tile.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slime/overload
	name = "Slime EMP"
	id = "m_emp"
	result = null
	required_reagents = list(REAGENT_BLOOD = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/overload/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	empulse(get_turf(holder.my_atom), 3, 7)

/datum/chemical_reaction/slime/cell
	name = "Slime Powercell"
	id = "m_cell"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/cell/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/obj/item/weapon/cell/slime/P = new /obj/item/weapon/cell/slime
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slime/glow
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list(REAGENT_WATER = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The contents of the slime core harden and begin to emit a warm, bright light."

/datum/chemical_reaction/slime/glow/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/obj/item/device/flashlight/slime/F = new /obj/item/device/flashlight/slime
	F.loc = get_turf(holder.my_atom)

//Purple
/datum/chemical_reaction/slime/psteroid
	name = "Slime Steroid"
	id = "m_steroid"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/obj/item/weapon/slimesteroid/P = new /obj/item/weapon/slimesteroid
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	id = "m_jam"
	result = REAGENT_SLIMEJELLY
	required_reagents = list(REAGENT_SUGAR = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple
/datum/chemical_reaction/slime/plasma
	name = "Slime Plasma"
	id = "m_plasma"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/plasma/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/stack/material/phoron/P = new /obj/item/stack/material/phoron
	P.amount = 10
	P.loc = get_turf(holder.my_atom)

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = REAGENT_GLYCEROL
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	id = "m_bloodlust"
	result = null
	required_reagents = list(REAGENT_BLOOD = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = 1
		slime.visible_message("<span class='warning'>The [slime] is driven into a frenzy!</span>")

//Pink
/datum/chemical_reaction/slime/ppotion
	name = "Slime Potion"
	id = "m_potion"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/ppotion/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/weapon/slimepotion/P = new /obj/item/weapon/slimepotion
	P.loc = get_turf(holder.my_atom)

//Black
/datum/chemical_reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	id = "mutationtoxin2"
	result = REAGENT_AMUTATIONTOXIN
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slime/explosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/explosion/on_reaction(var/datum/reagents/holder)
	..()
	sleep(50)
	explosion(get_turf(holder.my_atom), 1, 3, 6)

//Light Pink
/datum/chemical_reaction/slime/potion2
	name = "Slime Potion 2"
	id = "m_potion2"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(REAGENT_PHORON = 1)

/datum/chemical_reaction/slime/potion2/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/weapon/slimepotion2/P = new /obj/item/weapon/slimepotion2
	P.loc = get_turf(holder.my_atom)

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	id = "m_golem"
	result = null
	required_reagents = list(REAGENT_PHORON = 1)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine

/datum/chemical_reaction/slime/golem/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune
	Z.loc = get_turf(holder.my_atom)
	Z.announce_to_ghosts()







/*
====================
	Food
====================
*/

/datum/chemical_reaction/tofu
	name = "Tofu"
	id = REAGENT_TOFU
	result = null
	required_reagents = list(REAGENT_SOYMILK = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 1

/datum/chemical_reaction/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/tofu(location)
	return

/datum/chemical_reaction/chocolate_bar
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("soymilk" = 2, "coco" = 2, REAGENT_SUGAR = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/chocolate_bar2
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("milk" = 2, "coco" = 2, REAGENT_SUGAR = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	id = REAGENT_HOT_COCO
	result = REAGENT_HOT_COCO
	required_reagents = list("water" = 5, REAGENT_COCO = 1)
	result_amount = 5

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	id = REAGENT_SOYSAUCE
	result = REAGENT_SOYSAUCE
	required_reagents = list("soymilk" = 4, REAGENT_SACID = 1)
	result_amount = 5

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	id = REAGENT_KETCHUP
	result = REAGENT_KETCHUP
	required_reagents = list("tomatojuice" = 2, "water" = 1, REAGENT_SUGAR = 1)
	result_amount = 4

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list(REAGENT_MILK = 40)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 1

/datum/chemical_reaction/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel(location)
	return

/datum/chemical_reaction/meatball
	name = "Meatball"
	id = "meatball"
	result = null
	required_reagents = list("protein" = 3, REAGENT_FLOUR = 5)
	result_amount = 3

/datum/chemical_reaction/meatball/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(location)
	return

/datum/chemical_reaction/dough
	name = "Dough"
	id = "dough"
	result = null
	required_reagents = list("egg" = 3, REAGENT_FLOUR = 10)
	inhibitors = list("water" = 1, REAGENT_BEER = 1) //To prevent it messing with batter recipes
	result_amount = 1

/datum/chemical_reaction/dough/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)
	return

/datum/chemical_reaction/syntiflesh
	name = "Syntiflesh"
	id = "syntiflesh"
	result = null
	required_reagents = list("blood" = 5, REAGENT_CLONEXADONE = 1)
	result_amount = 1

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = REAGENT_HOT_RAMEN
	result = REAGENT_HOT_RAMEN
	required_reagents = list("water" = 1, REAGENT_DRY_RAMEN = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = REAGENT_HELL_RAMEN
	result = REAGENT_HELL_RAMEN
	required_reagents = list("capsaicin" = 1, REAGENT_HOT_RAMEN = 6)
	result_amount = 6

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = REAGENT_BATTER
	result = REAGENT_BATTER
	required_reagents = list("egg" = 3, "flour" = 10, "water" = 5, REAGENT_SODIUMCHLORIDE = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = REAGENT_BEERBATTER
	result = REAGENT_BEERBATTER
	required_reagents = list("egg" = 3, "flour" = 10, "beer" = 5, REAGENT_SODIUMCHLORIDE = 2)
	result_amount = 20

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = REAGENT_BROWNIEMIX
	result = REAGENT_BROWNIEMIX
	required_reagents = list("flour" = 5, "coco" = 5, REAGENT_SUGAR = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("cream" = 20, REAGENT_SODIUMCHLORIDE = 1)
	result_amount = 1

/datum/chemical_reaction/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/spreads/butter(location)
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

/datum/chemical_reaction/goldschlager
	name = "Goldschlager"
	id = REAGENT_GOLDSCHLAGER
	result = REAGENT_GOLDSCHLAGER
	required_reagents = list("vodka" = 10, REAGENT_GOLD = 1)
	result_amount = 10

/datum/chemical_reaction/patron
	name = "Patron"
	id = REAGENT_PATRON
	result = REAGENT_PATRON
	required_reagents = list("tequilla" = 10, REAGENT_SILVER = 1)
	result_amount = 10

/datum/chemical_reaction/bilk
	name = "Bilk"
	id = REAGENT_BILK
	result = REAGENT_BILK
	required_reagents = list("milk" = 1, REAGENT_BEER = 1)
	result_amount = 2

/datum/chemical_reaction/icetea
	name = "Iced Tea"
	id = REAGENT_ICETEA
	result = REAGENT_ICETEA
	required_reagents = list("ice" = 1, REAGENT_TEA = 2)
	result_amount = 3

/datum/chemical_reaction/icecoffee
	name = "Iced Coffee"
	id = REAGENT_ICECOFFEE
	result = REAGENT_ICECOFFEE
	required_reagents = list("ice" = 1, REAGENT_COFFEE = 2)
	result_amount = 3

/datum/chemical_reaction/nuka_cola
	name = "Nuka Cola"
	id = REAGENT_NUKA_COLA
	result = REAGENT_NUKA_COLA
	required_reagents = list("uranium" = 1, REAGENT_COLA = 5)
	result_amount = 5

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	id = REAGENT_MOONSHINE
	result = REAGENT_MOONSHINE
	required_reagents = list(REAGENT_NUTRIMENT = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/butanol
	name = "Butanol"
	id = REAGENT_BUTANOL
	result = REAGENT_BUTANOL
	required_reagents = list("cornoil" = 10, REAGENT_SUGAR = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 5

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	id = REAGENT_GRENADINE
	result = REAGENT_GRENADINE
	required_reagents = list(REAGENT_BERRYJUICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	id = REAGENT_WINE
	result = REAGENT_WINE
	required_reagents = list(REAGENT_GRAPEJUICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	id = REAGENT_PWINE
	result = REAGENT_PWINE
	required_reagents = list(REAGENT_POISONBERRYJUICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	id = REAGENT_MELONLIQUOR
	result = REAGENT_MELONLIQUOR
	required_reagents = list(REAGENT_WATERMELONJUICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	id = REAGENT_BLUECURACAO
	result = REAGENT_BLUECURACAO
	required_reagents = list(REAGENT_ORANGEJUICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = REAGENT_BEER
	required_reagents = list(REAGENT_CORNOIL = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/vodka
	name = "Vodka"
	id = REAGENT_VODKA
	result = REAGENT_VODKA
	required_reagents = list(REAGENT_POTATO = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	id = REAGENT_SAKE
	result = REAGENT_SAKE
	required_reagents = list(REAGENT_RICE = 10)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	id = REAGENT_KAHLUA
	result = REAGENT_KAHLUA
	required_reagents = list("coffee" = 5, REAGENT_SUGAR = 5)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 5

/datum/chemical_reaction/gin_tonic
	name = "Gin and Tonic"
	id = REAGENT_GINTONIC
	result = REAGENT_GINTONIC
	required_reagents = list("gin" = 2, REAGENT_TONIC = 1)
	result_amount = 3

/datum/chemical_reaction/cuba_libre
	name = "Cuba Libre"
	id = REAGENT_CUBALIBRE
	result = REAGENT_CUBALIBRE
	required_reagents = list("rum" = 2, REAGENT_COLA = 1)
	result_amount = 3

/datum/chemical_reaction/martini
	name = "Classic Martini"
	id = REAGENT_MARTINI
	result = REAGENT_MARTINI
	required_reagents = list("gin" = 2, REAGENT_VERMOUTH = 1)
	result_amount = 3

/datum/chemical_reaction/vodkamartini
	name = "Vodka Martini"
	id = REAGENT_VODKAMARTINI
	result = REAGENT_VODKAMARTINI
	required_reagents = list("vodka" = 2, REAGENT_VERMOUTH = 1)
	result_amount = 3

/datum/chemical_reaction/white_russian
	name = "White Russian"
	id = REAGENT_WHITERUSSIAN
	result = REAGENT_WHITERUSSIAN
	required_reagents = list("blackrussian" = 2, REAGENT_CREAM = 1)
	result_amount = 3

/datum/chemical_reaction/whiskey_cola
	name = "Whiskey Cola"
	id = REAGENT_WHISKEYCOLA
	result = REAGENT_WHISKEYCOLA
	required_reagents = list("whiskey" = 2, REAGENT_COLA = 1)
	result_amount = 3

/datum/chemical_reaction/screwdriver
	name = "Screwdriver"
	id = REAGENT_SCREWDRIVERCOCKTAIL
	result = REAGENT_SCREWDRIVERCOCKTAIL
	required_reagents = list("vodka" = 2, REAGENT_ORANGEJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/bloody_mary
	name = "Bloody Mary"
	id = REAGENT_BLOODYMARY
	result = REAGENT_BLOODYMARY
	required_reagents = list("vodka" = 2, "tomatojuice" = 3, REAGENT_LIMEJUICE = 1)
	result_amount = 6

/datum/chemical_reaction/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = REAGENT_GARGLEBLASTER
	result = REAGENT_GARGLEBLASTER
	required_reagents = list("vodka" = 2, "gin" = 1, "whiskey" = 1, "cognac" = 1, REAGENT_LIMEJUICE = 1)
	result_amount = 6

/datum/chemical_reaction/brave_bull
	name = "Brave Bull"
	id = REAGENT_BRAVEBULL
	result = REAGENT_BRAVEBULL
	required_reagents = list("tequilla" = 2, REAGENT_KAHLUA = 1)
	result_amount = 3

/datum/chemical_reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	id = REAGENT_TEQUILLASUNRISE
	result = REAGENT_TEQUILLASUNRISE
	required_reagents = list("tequilla" = 2, REAGENT_ORANGEJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/phoron_special
	name = "Toxins Special"
	id = REAGENT_PHORONSPECIAL
	result = REAGENT_PHORONSPECIAL
	required_reagents = list("rum" = 2, "vermouth" = 2, REAGENT_PHORON = 2)
	result_amount = 6

/datum/chemical_reaction/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = REAGENT_BEEPSKYSMASH
	required_reagents = list("limejuice" = 1, "whiskey" = 1, REAGENT_IRON = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = REAGENT_DOCTORSDELIGHT
	required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 2, REAGENT_TRICORDRAZINE = 1)
	result_amount = 6

/datum/chemical_reaction/irish_cream
	name = "Irish Cream"
	id = REAGENT_IRISHCREAM
	result = REAGENT_IRISHCREAM
	required_reagents = list("whiskey" = 2, REAGENT_CREAM = 1)
	result_amount = 3

/datum/chemical_reaction/manly_dorf
	name = "The Manly Dorf"
	id = REAGENT_MANLYDORF
	result = REAGENT_MANLYDORF
	required_reagents = list ("beer" = 1, "ale" = 2)
	result_amount = 3

/datum/chemical_reaction/hooch
	name = "Hooch"
	id = REAGENT_HOOCH
	result = REAGENT_HOOCH
	required_reagents = list ("sugar" = 1, "ethanol" = 2, "fuel" = 1)
	result_amount = 3

/datum/chemical_reaction/irish_coffee
	name = "Irish Coffee"
	id = REAGENT_IRISHCOFFEE
	result = REAGENT_IRISHCOFFEE
	required_reagents = list("irishcream" = 1, REAGENT_COFFEE = 1)
	result_amount = 2

/datum/chemical_reaction/b52
	name = "B-52"
	id = "b52"
	result = "b52"
	required_reagents = list("irishcream" = 1, "kahlua" = 1, REAGENT_COGNAC = 1)
	result_amount = 3

/datum/chemical_reaction/atomicbomb
	name = "Atomic Bomb"
	id = REAGENT_ATOMICBOMB
	result = REAGENT_ATOMICBOMB
	required_reagents = list("b52" = 10, REAGENT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/margarita
	name = "Margarita"
	id = REAGENT_MARGARITA
	result = REAGENT_MARGARITA
	required_reagents = list("tequilla" = 2, REAGENT_LIMEJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/longislandicedtea
	name = "Long Island Iced Tea"
	id = REAGENT_LONGISLANDICEDTEA
	result = REAGENT_LONGISLANDICEDTEA
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, REAGENT_CUBALIBRE = 3)
	result_amount = 6

/datum/chemical_reaction/icedtea
	name = "Long Island Iced Tea"
	id = REAGENT_LONGISLANDICEDTEA
	result = REAGENT_LONGISLANDICEDTEA
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, REAGENT_CUBALIBRE = 3)
	result_amount = 6

/datum/chemical_reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	id = REAGENT_THREEMILEISLAND
	result = REAGENT_THREEMILEISLAND
	required_reagents = list("longislandicedtea" = 10, REAGENT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/whiskeysoda
	name = "Whiskey Soda"
	id = REAGENT_WHISKEYSODA
	result = REAGENT_WHISKEYSODA
	required_reagents = list("whiskey" = 2, REAGENT_SODAWATER = 1)
	result_amount = 3

/datum/chemical_reaction/black_russian
	name = "Black Russian"
	id = REAGENT_BLACKRUSSIAN
	result = REAGENT_BLACKRUSSIAN
	required_reagents = list("vodka" = 2, REAGENT_KAHLUA = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan
	name = "Manhattan"
	id = REAGENT_MANHATTAN
	result = REAGENT_MANHATTAN
	required_reagents = list("whiskey" = 2, REAGENT_VERMOUTH = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan_proj
	name = "Manhattan Project"
	id = REAGENT_MANHATTAN_PROJ
	result = REAGENT_MANHATTAN_PROJ
	required_reagents = list("manhattan" = 10, REAGENT_URANIUM = 1)
	result_amount = 10

/datum/chemical_reaction/vodka_tonic
	name = "Vodka and Tonic"
	id = REAGENT_VODKATONIC
	result = REAGENT_VODKATONIC
	required_reagents = list("vodka" = 2, REAGENT_TONIC = 1)
	result_amount = 3

/datum/chemical_reaction/gin_fizz
	name = "Gin Fizz"
	id = REAGENT_GINFIZZ
	result = REAGENT_GINFIZZ
	required_reagents = list("gin" = 1, "sodawater" = 1, REAGENT_LIMEJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/bahama_mama
	name = "Bahama mama"
	id = REAGENT_BAHAMA_MAMA
	result = REAGENT_BAHAMA_MAMA
	required_reagents = list("rum" = 2, "orangejuice" = 2, "limejuice" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/singulo
	name = "Singulo"
	id = REAGENT_SINGULO
	result = REAGENT_SINGULO
	required_reagents = list("vodka" = 5, "radium" = 1, REAGENT_WINE = 5)
	result_amount = 10

/datum/chemical_reaction/alliescocktail
	name = "Allies Cocktail"
	id = REAGENT_ALLIESCOCKTAIL
	result = REAGENT_ALLIESCOCKTAIL
	required_reagents = list("martini" = 1, REAGENT_VODKA = 1)
	result_amount = 2

/datum/chemical_reaction/demonsblood
	name = "Demons Blood"
	id = REAGENT_DEMONSBLOOD
	result = REAGENT_DEMONSBLOOD
	required_reagents = list("rum" = 3, "spacemountainwind" = 1, "blood" = 1, REAGENT_DR_GIBB = 1)
	result_amount = 6

/datum/chemical_reaction/booger
	name = "Booger"
	id = REAGENT_BOOGER
	result = REAGENT_BOOGER
	required_reagents = list("cream" = 2, "banana" = 1, "rum" = 1, REAGENT_WATERMELONJUICE = 1)
	result_amount = 5

/datum/chemical_reaction/antifreeze
	name = "Anti-freeze"
	id = REAGENT_ANTIFREEZE
	result = REAGENT_ANTIFREEZE
	required_reagents = list("vodka" = 1, "cream" = 1, REAGENT_ICE = 1)
	result_amount = 3

/datum/chemical_reaction/barefoot
	name = "Barefoot"
	id = REAGENT_BAREFOOT
	result = REAGENT_BAREFOOT
	required_reagents = list("berryjuice" = 1, "cream" = 1, REAGENT_VERMOUTH = 1)
	result_amount = 3

/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	id = REAGENT_GRAPESODA
	result = REAGENT_GRAPESODA
	required_reagents = list("grapejuice" = 2, REAGENT_COLA = 1)
	result_amount = 3

/datum/chemical_reaction/sbiten
	name = "Sbiten"
	id = REAGENT_SBITEN
	result = REAGENT_SBITEN
	required_reagents = list("mead" = 10, REAGENT_CAPSAICIN = 1)
	result_amount = 10

/datum/chemical_reaction/red_mead
	name = "Red Mead"
	id = REAGENT_RED_MEAD
	result = REAGENT_RED_MEAD
	required_reagents = list("blood" = 1, REAGENT_MEAD = 1)
	result_amount = 2

/datum/chemical_reaction/mead
	name = "Mead"
	id = REAGENT_MEAD
	result = REAGENT_MEAD
	required_reagents = list("sugar" = 1, REAGENT_WATER = 1)
	catalysts = list(REAGENT_ENZYME = 5)
	result_amount = 2

/datum/chemical_reaction/iced_beer
	name = "Iced Beer"
	id = REAGENT_ICED_BEER
	result = REAGENT_ICED_BEER
	required_reagents = list("beer" = 10, REAGENT_FROSTOIL = 1)
	result_amount = 10

/datum/chemical_reaction/iced_beer2
	name = "Iced Beer"
	id = REAGENT_ICED_BEER
	result = REAGENT_ICED_BEER
	required_reagents = list("beer" = 5, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/grog
	name = "Grog"
	id = REAGENT_GROG
	result = REAGENT_GROG
	required_reagents = list("rum" = 1, REAGENT_WATER = 1)
	result_amount = 2

/datum/chemical_reaction/soy_latte
	name = "Soy Latte"
	id = REAGENT_SOY_LATTE
	result = REAGENT_SOY_LATTE
	required_reagents = list("coffee" = 1, REAGENT_SOYMILK = 1)
	result_amount = 2

/datum/chemical_reaction/cafe_latte
	name = "Cafe Latte"
	id = REAGENT_CAFE_LATTE
	result = REAGENT_CAFE_LATTE
	required_reagents = list("coffee" = 1, REAGENT_MILK = 1)
	result_amount = 2

/datum/chemical_reaction/freddo_espresso
	name = "Freddo Espresso"
	id = REAGENT_FREDDO_ESPRESSO
	result = REAGENT_FREDDO_ESPRESSO
	required_reagents = list("espresso" = 1, REAGENT_ICE = 1)
	result_amount = 2

/datum/chemical_reaction/caffe_americano
	name = "Caffe Americano"
	id = REAGENT_CAFFE_AMERICANO
	result = REAGENT_CAFFE_AMERICANO
	required_reagents = list("espresso" = 1, REAGENT_WATER = 1)
	result_amount = 2

/datum/chemical_reaction/flat_white
	name = "Flat White"
	id = REAGENT_FLAT_WHITE
	result = REAGENT_FLAT_WHITE
	required_reagents = list("espresso" = 1, REAGENT_MILK = 1)
	result_amount = 2

/datum/chemical_reaction/latte
	name = "Latte"
	id = REAGENT_LATTE
	result = REAGENT_LATTE
	required_reagents = list("flat_white" = 1, REAGENT_MILK = 1)
	result_amount = 2

/datum/chemical_reaction/cappuccino
	name = "Cappuccino"
	id = REAGENT_CAPPUCCINO
	result = REAGENT_CAPPUCCINO
	required_reagents = list("espresso" = 1, REAGENT_CREAM = 1)
	result_amount = 2

/datum/chemical_reaction/freddo_cappuccino
	name = "Freddo cappuccino"
	id = REAGENT_FREDDO_CAPPUCCINO
	result = REAGENT_FREDDO_CAPPUCCINO
	required_reagents = list("cappuccino" = 1, REAGENT_ICE = 1)
	result_amount = 2

/datum/chemical_reaction/macchiato
	name = "Macchiato"
	id = REAGENT_MACCHIATO
	result = REAGENT_MACCHIATO
	required_reagents = list("cappuccino" = 1, REAGENT_ESPRESSO = 1)
	result_amount = 2

/datum/chemical_reaction/mocacchino
	name = "Mocacchino"
	id = REAGENT_MOCACCHINO
	result = REAGENT_MOCACCHINO
	required_reagents = list("flat_white" = 1, REAGENT_COCO = 1)
	result_amount = 2

/datum/chemical_reaction/acidspit
	name = "Acid Spit"
	id = REAGENT_ACIDSPIT
	result = REAGENT_ACIDSPIT
	required_reagents = list("sacid" = 1, REAGENT_WINE = 5)
	result_amount = 6

/datum/chemical_reaction/amasec
	name = "Amasec"
	id = REAGENT_AMASEC
	result = REAGENT_AMASEC
	required_reagents = list("iron" = 1, "wine" = 5, REAGENT_VODKA = 5)
	result_amount = 10

/datum/chemical_reaction/changelingsting
	name = "Changeling Sting"
	id = REAGENT_CHANGELINGSTING
	result = REAGENT_CHANGELINGSTING
	required_reagents = list("screwdrivercocktail" = 1, "limejuice" = 1, REAGENT_LEMONJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/aloe
	name = "Aloe"
	id = REAGENT_ALOE
	result = REAGENT_ALOE
	required_reagents = list("cream" = 1, "whiskey" = 1, REAGENT_WATERMELONJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/andalusia
	name = "Andalusia"
	id = REAGENT_ANDALUSIA
	result = REAGENT_ANDALUSIA
	required_reagents = list("rum" = 1, "whiskey" = 1, REAGENT_LEMONJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	id = REAGENT_NEUROTOXIN
	result = REAGENT_NEUROTOXIN
	required_reagents = list("gargleblaster" = 1, REAGENT_STOXIN = 1)
	result_amount = 2

/datum/chemical_reaction/snowwhite
	name = "Snow White"
	id = REAGENT_SNOWWHITE
	result = REAGENT_SNOWWHITE
	required_reagents = list("beer" = 1, REAGENT_LEMON_LIME = 1)
	result_amount = 2

/datum/chemical_reaction/irishcarbomb
	name = "Irish Car Bomb"
	id = REAGENT_IRISHCARBOMB
	result = REAGENT_IRISHCARBOMB
	required_reagents = list("ale" = 1, REAGENT_IRISHCREAM = 1)
	result_amount = 2

/datum/chemical_reaction/syndicatebomb
	name = "Syndicate Bomb"
	id = REAGENT_SYNDICATEBOMB
	result = REAGENT_SYNDICATEBOMB
	required_reagents = list("beer" = 1, REAGENT_WHISKEYCOLA = 1)
	result_amount = 2

/datum/chemical_reaction/erikasurprise
	name = "Erika Surprise"
	id = REAGENT_ERIKASURPRISE
	result = REAGENT_ERIKASURPRISE
	required_reagents = list("ale" = 2, "limejuice" = 1, "whiskey" = 1, "banana" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/devilskiss
	name = "Devils Kiss"
	id = REAGENT_DEVILSKISS
	result = REAGENT_DEVILSKISS
	required_reagents = list("blood" = 1, "kahlua" = 1, REAGENT_RUM = 1)
	result_amount = 3

/datum/chemical_reaction/hippiesdelight
	name = "Hippies Delight"
	id = REAGENT_HIPPIESDELIGHT
	result = REAGENT_HIPPIESDELIGHT
	required_reagents = list("psilocybin" = 1, REAGENT_GARGLEBLASTER = 1)
	result_amount = 2

/datum/chemical_reaction/bananahonk
	name = "Banana Honk"
	id = REAGENT_BANANAHONK
	result = REAGENT_BANANAHONK
	required_reagents = list("banana" = 1, "cream" = 1, REAGENT_SUGAR = 1)
	result_amount = 3

/datum/chemical_reaction/silencer
	name = "Silencer"
	id = REAGENT_SILENCER
	result = REAGENT_SILENCER
	required_reagents = list("nothing" = 1, "cream" = 1, REAGENT_SUGAR = 1)
	result_amount = 3

/datum/chemical_reaction/driestmartini
	name = "Driest Martini"
	id = REAGENT_DRIESTMARTINI
	result = REAGENT_DRIESTMARTINI
	required_reagents = list("nothing" = 1, REAGENT_GIN = 1)
	result_amount = 2

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	id = REAGENT_LEMONADE
	result = REAGENT_LEMONADE
	required_reagents = list("lemonjuice" = 1, "sugar" = 1, REAGENT_WATER = 1)
	result_amount = 3

/datum/chemical_reaction/kiraspecial
	name = "Kira Special"
	id = REAGENT_KIRASPECIAL
	result = REAGENT_KIRASPECIAL
	required_reagents = list("orangejuice" = 1, "limejuice" = 1, REAGENT_SODAWATER = 1)
	result_amount = 3

/datum/chemical_reaction/brownstar
	name = "Brown Star"
	id = REAGENT_BROWNSTAR
	result = REAGENT_BROWNSTAR
	required_reagents = list("orangejuice" = 2, REAGENT_COLA = 1)
	result_amount = 3

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	id = REAGENT_MILKSHAKE
	result = REAGENT_MILKSHAKE
	required_reagents = list("cream" = 1, "ice" = 2, REAGENT_MILK = 2)
	result_amount = 5

/datum/chemical_reaction/cmojito
	name = "Champagne Mojito"
	id = REAGENT_CMOJITO
	result = REAGENT_CMOJITO
	required_reagents = list("mintsyrup" = 1, "champagne" = 1, REAGENT_RUM = 1)
	result_amount = 3

/datum/chemical_reaction/classic
	name = "The Classic"
	id = REAGENT_CLASSIC
	result = REAGENT_CLASSIC
	required_reagents = list("champagne" = 2, "bitters" = 1, REAGENT_LEMONJUICE = 1)
	result_amount = 4

/datum/chemical_reaction/corkpopper
	name = "Cork Popper"
	id = REAGENT_CORKPOPPER
	result = REAGENT_CORKPOPPER
	required_reagents = list("whiskey" = 1, "champagne" = 1, REAGENT_LEMONJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/french75
	name = "French 75"
	id = "french75"
	result = "french75"
	required_reagents = list("champagne" = 2, "gin" = 1, REAGENT_LEMONJUICE = 1)
	result_amount = 4

/datum/chemical_reaction/muscmule
	name = "Muscovite Mule"
	id = REAGENT_MUSCMULE
	result = REAGENT_MUSCMULE
	required_reagents = list("vodka" = 1, "limejuice" = 1, REAGENT_MINTSYRUP = 1)
	result_amount = 3

/datum/chemical_reaction/omimosa
	name = "Orange Mimosa"
	id = REAGENT_OMIMOSA
	result = REAGENT_OMIMOSA
	required_reagents = list("orangejuice" = 1, REAGENT_CHAMPAGNE = 1)
	result_amount = 2

/datum/chemical_reaction/pinkgin
	name = "Pink Gin"
	id = REAGENT_PINKGIN
	result = REAGENT_PINKGIN
	required_reagents = list("gin" = 2, REAGENT_BITTERS = 1)
	result_amount = 3

/datum/chemical_reaction/pinkgintonic
	name = "Pink Gin and Tonic"
	id = REAGENT_PINKGINTONIC
	result = REAGENT_PINKGINTONIC
	required_reagents = list("pinkgin" = 2, REAGENT_TONIC = 1)
	result_amount = 3

/datum/chemical_reaction/piratepunch
	name = "Pirate's Punch"
	id = REAGENT_PIRATEPUNCH
	result = REAGENT_PIRATEPUNCH
	required_reagents = list("rum" = 1, "lemonjuice" = 1, "mintsyrup" = 1, "grenadine" = 1, REAGENT_BITTERS = 1)
	result_amount = 5

/datum/chemical_reaction/planterpunch
	name = "Planter's Punch"
	id = REAGENT_PLANTERPUNCH
	result = REAGENT_PLANTERPUNCH
	required_reagents = list("rum" = 2, "orangejuice" = 1, REAGENT_GRENADINE = 1)
	result_amount = 4

/datum/chemical_reaction/ssroyale
	name = "Southside Royale"
	id = REAGENT_SSROYALE
	result = REAGENT_SSROYALE
	required_reagents = list("mintsyrup" = 1, "gin" = 1, "limejuice" = 1, REAGENT_CHAMPAGNE = 1)
	result_amount = 4

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	id = REAGENT_REWRITER
	result = REAGENT_REWRITER
	required_reagents = list("spacemountainwind" = 1, REAGENT_COFFEE = 1)
	result_amount = 2

/datum/chemical_reaction/suidream
	name = "Sui Dream"
	id = REAGENT_SUIDREAM
	result = REAGENT_SUIDREAM
	required_reagents = list("space_up" = 1, "bluecuracao" = 1, REAGENT_MELONLIQUOR = 1)
	result_amount = 3

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = REAGENT_LUMINOL
	result = REAGENT_LUMINOL
	required_reagents = list("hydrazine" = 2, "carbon" = 2, REAGENT_AMMONIA = 2)
	result_amount = 6

//aurora's drinks

/datum/chemical_reaction/daiquiri
	name = "Daiquiri"
	id = REAGENT_DAIQUIRI
	result = REAGENT_DAIQUIRI
	required_reagents = list("limejuice" = 1, REAGENT_RUM = 1)
	result_amount = 2

/datum/chemical_reaction/icepick
	name = "Ice Pick"
	id = REAGENT_ICEPICK
	result = REAGENT_ICEPICK
	required_reagents = list("icetea" = 1, REAGENT_VODKA = 1)
	result_amount = 2

/datum/chemical_reaction/poussecafe
	name = "Pousse-Cafe"
	id = REAGENT_POUSSECAFE
	result = REAGENT_POUSSECAFE
	required_reagents = list("brandy" = 1, "chartreusegreen" = 1, "chartreuseyellow" = 1, "cremewhite" = 1, REAGENT_GRENADINE = 1)
	result_amount = 5

/datum/chemical_reaction/mintjulep
	name = "Mint Julep"
	id = REAGENT_MINTJULEP
	result = REAGENT_MINTJULEP
	required_reagents = list("water" = 1, "whiskey" = 1, REAGENT_ICE = 1)
	result_amount = 2

/datum/chemical_reaction/johncollins
	name = "John Collins"
	id = REAGENT_JOHNCOLLINS
	result = REAGENT_JOHNCOLLINS
	required_reagents = list("whiskeysoda" = 2, "lemonjuice" = 1, "grenadine" = 1, REAGENT_ICE = 1)
	result_amount = 5

/datum/chemical_reaction/gimlet
	name = "Gimlet"
	id = REAGENT_GIMLET
	result = REAGENT_GIMLET
	required_reagents = list("limejuice" = 1, "gin" = 1, REAGENT_SODAWATER = 1)
	result_amount = 3

/datum/chemical_reaction/starsandstripes
	name = "Stars and Stripes"
	id = REAGENT_STARSANDSTRIPES
	result = REAGENT_STARSANDSTRIPES
	required_reagents = list("cream" = 1, "cremeyvette" = 1, REAGENT_GRENADINE = 1)
	result_amount = 3

/datum/chemical_reaction/metropolitan
	name = "Metropolitan"
	id = REAGENT_METROPOLITAN
	result = REAGENT_METROPOLITAN
	required_reagents = list("brandy" = 1, "vermouth" = 1, REAGENT_GRENADINE = 1)
	result_amount = 3

/datum/chemical_reaction/caruso
	name = "Caruso"
	id = REAGENT_CARUSO
	result = REAGENT_CARUSO
	required_reagents = list("martini" = 2, REAGENT_CREMEWHITE = 1)
	result_amount = 3

/datum/chemical_reaction/aprilshower
	name = "April Shower"
	id = REAGENT_APRILSHOWER
	result = REAGENT_APRILSHOWER
	required_reagents = list("brandy" = 1, "chartreuseyellow" = 1, REAGENT_ORANGEJUICE = 1)
	result_amount = 3

/datum/chemical_reaction/carthusiansazerac
	name = "Carthusian Sazerac"
	id = REAGENT_CARTHUSIANSAZERAC
	result = REAGENT_CARTHUSIANSAZERAC
	required_reagents = list("whiskey" = 1, "chartreusegreen" = 1, "grenadine" = 1, REAGENT_ABSINTHE = 1)
	result_amount = 4

/datum/chemical_reaction/deweycocktail
	name = "Dewey Cocktail"
	id = REAGENT_DEWEYCOCKTAIL
	result = REAGENT_DEWEYCOCKTAIL
	required_reagents = list("cremeyvette" = 1, "gin" = 1, REAGENT_GRENADINE = 1)
	result_amount = 3

/datum/chemical_reaction/rustynail
	name = "Rusty Nail"
	id = REAGENT_RUSTYNAIL
	result = REAGENT_RUSTYNAIL
	required_reagents = list("whiskey" = 1, REAGENT_DRAMBUIE = 1)
	result_amount = 2

/datum/chemical_reaction/oldfashioned
	name = "Old Fashioned"
	id = REAGENT_OLDFASHIONED
	result = REAGENT_OLDFASHIONED
	required_reagents = list("whiskeysoda" = 3, "bitters" = 1, REAGENT_SUGAR = 1)
	result_amount = 5

/datum/chemical_reaction/blindrussian
	name = "Blind Russian"
	id = REAGENT_BLINDRUSSIAN
	result = REAGENT_BLINDRUSSIAN
	required_reagents = list("kahlua" = 1, "irishcream" = 1, REAGENT_CREAM = 1)
	result_amount = 3

/datum/chemical_reaction/tallrussian
	name = "Tall Black Russian"
	id = REAGENT_TALLRUSSIAN
	result = REAGENT_TALLRUSSIAN
	required_reagents = list("blackrussian" = 1, REAGENT_COLA = 1)
	result_amount = 2

// Synnono Meme Drinks
//==============================
// Organized here because why not.

/datum/chemical_reaction/badtouch
	name = "Bad Touch"
	id = REAGENT_BADTOUCH
	result = REAGENT_BADTOUCH
	required_reagents = list("vodka" = 2, "rum" = 2, "absinthe" = 1, REAGENT_LEMON_LIME = 1)
	result_amount = 6

/datum/chemical_reaction/bluelagoon
	name = "Blue Lagoon"
	id = "bluelagooon"
	result = REAGENT_BLUELAGOON
	required_reagents = list("lemonade" = 3, "vodka" = 1, "bluecuracao" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/cherrytreefireball
	name = "Cherry Tree Fireball"
	id = "cherrytreefirebal		l"
	result = REAGENT_CHERRYTREEFIREBALL
	required_reagents = list("lemonade" = 3, "fireball" = 1, "cherryjelly" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/cobaltvelvet
	name = "Cobalt Velvet"
	id = REAGENT_COBALTVELVET
	result = REAGENT_COBALTVELVET
	required_reagents = list("champagne" = 3, "bluecuracao" = 2, REAGENT_COLA = 1)
	result_amount = 6

/datum/chemical_reaction/fringeweaver
	name = "Fringe Weaver"
	id = REAGENT_FRINGEWEAVER
	result = REAGENT_FRINGEWEAVER
	required_reagents = list("ethanol" = 2, REAGENT_SUGAR = 1)
	result_amount = 3

/datum/chemical_reaction/junglejuice
	name = "Jungle Juice"
	id = REAGENT_JUNGLEJUICE
	result = REAGENT_JUNGLEJUICE
	required_reagents = list("lemonjuice" = 1, "orangejuice" = 1, "lemon_lime" = 1, "vodka" = 1, REAGENT_RUM = 1)
	result_amount = 5

/datum/chemical_reaction/marsarita
	name = "Marsarita"
	id = REAGENT_MARSARITA
	result = REAGENT_MARSARITA
	required_reagents = list("margarita" = 4, "bluecuracao" = 1, REAGENT_CAPSAICIN = 1)
	result_amount = 6

/datum/chemical_reaction/meloncooler
	name = "Melon Cooler"
	id = REAGENT_MELONCOOLER
	result = REAGENT_MELONCOOLER
	required_reagents = list("watermelonjuice" = 2, "sodawater" = 2, "mintsyrup" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/midnightkiss
	name = "Midnight Kiss"
	id = REAGENT_MIDNIGHTKISS
	result = REAGENT_MIDNIGHTKISS
	required_reagents = list("champagne" = 3, "vodka" = 1, REAGENT_BLUECURACAO = 1)
	result_amount = 5

/datum/chemical_reaction/millionairesour
	name = "Millionaire Sour"
	id = REAGENT_MILLIONAIRESOUR
	result = REAGENT_MILLIONAIRESOUR
	required_reagents = list("spacemountainwind" = 3, "grenadine" = 1, REAGENT_LIMEJUICE = 1)
	result_amount = 5

/datum/chemical_reaction/olympusmons
	name = "Olympus Mons"
	id = REAGENT_OLYMPUSMONS
	result = REAGENT_OLYMPUSMONS
	required_reagents = list("blackrussian" = 1, "whiskey" = 1, REAGENT_RUM = 1)
	result_amount = 3

/datum/chemical_reaction/europanail
	name = "Europa Nail"
	id = REAGENT_EUROPANAIL
	result = REAGENT_EUROPANAIL
	required_reagents = list("rustynail" = 2, "kahlua" = 2, REAGENT_CREAM = 2)
	result_amount = 6

/datum/chemical_reaction/portsvilleminttea
	name = "Portsville Mint Tea"
	id = REAGENT_PORTSVILLEMINTTEA
	result = REAGENT_PORTSVILLEMINTTEA
	required_reagents = list("icetea" = 3, "berryjuice" = 1, "mintsyrup" = 1, REAGENT_SUGAR = 1)
	result_amount = 6

/datum/chemical_reaction/shirleytemple
	name = "Shirley Temple"
	id = REAGENT_SHIRLEYTEMPLE
	result = REAGENT_SHIRLEYTEMPLE
	required_reagents = list("space_up" = 4, REAGENT_GRENADINE = 2)
	result_amount = 6

/datum/chemical_reaction/sugarrush
	name = "Sugar Rush"
	id = REAGENT_SUGARRUSH
	result = REAGENT_SUGARRUSH
	required_reagents = list("brownstar" = 4, "grenadine" = 1, REAGENT_VODKA = 1)
	result_amount = 6

/datum/chemical_reaction/sangria
	name = "Sangria"
	id = REAGENT_SANGRIA
	result = REAGENT_SANGRIA
	required_reagents = list("wine" = 3, "orangejuice" = 1, "lemonjuice" = 1, REAGENT_BRANDY = 1)
	result_amount = 6

/datum/chemical_reaction/bassline
	name = "Bassline"
	id = REAGENT_BASSLINE
	result = REAGENT_BASSLINE
	required_reagents = list("vodka" = 2, "bluecuracao" = 1, "limejuice" = 1, REAGENT_GRAPEJUICE = 2)
	result_amount = 6

/datum/chemical_reaction/bluebird
	name = "Bluebird"
	id = REAGENT_BLUEBIRD
	result = REAGENT_BLUEBIRD
	required_reagents = list("gintonic" = 3, REAGENT_BLUECURACAO = 1)
	result_amount = 4

//Snowflake drinks
/datum/chemical_reaction/dr_gibb_diet
	name = "Diet Dr. Gibb"
	id = REAGENT_DR_GIBB_DIET
	result = REAGENT_DR_GIBB_DIET
	required_reagents = list("dr_gibb" = 1, REAGENT_WATER = 1)
	result_amount = 2

/datum/chemical_reaction/dr_daniels
	name = "Dr. Daniels"
	id = REAGENT_DR_DANIELS
	result = REAGENT_DR_DANIELS
	required_reagents = list("dr_gibb_diet" = 3, "whiskey" = 1, REAGENT_HONEY = 1)
	result_amount = 5

/datum/chemical_reaction/meatshake
	name = "Meatshake"
	id = REAGENT_MEATSHAKE
	result = REAGENT_MEATSHAKE
	required_reagents = list("cream" = 1, "protein" = 1,REAGENT_WATER = 1)
	result_amount = 3

/datum/chemical_reaction/crocodile_booze
	name = "Crocodile Guwan"
	id = REAGENT_CROCODILE_BOOZE
	result = REAGENT_CROCODILE_BOOZE
	required_reagents = list("sarezhiwine" = 5, REAGENT_TOXIN = 1)
	result_amount = 6

//Kaed's Unathi cocktails
//========

/datum/chemical_reaction/moghesmargarita
	name = "Moghes Margarita"
	id = REAGENT_MOGHESMARGARITA
	result = REAGENT_MOGHESMARGARITA
	required_reagents = list("xuizijuice" = 2, REAGENT_LIMEJUICE = 3)
	result_amount = 5

/datum/chemical_reaction/bahamalizard
	name = "Bahama Lizard"
	id = REAGENT_BAHAMALIZARD
	result = REAGENT_BAHAMALIZARD
	required_reagents = list("xuizijuice" = 2, "orangejuice" = 2, "limejuice" = 1, REAGENT_ICE = 1)
	result_amount = 6

/datum/chemical_reaction/cactuscreme
	name = "Cactus Creme"
	id = REAGENT_CACTUSCREME
	result = REAGENT_CACTUSCREME
	required_reagents = list("berryjuice" = 2, "cream" = 1, REAGENT_XUIZIJUICE = 2)
	result_amount = 5

/datum/chemical_reaction/lizardplegm
	name = "Lizard Phlegm"
	id = REAGENT_LIZARDPHLEGM
	result = REAGENT_LIZARDPHLEGM
	required_reagents = list("cream" = 2, "banana" = 1, "xuizijuice" = 1, REAGENT_WATERMELONJUICE = 1)
	result_amount = 5

/datum/chemical_reaction/cactustea
	name = "Cactus Tea"
	id = REAGENT_CACTUSTEA
	result = REAGENT_CACTUSTEA
	required_reagents = list("icetea" = 1, REAGENT_XUIZIJUICE = 1)
	result_amount = 2

/datum/chemical_reaction/moghespolitan
	name = "Moghespolitan"
	id = REAGENT_MOGHESPOLITAN
	result = REAGENT_MOGHESPOLITAN
	required_reagents = list("sarezhiwine" = 2, "xuizijuice" = 1, REAGENT_GRENADINE = 5)
	result_amount = 5

/datum/chemical_reaction/wastelandheat
	name = "Wasteland Heat"
	id = REAGENT_WASTELANDHEAT
	result = REAGENT_WASTELANDHEAT
	required_reagents = list("xuizi" = 10, REAGENT_CAPSAICIN = 3)
	result_amount = 10

/datum/chemical_reaction/sandgria
	name = "Sandgria"
	id = REAGENT_SANDGRIA
	result = REAGENT_SANDGRIA
	required_reagents = list("sarezhiwine" = 3, "orangejuice" = 1, "lemonjuice" = 1, REAGENT_XUIZIJUICE = 1)
	result_amount = 6

/datum/chemical_reaction/contactwine
	name = "Contact Wine"
	id = REAGENT_CONTACTWINE
	result = REAGENT_CONTACTWINE
	required_reagents = list("xuizijuice" = 5, "radium" = 1, REAGENT_SAREZHIWINE = 5)
	result_amount = 10

/datum/chemical_reaction/hereticblood
	name = "Heretics' Blood"
	id = REAGENT_HERETICBLOOD
	result = REAGENT_HERETICBLOOD
	required_reagents = list("xuizijuice" = 3, "spacemountainwind" = 1, "blood" = 1, REAGENT_DR_GIBB = 1)
	result_amount = 6

/datum/chemical_reaction/sandpit
	name = "Sandpit"
	id = REAGENT_SANDPIT
	result = REAGENT_SANDPIT
	required_reagents = list("xuizijuice" = 2, REAGENT_ORANGEJUICE = 2)
	result_amount = 4

/datum/chemical_reaction/cactuscola
	name = "Cactus Cola"
	id = REAGENT_CACTUSCOLA
	result = REAGENT_CACTUSCOLA
	required_reagents = list("xuizijuice" = 2, "cola" = 2, REAGENT_ICE = 1)
	result_amount = 5

/datum/chemical_reaction/bloodwine
	name = "Bloodwine"
	id = REAGENT_BLOODWINE
	result = REAGENT_BLOODWINE
	required_reagents = list("blood" = 2, REAGENT_SAREZHIWINE = 3)
	result_amount = 5

//transmutation

/datum/chemical_reaction/transmutation_silver
	name = "Transmutation: Silver"
	id = "transmutation_silver"
	result = null
	required_reagents = list("iron" = 5, REAGENT_COPPER = 5)
	catalysts = list(REAGENT_PHILOSOPHER_STONE = 1)
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
	required_reagents = list("aluminum" = 5, REAGENT_SILVER = 5)
	catalysts = list(REAGENT_PHILOSOPHER_STONE = 1)
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
	required_reagents = list("carbon" = 5, REAGENT_GOLD = 5)
	catalysts = list(REAGENT_PHILOSOPHER_STONE = 1)
	result_amount = 1

/datum/chemical_reaction/transmutation_diamond/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/material/diamond(location)
	return
