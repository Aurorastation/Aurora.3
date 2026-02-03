// SSanabasis basically handles all the background work for the living setting. Things like contracts, objectives, and also faction aggression.
SUBSYSTEM_DEF(anabasis)
	name = "Anabasis"
	init_order = INIT_ORDER_ANABASIS
	runlevels = RUNLEVELS_PLAYING

	/// The variable to rule the world - the current amount of money the ship has. Loaded as soon as the game starts from the DB.
	var/anabasis_money
	/// Persistent threat level of the ship. The more bad things you do, the more people you kill, the more this will rise. A higher threat level means worse and worse people will be on your ass.
	var/threat_level = ANABASIS_THREAT_LEVEL_GOOD
	/// The current contract picked for this round.
	var/datum/contract/current_contract
	/// Currently incomplete objectives (more of a debugging and statistics list).
	var/list/datum/objective/incomplete_objectives
	/// Currently completed objectives (more of a debugging and statistics list).
	var/list/datum/component/complete_objectives

/datum/controller/subsystem/anabasis/Initialize()
	//todomatt: load money with SQL here and throw a shitfit if it can't happen

	RegisterSignal(src, COMSIG_OBJECTIVE_COMPLETED, PROC_REF(complete_objective))
	return SS_INIT_SUCCESS

/**
 * Adds an objective to the Anabasis subsystem and begins tracking its completion.
 */
/datum/controller/subsystem/anabasis/proc/add_objective(datum/component/objective/objective)
	LAZYSET(incomplete_objectives, objective.objective_id, objective)
	objective.connected_contract = current_contract
	log_debug("Added new Anabasis objective: [objective.objective_id]")

	if(current_contract.completed)
		current_contract.set_completion(FALSE)

/**
 * Removes an objective from the Anabasis subsystem.
 */
/datum/controller/subsystem/anabasis/proc/remove_objective(datum/component/objective/objective)
	log_debug("Removed an Anabasis objective: [objective.objective_id]")
	if(objective.completed)
		LAZYREMOVE(complete_objectives, objective.objective_id)
	else
		LAZYREMOVE(incomplete_objectives, objective.objective_id)

	// Need to check if the contract is completed, as an objective may have been removed by admins cause it was bugged.
	check_contract_completion()

/**
 * Sets an objective to complete.
 */
/datum/controller/subsystem/anabasis/proc/complete_objective(datum/component/objective/objective)
	SIGNAL_HANDLER
	log_and_message_admins("An Anabasis objective has been completed: [objective.objective_id]")
	LAZYREMOVE(incomplete_objectives, completed_objective.objective_id)
	LAZYSET(complete_objectives, objective.objective_id, objective)

	check_contract_completion()

/**
 * Handles objective completion and checks if the current contract is completed.
 */
/datum/controller/subsystem/anabasis/proc/check_contract_completion()
	if(!length(incomplete_objectives))
		current_contract.set_completion(FALSE)


