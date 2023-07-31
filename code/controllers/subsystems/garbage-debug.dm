#ifdef REFERENCE_TRACKING

/datum/var/running_find_references
/datum/var/last_find_references = 0

/datum/verb/find_refs()
	set category = "Debug"
	set name = "Find References"
	set background = 1
	set src in world

	find_references(FALSE)

/client/verb/show_qdeleted()
	set category = "Debug"
	set name = "Show qdel() Log"
	set desc = "Render the qdel() log and display it"

	var/dat = "<B>List of things that have been qdel()eted this round</B><BR><BR>"

	var/tmplist = list()
	for(var/elem in SSgarbage.qdel_list)
		if(!(elem in tmplist))
			tmplist[elem] = 0
		tmplist[elem]++

	sortTim(tmplist, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)

	for(var/path in tmplist)
		dat += "[path] - [tmplist[path]] times<BR>"

	usr << browse(dat, "window=qdeletedlog")

/datum/proc/find_references(skip_alert)
	running_find_references = type
	if(usr?.client)
		if(usr.client.running_find_references)
			testing("CANCELLED search for references to a [usr.client.running_find_references].")
			usr.client.running_find_references = null
			running_find_references = null
			SSgarbage.enable()
			return

		if(!skip_alert && alert(usr, "Running this will lock everything up for 5+ minutes. Would you like to begin the search?", "Find References", "Yes", "No") != "Yes")
			running_find_references = null
			return

	SSgarbage.disable() // Keeps the GC from failing to collect objects being searched for here

	if(usr?.client)
		usr.client.running_find_references = type

	//Time to search the whole game for our ref
	testing("Beginning search for references to a [type].")
	var/starting_time = world.time

	//Yes we do actually need to do this. The searcher refuses to read weird lists
	//And global.vars is a really weird list
	var/global_vars = list()
	for(var/key in global.vars)
		global_vars[key] = global.vars[key]

	search_var(global_vars, "Native Global", search_time = starting_time)
	testing("Finished searching native globals")

	for(var/datum/thing in world) // atoms (don't believe its lies)
		search_var(thing, "World -> [thing.type]", search_time = starting_time)
	testing("Finished searching atoms")

	for(var/datum/thing) // datums
		search_var(thing, "Datums -> [thing.type]", search_time = starting_time)
	testing("Finished searching datums")

	//Warning, attempting to search clients like this will cause crashes if done on live. Watch yourself
	for(var/client/thing) // clients
		search_var(thing, "Clients -> [thing.type]", search_time = starting_time)
	testing("Finished searching clients")

	testing("Completed all searches for references to a [type].")

	if(usr?.client)
		usr.client.running_find_references = null
	running_find_references = null

	SSgarbage.enable() //restart the garbage collector

/datum/proc/search_var(potential_container, container_name, recursive_limit = 64, search_time = world.time)

	if(usr?.client && !usr.client.running_find_references)
		return

	if(!recursive_limit)
		testing("Recursion limit reached. [container_name]")
		return

	//Check each time you go down a layer. This makes it a bit slow, but it won't effect the rest of the game at all
	#ifndef FIND_REF_NO_CHECK_TICK
	CHECK_TICK
	#endif

	if(isdatum(potential_container))
		var/datum/datum_container = potential_container
		if(datum_container.last_find_references == search_time)
			return

		datum_container.last_find_references = search_time
		var/list/vars_list = datum_container.vars

		for(var/varname in vars_list)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			if (varname == "vars" || varname == "vis_locs") //Fun fact, vis_locs don't count for references
				continue
			var/variable = vars_list[varname]

			if(variable == src)
				testing("Found [type] [text_ref(src)] in [datum_container.type]'s [text_ref(datum_container)] [varname] var. [container_name]")
				continue

			if(islist(variable))
				search_var(variable, "[container_name] [text_ref(datum_container)] -> [varname] (list)", recursive_limit - 1, search_time)

	else if(islist(potential_container))
		var/normal = IS_NORMAL_LIST(potential_container)
		var/list/potential_cache = potential_container
		for(var/element_in_list in potential_cache)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			// Check normal entries
			if(element_in_list == src)
				testing("Found [type] [text_ref(src)] in list [container_name]\[[element_in_list]\]")
				continue

			var/assoc_val = null
			if(!isnum(element_in_list) && normal)
				assoc_val = potential_cache[element_in_list]
			// Check assoc entries
			if(assoc_val == src)
				testing("Found [type] [text_ref(src)] in list [container_name]\[[element_in_list]\]")
				continue

			//We need to run both of these checks, since our object could be hiding in either of them
			// Check normal sublists
			if(islist(element_in_list))
				search_var(element_in_list, "[container_name] -> [element_in_list] (list)", recursive_limit - 1, search_time)
			// Check assoc sublists
			if(islist(assoc_val))
				search_var(potential_container[element_in_list], "[container_name]\[[element_in_list]\] -> [assoc_val] (list)", recursive_limit - 1, search_time)

/proc/qdel_and_find_ref_if_fail(datum/thing_to_qdel, force = FALSE)
	thing_to_qdel.qdel_and_find_ref_if_fail(force)

/datum/proc/qdel_and_find_ref_if_fail(force = FALSE)
	SSgarbage.reference_find_on_fail[text_ref(src)] = TRUE
	qdel(src, force)

#endif
