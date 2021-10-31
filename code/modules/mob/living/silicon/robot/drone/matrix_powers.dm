/mob/living/silicon/robot/drone/verb/view_matrix_info()
	set name = "View Matrix Info"
	set desc = "View various information regarding the status of your assigned matrix."
	set category = "Matrix"

	if(!master_matrix)
		to_chat(src, SPAN_WARNING("You do not belong to a matrix!"))
		return

	var/datum/drone_matrix/DM = master_matrix

	var/dat = ""
	var/mob/living/silicon/robot/drone/construction/matriarch/matriarch = DM.get_matriarch()
	if(matriarch)
		var/drone_stat = ""
		if(matriarch.stat == UNCONSCIOUS)
			drone_stat = " (Disabled)"
		else if(matriarch.stat == DEAD)
			drone_stat = " (Destroyed)"
		dat += "<b>Matriarch:</b> [matriarch.designation][drone_stat]<hr>"
	else
		dat += "<b>Matriarch:</b> None<hr>"

	var/list/drone_list = DM.get_drones()
	dat += "<h2>Drones</h2>"
	if(!length(drone_list))
		dat += " - None<br>"
	else
		for(var/mob/living/silicon/robot/drone/D as anything in drone_list)
			var/drone_stat = ""
			if(D.stat == UNCONSCIOUS)
				drone_stat = " (Disabled)"
			else if(D.stat == DEAD)
				drone_stat = " (Destroyed)"
			dat += " - [D.designation][drone_stat]<br>"

	dat += "<h2>Directives</h2>"
	dat += "<b>Area Restriction:</b> [DM.process_level_restrictions ? "Enabled" : "Disabled"]<br>"

	var/datum/browser/matrix_win = new(src, "matrixinfo", "Matrix Information", 450, 500)
	matrix_win.set_content(dat)
	matrix_win.open()

/mob/living/silicon/robot/drone/construction/matriarch/verb/toggle_matrix_level_restrictions()
	set name = "Toggle Matrix Level Restrictions"
	set desc = "Set whether the drones in your matrix should self destruct when they leave station areas."
	set category = "Matrix"

	if(!master_matrix)
		to_chat(src, SPAN_WARNING("You do not belong to a matrix!"))
		return

	master_matrix.process_level_restrictions = !master_matrix.process_level_restrictions
	master_matrix.message_drones(MATRIX_NOTICE("Matrix Update: Drones within this matrix will [master_matrix.process_level_restrictions ? "now" : "no longer"] self destruct when leaving standard operational areas."))
