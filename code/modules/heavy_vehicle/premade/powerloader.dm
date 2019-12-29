/mob/living/heavy_vehicle/premade/ripley
	name = "power loader"
	desc = "An ancient but well-liked cargo handling exosuit."

/mob/living/heavy_vehicle/premade/ripley/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/ripley(src)
		arms.color = "#ffbc37"
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/ripley(src)
		legs.color = "#ffbc37"
	if(!head)
		head = new /obj/item/mech_component/sensors/ripley(src)
		head.color = "#ffbc37"
	if(!body)
		body = new /obj/item/mech_component/chassis/ripley(src)
		body.color = "#ffdc37"

	body.armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

	. = ..()

/mob/living/heavy_vehicle/premade/ripley/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/ripley
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 70
	power_use = 2000
	melee_damage = 40
	desc = "The Xion Manufacturing Group Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/ripley
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	max_damage = 70
	move_delay = 4
	turn_delay = 4
	power_use = 2000
	trample_damage = 10

/obj/item/mech_component/sensors/ripley
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/sensors/ripley/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/obj/item/mech_component/chassis/ripley
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically."
	max_damage = 100
	power_use = 5000

/obj/item/mech_component/chassis/ripley/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

/obj/item/mech_component/chassis/ripley/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/mob/living/heavy_vehicle/premade/ripley/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool red flames."
	icon_state = "ripley_flames_red"
	decal = "flames_red"

/mob/living/heavy_vehicle/premade/ripley/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool blue flames."
	icon_state = "ripley_flames_blue"
	decal = "flames_blue"

/mob/living/heavy_vehicle/premade/firefighter
	name = "firefighting exosuit"
	desc = "A mix and match of industrial parts designed to withstand fires."
	icon_state = "firefighter"

/mob/living/heavy_vehicle/premade/firefighter/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/ripley(src)
		arms.color = "#385b3c"
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/ripley(src)
		legs.color = "#385b3c"
	if(!head)
		head = new /obj/item/mech_component/sensors/ripley(src)
		head.color = "#385b3c"
	if(!body)
		body = new /obj/item/mech_component/chassis/ripley(src)
		body.color = "#385b3c"

	. = ..()

	material = get_material_by_name("osmium", "carbide", "plasteel")

/mob/living/heavy_vehicle/premade/firefighter/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/extinguisher(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/sensors/firefighter/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/mob/living/heavy_vehicle/premade/combatripley
	name = "combat APLU \"Ripley\""
	desc = "A large APLU unit fitted with specialized composite armor and fancy, though old targeting systems."
	icon_state = "combatripley"
	decal = "ripley_legion"

/mob/living/heavy_vehicle/premade/combatripley/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/ripley(src)
		arms.color = "#849bc1"
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/ripley(src)
		legs.color = "#849bc1"
	if(!head)
		head = new /obj/item/mech_component/sensors/combatripley(src)
		head.color = "#849bc1"
	if(!body)
		body = new /obj/item/mech_component/chassis/ripley(src)
		body.color = "#849bc1"

		body.mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

	. = ..()

/mob/living/heavy_vehicle/premade/combatripley/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/mounted_system/blaster(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/gauss(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/flarelauncher(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mecha_equipment/mounted_system/grenadesmoke(src), HARDPOINT_LEFT_SHOULDER)

/obj/item/mech_component/sensors/combatripley
	name = "exosuit sensors"
	gender = PLURAL
	power_use = 50000
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/combatripley/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_WEAPONS)
