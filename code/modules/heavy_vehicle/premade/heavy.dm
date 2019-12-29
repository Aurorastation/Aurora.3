/mob/living/heavy_vehicle/premade/heavy
	name = "Heavy exosuit"
	desc = "A heavily armored combat exosuit."
	icon_state = "durand"

/mob/living/heavy_vehicle/premade/heavy/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/heavy(src)
		arms.color = COLOR_TITANIUM
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy(src)
		legs.color = COLOR_TITANIUM
	if(!head)
		head = new /obj/item/mech_component/sensors/heavy(src)
		head.color = COLOR_TITANIUM
	if(!body)
		body = new /obj/item/mech_component/chassis/heavy(src)
		body.color = COLOR_TITANIUM

	. = ..()

	install_system(new /obj/item/mecha_equipment/mounted_system/taser/laser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	melee_damage = 50
	action_delay = 15
	max_damage = 90
	power_use = 7500
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy hydraulic legs"
	desc = "Oversized actuators struggle to move these armoured legs. "
	icon_state = "heavy_legs"
	move_delay = 5
	max_damage = 90
	power_use = 5000

/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 120
	power_use = 0

/obj/item/mech_component/sensors/heavy/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 150
	mech_health = 500
	has_hardpoints = list(HARDPOINT_BACK)
	power_use = 5000

/obj/item/mech_component/chassis/heavy/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/obj/item/mech_component/chassis/superheavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 150
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	power_use = 15000

/obj/item/mech_component/chassis/superheavy/prebuild()
	. = ..()
	cell = new /obj/item/cell/super(src)
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/mob/living/heavy_vehicle/premade/superheavy
	name = "Marauder"
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	icon_state = "darkgygax"

/mob/living/heavy_vehicle/premade/superheavy/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/heavy(src)
		arms.color = COLOR_DARK_GUNMETAL
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy(src)
		legs.color = COLOR_DARK_GUNMETAL
	if(!head)
		head = new /obj/item/mech_component/sensors/heavy(src)
		head.color = COLOR_DARK_GUNMETAL
	if(!body)
		body = new /obj/item/mech_component/chassis/superheavy(src)
		body.color = COLOR_DARK_GUNMETAL

	. = ..()

/mob/living/heavy_vehicle/premade/superheavy/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mecha_equipment/mounted_system/missile(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mecha_equipment/mounted_system/pulse(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/smg(src), HARDPOINT_RIGHT_HAND)