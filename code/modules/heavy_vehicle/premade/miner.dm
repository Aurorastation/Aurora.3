/mob/living/heavy_vehicle/premade/miner
	name = "mining mecha"
	desc = "A mining mecha of custom design, a closed cockpit with powerloader appendages."

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/combat/cell
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_RIPLEY

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/clamp
	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/mining/kinetic_accelerator/heavy
	h_back = /obj/item/mecha_equipment/ore_summoner

/mob/living/heavy_vehicle/premade/miner/remote
	name = "remote mining mecha"
	dummy_colour = "#ffc44f"
	remote_network = REMOTE_GENERIC_MECH
	does_hardpoint_lock = FALSE

/mob/living/heavy_vehicle/premade/miner/remote_prison
	name = "penal mining mecha"
	dummy_colour = "#302e2b"
	remote_network = REMOTE_PRISON_MECH
	remote_type = /obj/item/remote_mecha/penal

/mob/living/heavy_vehicle/premade/salvage
	name = "salvage exosuit"
	desc = "An exosuit of unknown design, with a closed cockpit and quadruped motivators."
	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/combat/nuclear
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/spider
	e_color = "#b07f0c"

	h_l_hand = /obj/item/mecha_equipment/clamp
	h_r_hand = /obj/item/mecha_equipment/mounted_system/plasmacutter
