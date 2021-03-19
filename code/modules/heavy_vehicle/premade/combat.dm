/mob/living/heavy_vehicle/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/combat
	e_body = /obj/item/mech_component/chassis/combat
	e_arms = /obj/item/mech_component/manipulators/combat
	e_legs = /obj/item/mech_component/propulsion/combat
	e_color = COLOR_DARK_GUNMETAL

	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/combat/smg
	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/combat/smg

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	desc = "Extremely fast and responsive weapon mounts for combat mechas. These seem sturdy, but their short nature only permits access to shoulder-mounted weapons."
	icon_state = "combat_arms"
	melee_damage = 30
	action_delay = 5
	max_damage = 130
	power_use = 5000
	has_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	desc = "Complex armor provides excellent protective coverage over the internals of these combat-oriented legs."
	icon_state = "combat_legs"
	move_delay = 3
	turn_delay = 3
	max_damage = 100
	power_use = 5000
	trample_damage = 35

/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution sensors"
	desc = "A highly advanced cockpit with high-resolution thermal optics installed on its faces. Poorly armored with excellent situational awareness."
	icon_state = "combat_head"
	max_damage = 50
	power_use = 50000
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/combat/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_UTILITY)

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	exosuit_desc_string = "an armored chassis"
	desc = "A lightweight composite frame keeps the armor of this chassis respectable, but the interior spacious."
	icon_state = "combat_body"
	max_damage = 200
	power_use = 2500
	transparent_cabin =  TRUE

/obj/item/mech_component/chassis/combat/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/obj/item/mech_component/chassis/combat/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()