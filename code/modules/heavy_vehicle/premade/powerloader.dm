/mob/living/heavy_vehicle/premade/ripley
	name = "power loader"
	desc = "An ancient but well-liked cargo handling exosuit."

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_RIPLEY

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/clamp

/mob/living/heavy_vehicle/premade/ripley/Initialize()
	. = ..()
	body.armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

/mob/living/heavy_vehicle/premade/ripley/cargo
	h_back = /obj/item/mecha_equipment/autolathe

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

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = "#385b3c"

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/mounted_system/extinguisher

/mob/living/heavy_vehicle/premade/firefighter/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name(MATERIAL_PLASTEEL)

/obj/item/mech_component/sensors/firefighter/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/mob/living/heavy_vehicle/premade/combatripley
	name = "combat APLU \"Ripley\""
	desc = "A large APLU unit fitted with specialized composite armor and fancy, though old targeting systems."
	icon_state = "combatripley"
	decal = "ripley_legion"

	e_head = /obj/item/mech_component/sensors/combatripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_TCFL

	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/grenadesmoke
	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/flarelauncher
	h_l_hand = /obj/item/mecha_equipment/mounted_system/blaster
	h_r_hand = /obj/item/mecha_equipment/mounted_system/gauss

/mob/living/heavy_vehicle/premade/combatripley/Initialize()
	. = ..()
	body.mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

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

/mob/living/heavy_vehicle/premade/ripley/remote
	name = "remote power loader"
	dummy_colour = "#ffc44f"
	remote_network = "remotemechs"

/mob/living/heavy_vehicle/premade/ripley/remote_prison
	name = "penal power loader"
	dummy_colour = "#302e2b"
	remote_network = "prisonmechs"