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

//during phoron scarcity lore arc. remove when lore permits. 

/datum/bounty/item/phoron_sheet
	name = "Phoron Sheets"
	description = "Always prioritize this bounty. Failure to meet this quota may result in adverse impact upon your status in the NanoTrasen Corporation."
	reward_low = 7000
	reward_high = 9000
	required_count = 75
	random_count = 15
	wanted_types = list(/obj/item/stack/material/phoron)
	high_priority = TRUE

/datum/bounty/item/phoron_sheet/New()
	..()
	required_count = round(required_count, 10)
	//Temporarily overwrite the normal price randomization because the random_count is so high. There would be absolutely nuts price fluctuation. It's a temporary bounty anyway.
	reward = round(rand(reward_low, reward_high), 100)

/datum/bounty/item/phoron_sheet/ship(var/obj/item/stack/material/phoron/O)
	if(!applies_to(O))
		return
	shipped_count += O.amount

/datum/bounty/item/phoron_canister
	name = "Phoron Canisters"
	description = "Updated requirement: Canisters must now be filled to a minimum of 2000 moles. Always prioritize this bounty. Failure to meet this quota may result in adverse impact upon your status in the NanoTrasen Corporation."
	reward_low = 8000
	reward_high = 10000
	required_count = 3
	random_count = 1 // 2 to 4
	wanted_types = list(/obj/machinery/portable_atmospherics/canister)
	high_priority = TRUE	
	var/moles_required = 2000 //Roundstart total_moles for a FULL tank is about 1871 per tank. However during the arc this bounty is relevant, tanks are half full. 

/datum/bounty/item/phoron_canister/applies_to(var/obj/machinery/portable_atmospherics/canister/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE

	var/datum/gas_mixture/environment = O.return_air()
	if(!environment || !O.air_contents.gas["phoron"])
		return FALSE

	return O.air_contents.gas["phoron"] >= moles_required