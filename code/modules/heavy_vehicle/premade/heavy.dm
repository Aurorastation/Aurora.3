/mob/living/heavy_vehicle/premade/heavy
	name = "Heavy exosuit"
	desc = "A heavily armored combat exosuit."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/heavy
	e_body = /obj/item/mech_component/chassis/heavy
	e_arms = /obj/item/mech_component/manipulators/heavy
	e_legs = /obj/item/mech_component/propulsion/heavy
	e_color = COLOR_TITANIUM

	h_l_hand = /obj/item/mecha_equipment/mounted_system/combat/laser
	h_r_hand = /obj/item/mecha_equipment/mounted_system/combat/ion
	h_back = /obj/item/mecha_equipment/shield

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	melee_damage = 50
	action_delay = 15
	max_damage = 200
	power_use = 7500
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy hydraulic legs"
	desc = "Oversized actuators struggle to move these armored legs."
	icon_state = "heavy_legs"
	move_delay = 5
	max_damage = 200
	power_use = 5000
	trample_damage = 45

/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armor plates."
	icon_state = "heavy_head"
	max_damage = 240
	power_use = 0

/obj/item/mech_component/sensors/heavy/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_UTILITY)

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armored chassis"
	icon_state = "heavy_body"
	max_damage = 300
	mech_health = 1000
	has_hardpoints = list(HARDPOINT_BACK)
	power_use = 5000

/obj/item/mech_component/chassis/heavy/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

