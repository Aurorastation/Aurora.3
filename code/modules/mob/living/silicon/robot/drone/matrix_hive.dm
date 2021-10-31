var/global/list/drone_matrices = list()

/datum/drone_matrix
	var/id = null
	var/datum/weakref/matriarch
	var/list/datum/weakref/drones = list()

	var/process_level_restrictions = TRUE

/datum/drone_matrix/New(var/matrix_id)
	..()
	id = matrix_id
	drone_matrices[id] = src

/datum/drone_matrix/Destroy(force)
	drone_matrices -= id
	return ..()

/datum/drone_matrix/proc/get_matriarch()
	if(matriarch)
		return matriarch.resolve()
	return null

/datum/drone_matrix/proc/get_drones()
	. = list()
	for(var/datum/weakref/drone_ref as anything in drones)
		var/mob/living/silicon/robot/drone/D = drone_ref.resolve()
		if(D)
			. += D


/datum/drone_matrix/proc/message_drones(var/msg)
	var/mob/living/silicon/robot/drone/D = null
	if(matriarch)
		D = matriarch.resolve()
		if(D)
			to_chat(D, msg)

	for(var/datum/weakref/drone_ref as anything in drones)
		D = drone_ref.resolve()
		if(D)
			to_chat(D, msg)

/datum/drone_matrix/proc/add_drone(mob/living/silicon/robot/drone/D)
	if(isMatriarchDrone(D))
		matriarch = WEAKREF(D)
		return
	drones += WEAKREF(D)

/datum/drone_matrix/proc/remove_drone(var/datum/weakref/drone_ref, var/death = TRUE)
	if(drone_ref == matriarch)
		matriarch = null
		if(death)
			message_drones(MATRIX_DANGER("A cold wave washes over your circuits. The matriarch is dead!"))
		return
	drones -= drone_ref
	if(death)
		var/mob/living/silicon/robot/drone/D = drone_ref.resolve()
		if(D)
			message_drones(SPAN_DANGER("Your circuits spark. Drone [D.designation] has died."))


/proc/assign_drone_to_matrix(mob/living/silicon/robot/drone/D, var/matrix_tag)
	var/datum/drone_matrix/DM = drone_matrices[matrix_tag]
	if(!DM)
		DM = new /datum/drone_matrix(matrix_tag)
	D.master_matrix = DM
	DM.add_drone(D)
