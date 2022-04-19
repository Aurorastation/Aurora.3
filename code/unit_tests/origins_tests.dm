/datum/unit_test/cultures
	name = "Cultures Test - All cultures shall be filled out"

/datum/unit_test/cultures/start_test()
	var/list/decl/origin_item/culture/all_cultures = decls_repository.get_decls_of_subtype(/decl/origin_item/culture)
	for(var/decl/origin_item/culture/OC in all_cultures)
		if(!istext(OC.name))
			fail("Culture [OC.name] does not have a name!")
		if(!istext(OC.desc))
			fail("Culture [OC.name] does not have a description!")
		if(!islist(OC.possible_origins))
			fail("Culture [OC.name]'s possible_origins list is not a list!")
		if(!length(OC.possible_origins))
			fail("Culture [OC.name] does not have any possible origins!")
	pass("All cultures are filled out properly.")

/datum/unit_test/origins
	name = "Origins Test - All origins shall be filled out"

/datum/unit_test/origins/start_test()
	var/list/decl/origin_item/origin/all_origins = decls_repository.get_decls_of_subtype(/decl/origin_item/origin)
	for(var/decl/origin_item/origin/OI in all_origins)
		if(!istext(OI.name))
			fail("Origin [OI.name] does not have a name!")
		if(!istext(OI.desc))
			fail("Origin [OI.name] does not have a description!")
		if(!islist(OI.possible_accents) || !islist(OI.possible_citizenships) || !islist(OI.possible_religions))
			fail("Origin [OI.name] is missing at least one list in the possible accents, citizenships or religions!")
		if(!length(OI.possible_accents) || !length(OI.possible_citizenships) || !length(OI.possible_religions))
			fail("Origin [OI.name] is missing at least one entry in the possible accents, citizenships or religions lists!")
	pass("All origins are filled out properly.")