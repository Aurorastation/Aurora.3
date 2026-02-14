/datum/admin_secret_item/admin_secret/jump_shuttle
	name = "Jump a Shuttle"

/datum/admin_secret_item/admin_secret/jump_shuttle/can_execute(var/mob/user)
	if(!SSshuttle) return 0
	return ..()

/datum/admin_secret_item/admin_secret/jump_shuttle/execute(var/mob/user)
	if(!(. = ..()))
		return
	var/shuttle_tag = tgui_input_list(user, "Which shuttle do you want to jump?", "Pick Shuttle", SSshuttle.shuttles)
	if (!shuttle_tag) return

	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_tag]

	var/destination_tag = tgui_input_list(user, "Where do you want to jump to?", "Jump Shuttle", SSshuttle.registered_shuttle_landmarks)

	if (!destination_tag) return
	var/obj/effect/shuttle_landmark/destination = SSshuttle.registered_shuttle_landmarks[destination_tag]

	var/move_duration = tgui_input_number(user, "How many seconds will this jump take?", "Jump Duration", 0)
	message_admins(SPAN_NOTICE("[key_name_admin(user)] has initiated a jump from [S.current_location] to [destination] lasting [move_duration] seconds for the [shuttle_tag] shuttle"), 1)
	log_admin("[key_name(user)] has initiated a jump from [S.current_location] to [destination] lasting [move_duration] seconds for the [shuttle_tag] shuttle")

	S.spoolup(destination)
	S.takeoff(destination, move_duration SECONDS)
