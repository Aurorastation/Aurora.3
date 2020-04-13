var/datum/controller/subsystem/chemistry/SSchemistry

/datum/controller/subsystem/chemistry
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_MISC_FIRST

	var/list/active_holders = list()
	var/list/chemical_reactions
	var/list/chemical_reactions_clean = list()
	var/list/datum/reagent/chemical_reagents

	var/tmp/list/processing_holders = list()

/datum/controller/subsystem/chemistry/proc/has_valid_specific_heat(var/datum/reagent/R) //Used for unit tests. Same as check_specific_heat but returns a boolean instead.

	if(R.specific_heat > 0)
		return TRUE

	if(chemical_reagents[R.id].specific_heat > 0) //Don't think this will happen but you never know.
		return TRUE

	var/datum/chemical_reaction/recipe = find_recipe_by_result(R.id)
	if(recipe)
		for(var/chem in recipe.required_reagents)
			if(!has_valid_specific_heat(chemical_reagents[chem]))
				log_ss("chemistry", "ERROR: [recipe.type] has an improper recipe!")
				return R.fallback_specific_heat > 0

		return TRUE
	else
		if(R.fallback_specific_heat > 0)
			return TRUE
		else
			log_ss("chemistry", "ERROR: [R.type] does not have a valid specific heat ([R.specific_heat]) or a valid fallback specific heat ([R.fallback_specific_heat]) assigned!")
			return FALSE

/datum/controller/subsystem/chemistry/proc/check_specific_heat(var/datum/reagent/R)

	if(R.specific_heat > 0)
		return R.specific_heat

	if(chemical_reagents[R.id].specific_heat > 0) //Don't think this will happen but you never know.
		return chemical_reagents[R.id].specific_heat

	var/datum/chemical_reaction/recipe = find_recipe_by_result(R.id)
	if(recipe)
		var/final_heat = 0
		var/result_amount = recipe.result_amount
		for(var/chem in recipe.required_reagents)
			var/chem_specific_heat = check_specific_heat(chemical_reagents[chem])
			if(chem_specific_heat <= 0)
				log_ss("chemistry", "ERROR: [R.type] does not have a specific heat value set, and there is no associated recipe for it! Please fix this by giving it a specific_heat value!")
				final_heat = 0
				break
			final_heat += chem_specific_heat * (recipe.required_reagents[chem]/result_amount)

		if(final_heat > 0)
			chemical_reagents[R.id].specific_heat = final_heat
			return final_heat

	if(R.fallback_specific_heat > 0)
		chemical_reagents[R.id].specific_heat = R.fallback_specific_heat
		return R.fallback_specific_heat

	log_ss("chemistry", "ERROR: [R.type] does not have a specific heat value set, and there is no associated recipe for it! Please fix this by giving it a specific_heat value!")
	chemical_reagents[R.id].specific_heat = 1
	return 1

/datum/controller/subsystem/chemistry/proc/find_recipe_by_result(var/result_id)
	for(var/key in chemical_reactions_clean)
		var/datum/chemical_reaction/CR = chemical_reactions_clean[key]
		if(CR.result == result_id && CR.result_amount > 0)
			return CR

/datum/controller/subsystem/chemistry/stat_entry()
	..("AH:[active_holders.len]")

/datum/controller/subsystem/chemistry/New()
	NEW_SS_GLOBAL(SSchemistry)

/datum/controller/subsystem/chemistry/Initialize()
	initialize_chemical_reagents()
	initialize_chemical_reactions()
	var/pre_secret_len = chemical_reactions.len
	log_ss("chemistry", "Found [chemical_reagents.len] reagents, [pre_secret_len] reactions.")
	load_secret_chemicals()
	log_ss("chemistry", "Loaded [chemical_reactions.len - pre_secret_len] secret reactions.")
	..()

/datum/controller/subsystem/chemistry/fire(resumed = FALSE)
	if (!resumed)
		processing_holders = active_holders.Copy()

	while (processing_holders.len)
		var/datum/reagents/holder = processing_holders[processing_holders.len]
		processing_holders.len--

		if (QDELETED(holder))
			active_holders -= holder
			log_debug("SSchemistry: QDELETED holder found in processing list!")
			if (MC_TICK_CHECK)
				return
			continue

		if (!holder.process_reactions())
			active_holders -= holder

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/chemistry/proc/mark_for_update(var/datum/reagents/holder)
	if (holder in active_holders)
		return

	if (holder.process_reactions())
		active_holders += holder

/datum/controller/subsystem/chemistry/Recover()
	src.active_holders = SSchemistry.active_holders
	src.chemical_reactions = SSchemistry.chemical_reactions
	src.chemical_reagents = SSchemistry.chemical_reagents

/datum/controller/subsystem/chemistry/proc/load_secret_chemicals()
	var/list/chemconfig = list()
	try
		chemconfig = json_decode(return_file_text("config/secretchem.json"))
	catch(var/exception/e)
		log_debug("SSchemistry: Warning: Could not load config, as secretchem.json is missing - [e]")
		return

	chemconfig = chemconfig["chemicals"]
	for (var/chemical in chemconfig)
		log_debug("SSchemistry: Loading chemical: [chemical]")
		var/datum/chemical_reaction/cc = new()
		cc.name = chemconfig[chemical]["name"]
		cc.id = chemconfig[chemical]["id"]
		cc.result = chemconfig[chemical]["result"]
		cc.result_amount = chemconfig[chemical]["resultamount"]
		cc.required_reagents = chemconfig[chemical]["required_reagents"]
		if(!cc.result in chemical_reagents)
			log_debug("SSchemistry: Warning: Invalid result [cc.result] in [cc.name] reactions list.")
			qdel(cc)

		for(var/A in cc.required_reagents)
			if(!(A in chemical_reagents))
				log_debug("SSchemistry: Warning: Invalid chemical [A] in [cc.name] required reagents list.")
				qdel(cc)
				break

		if(LAZYLEN(cc.required_reagents))
			var/reagent_id = cc.required_reagents[1]
			LAZYINITLIST(chemical_reactions[reagent_id])
			chemical_reactions[reagent_id] += cc

//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reagents()
	var/paths = subtypesof(/datum/reagent)
	chemical_reagents = list()
	for(var/path in paths)
		var/datum/reagent/D = new path()
		if(!D.name)
			continue
		chemical_reagents[D.id] = D

	sortTim(chemical_reagents, /proc/cmp_text_asc)


//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reactions()
	var/paths = subtypesof(/datum/chemical_reaction)
	chemical_reactions = list()

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		if(D.required_reagents && D.required_reagents.len)
			var/reagent_id = D.required_reagents[1]
			if(!chemical_reactions[reagent_id])
				chemical_reactions[reagent_id] = list()
			chemical_reactions[reagent_id] += D
		if(D.id)
			chemical_reactions_clean[D.id] = D
