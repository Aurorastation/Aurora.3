/mob/living/heavy_vehicle/premade/hoverpod
	name = "hoverpod"
	desc = "An aging exosuit, produced to be a cheap variant to traditional space transport."
	icon_state = "engineering_pod"

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/pod
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/hover
	e_color = COLOR_BLUE_GRAY

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/clamp

/obj/item/mech_component/propulsion/hover
	name = "hover thrusters"
	exosuit_desc_string = "hover thrusters"
	desc = "An ancient set of hover thrusters capable of keeping a exosuit aloft."
	icon_state = "hoverlegs"
	mech_turn_sound = null
	mech_step_sound = null
	max_damage = 40
	move_delay = 4
	turn_delay = 2
	power_use = 3000
	trample_damage = 0
	hover = TRUE

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	desc = "A simple spherical exosuit cockpit commonly used in space pods."
	hatch_descriptor = "window"
	pilot_coverage = 100
	transparent_cabin = TRUE
	hide_pilot = TRUE
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/radproof(src)