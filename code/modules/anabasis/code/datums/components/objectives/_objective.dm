/// The objective component is a component we can basically stick onto anything to give it a purpose for a contract.

/datum/component/objective
	/// The type of objective this is.
	var/objective_type
	/// If this objective is completed or not.
	var/completed = FALSE
	/// Unique identifier for this objective, used in linked lists.
	var/objective_id
	/// The contract connected to this objective.
	var/datum/contract/connected_contract

/datum/component/objective/Initialize(...)
	. = ..()
	RegisterSignal(SSanabasis, COMSIG_ANABASIS_UPDATE_CONTRACT, PROC_REF(update_contract))
	objective_id = "[objective_id]_" + REF(src)
	do_objective_setup()
	SSanabasis.add_objective(src)

/datum/component/objective/Destroy(force)
	SSanabasis.remove_objective(src)
	connected_contract = null
	return ..()

/**
 * Once we know that this objective is valid, set up what we need to do. This is the proc where you want to register the appropriate signals
 * or anything else that will check if the objective is complete or not.
 */
/datum/component/objective/proc/do_objective_setup()
	return

/**
 * This proc is the one you should override in order to check objective completion (see if the appropriate object is on top of the turf, etc.)
 */
/datum/component/objective/proc/verify_objective_completion()
	SHOULD_CALL_PARENT(TRUE)
	if(completed)
		return FALSE

/datum/component/objective/proc/complete_objective()
	completed = TRUE
	SEND_SIGNAL(SSanabasis, COMSIG_OBJECTIVE_COMPLETED, src)
	return TRUE

/**
 * Re-check if the contract is valid for this objective. If it is, update current contract. Otherwise, delete ourselves.
 */
/datum/component/objective/proc/update_contract()
	//todomatt: check if the contract is valid

// This type of objective basically just has a connected item and checks if the item is brought on top of it.
/datum/component/objective/receptacle_turf
	objective_type = OBJECTIVE_TYPE_RECEPTACLE

	/// The turf we are checking.
	var/turf/parent_turf
	/// The TYPEPATH of the item we want.
	var/required_item

/datum/component/objective/receptacle_turf/Initialize(...)
	if(isturf(parent))
		parent_turf = parent
	else
		log_debug("Receptacle turf objective spawned without an appropriate turf.")
		return INITIALIZE_HINT_QDEL
	. = ..()

/datum/component/objective/receptacle_turf/do_objective_setup()
	RegisterSignal(parent_turf, COMSIG_ATOM_ENTERED, PROC_REF(verify_objective_completion))

/datum/component/objective/receptacle_turf/verify_objective_completion(datum/source)
	. = ..()
	if(!.)
		return FALSE

	if(istype(source, required_item))
		var/atom/movable/fetched = source
		fetched.anchored = TRUE //no cheese
		return complete_objective()
