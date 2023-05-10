/datum/unit_test/species
	name = "SPECIES template"

/datum/unit_test/species/injection_mod
	name = "SPECIES: All species shall have a valid injection_mod"

// Check that injection_mod is larger than 0. 0 injection_mod is indistinguishable from a failed injection, and a negative injection_mod is meaningless.
/datum/unit_test/species/injection_mod/start_test()
	var/list/failed_species = list()

	for(var/S in typesof(/datum/species))
		var/datum/species/species = S

		if(initial(species.injection_mod) > 0)
			continue
		else
			failed_species |= species.type

	if(failed_species.len)
		for(var/fail in failed_species)
		TEST_FAIL("SPECIES: Invalid injection_mod var set on species: [english_list(failed_species)]")
	else
		TEST_PASS("SPECIES: All species had valid injection_mod vars set.")


	return 1
