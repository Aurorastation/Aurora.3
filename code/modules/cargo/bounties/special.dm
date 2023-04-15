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

//Part of the Horizon's operations is to secure phoron, so high priority.

/datum/bounty/item/phoron_sheet
	name = "Phoron Sheets"
	description = "Shipment of Phoron is considered to be a key part of the SCCV Horizon's operations within the CRZ. This bounty should always be prioritized."
	reward_low = 2600
	reward_high = 3750
	required_count = 40
	random_count = 10
	wanted_types = list(/obj/item/stack/material/phoron)
	high_priority = TRUE

/datum/bounty/item/phoron_sheet/New()
	..()
	required_count = round(required_count, 10)
	//Overwrite the normal price randomization because the random_count is so high. There would be absolutely nuts price fluctuation. 
	reward = round(rand(reward_low, reward_high), 100)

/datum/bounty/item/phoron_sheet/ship(var/obj/item/stack/material/phoron/O)
	if(!applies_to(O))
		return
	shipped_count += O.amount

/datum/bounty/item/solar_array
	name = "Assembled Solar Panels"
	description = "Owing to the phoron shortage continuing for over a year, longer than projected, we have decided to use solar arrays to power various facilities across our region of influence."
	reward_low = 8000
	reward_high = 10000
	required_count = 6
	random_count = 2 // 4 to 8
	wanted_types = list(/obj/machinery/power/solar)
	high_priority = TRUE
