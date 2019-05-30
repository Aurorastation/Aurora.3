/obj/item/weapon/shuttle_parts
	name = "shuttle part"
	desc = "What?"
	gender = NEUTER
	icon = 'icons/obj/shuttle_parts.dmi'
	icon_state = "carbon_rod"
	w_class = 2.0
	drop_sound = 'sound/items/drop/sword.ogg'

/obj/item/weapon/shuttle_parts/einstein/bluespace_relay
	name = "Bluespace relay"
	desc = "A cheaply designed bluespace relay of Einstein Engines make. The framed bluespace crystal looks to be of low quality and its potential longevity is questionable."
	icon_state = "bluespace_relay"

/obj/item/weapon/shuttle_parts/einstein/ignition_chamber
	name = "Ignition chamber"
	desc = "Placeholder"
	icon_state = "ignition_chamber"
	w_class = 3.0

/obj/item/weapon/shuttle_parts/einstein/propellant_assembly
	name = "Propellant assembly"
	desc = "Placeholder"
	icon_state = "propellant_assembly"
	w_class = 3.0

/obj/item/weapon/shuttle_parts/einstein/propulsion_electronics
	name = "Propulsion electronics"
	desc = "Placeholder"
	icon_state = "propulsion_electronics"

/obj/item/weapon/circuitboard/ee_engine
	name = T_BOARD("Engine booster circuit")
	desc = "Circuit board designed by Eienstein Engines to control a rocket booster."
	build_path = "/obj/structure/shuttle/engine/propulsion/temp"
	board_type = "machine"
	origin_tech = list(TECH_EGNINEERING = 3, TECH_PHORON = 2)
	req_components = list(
							"/obj/item/weapon/shuttle_parts/einstein/bluespace_relay" = 1, "/obj/item/weapon/shuttle_parts/einstein/ignition_chamber" = 1, 
							"/obj/item/weapon/shuttle_parts/einstein/propellant_assembly" = 1, "/obj/item/weapon/shuttle_parts/einstein/propulsion_electronics" = 1
	)
	