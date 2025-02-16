/datum/antagonist/proc/get_panel_entry(var/datum/mind/player)

	var/dat = "<tr><td><b>[role_text]:</b>"
	var/extra = get_extra_panel_options(player)
	if(is_antagonist(player))
		dat += "<a href='byond://?src=[REF(player)];remove_antagonist=[id]'>\[-\]</a>"
		dat += "<a href='byond://?src=[REF(player)];equip_antagonist=[id]'>\[equip\]</a>"
		if(starting_locations && starting_locations.len)
			dat += "<a href='byond://?src=[REF(player)];move_antag_to_spawn=[id]'>\[move to spawn\]</a>"
		if(extra) dat += "[extra]"
	else
		dat += "<a href='byond://?src=[REF(player)];add_antagonist=[id]'>\[+\]</a>"
	dat += "</td></tr>"

	return dat

/datum/antagonist/proc/get_extra_panel_options()
	return

//Overridden elsewhere.
/datum/antagonist/proc/get_additional_check_antag_output(var/datum/admins/requester)
	return ""
