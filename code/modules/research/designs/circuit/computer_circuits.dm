/datum/design/circuit/computer
	design_order = 1

/datum/design/circuit/computer/AssembleDesignName()
	..()
	name = "Computer Circuit Design ([item_name])"

/datum/design/circuit/computer/seccamera
	name = "Security Camera Monitor"
	build_path = /obj/item/circuitboard/security

/datum/design/circuit/computer/prisonmanage
	name = "Prisoner Management Console"
	build_path = /obj/item/circuitboard/prisoner

/datum/design/circuit/computer/sentencing
	name = "Criminal Sentencing Console"
	build_path = /obj/item/circuitboard/sentencing

/datum/design/circuit/computer/operating
	name = "Patient Monitoring Console"
	build_path = /obj/item/circuitboard/operating

/datum/design/circuit/computer/pandemic
	name = "PanD.E.M.I.C. 2200"
	build_path = /obj/item/circuitboard/pandemic

/datum/design/circuit/computer/teleconsole
	name = "Teleporter Control Console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/circuit/computer/robocontrol
	name = "Robotics Control Console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics

/datum/design/circuit/computer/rdconsole
	name = "R&D Control Console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/circuit/computer/comm_monitor
	name = "Telecommunications Monitoring Console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/circuit/computer/comm_server
	name = "Telecommunications Server Monitoring Console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/circuit/computer/message_monitor
	name = "Messaging Monitor Console"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/circuit/computer/aiupload
	name = "AI Upload Console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/circuit/computer/borgupload
	name = "Cyborg Upload Console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/circuit/computer/atmosalerts
	name = "Atmosphere Alert Console"
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/circuit/computer/air_management
	name = "Atmosphere Monitoring Console"
	build_path = /obj/item/circuitboard/air_management

/datum/design/circuit/computer/rcon_console
	name = "RCON Remote Control Console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console

/datum/design/circuit/computer/dronecontrol
	name = "Drone Control Console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control

/datum/design/circuit/computer/powermonitor
	name = "Power Monitoring Console"
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/circuit/computer/solarcontrol
	name = "Solar Control Console"
	build_path = /obj/item/circuitboard/solar_control

/datum/design/circuit/computer/telesci_console
	name = "Telepad Control Console"
	build_path = /obj/item/circuitboard/telesci_console