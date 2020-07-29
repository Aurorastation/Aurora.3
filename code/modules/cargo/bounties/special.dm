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
//reward_low and reward_high are set to half of the target amount since they will always be marked high priority.

/datum/bounty/item/phoron_sheet
	name = "Phoron Sheets"
	description = "Always prioritize this bounty. Failure to meet this quota may result in adverse impact upon your status in the NanoTrasen Corporation."
	reward_low = 8000
	reward_high = 9000
	required_count = 150
	random_count = 25
	wanted_types = list(/obj/item/stack/material/phoron)
	high_priority = TRUE

/datum/bounty/item/phoron_sheet/New()
	..()
	required_count = round(required_count, 10)

/datum/bounty/item/phoron_canister
	name = "Phoron Canisters"
	description = "Always prioritize this bounty. Failure to meet this quota may result in adverse impact upon your status in the NanoTrasen Corporation. Tanks must be filled to at least standard stock amounts."
	reward_low = 7500
	reward_high = 8500
	required_count = 4
	random_count = 1 // 3 to 5
	wanted_types = list(/obj/machinery/portable_atmospherics/canister)
	high_priority = TRUE	
	var/moles_required = 1800 //Roundstart total_moles is about 1871 per tank. This is a small leeway.

/datum/bounty/item/phoron_canister/applies_to(obj/O)
	if(!..())
		return FALSE
	if(!istype(O, /obj/machinery/portable_atmospherics/canister))
		return FALSE

	var/obj/machinery/portable_atmospherics/canister/C = O
	var/datum/gas_mixture/environment = C.return_air()
	if(!environment || !C.air_contents.gas["phoron"])
		return FALSE

	return C.air_contents.gas["phoron"] >= moles_required