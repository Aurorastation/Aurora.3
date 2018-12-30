/obj/machinery/computer/records
	name = "records console"
	desc = "Used to view, edit and maintain records."
	var/records_type = RECORD_GENERAL | RECORD_MEDICAL | RECORD_SECURITY | RECORD_VIRUS | RECORD_WARRANT | RECORD_LOCKED
	var/edit_type = RECORD_GENERAL | RECORD_MEDICAL | RECORD_SECURITY | RECORD_VIRUS | RECORD_WARRANT | RECORD_LOCKED
	var/datum/record/general/active
	var/datum/record/virus/active_virus
	var/default_screen = "general"
	var/typechoices = list(
		"general" = list(
			"phisical_status" = list("Active", "*Deceased*", "*SSD*", "Physically Unfit", "Disabled"),
			"mental_status" = list("Stable", "*Insane*", "*Unstable*", "*Watch*")
		),
		"medical" = list(
			"blood_type" = list("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
		)
	)

/obj/machinery/computer/records/medical
	name = "medical records console"
	desc = "Used to view, edit and maintain medical records."

	icon_screen = "medcomp"
	light_color = "#315ab4"
	req_one_access = list(access_medical_equip, access_forensics_lockers, access_detective, access_hop)
	circuit = /obj/item/weapon/circuitboard/med_data
	records_type = RECORD_MEDICAL
	edit_type = RECORD_MEDICAL
	default_screen = "medical"

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
	edit_type = RECORD_SECURITY
	default_screen = "security"

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
	edit_type = RECORD_GENERAL

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
			"activeview" = "list",
			"defaultview" = default_screen,
			"editable" = edit_type
			)
	
	VUEUI_SET_CHECK(data["avaivabletypes"], records_type, ., data)
	LAZYINITLIST(data["allrecords"])
	for(var/tR in sortRecord(SSrecords.records))
		var/datum/record/general/R = tR
		LAZYINITLIST(data["allrecords"][R.id])
		VUEUI_SET_CHECK(data["allrecords"][R.id]["id"], R.id, ., data)
		VUEUI_SET_CHECK(data["allrecords"][R.id]["name"], R.name, ., data)
		VUEUI_SET_CHECK(data["allrecords"][R.id]["rank"], R.rank, ., data)

	if(records_type & RECORD_LOCKED)
		LAZYINITLIST(data["allrecords_locked"])
		for(var/tR in sortRecord(SSrecords.records_locked))
			var/datum/record/general/R = tR
			LAZYINITLIST(data["allrecords_locked"][R.id])
			VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["id"], R.id, ., data)
			VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["name"], R.name, ., data)
			VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["rank"], R.rank, ., data)

	if(records_type & RECORD_VIRUS)
		LAZYINITLIST(data["record_viruses"])
		for(var/tR in sortRecord(SSrecords.viruses))
			var/datum/record/virus/R = tR
			LAZYINITLIST(data["record_viruses"]["[R.id]"])
			VUEUI_SET_CHECK(data["record_viruses"]["[R.id]"]["id"], R.id, ., data)
			VUEUI_SET_CHECK(data["record_viruses"]["[R.id]"]["name"], R.name, ., data)
	if(active_virus)
		var/returned = active_virus.Listify(1, list(), data["active_virus"])
		if(returned)
			data["active_virus"] = returned
			. = data
	else
		VUEUI_SET_CHECK(data["active_virus"], 0, ., data)
	if(active)
		var/excluded = list()
		if(!(records_type & RECORD_GENERAL)) excluded += active.advanced_fields
		if(!(records_type & RECORD_SECURITY)) excluded += "security"
		if(!(records_type & RECORD_MEDICAL)) excluded += "medical"
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
	if(href_list["setactive_locked"] && (records_type & RECORD_LOCKED))
		active = SSrecords.find_record("id", href_list["setactive_locked"], RECORD_GENERAL | RECORD_LOCKED)
		SSvueui.check_uis_for_change(src)
	if(href_list["setactive_virus"] && (records_type & RECORD_VIRUS))
		active_virus = SSrecords.find_record("id", text2num(href_list["setactive_virus"]), RECORD_VIRUS)
		SSvueui.check_uis_for_change(src)
	if(href_list["editrecord"])
		ApplyRecordEdit(href_list["editrecord"]["key"], href_list["editrecord"]["value"])
	
/obj/machinery/computer/records/proc/ApplyRecordEdit(var/key, var/value)
	world << "[src] tried to edit [src.active] key: [json_encode(key)], value: [value]"

