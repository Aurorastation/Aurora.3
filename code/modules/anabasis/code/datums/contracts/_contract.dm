/datum/contract
	/// The name of the contract. Shows up as what people select at roundstart.
	var/name
	/// The basic difficulty of the contract.
	var/difficulty
	/// If the contract is completed or not.
	var/completed = FALSE
	/// The payout in case the contract is completed.
	var/payout
	/// The threat level this contract generates.
	var/threat_level_added
	/// The scenario singleton connected to this contract.
	var/singleton/scenario/connected_scenario

/datum/contract/New()
	. = ..()
	//generate the contract here
	//shouldn't be a singleton because contracts should be somewhat dynamic and so we need to change variables & shit
	//technically they could be a singleton anyway we'd just break the laws of coding

/**
 * Sets the contract to complete or not. IMPORTANT: this does not automatically handle paying out the sum. That's done at round end.
 * The reason for this is contracts may be completed/uncompleted due to plot twists or admin interference.
 */
/datum/contract/proc/set_completion(state)
	completed = TRUE
	//do more fancy shit here
