/obj/machinery/computer/fusion
	icon_keyboard = "yellow_key"
	icon_screen = "solar"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	manufacturer = "hephaestus"
	var/ui_template
	var/initial_id_tag

/obj/machinery/computer/fusion/Initialize()
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	. = ..()

/obj/machinery/computer/fusion/proc/get_local_network()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	return fusion.get_local_network()

/obj/machinery/computer/fusion/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
		fusion.get_new_tag(user)
		return
	else
		return ..()

/obj/machinery/computer/fusion/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ui_interact(user)
	return TRUE

/obj/machinery/computer/fusion/ui_data(mob/user)
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/data = list()
	data["id"] = lan ? lan.id_tag : "unset"
	data["name"] = name
	data["manufacturer"] = manufacturer
	. = data

/obj/machinery/computer/fusion/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, ui_template, name, 400, 500)
		ui.open()
