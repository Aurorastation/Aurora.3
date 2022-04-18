/datum/bounty/more_bounties
	name = "More Bounties"
	description = "Complete enough bounties and %BOSSSHORT will issue new ones!"
	reward = 3 // number of bounties
	var/required_bounties = 5

/datum/bounty/more_bounties/can_claim()
	return ..() && SScargo.completed_bounty_count() >= required_bounties

/datum/bounty/more_bounties/completion_string()
	return "[min(required_bounties, SScargo.completed_bounty_count())]/[required_bounties] Bounties"

/datum/bounty/more_bounties/reward_string()
	return "Up to [reward] new bounties"

/datum/bounty/more_bounties/claim()
	if(can_claim())
		claimed = TRUE
		for(var/i = 0; i < reward; ++i)
			SScargo.try_add_bounty(SScargo.random_bounty())

/datum/bounty/item/solar_array
	name = "Assembled Solar Panels"
	description = "Owing to the phoron shortage continuing for over a year, longer than projected, we have decided to use solar arrays to power various facilities across our region of influence."
	reward_low = 8000
	reward_high = 10000
	required_count = 6
	random_count = 2 // 4 to 8
	wanted_types = list(/obj/machinery/power/solar)
	high_priority = TRUE
