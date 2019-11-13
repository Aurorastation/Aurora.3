#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/message_monitor
	name = T_BOARD("message monitor console")
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/aiupload
	name = T_BOARD("AI upload console")
	build_path = /obj/machinery/computer/aiupload
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/borgupload
	name = T_BOARD("cyborg upload console")
	build_path = /obj/machinery/computer/borgupload
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/med_data
	name = T_BOARD("medical records console")
	build_path = /obj/machinery/computer/records/medical

/obj/item/circuitboard/pandemic
	name = T_BOARD("PanD.E.M.I.C. 2200")
	build_path = /obj/machinery/computer/pandemic
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/circuitboard/scan_consolenew
	name = T_BOARD("DNA machine")
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/circuitboard/teleporter
	name = T_BOARD("teleporter control console")
	build_path = /obj/machinery/computer/teleporter
	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 2)

/obj/item/circuitboard/secure_data
	name = T_BOARD("security records console")
	build_path = /obj/machinery/computer/records/security

/obj/item/circuitboard/skills
	name = T_BOARD("employment records console")
	build_path = /obj/machinery/computer/records/employment

/obj/item/circuitboard/sentencing
	name = T_BOARD("criminal sentencing console")
	build_path = /obj/machinery/computer/sentencing


/obj/item/circuitboard/atmos_alert
	name = T_BOARD("atmospheric alert console")
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/pod
	name = T_BOARD("massdriver control")
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/robotics
	name = T_BOARD("robotics control console")
	build_path = /obj/machinery/computer/robotics
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/drone_control
	name = T_BOARD("drone control console")
	build_path = /obj/machinery/computer/drone_control
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/cloning
	name = T_BOARD("cloning control console")
	build_path = /obj/machinery/computer/cloning
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)

/obj/item/circuitboard/arcade/battle
	name = T_BOARD("battle arcade machine")
	build_path = /obj/machinery/computer/arcade/battle
	origin_tech = list(TECH_DATA = 1)

/obj/item/circuitboard/arcade/orion_trail
	name = T_BOARD("orion trail arcade machine")
	build_path = /obj/machinery/computer/arcade/orion_trail
	origin_tech = list(TECH_DATA = 1)

/obj/item/circuitboard/turbine_control
	name = T_BOARD("turbine control console")
	build_path = /obj/machinery/computer/turbine_computer

/obj/item/circuitboard/solar_control
	name = T_BOARD("solar control console")
	build_path = /obj/machinery/power/solar_control
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2)

/obj/item/circuitboard/powermonitor
	name = T_BOARD("power monitoring console")
	build_path = /obj/machinery/computer/power_monitor

/obj/item/circuitboard/olddoor
	name = T_BOARD("DoorMex")
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/syndicatedoor
	name = T_BOARD("ProComp Executive")
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/swfdoor
	name = T_BOARD("Magix")
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/prisoner
	name = T_BOARD("prisoner management console")
	build_path = /obj/machinery/computer/prisoner

/obj/item/circuitboard/mecha_control
	name = T_BOARD("exosuit control console")
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/rdservercontrol
	name = T_BOARD("R&D server control console")
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/crew
	name = T_BOARD("crew monitoring console")
	build_path = /obj/machinery/computer/crew
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MAGNET = 2)

/obj/item/circuitboard/operating
	name = T_BOARD("patient monitoring console")
	build_path = /obj/machinery/computer/operating
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/circuitboard/advoperating
	name = T_BOARD("life support table console")
	build_path = /obj/machinery/computer/operating/advanced
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 4)

/obj/item/circuitboard/curefab
	name = T_BOARD("cure fabricator")
	build_path = /obj/machinery/computer/curer

/obj/item/circuitboard/splicer
	name = T_BOARD("disease splicer")
	build_path = /obj/machinery/computer/diseasesplicer

/obj/item/circuitboard/mining_shuttle
	name = T_BOARD("mining shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/mining
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/engineering_shuttle
	name = T_BOARD("engineering shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/engineering
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/research_shuttle
	name = T_BOARD("research shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/research
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/area_atmos
	name = T_BOARD("area air control console")
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = list(TECH_DATA = 2)

/*/obj/item/circuitboard/prison_shuttle
	name = T_BOARD("prison shuttle control console")
	build_path = /obj/machinery/computer/prison_shuttle
	origin_tech = list(TECH_DATA = 2)*/

/obj/item/circuitboard/rcon_console
	name = T_BOARD("RCON remote control console")
	build_path = /obj/machinery/computer/rcon
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)

/obj/item/circuitboard/telesci_console
	name = T_BOARD("Telescience Console")
	build_path = /obj/machinery/computer/telescience
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)

/obj/item/circuitboard/slot_machine
	name = T_BOARD("Slot Machine")
	build_path = /obj/machinery/computer/slot_machine
	origin_tech = list(TECH_DATA = 2)
