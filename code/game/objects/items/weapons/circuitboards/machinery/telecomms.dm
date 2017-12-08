#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

	board_type = "machine"

	name = T_BOARD("subspace receiver")
	build_path = "/obj/machinery/telecomms/receiver"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	req_components = list(

	name = T_BOARD("hub mainframe")
	build_path = "/obj/machinery/telecomms/hub"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("relay mainframe")
	build_path = "/obj/machinery/telecomms/relay"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("bus mainframe")
	build_path = "/obj/machinery/telecomms/bus"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 1,

	name = T_BOARD("processor unit")
	build_path = "/obj/machinery/telecomms/processor"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,

	name = T_BOARD("telecommunication server")
	build_path = "/obj/machinery/telecomms/server"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	req_components = list(
							"/obj/item/stack/cable_coil" = 1,

	name = T_BOARD("subspace broadcaster")
	build_path = "/obj/machinery/telecomms/broadcaster"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	req_components = list(
							"/obj/item/stack/cable_coil" = 1,
