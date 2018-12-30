/obj/machinery/computer/records
	name = "records console"
	desc = "Used to view, edit and maintain records."

/obj/machinery/computer/records/medical
	name = "medical records console"
	desc = "Used to view, edit and maintain medical records."

	icon_screen = "medcomp"
	light_color = "#315ab4"
	req_one_access = list(access_medical_equip, access_forensics_lockers, access_detective, access_hop)
	circuit = /obj/item/weapon/circuitboard/med_data

/obj/machinery/computer/records/security
	name = "security records console"
	desc = "Used to view, edit and maintain security records"

	icon_screen = "security"
	light_color = LIGHT_COLOR_ORANGE
	req_one_access = list(access_security, access_forensics_lockers, access_lawyer, access_hop)
	circuit = /obj/item/weapon/circuitboard/secure_data

/obj/machinery/computer/records/employment
	name = "employment records console"
	desc = "Used to view, edit and maintain employment records."

	icon_state = "medlaptop0"
	icon_screen = "medlaptop"
	light_color = "#00b000"
	req_one_access = list(access_heads)
	circuit = /obj/item/weapon/circuitboard/skills

