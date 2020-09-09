/obj/item/mech_component/manipulators/superheavy
	name = "superheavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "strider_arms"
	desc = "These basic, heavy plasteel mounts are used for mounting only the meanest weapons. Probably good at breaking things, too."
	melee_damage = 50
	action_delay = 15
	max_damage = 4000
	power_use = 7500
	has_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/superheavy
	name = "superheavy motivators"
	exosuit_desc_string = "heavy hydraulic legs"
	desc = "Four utterly goliath stump-like pistons hold this propulsion mechanism together."
	icon_state = "strider_legs"
	move_delay = 5
	max_damage = 650
	power_use = 5000
	trample_damage = 45

/obj/item/mech_component/sensors/superheavy
	name = "superheavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A small optic is all that can be discerned of this faceless, unmarked spire of an exosuit control center."
	icon_state = "strider_head"
	max_damage = 550
	power_use = 0

/obj/item/mech_component/sensors/superheavy/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mech_component/chassis/superheavy
	name = "heavy-duty military chassis"
	hatch_descriptor = "hatch"
	desc = "A cramped compartment and a senseless amount of armor is all this steel coffin contains."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armored chassis"
	icon_state = "strider_body"
	max_damage = 750
	mech_health = 3500
	power_use = 15000

/obj/item/mech_component/chassis/superheavy/prebuild()
	. = ..()
	cell = new /obj/item/cell/super(src)
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/mob/living/heavy_vehicle/premade/superheavy
	name = "Basilisk"
	desc = "An incredibly heavy-duty quadruped war machine derived from an Interstellar War design."
	icon_state = "darkgygax"

	e_head = /obj/item/mech_component/sensors/superheavy
	e_body = /obj/item/mech_component/chassis/superheavy
	e_arms = /obj/item/mech_component/manipulators/superheavy
	e_legs = /obj/item/mech_component/propulsion/superheavy
	e_color = COLOR_DARK_GUNMETAL

	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/pulse
	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/pulse