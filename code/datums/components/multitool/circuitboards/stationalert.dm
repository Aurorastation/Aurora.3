/obj/item/circuitboard/stationalert/Initialize()
	. = ..()
	AddComponent(/datum/component/multitool/circuitboards, CALLBACK(src, PROC_REF(get_multitool_ui)), CALLBACK(src, PROC_REF(get_multitool_ui)))

/obj/item/circuitboard/stationalert/proc/get_multitool_ui(var/mob/user, var/obj/item/device/multitool/MT, var/datum/component/multitool/C)
	. += "<b>Alarm Sources</b><br>"
	. += "<table>"
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		. += "<tr>"
		. += "<td>[AH.category]</td>"
		if(AH in alarm_handlers)
			. += "<td><span class='good'>&#9724</span>Active</td><td><a href='?src=\ref[C];remove=\ref[AH]'>Inactivate</a></td>"
		else
			. += "<td><span class='bad'>&#9724</span>Inactive</td><td><a href='?src=\ref[C];add=\ref[AH]'>Activate</a></td>"
		. += "</tr>"
	. += "</table>"

/obj/item/circuitboard/stationalert/proc/on_topic(href, href_list, var/mob/user, var/datum/component/multitool/MT)
	if(href_list["add"])
		var/datum/alarm_handler/AH = locate(href_list["add"]) in SSalarm.all_handlers
		if(AH)
			alarm_handlers |= AH
			return MT_REFRESH

	if(href_list["remove"])
		var/datum/alarm_handler/AH = locate(href_list["remove"]) in SSalarm.all_handlers
		if(AH)
			alarm_handlers -= AH
			return MT_REFRESH

	return MT_NOACTION
