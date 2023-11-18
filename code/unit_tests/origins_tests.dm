/datum/unit_test/cultures
	name = "Cultures Test - All cultures shall be filled out"
	groups = list("generic")

/datum/unit_test/cultures/start_test()
	var/failures = 0
	var/list/singleton/origin_item/culture/all_cultures = GET_SINGLETON_SUBTYPE_MAP(/singleton/origin_item/culture)
	for(var/singleton/origin_item/culture/OC in all_cultures)
		if(!istext(OC.name))
			TEST_FAIL("Culture [OC.name] does not have a name!")
			failures++
		if(!istext(OC.desc))
			TEST_FAIL("Culture [OC.name] does not have a description!")
			failures++
		if(!islist(OC.possible_origins))
			TEST_FAIL("Culture [OC.name]'s possible_origins list is not a list!")
			failures++
		if(!length(OC.possible_origins))
			TEST_FAIL("Culture [OC.name] does not have any possible origins!")
			failures++
	if(failures)
		TEST_FAIL("[failures] error(s) found.")
	else
		TEST_PASS("All cultures are filled out properly.")
	return TRUE

/datum/unit_test/origins
	name = "Origins Test - All origins shall be filled out"
	groups = list("generic")

/datum/unit_test/origins/start_test()
	var/failures = 0
	var/list/singleton/origin_item/origin/all_origins = GET_SINGLETON_SUBTYPE_MAP(/singleton/origin_item/origin)
	for(var/singleton/origin_item/origin/OI in all_origins)
		if(!istext(OI.name))
			TEST_FAIL("Origin [OI.name] does not have a name!")
			failures++
		if(!istext(OI.desc))
			TEST_FAIL("Origin [OI.name] does not have a description!")
			failures++
		if(!islist(OI.possible_accents) || !islist(OI.possible_citizenships) || !islist(OI.possible_religions))
			TEST_FAIL("Origin [OI.name] is missing at least one list in the possible accents, citizenships or religions!")
			failures++
		if(!length(OI.possible_accents) || !length(OI.possible_citizenships) || !length(OI.possible_religions))
			TEST_FAIL("Origin [OI.name] is missing at least one entry in the possible accents, citizenships or religions lists!")
			failures++
	if(failures)
		TEST_FAIL("[failures] error(s) found.")
	else
		TEST_PASS("All origins are filled out properly.")
	return TRUE

/datum/unit_test/accent_tags
	name = "All accent tags shall have a text tag"
	groups = list("generic")

/datum/unit_test/accent_tags/start_test()
	var/failures = 0
	for(var/datum/accent/A in subtypesof(/datum/accent))
		A = new()
		if(!istext(A.text_tag))
			TEST_FAIL("Accent tag [A.name] did not have a text tag or the type was inappropriate!")
			failures++
	if(failures)
		TEST_FAIL("[failures] errors found.")
	else
		TEST_PASS("All accents have a text tag.")
	return TRUE
