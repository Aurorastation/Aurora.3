#define BOUNTY_MIN 1000
#define BOUNTY_MAX 15000

#define BOUNTY_NUM_LOW 1
#define BOUNTY_NUM_MED 2
#define BOUNTY_NUM_HIGH 3

/datum/bounty
	var/name
	var/description
	var/reward = BOUNTY_MIN // In credits. Mostly a fallback
	var/reward_low = 0	//If 0, uses reward value instead
	var/reward_high = 0	//If 0, uses reward value instead. Must be higher than reward_low
	var/claimed = FALSE
	var/high_priority = FALSE

/datum/bounty/New()
	if(reward_low > 0 && reward_high > reward_low)
		reward = round(rand(reward_low, reward_high), 100)
	description = replacetext(description, "%DOCKNAME",current_map.dock_name)
	description = replacetext(description, "%DOCKSHORT",current_map.dock_short)
	description = replacetext(description, "%BOSSNAME",current_map.boss_name)
	description = replacetext(description, "%BOSSSHORT",current_map.boss_short)
	description = replacetext(description, "%COMPNAME",current_map.company_name)
	description = replacetext(description, "%COMPSHORT",current_map.company_short)
	description = replacetext(description, "%PERSONNAME","[pick("Trooper", "Commander", "Agent", "Director", "Doctor")] [pick(last_names)]")

// Displayed on bounty UI screen.
/datum/bounty/proc/completion_string()
	return ""

// Displayed on bounty UI screen.
/datum/bounty/proc/reward_string()
	return "[reward] Credits"

/datum/bounty/proc/can_claim()
	return !claimed

// Called when the claim button is clicked. Override to provide fancy rewards.
/datum/bounty/proc/claim()
	if(can_claim())
		SScargo.charge_cargo("Bounty Reward for: [name]", -reward)
		claimed = TRUE
		return TRUE
	return FALSE

// If an item sent in the cargo shuttle can satisfy the bounty.
/datum/bounty/proc/applies_to(obj/O)
	return FALSE

// Called when an object is shipped on the cargo shuttle.
/datum/bounty/proc/ship(obj/O)
	return

// When randomly generating the bounty list, duplicate bounties must be avoided.
// This proc is used to determine if two bounties are duplicates, or incompatible in general.
/datum/bounty/proc/compatible_with(var/datum/other_bounty)
	return TRUE

/datum/bounty/proc/mark_high_priority(scale_reward = 2)
	if(high_priority)
		return
	high_priority = TRUE
	reward = min(round(reward * scale_reward), BOUNTY_MAX)	//15k limit

//Generates a list of available bounties to be displayed
/datum/controller/subsystem/cargo/proc/get_bounty_list()
	var/list/bounties = list()
	for(var/datum/bounty/B in bounties_list)
		var/list/bounty = list()
		bounty["name"] = B.name
		bounty["description"] = B.description
		bounty["reward_string"] = B.reward_string()
		bounty["completion_string"] = B.completion_string()
		bounty["can_claim"] = B.can_claim()
		bounty["claimed"] = B.claimed
		bounty["high_priority"] = B.high_priority
		if(bounty["can_claim"])
			bounty["background"] = "'background-color:#4F7529;'"
		else if(bounty["claimed"])
			bounty["background"] = "'background-color:#294675;'"
		else
			bounty["background"] = "'background-color:#990000;'"
		bounties.Add(list(bounty))
	return bounties

// This proc is called when the shuttle docks at CentCom.
// It handles items shipped for bounties.
/datum/controller/subsystem/cargo/proc/bounty_ship_item_and_contents(atom/movable/AM, dry_run=FALSE)
	var/list/matched_one = FALSE
	var/list/contents = AM.GetAllContents()
	for(var/thing in reverseRange(contents))
		var/matched_this = FALSE
		for(var/datum/bounty/B in bounties_list)
			if(B.applies_to(thing))
				matched_one = TRUE
				matched_this = TRUE
				if(!dry_run)
					B.ship(thing)
		if(!dry_run && matched_this)
			qdel(thing)
	return matched_one

// Returns FALSE if the bounty is incompatible with the current bounties.
/datum/controller/subsystem/cargo/proc/try_add_bounty(datum/bounty/new_bounty)
	if(!new_bounty || !new_bounty.name || !new_bounty.description)
		return FALSE
	for(var/i in bounties_list)
		var/datum/bounty/B = i
		if(!B.compatible_with(new_bounty) || !new_bounty.compatible_with(B))
			return FALSE
	bounties_list += new_bounty
	return TRUE

