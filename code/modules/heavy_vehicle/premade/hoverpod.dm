/mob/living/heavy_vehicle/premade/hoverpod
	name = "hoverpod"
	desc = "An aging exosuit, produced to be a cheap variant to traditional space transport."
	icon_state = "engineering_pod"

/mob/living/heavy_vehicle/premade/hoverpod/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/ripley(src)
		arms.color = COLOR_BLUE_GRAY
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/hover(src)
		legs.color = COLOR_BLUE_GRAY
	if(!head)
		head = new /obj/item/mech_component/sensors/ripley(src)
		head.color = COLOR_BLUE_GRAY
	if(!body)
		body = new /obj/item/mech_component/chassis/pod(src)
		body.color = COLOR_BLUE_GRAY

	. = ..()

/mob/living/heavy_vehicle/premade/hoverpod/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

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
	hatch_descriptor = "window"
	pilot_coverage = 100
	transparent_cabin = TRUE
	hide_pilot = TRUE
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "A simple spherical exosuit cockpit commonly used in space pods."

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/radproof(src)