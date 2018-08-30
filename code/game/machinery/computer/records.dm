/obj/machinery/computer/records
	name = "records console"
	desc = "Used to view, edit and maintain records."
	var/records_type = RECORD_GENERAL | RECORD_MEDICAL | RECORD_SECURITY
	var/datum/record/general/active

/obj/machinery/computer/records/medical
	name = "medical records console"
	desc = "Used to view, edit and maintain medical records."

	icon_screen = "medcomp"
	light_color = "#315ab4"
	req_one_access = list(access_medical_equip, access_forensics_lockers, access_detective, access_hop)
	circuit = /obj/item/weapon/circuitboard/med_data
	records_type = RECORD_MEDICAL

/obj/machinery/computer/records/medical/laptop
	name = "medical laptop"
	desc = "A cheap laptop."

	icon_state = "medlaptop0"
	icon_screen = "medlaptop"
	is_holographic = FALSE

/obj/machinery/computer/records/security
	name = "security records console"
	desc = "Used to view, edit and maintain security records"

	icon_screen = "security"
	light_color = LIGHT_COLOR_ORANGE
	req_one_access = list(access_security, access_forensics_lockers, access_lawyer, access_hop)
	circuit = /obj/item/weapon/circuitboard/secure_data
	records_type = RECORD_SECURITY

/obj/machinery/computer/records/security/detective
	icon_state = "messyfiles"
	icon_screen = null
	light_range_on = 0
	light_power_on = 0

/obj/machinery/computer/records/employment
	name = "employment records console"
	desc = "Used to view, edit and maintain employment records."

	icon_state = "medlaptop0"
	icon_screen = "medlaptop"
	light_color = "#00b000"
	req_one_access = list(access_heads)
	circuit = /obj/item/weapon/circuitboard/skills
	records_type = RECORD_GENERAL | RECORD_SECURITY

/obj/machinery/computer/records/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "records-main", 450, 350, capitalize(src.name))
	ui.open()

/obj/machinery/computer/records/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/records/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/records/vueui_data_change(var/list/data, var/mob/user, var/vueui/ui)
	if(!data)
		. = data = list(
			"activeview" = "list" 
			)
	
	VUEUI_SET_CHECK(data["avaivabletypes"], records_type, ., data)
	LAZYINITLIST(data["allrecords"])
	for(var/tR in SSrecords.records)
		var/datum/record/general/R = tR
		LAZYINITLIST(data["allrecords"][R.id])
		VUEUI_SET_CHECK(data["allrecords"][R.id]["id"], R.id, ., data)
		VUEUI_SET_CHECK(data["allrecords"][R.id]["name"], R.name, ., data)
		VUEUI_SET_CHECK(data["allrecords"][R.id]["rank"], R.rank, ., data)

	if(active)
		var/excluded = list()
		if(!(records_type & RECORD_GENERAL)) excluded += active.advanced_fields
		if(!(records_type & RECORD_SECURITY)) excluded += list("security")
		if(!(records_type & RECORD_MEDICAL)) excluded += list("medical")
		var/returned = active.Listify(1, excluded, data["active"])
		if(returned)
			data["active"] = returned
			. = data
	else
		VUEUI_SET_CHECK(data["active"], 0, ., data)

/obj/machinery/computer/records/Topic(href, href_list)
	if(href_list["setactive"])
		active = SSrecords.find_record("id", href_list["setactive"])
		SSvueui.check_uis_for_change(src)

#define UIDEBUG