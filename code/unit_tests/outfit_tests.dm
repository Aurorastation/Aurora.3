ABSTRACT_TYPE(/datum/unit_test/outfits)
	name = "OUTFITS: Template"
	groups = list("generic")

/datum/unit_test/outfits/no_abstracts
	name = "OUTFITS: No Abstract Types in Outfits"
	var/errorcount = 0

///Macro to add a slot to the list of paths to test
#define ADD_SLOT_TO_TEST(list_paths_to_test, slot)\
	if(!isnull(slot)){\
		if(islist(slot)){\
			list_paths_to_test |= slot;\
		}\
		else{\
			list_paths_to_test += slot;\
		}\
	}

/datum/unit_test/outfits/no_abstracts/start_test()

	//For each of the outfit subtypes
	for(var/outfit_path in subtypesof(/datum/outfit))
		if(is_abstract(outfit_path))
			continue

		var/list/paths_to_test = list()

		//Create the outfit
		var/datum/outfit/outfit = new outfit_path()

		//Populate all the items in a single list to test
		ADD_SLOT_TO_TEST(paths_to_test, outfit.id)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.uniform)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.suit)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.suit_store)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.back)

		if(!isnull(outfit.backpack_contents))
			if(islist(outfit.backpack_contents))
				for(var/k in outfit.backpack_contents)
					paths_to_test += k
			else
				paths_to_test += outfit.backpack_contents

		ADD_SLOT_TO_TEST(paths_to_test, outfit.belt)

		if(!isnull(outfit.belt_contents))
			if(islist(outfit.belt_contents))
				for(var/k in outfit.belt_contents)
					paths_to_test += k
			else
				paths_to_test += outfit.belt_contents

		ADD_SLOT_TO_TEST(paths_to_test, outfit.glasses)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.gloves)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.head)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.mask)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.shoes)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.l_pocket)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.r_pocket)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.l_ear)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.r_ear)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.accessory)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.implants)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.pda)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.radio)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.backpack)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.satchel)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.satchel_alt)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.dufflebag)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.messengerbag)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.rucksack)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.pocketbook)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.tab_pda)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.tablet)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.wristbound)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.headset)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.bowman)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.double_headset)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.wrist_radio)
		ADD_SLOT_TO_TEST(paths_to_test, outfit.clipon_radio)

		if(!isnull(outfit.accessory_contents))
			if(islist(outfit.accessory_contents))
				for(var/k in outfit.accessory_contents)
					paths_to_test += k
			else
				paths_to_test += outfit.accessory_contents

		ADD_SLOT_TO_TEST(paths_to_test, outfit.spells)


		//Check all the items collected from this outfit
		for(var/itempath in paths_to_test)
			//Need to be paths
			if(!ispath(itempath))
				TEST_FAIL("Outfit [outfit_path] has an invalid item in its slot, which isn't a path: [itempath]!")
				errorcount++

			//Need not to be abstract
			if(is_abstract(itempath))
				TEST_FAIL("Outfit [outfit_path] has an abstract item in its slot: [itempath]!")
				errorcount++

	if(errorcount)
		return TEST_FAIL("Found [errorcount] abstract item(s) in outfit(s)!")
	else
		return TEST_PASS("All outfits are valid")

#undef ADD_SLOT_TO_TEST
