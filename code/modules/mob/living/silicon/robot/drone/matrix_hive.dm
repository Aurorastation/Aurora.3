/datum/drone_matrix
	var/id = null
	var/datum/weakref/matriarch
	var/list/datum/weakref/drones

	var/process_self_destruct = TRUE

/datum/drone_matrix/proc/get_matriarch()
	if(matriarch)
		return matriarch.resolve()
	return null

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

/datum/drone_matrix/proc/remove_drone(var/datum/weakref/drone_ref, var/death = TRUE)
	if(drone_ref == matriarch)
		matriarch = null
		message_drones(FONT_LARGE(SPAN_DANGER("A cold wave washes over your circuits. The matriarch is dead!")))
		return
	drones -= drone_ref
	message_drones(SPAN_DANGER("Your circuits spark. []"))
