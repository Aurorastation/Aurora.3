/datum/unit_test/language_test
	name = "Language Test - Repeated Keys"

/datum/unit_test/language_test/start_test()
	var/list/used_keys = list()

	for(var/language_path in subtypesof(/datum/language))
		var/datum/language/L = new language_path
		if(L.key in used_keys)
			fail("[L.name]'s key, [L.key], is used multiple times!")
			continue
		used_keys += L.key
	
	if(!reported)
		pass("All languages have unique keys.")

	return TRUE