// Returns a new bounty of random type, but does not add it to bounties_list.
/datum/controller/subsystem/cargo/proc/random_bounty(var/category)
	if(!category)
		category = rand(1, 10)
	switch(category)
		if(1)
			var/subtype = pick(subtypesof(/datum/bounty/item/assistant))
			return new subtype
		if(2)
			var/subtype = pick(subtypesof(/datum/bounty/item/engineer))
			return new subtype
		if(3)
			var/subtype = pick(subtypesof(/datum/bounty/item/chef))
			return new subtype
		if(4)
			var/subtype = pick(subtypesof(/datum/bounty/item/security))
			return new subtype
		if(5)
			if(rand(2) == 1)
				return new /datum/bounty/reagent/simple_drink
			return new /datum/bounty/reagent/complex_drink
		if(6)
			return new /datum/bounty/reagent/chemical
		if(7)
			var/subtype = pick(subtypesof(/datum/bounty/item/science))
			return new subtype
		if(8)
			var/subtype = pick(subtypesof(/datum/bounty/item/hydroponicist))
			return new subtype
		if(9)
			var/subtype = pick(subtypesof(/datum/bounty/item/bot))
			return new subtype
		if(10)
			var/subtype = pick(subtypesof(/datum/bounty/weapon_prototype))
			return new subtype

//A abstraction to simplify adding new bounties
/datum/controller/subsystem/cargo/proc/add_bounty_abstract(var/string,var/number)
	if(string=="random")
		if(try_add_bounty(random_bounty(number)))
			return "Added random bounty"
		else
			return "Failed to add random bounty"
	else
		var/datum/bounty/b = text2path(string)
		if(b && try_add_bounty(new b))
			return "Added bounty [b.name]"
		else
			return "Failed to add bounty"

// Called lazily at startup to populate bounties_list with random bounties.
/datum/controller/subsystem/cargo/proc/setupBounties()
	var/list/assistant_bounties = subtypesof(/datum/bounty/item/assistant)
	for(var/i = 0; i < BOUNTY_NUM_HIGH; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(assistant_bounties)
		try_add_bounty(new subtype)

	var/list/robotics_and_science_bounties = subtypesof(/datum/bounty/item/bot) + subtypesof(/datum/bounty/item/science)
	for(var/i = 0; i < BOUNTY_NUM_HIGH; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(robotics_and_science_bounties)
		try_add_bounty(new subtype)

	var/list/chef_bounties = subtypesof(/datum/bounty/item/chef)
	for(var/i = 0; i < BOUNTY_NUM_MED; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(chef_bounties)
		try_add_bounty(new subtype)

	var/list/hydroponics_bounties = subtypesof(/datum/bounty/item/hydroponicist)
	for(var/i = 0; i < BOUNTY_NUM_MED; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(hydroponics_bounties)
		try_add_bounty(new subtype)

	var/list/security_and_engineering_bounties = subtypesof(/datum/bounty/item/security) + subtypesof(/datum/bounty/item/engineer)
	for(var/i = 0; i < BOUNTY_NUM_HIGH; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(security_and_engineering_bounties)
		try_add_bounty(new subtype)

	var/list/prototype_weapon_and_slime_bounties = subtypesof(/datum/bounty/weapon_prototype) + subtypesof(/datum/bounty/item/slime)
	for(var/i = 0; i < BOUNTY_NUM_LOW; i++)
		CHECK_TICK
		var/datum/bounty/subtype = pick(prototype_weapon_and_slime_bounties)
		try_add_bounty(new subtype)

	//add one of each reagent, then another one picked at random
	try_add_bounty(new /datum/bounty/reagent/simple_drink)
	try_add_bounty(new /datum/bounty/reagent/complex_drink)
	try_add_bounty(new /datum/bounty/reagent/chemical)
	var/datum/bounty/r_subtype = pick(subtypesof(/datum/bounty/reagent))
	try_add_bounty(new r_subtype)

	if(prob(60))
		//phoron bounties
		var/datum/bounty/item/phoron_bounty = pick(/datum/bounty/item/phoron_sheet, /datum/bounty/item/solar_array)
		try_add_bounty(new phoron_bounty)
	else
		var/datum/bounty/B = pick(bounties_list)
		B.mark_high_priority()

	// Generate these last so they can't be high priority.
	try_add_bounty(new /datum/bounty/more_bounties)

/datum/controller/subsystem/cargo/proc/completed_bounty_count()
	var/count = 0
	for(var/i in bounties_list)
		var/datum/bounty/B = i
		if(B.claimed)
			++count
	return count
