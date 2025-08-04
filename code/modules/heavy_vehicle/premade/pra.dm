/mob/living/heavy_vehicle/premade/pra_egg
	name = "\improper P'kus-3 exosuit"
	desc = "An exosuit developed by the People's Republic of Adhomai for the Division Experimental Exosuit."
	icon_state = "egg"

	e_head = /obj/item/mech_component/sensors/pra_egg
	e_body = /obj/item/mech_component/chassis/pra_egg/nuclear
	e_arms = /obj/item/mech_component/manipulators/pra_egg
	e_legs = /obj/item/mech_component/propulsion/pra_egg
	e_color = COLOR_STEEL
	h_head = null
	h_r_hand = /obj/item/mecha_equipment/mounted_system/combat/smg/pra_egg

/obj/item/mech_component/manipulators/pra_egg
	name = "\improper P'kus-3 arms"
	exosuit_desc_string = "flexible arms"
	desc = "Robotics arms designed to carry large weapons."
	icon_state = "egg_arms"
	melee_damage = 15
	action_delay = 5
	max_damage = 100
	power_use = 2500
	has_hardpoints = list(HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_HAND)

/obj/item/mech_component/propulsion/pra_egg
	name = "\improper P'kus-3 legs"
	exosuit_desc_string = "hydraulic legs"
	desc = "Strong legs adapted for the Adhomian rought terrain."
	icon_state = "egg_legs"
	move_delay = 3
	turn_delay = 3
	max_damage = 100
	power_use = 2500
	trample_damage = 15

/obj/item/mech_component/sensors/pra_egg
	name = "\improper P'kus-3 sensors"
	gender = PLURAL
	exosuit_desc_string = "weather-resistant sensors"
	desc = "A round cockpit in the shape of an egg. Its sensors are adapted to the Adhomian winds and hail."
	icon_state = "egg_head"
	max_damage = 50
	power_use = 50000
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/pra_egg/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_UTILITY)

/obj/item/mech_component/chassis/pra_egg
	name = "\improper P'kus-3 chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	exosuit_desc_string = "a light armored chassis"
	desc = "A lightweight composite frame keeps the armor of this chassis respectable, but the interior spacious."
	icon_state = "egg_body"
	max_damage = 150
	power_use = 250

/obj/item/mech_component/chassis/pra_egg/nuclear
	cell_type = /obj/item/cell/mecha/nuclear

/obj/item/mech_component/chassis/pra_egg/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

/mob/living/heavy_vehicle/premade/pra_egg/armored
	desc = "An exosuit developed by the People's Republic of Adhomai for the Division Experimental Exosuit. This one is a heavily armored version."
	icon_state = "egg_heavy"

	e_head = /obj/item/mech_component/sensors/pra_egg/armored
	e_body = /obj/item/mech_component/chassis/pra_egg/armored/nuclear
	e_arms = /obj/item/mech_component/manipulators/pra_egg/armored

/obj/item/mech_component/manipulators/pra_egg/armored
	name = "armored P'kus-3 arms"
	exosuit_desc_string = "armored flexible arms"
	desc = "Armored robotics arms designed to carry large weapons."
	icon_state = "strong_egg_arms"
	melee_damage = 20
	max_damage = 120

/obj/item/mech_component/sensors/pra_egg/armored
	name = "armored P'kus-3 sensors"
	exosuit_desc_string = "weather-resistant armored sensors"
	desc = "An armored cockpit in the shape of an egg. Its sensors are adapted to the Adhomian winds and hail."
	icon_state = "strong_egg_head"
	max_damage = 120

/obj/item/mech_component/chassis/pra_egg/armored/nuclear
	name = "armored P'kus-3 chassis"
	exosuit_desc_string = "an armored chassis"
	desc = "A armored composite frame keeps the armor of this chassis respectable, but the interior spacious."
	icon_state = "strong_egg_body"
	max_damage = 150
	power_use = 250

	cell_type = /obj/item/cell/mecha/nuclear

/obj/item/mech_component/chassis/pra_egg/armored/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)
