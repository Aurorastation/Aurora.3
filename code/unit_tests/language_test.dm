/datum/unit_test/language_test
	name = "Language Test - Repeated Keys"
	groups = list("generic", "language")

/datum/unit_test/language_test/start_test()
	var/list/used_keys = list()

	for(var/language_path in subtypesof(/datum/language))
		var/datum/language/L = new language_path
		if(L.key in used_keys)
			TEST_FAIL("[L.name]'s key, [L.key], is used multiple times!")
			continue
		used_keys += L.key

	if(!reported)
		TEST_PASS("All languages have unique keys.")

	return TRUE
