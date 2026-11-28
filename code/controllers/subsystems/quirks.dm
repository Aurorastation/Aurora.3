SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	flags = SS_NO_FIRE

	/// Quirk categories mapped to the quirks declared beneath them.
	var/list/quirk_tree = list()
	/// All selectable quirk singletons.
	var/list/all_quirks = list()
	/// Legacy disability display names mapped to their replacement quirks.
	var/list/legacy_quirks = list()

/datum/controller/subsystem/quirks/Initialize()
	for(var/singleton/quirk_category/quirk_category as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/quirk_category))
		quirk_tree[quirk_category] = list()

	for(var/singleton/quirk/quirk as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/quirk))
		if(quirk.slot_cost < 0)
			crash_with("QUIRKS: [quirk.type] has a negative slot cost.")
			continue
		var/singleton/quirk_category/quirk_category = GET_SINGLETON(quirk.category)
		if(!quirk_category || !(quirk_category in quirk_tree))
			crash_with("QUIRKS: [quirk.type] has an invalid category: [quirk.category]")
			continue
		all_quirks += quirk
		quirk_tree[quirk_category] += quirk
		for(var/legacy_name in quirk.legacy_names)
			legacy_quirks[legacy_name] = quirk

	return SS_INIT_SUCCESS

/datum/controller/subsystem/quirks/Destroy()
	quirk_tree.Cut()
	all_quirks.Cut()
	legacy_quirks.Cut()
	return ..()
