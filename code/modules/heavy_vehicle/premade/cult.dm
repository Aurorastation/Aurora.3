// adminspawn only
/mob/living/heavy_vehicle/premade/cult
	name = "Daemon Exosuit"
	desc = "An unholy construction, a mecha ripped from the jaws of the underworld, here to wreak havoc on the living."
	icon_state = "cult"

	e_head = /obj/item/mech_component/sensors/cult
	e_body = /obj/item/mech_component/chassis/cult
	e_arms = /obj/item/mech_component/manipulators/cult
	e_legs = /obj/item/mech_component/propulsion/cult
	e_color = null // Uses pre-coloured assets

	h_head = /obj/item/mecha_equipment/light/cult
	h_back = /obj/item/mecha_equipment/quick_enter
	h_r_hand = /obj/item/mecha_equipment/doomblade

/mob/living/heavy_vehicle/premade/cult/super
	h_l_hand = /obj/item/mecha_equipment/mounted_system/soul_javelin

/obj/item/mech_component/manipulators/cult
	name = "daemon arms"
	desc = "Forged by the Great Unknown, these arms wield dark weapons gifted by Nar'Sie."
	exosuit_desc_string = "bloodpact reinforced manipulators"
	icon_state = "cult_arms"
	melee_damage = 50
	action_delay = 5
	max_damage = 90
	power_use = 3500
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/cult
	name = "daemon legs"
	desc = "Moving with purpose, these legs can take a follower of Nar'Sie where judgement must be executed."
	exosuit_desc_string = "bloodbound hydraulic legs"
	icon_state = "cult_legs"
	move_delay = 5
	max_damage = 90
	power_use = 2500
	trample_damage = 45

/obj/item/mech_component/sensors/cult
	name = "daemon sensors"
	desc = "A hard shell to protect those that follow the Great One, these sensors assist in the slaughter."
	exosuit_desc_string = "oozing sensor array"
	icon_state = "cult_head"
	max_damage = 120
	power_use = 0

/obj/item/mech_component/sensors/cult/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_CULT)

/obj/item/mech_component/chassis/cult
	name = "daemon exosuit chassis"
	desc = "Despite its looks, this protective chassis provides supreme comfort to its pilot during their conquest."
	hatch_descriptor = "bloodied ribcage"
	pilot_coverage = 100
	exosuit_desc_string = "a bloodied chassis"
	icon_state = "cult_body"
	max_damage = 150
	mech_health = 500
	power_use = 500

/obj/item/mech_component/chassis/cult/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/obj/item/mecha_equipment/light/cult
	name = "daemon floatlights"
	desc = "Levitating floatlamps held aloft by daemon energy. Casts a crimson light."
	icon_state = "mecha_bulb"
	mech_layer = MECH_GEAR_LAYER
	restricted_software = list(MECH_SOFTWARE_CULT)

	light_color = LIGHT_COLOR_EMERGENCY
