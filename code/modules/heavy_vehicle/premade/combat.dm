/mob/living/heavy_vehicle/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."
	icon_state = "durand"

/mob/living/heavy_vehicle/premade/combat/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/combat(src)
		arms.color = COLOR_DARK_GUNMETAL
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/combat(src)
		legs.color = COLOR_DARK_GUNMETAL
	if(!head)
		head = new /obj/item/mech_component/sensors/combat(src)
		head.color = COLOR_DARK_GUNMETAL
	if(!body)
		body = new /obj/item/mech_component/chassis/combat(src)
		body.color = COLOR_DARK_GUNMETAL

	. = ..()

/mob/living/heavy_vehicle/premade/combat/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "combat_arms"
	melee_damage = 30
	action_delay = 10
	power_use = 5000

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "combat_legs"
	move_delay = 3
	turn_delay = 3
	power_use = 5000

/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution sensors"
	icon_state = "combat_head"
	power_use = 50000
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/combat/prebuild()
	..()
	software = new(src)
	software.installed_software |= MECH_SOFTWARE_WEAPONS
	software.installed_software |= MECH_SOFTWARE_ADVWEAPONS

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	exosuit_desc_string = "an armoured chassis"
	icon_state = "combat_body"
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