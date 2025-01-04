/datum/component/eye
	///The actual eye mob linked to the component
	var/mob/abstract/eye/component_eye
	///What type of /mob/abstract/eye is used
	var/eye_type = /mob/abstract/eye
	///The mob currently looking through the eye
	var/mob/current_looker

	///Actions used to pass commands from the eye to the holder. Must be subtypes of /datum/action/eye
	///Base type of the action, all subtypes of this are added to actions.
	var/action_type
	///The actions available to the eye
	var/list/actions = list()

/datum/component/eye/Destroy()
	unlook()
	QDEL_LIST(actions)
	. = ..()

/datum/component/eye/proc/look(mob/new_looker, list/eye_args)
	if(new_looker.eyeobj || current_looker)
		return FALSE
	LAZYINSERT(eye_args, get_turf(current_looker), 1) //Make sure that a loc is provided to the eye
	if(!component_eye)
		component_eye = new eye_type(arglist(eye_args))
	current_looker = new_looker
	component_eye.possess(current_looker)

	if(action_type)
		for(var/atype in subtypesof(action_type))
			var/datum/action/eye/action = new atype(src)
			actions += action
			action.Grant(current_looker)

	//Manual unlooking for the looker
	var/datum/action/eye/unlook/unlook_action = new(src)
	actions += unlook_action
	unlook_action.Grant(current_looker)

	//Checks for removing the user from the eye outside of unlook actions.
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(unlook))
	RegisterSignal(current_looker, COMSIG_MOVABLE_MOVED, PROC_REF(unlook))

	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(unlook))
	RegisterSignal(current_looker, COMSIG_QDELETING, PROC_REF(unlook))
	RegisterSignal(component_eye, COMSIG_QDELETING, PROC_REF(unlook))

	RegisterSignal(current_looker, COMSIG_MOB_LOGOUT, PROC_REF(unlook))
	RegisterSignal(current_looker, COMSIG_GLOB_MOB_DEATH, PROC_REF(unlook))

	return TRUE

/datum/component/eye/proc/unlook()
	if(!isnull(parent))
		UnregisterSignal(parent, COMSIG_QDELETING)
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

	if(!isnull(component_eye))
		UnregisterSignal(component_eye, COMSIG_QDELETING)
		component_eye.release(current_looker)

	if(!isnull(current_looker))
		UnregisterSignal(current_looker, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_looker, COMSIG_QDELETING)
		UnregisterSignal(current_looker, COMSIG_MOB_LOGOUT)
		UnregisterSignal(current_looker, COMSIG_GLOB_MOB_DEATH)
		if(current_looker.client)
			current_looker.client.eye = current_looker
		current_looker.eyeobj = null
	QDEL_NULL(component_eye)
	if(current_looker)
		for(var/datum/action/A in actions)
			A.Remove(current_looker)
	current_looker = null

/datum/component/eye/proc/get_eye_turf()
	return get_turf(component_eye)

//Every eye created using a subtype of this extension will have this action added for manual unlooking.
/datum/action/eye/unlook
	name = "Stop looking"
	procname = "unlook"
	button_icon_state = "cancel"
	target_type = COMPONENT_TARGET
