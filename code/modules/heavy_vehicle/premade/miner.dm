/mob/living/heavy_vehicle/premade/miner
	name = "mining mecha"
	desc = "A mining mecha of custom design, a closed cockpit with powerloader appendages."

/mob/living/heavy_vehicle/premade/miner/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/ripley(src)
		arms.color = "#ffbc37"
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/ripley(src)
		legs.color = "#ffbc37"
	if(!head)
		head = new /obj/item/mech_component/sensors/ripley(src)
		head.color = "#ffbc37"
	if(!body)
		body = new /obj/item/mech_component/chassis/combat(src)
		body.color = "#ffdc37"

	body.armor = new /obj/item/robot_parts/robot_component/armor(src)

	. = ..()

/mob/living/heavy_vehicle/premade/miner/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/mob/living/heavy_vehicle/premade/miner/remote
	name = "remote mining mecha"
	dummy_colour = "#ffc44f"
	remote_network = "remotemechs"

/mob/living/heavy_vehicle/premade/miner/remote_prison
	name = "penal mining mecha"
	dummy_colour = "#302e2b"
	remote_network = "prisonmechs"