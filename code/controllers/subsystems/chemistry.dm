SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_MISC_FIRST
	runlevels = RUNLEVELS_PLAYING
	init_stage = INITSTAGE_EARLY

	var/list/active_holders = list()
	var/list/chemical_reactions
	var/list/chemical_reactions_clean = list()

	var/tmp/list/processing_holders = list()
	var/list/codex_data = list()
	var/list/codex_ignored_reaction_path = list(/datum/chemical_reaction/slime)
	var/list/codex_ignored_result_path = list(/singleton/reagent/drink, /singleton/reagent/alcohol)

/datum/controller/subsystem/chemistry/proc/has_valid_specific_heat(var/_R) //Used for unit tests. Same as check_specific_heat but returns a boolean instead.
	var/singleton/reagent/R = GET_SINGLETON(_R)
	if(R.specific_heat > 0)
		return TRUE

	var/datum/chemical_reaction/recipe = find_recipe_by_result(_R)
	if(recipe)
		for(var/chem in recipe.required_reagents)
			if(!has_valid_specific_heat(chem))
				log_subsystem_chemistry("ERROR: [recipe.type] has an improper recipe!")
				return R.fallback_specific_heat > 0

		return TRUE
	else
		if(R.fallback_specific_heat > 0)
			return TRUE
		else
			log_subsystem_chemistry("ERROR: [_R] does not have a valid specific heat ([R.specific_heat]) or a valid fallback specific heat ([R.fallback_specific_heat]) assigned!")
			return FALSE

/datum/controller/subsystem/chemistry/proc/check_specific_heat(var/_R)
	var/singleton/reagent/R = GET_SINGLETON(_R)
	if(R.specific_heat > 0)
		return R.specific_heat

	if(R.specific_heat > 0) //Don't think this will happen but you never know.
		return R.specific_heat

	var/datum/chemical_reaction/recipe = find_recipe_by_result(_R)
	if(recipe)
		var/final_heat = 0
		var/result_amount = recipe.result_amount
		for(var/chem in recipe.required_reagents)
			var/chem_specific_heat = check_specific_heat(chem)
			if(chem_specific_heat <= 0)
				log_subsystem_chemistry("ERROR: [R.type] does not have a specific heat value set, and there is no associated recipe for it! Please fix this by giving it a specific_heat value!")
				final_heat = 0
				break
			final_heat += chem_specific_heat * (recipe.required_reagents[chem]/result_amount)

		if(final_heat > 0)
			R.specific_heat = final_heat
			return final_heat

	if(R.fallback_specific_heat > 0)
		R.specific_heat = R.fallback_specific_heat
		return R.fallback_specific_heat

	log_subsystem_chemistry("ERROR: [_R] does not have a specific heat value set, and there is no associated recipe for it! Please fix this by giving it a specific_heat value!")
	R.specific_heat = 1
	return 1

/datum/controller/subsystem/chemistry/proc/find_recipe_by_result(var/result_id)
	for(var/key in chemical_reactions_clean)
		var/datum/chemical_reaction/CR = chemical_reactions_clean[key]
		if(CR.result == result_id && CR.result_amount > 0)
			return CR

/datum/controller/subsystem/chemistry/proc/initialize_specific_heats()
	for(var/_R in subtypesof(/singleton/reagent/))
		check_specific_heat(_R)

/datum/controller/subsystem/chemistry/stat_entry(msg)
	msg = "AH:[active_holders.len]"
	return ..()

/datum/controller/subsystem/chemistry/Initialize()
	initialize_chemical_reactions()
	initialize_codex_data()
	var/pre_secret_len = chemical_reactions.len
	log_subsystem_chemistry("Found [pre_secret_len] reactions.")
	log_subsystem_chemistry("Loaded [load_secret_chemicals()] secret reactions.")
	initialize_specific_heats() // must be after reactions

	return SS_INIT_SUCCESS

/datum/controller/subsystem/chemistry/fire(resumed = FALSE)
	if (!resumed)
		processing_holders = active_holders.Copy()

	while (processing_holders.len)
		var/datum/reagents/holder = processing_holders[processing_holders.len]
		processing_holders.len--

		if (QDELETED(holder))
			active_holders -= holder
			LOG_DEBUG("SSchemistry: QDELETED holder found in processing list!")
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

