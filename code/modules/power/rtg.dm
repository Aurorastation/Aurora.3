// Radioisotope Thermoelectric Generator (RTG)
// Simple power generator that would replace "magic SMES" on various derelicts.

/obj/structure/machinery/power/rtg
	name = "radioisotope thermoelectric generator"
	desc = "A simple nuclear power generator, used in small outposts to reliably provide power for decades."
	icon = 'icons/obj/power.dmi'
	icon_state = "rtg"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_OFF

	// You can buckle someone to RTG, then open its panel. Fun stuff.
	can_buckle = list(/mob/living)
	buckle_lying = FALSE
	buckle_require_restraints = TRUE

	var/power_gen = 4000 // Enough to power a single APC. 16000 output with T4 capacitor.
	var/reactor_tuned = FALSE

	var/irradiate = TRUE // RTGs irradiate surroundings, but only when panel is open.

	component_types = list(
		/obj/item/stack/cable_coil{amount = 5},
		/obj/item/stock_parts/capacitor,
		/obj/item/stack/material/uranium{amount = 10},
		/obj/item/circuitboard/rtg
	)

	parts_power_mgmt = FALSE

/obj/structure/machinery/power/rtg/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>capacitors</b> will increase maximum power output."

/obj/structure/machinery/power/rtg/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	var/skill_level = GET_SKILL_LEVEL(user, REACTOR_SYSTEMS_SKILL_COMPONENT)
	if(isnull(skill_level) || skill_level >= SKILL_LEVEL_TRAINED)
		. += SPAN_NOTICE("<b>RTG Diagnostics:</b> Output: [power_wattage_readable(power_gen)]")
		if(panel_open && irradiate)
			. += SPAN_DANGER("Warning: Maintenance panel is open and the radioisotope core is actively irradiating the surroundings!")

/obj/structure/machinery/power/rtg/Initialize()
	. = ..()
	connect_to_network()

/obj/structure/machinery/power/rtg/process()
	..()
	ADD_TO_POWERNET(src, power_gen)
	if(panel_open && irradiate)
		for (var/mob/living/L in range(2, src))
			L.apply_damage(10, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)	// Weak but noticeable.

/obj/structure/machinery/power/rtg/update_icon()
	icon_state = panel_open ? "[initial(icon_state)]-open" : initial(icon_state)

/obj/structure/machinery/power/rtg/AltClick(mob/user)
	var/tune_result = attempt_skill_tuning(user, REACTOR_SYSTEMS_SKILL_COMPONENT, reactor_tuned, "calibrating the thermocouple array of", "\the [src] for +20% power output")
	if(isnull(tune_result))
		return ..()
	if(tune_result && !reactor_tuned)
		reactor_tuned = TRUE
		power_gen = round(power_gen * 1.2)
	return TRUE

/obj/structure/machinery/power/rtg/RefreshParts()
	..()
	var/part_level = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		part_level += SP.rating

	power_gen = round(initial(power_gen) * part_level * (reactor_tuned ? 1.2 : 1))

/obj/structure/machinery/power/rtg/attackby(obj/item/attacking_item, mob/user, params)
	if(default_part_replacement(user, attacking_item))
		return
	else if(default_deconstruction_screwdriver(user, attacking_item))
		return
	else if(default_deconstruction_crowbar(user, attacking_item))
		return
	return ..()

/obj/structure/machinery/power/rtg/attack_hand(mob/user)
	if(user.a_intent == I_GRAB && user_buckle(user.pulling, user))
		return
	..()

/obj/structure/machinery/power/rtg/advanced
	desc = "An advanced RTG capable of moderating isotope decay, increasing power output but reducing lifetime. It uses phoron-fueled radiation collectors to increase output even further."
	power_gen = 5000 // 10000 on T1, 20000 on T4.

	component_types = list(
		/obj/item/stack/cable_coil{amount = 5},
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stack/material/uranium{amount = 10},
		/obj/item/stack/material/phoron{amount = 5},
		/obj/item/circuitboard/rtg/advanced
	)

/obj/item/circuitboard/rtg
	name = T_BOARD("radioisotope thermoelectric generator")
	build_path = /obj/structure/machinery/power/rtg
	board_type = BOARD_MACHINE
	origin_tech = list(
		TECH_ENGINEERING = 3,
		TECH_DATA = 2,
		TECH_MATERIAL = 4,
		TECH_POWER = 3
	)
	req_components = list(
		"/obj/item/stack/cable_coil" = 5,
		"/obj/item/stock_parts/capacitor" = 1,
		"/obj/item/stack/material/uranium" = 10
	)

/obj/item/circuitboard/rtg/advanced
	name = T_BOARD("advanced radioisotope thermoelectric generator")
	build_path = /obj/structure/machinery/power/rtg/advanced
	origin_tech = list(
		TECH_DATA = 3,
		TECH_MATERIAL = 4,
		TECH_POWER = 3,
		TECH_ENGINEERING = 3,
		TECH_PHORON = 3
	)
	req_components = list(
		"/obj/item/stack/cable_coil" = 5,
		"/obj/item/stock_parts/capacitor" = 1,
		"/obj/item/stock_parts/micro_laser" = 1,
		"/obj/item/stack/material/uranium" = 10,
		"/obj/item/stack/material/phoron" = 5
	)
