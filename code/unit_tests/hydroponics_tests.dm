/*
For unit tests relating to hydroponics mechanics, with no direct relation to cooking.
*/

/**
Checks if the preference values of a seed are lesser than their tolerance values.
Preferences should always be within tolerances. We don't want any plant to be dying from intolerance
while simultaneously growing faster from being within its preferences.
*/
/datum/unit_test/seed_preferences_check
	name = "HYDROPONICS: Check preference and tolerance validity"
	groups = list("generic", "cooking")

/datum/unit_test/seed_preferences_check/start_test()
	for(var/seed_name in SSplants.seeds)
		var/datum/seed/S = SSplants.seeds[seed_name]

		if(S.get_trait(TRAIT_LIGHT_TOLERANCE) < S.get_trait(TRAIT_LIGHT_PREFERENCE))
			TEST_FAIL("Seed [S] has a light preference value set higher than its light tolerance.")

		if(S.get_trait(TRAIT_HEAT_TOLERANCE) < S.get_trait(TRAIT_HEAT_PREFERENCE))
			TEST_FAIL("Seed [S] has a heat preference value set higher than its heat tolerance.")

	if(!reported)
		TEST_PASS("All seeds have preference values that are lower than their tolerance values.")

	return 1
