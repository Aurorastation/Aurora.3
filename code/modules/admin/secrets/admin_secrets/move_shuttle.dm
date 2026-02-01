/datum/admin_secret_item/admin_secret/move_shuttle
	name = "Move a Shuttle"

/datum/admin_secret_item/admin_secret/move_shuttle/can_execute(var/mob/user)
	if(!SSshuttle)
		return 0
	return ..()

/datum/admin_secret_item/admin_secret/move_shuttle/execute(var/mob/user)
	if(!(. = ..()))
		return
	var/confirm = tgui_alert(user, "This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", list("OK", "Cancel"))
	if(confirm == "Cancel")
		return

	var/shuttle_tag = tgui_input_list(user, "Which shuttle do you want to move?", "Pick Shuttle", SSshuttle.shuttles)
	if(!shuttle_tag)
		return

	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_tag]

	var/destination_tag = tgui_input_list(user, "Where do you want to move to?", "Move Shuttle", SSshuttle.registered_shuttle_landmarks)

	if (!destination_tag) return
	var/obj/effect/shuttle_landmark/destination = SSshuttle.registered_shuttle_landmarks[destination_tag]

	S.transit_to_landmark(destination, S.overmap_shuttle.fore_dir, force = TRUE)
	log_and_message_admins("moved the [shuttle_tag] shuttle to [destination] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[destination.x];Y=[destination.y];Z=[destination.z]'>JMP</a>)", user)
