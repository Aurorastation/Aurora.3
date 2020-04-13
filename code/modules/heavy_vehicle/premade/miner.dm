/mob/living/heavy_vehicle/premade/miner
	name = "mining mecha"
	desc = "A mining mecha of custom design, a closed cockpit with powerloader appendages."

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/combat
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_RIPLEY

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/clamp

/mob/living/heavy_vehicle/premade/miner/Initialize()
	. = ..()
	body.armor = new /obj/item/robot_parts/robot_component/armor(src)

/mob/living/heavy_vehicle/premade/miner/remote
	name = "remote mining mecha"
	dummy_colour = "#ffc44f"
	remote_network = "remotemechs"

/mob/living/heavy_vehicle/premade/miner/remote_prison
	name = "penal mining mecha"
	dummy_colour = "#302e2b"
	remote_network = "prisonmechs"