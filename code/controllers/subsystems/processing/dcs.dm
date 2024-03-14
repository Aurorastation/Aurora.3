PROCESSING_SUBSYSTEM_DEF(dcs)
	name = "Datum Component System"
	flags = SS_NO_INIT

	var/list/elements_by_type = list()

/datum/controller/subsystem/processing/dcs/Recover()
	comp_lookup = SSdcs.comp_lookup

/datum/controller/subsystem/processing/dcs/proc/GetElement(list/arguments)
	var/datum/element/eletype = arguments[1]
	var/element_id = eletype

	if(!ispath(eletype, /datum/element))
		CRASH("Attempted to instantiate [eletype] as a /datum/element")

	if(initial(eletype.element_flags) & ELEMENT_BESPOKE)
		element_id = GetIdFromArguments(arguments)

	. = elements_by_type[element_id]
	if(.)
		return
	. = elements_by_type[element_id] = new eletype

/****
	* Generates an id for bespoke elements when given the argument list
	* Generating the id here is a bit complex because we need to support named arguments
	* Named arguments can appear in any order and we need them to appear after ordered arguments
	* We assume that no one will pass in a named argument with a value of null
	**/
/datum/controller/subsystem/processing/dcs/proc/GetIdFromArguments(list/arguments)
	var/datum/element/eletype = arguments[1]
	var/list/fullid = list("[eletype]")
	var/list/named_arguments
	for(var/i in initial(eletype.argument_hash_start_idx) to length(arguments))
		var/key = arguments[i]

		if(istext(key))
			var/value = arguments[key]
			if (isnull(value))
				fullid += key
			else
				if (!istext(value) && !isnum(value))
					//One day we will complete the port with everything. For now, this pieces remains commented as a reference.
					//Also hello, programmer 9 years from now that is reading this.
					// if(PERFORM_ALL_TESTS(dcs_check_list_arguments) && islist(value))
					// 	add_to_arguments_that_are_lists(value, eletype)
					value = REF(value)

				if (!named_arguments)
					named_arguments = list()

				named_arguments[key] = value
			continue

		if (isnum(key))
			fullid += key
		else
			// if(PERFORM_ALL_TESTS(dcs_check_list_arguments) && islist(key))
			// 	add_to_arguments_that_are_lists(key, eletype)
			fullid += REF(key)

	if(length(named_arguments))
		named_arguments = sortList(named_arguments)
		fullid += named_arguments
	return list2params(fullid)
