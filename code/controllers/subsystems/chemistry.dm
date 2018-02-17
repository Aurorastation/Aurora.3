var/datum/controller/subsystem/chemistry/SSchemistry

/datum/controller/subsystem/chemistry
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_MISC_FIRST

	var/list/active_holders = list()
	var/list/chemical_reactions
	var/list/chemical_reagents

	var/tmp/list/processing_holders = list()

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

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
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