/datum/controller/subsystem/chemistry/proc/load_secret_chemicals()
	. = 0
	var/list/chemconfig = list()

	if(!(rustg_file_exists("config/secretchem.json") == "true"))
		log_config("The file config/secretchem.json was not found, secret chemicals will not be loaded.")
		return

	try
		chemconfig = json_decode(return_file_text("config/secretchem.json"))
	catch(var/exception/e)
		log_subsystem_chemistry("Warning: Could not load config, as secretchem.json is missing - [e]")
		return

	chemconfig = chemconfig["chemicals"]
	for (var/chemical in chemconfig)
		log_subsystem_chemistry("Loading chemical: [chemical]")
		var/datum/chemical_reaction/cc = new()
		cc.name = chemconfig[chemical]["name"]
		cc.id = chemconfig[chemical]["id"]
		cc.result = text2path(chemconfig[chemical]["result"])
		cc.result_amount = chemconfig[chemical]["resultamount"]
		if(!ispath(cc.result, /singleton/reagent))
			log_subsystem_chemistry("Warning: Invalid result [cc.result] in [cc.name] reactions list.")
			qdel(cc)
			break

		for(var/key in chemconfig[chemical]["required_reagents"])
			var/result_chem = text2path(key)
			LAZYSET(cc.required_reagents, result_chem, chemconfig[chemical]["required_reagents"][key])
			if(!ispath(result_chem, /singleton/reagent))
				log_subsystem_chemistry("Warning: Invalid chemical [key] in [cc.name] required reagents list.")
				qdel(cc)
				break

		if(LAZYLEN(cc?.required_reagents))
			var/rtype = cc.required_reagents[1]
			LAZYINITLIST(chemical_reactions[rtype])
			chemical_reactions[rtype] += cc
			.++

//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reaction_list[/singleton/reagent/toxin/phoron] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reactions()
	var/paths = subtypesof(/datum/chemical_reaction)
	chemical_reactions = list()

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		if(D.required_reagents && D.required_reagents.len)
			var/rtype = D.required_reagents[1]
			if(!chemical_reactions[rtype])
				chemical_reactions[rtype] = list()
			chemical_reactions[rtype] += D
		if(D.type)
			chemical_reactions_clean[D.type] = D

// Creates data for chemical codex
/datum/controller/subsystem/chemistry/proc/initialize_codex_data()
	codex_data = list()
	for(var/chem_path in chemical_reactions_clean)
		if(codex_ignored_reaction_path && is_path_in_list(chem_path, codex_ignored_reaction_path))
			continue
		var/datum/chemical_reaction/CR = new chem_path
		if(!CR.result)
			continue
		if(codex_ignored_result_path && is_path_in_list(CR.result, codex_ignored_result_path))
			continue
		var/singleton/reagent/R = GET_SINGLETON(CR.result)
		var/reactionData = list(id = CR.id)
		reactionData["result"] = list(
			name = R.name,
			description = R.description,
			amount = CR.result_amount
		)

		reactionData["reagents"] = list()
		for(var/reagent in CR.required_reagents)
			var/singleton/reagent/required_reagent = reagent
			reactionData["reagents"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.required_reagents[reagent]
			))

		reactionData["catalysts"] = list()
		for(var/reagent_path in CR.catalysts)
			var/singleton/reagent/required_reagent = reagent_path
			reactionData["catalysts"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.catalysts[reagent_path]
			))

		reactionData["inhibitors"] = list()
		for(var/reagent_path in CR.inhibitors)
			var/singleton/reagent/required_reagent = reagent_path
			var/inhibitor_amount = CR.inhibitors[reagent_path] ? CR.inhibitors[reagent_path] : "Any"
			reactionData["inhibitors"] += list(list(
				name = initial(required_reagent.name),
				amount = inhibitor_amount
			))

		reactionData["temp_min"] = CR.required_temperature_min

		reactionData["temp_max"] = CR.required_temperature_max

		codex_data += list(reactionData)
