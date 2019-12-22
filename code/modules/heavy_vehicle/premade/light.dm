/mob/living/heavy_vehicle/premade/light
	name = "light exosuit"
	desc = "A light and agile exosuit."
	icon_state = "odysseus"

/mob/living/heavy_vehicle/premade/light/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/light(src)
		arms.color = COLOR_OFF_WHITE
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/light(src)
		legs.color = COLOR_OFF_WHITE
	if(!head)
		head = new /obj/item/mech_component/sensors/light(src)
		head.color = COLOR_OFF_WHITE
	if(!body)
		body = new /obj/item/mech_component/chassis/light(src)
		body.color = COLOR_OFF_WHITE

	. = ..()

/mob/living/heavy_vehicle/premade/light/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/catapult(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/sleeper(src), HARDPOINT_BACK)
	install_system(new /obj/item/mecha_equipment/light(src), HARDPOINT_HEAD)

/obj/item/mech_component/manipulators/light
	name = "light arms"
	exosuit_desc_string = "lightweight, segmented manipulators"
	icon_state = "light_arms"
	melee_damage = 15
	action_delay = 15
	max_damage = 40
	power_use = 3000
	desc = "As flexible as they are fragile, these Vey-Med manipulators can follow a pilot's movements in close to real time."

/obj/item/mech_component/propulsion/light
	name = "light legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	icon_state = "light_legs"
	move_delay = 2
	turn_delay = 3
	max_damage = 40
	power_use = 3000
	desc = "The electrical systems driving these legs are almost totally silent. Unfortunately slamming a plate of metal against the ground is not."

/obj/item/mech_component/sensors/light
	name = "light sensors"
	gender = PLURAL
	exosuit_desc_string = "advanced sensor array"
	icon_state = "light_head"
	max_damage = 30
	power_use = 12000
	desc = "A series of high resolution optical sensors."
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/light/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_MEDICAL)

/obj/item/mech_component/chassis/light
	name = "light exosuit chassis"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	hatch_descriptor = "canopy"
	exosuit_desc_string = "an open and light chassis"
	icon_state = "light_body"
	max_damage = 50
	power_use = 3000
	desc = "The Veymed Odysseus series cockpits combine ultralight materials and clear aluminum laminates to provide an optimized cockpit experience."


/obj/item/mech_component/chassis/light/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/radproof(src)

/obj/item/mech_component/chassis/light/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = -2),
			"[SOUTH]" = list("x" = 8,  "y" = -2),
			"[EAST]"  = list("x" = 1,  "y" = -2),
			"[WEST]"  = list("x" = 9,  "y" = -2)
		)
	)
	. = ..()

/mob/living/heavy_vehicle/premade/light/legion
	name = "legion support exosuit"
	desc = "A light and agile exosuit painted in the colours of the Tau Ceti Foreign Legion."
	icon_state = "odysseus"

/mob/living/heavy_vehicle/premade/light/legion/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/light(src)
		arms.color = "#849bc1"
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/light(src)
		legs.color = "#849bc1"
	if(!head)
		head = new /obj/item/mech_component/sensors/light(src)
		head.color = "#849bc1"
	if(!body)
		body = new /obj/item/mech_component/chassis/light(src)
		body.color = "#849bc1"

	. = ..()

/mob/living/heavy_vehicle/premade/light/legion/spawn_mech_equipment()
	install_system(new /obj/item/mecha_equipment/clamp(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/medanalyzer(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/sleeper(src), HARDPOINT_BACK)
	install_system(new /obj/item/mecha_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mecha_equipment/mounted_system/flarelauncher(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mecha_equipment/crisis_drone(src), HARDPOINT_LEFT_SHOULDER)
