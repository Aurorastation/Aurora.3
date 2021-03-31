/obj/machinery/nanomachine_incubator
	name = "nanomachine incubator"
	desc = "An advanced machine capable of generating nanomachines with various programs loaded into them."
	desc_fluff = "Created in coordination with all the SCC companies, this machine combines the strengths of all of them to create a man-to-machine interface."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "processor"

/obj/machinery/nanomachine_incubator/update_icon(var/power_state)
	if(!power_state)
		power_state = !(stat & (BROKEN|NOPOWER|EMPED))
	icon_state = "processor[power_state ? "" : "_off"]"

/obj/machinery/nanomachine_incubator/machinery_process()
	if(stat & (BROKEN|NOPOWER|EMPED))
		update_icon(FALSE)
		return
	update_icon(TRUE)

/obj/machinery/nanomachine_incubator/attack_hand(var/mob/user)
	if(..())
		return

	ui_interact(user)

/obj/machinery/nanomachine_incubator/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "medical-nanomachineincubator", 600, 500, capitalize(name))
		ui.auto_update_content = TRUE
	ui.open()

/obj/machinery/nanomachine_incubator/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		data = list()
	data["bongus"] = 1
	return data