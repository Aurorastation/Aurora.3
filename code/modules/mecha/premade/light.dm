/mob/living/heavy_vehicle/premade/odysseus
	name = "light exosuit"
	desc = "A sleek and fast-moving suit. Light on armour and support systems."
/mob/living/heavy_vehicle/premade/odysseus/New()
	if(!arms) arms = new /obj/item/mech_component/manipulators/odysseus(src)
	if(!legs) legs = new /obj/item/mech_component/propulsion/odysseus(src)
	if(!head) head = new /obj/item/mech_component/sensors/odysseus(src)
	if(!body) body = new /obj/item/mech_component/chassis/odysseus(src)
	..()
	install_system(new /obj/item/weapon/mecha_equipment/mounted_system/weapon/taser(src), HARDPOINT_LEFT_HAND)
	install_system(new 	/obj/item/weapon/mecha_equipment/mounted_system/plasmacutter(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/weapon/mecha_equipment/sleeper(src), HARDPOINT_BACK)

/obj/item/mech_component/manipulators/odysseus
	name = "light exosuit arms"
	icon_state = "light_arms"
	has_hardpoints = list(
		HARDPOINT_LEFT_HAND,
		HARDPOINT_RIGHT_HAND,
		HARDPOINT_BACK
		)
/obj/item/mech_component/propulsion/odysseus
	name = "light exosuit legs"
	icon_state = "light_legs"
	move_speed = 1
/obj/item/mech_component/sensors/odysseus
	name = "light exosuit sensors"
	icon_state = "light_head"
/obj/item/mech_component/sensors/odysseus/prebuild()
	..()
	software = new(src)
	software.installed_software |= MECH_SOFTWARE_UTILITY
	software.installed_software |= MECH_SOFTWARE_WEAPONS
	software.installed_software |= MECH_SOFTWARE_MEDICAL
/obj/item/mech_component/chassis/odysseus
	name = "light exosuit chassis"
	icon_state = "light_body"