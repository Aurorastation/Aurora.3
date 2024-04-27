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

	dat += "<h2>Upgrades</h2>"
	if(!length(DM.bought_upgrades))
		dat += " - None<br>"
	else
		for(var/upgrade in DM.bought_upgrades)
			dat += " - [upgrade]<br>"

	var/datum/browser/matrix_win = new(src, "matrixinfo", "Matrix Information", 250, 350)
	matrix_win.set_content(dat)
	matrix_win.open()

/mob/living/silicon/robot/drone/verb/view_own_matrix_upgrades()
	set name = "View Own Matrix Upgrades"
	set desc = "View the matrix upgrades applied to your own chassis."
	set category = "Matrix"

	if(!LAZYLEN(matrix_upgrades))
		to_chat(src, SPAN_WARNING("You have no matrix upgrades."))
		return

	to_chat(src, SPAN_NOTICE("Matrix upgrades active on chassis: [english_list(matrix_upgrades)]"))

/mob/living/silicon/robot/drone/construction/matriarch/verb/select_matrix_upgrades()
	set name = "Select Matrix Upgrades"
	set desc = "Select the upgrades to apply to the drones within your matrix."
	set category = "Matrix"

	if(!master_matrix)
		to_chat(src, SPAN_WARNING("You do not belong to a matrix!"))
		return

	var/datum/drone_matrix/DM = master_matrix
	if(!DM.upgrades_remaining)
		to_chat(src, SPAN_WARNING("The matrix cannot support more upgrades!"))
		return

	var/list/selectable_upgrades = ALL_MATRIX_UPGRADES - DM.bought_upgrades
	if(!length(selectable_upgrades))
		to_chat(src, SPAN_WARNING("There are no more matrix upgrades to select!"))
		return

	var/selected_upgrade = input(src, "Select an upgrade for your matrix drones. ([DM.upgrades_remaining] Upgrades Remaining)", "Matrix Upgrades") as null|anything in selectable_upgrades
	if(!selected_upgrade)
		return

	DM.buy_upgrade(selected_upgrade)
