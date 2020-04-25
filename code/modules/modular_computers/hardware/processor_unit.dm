// CPU that allows the computer to run programs.
// Better CPUs are obtainable via research and can run more programs on background.

/obj/item/computer_hardware/processor_unit
	name = "standard processor"
	desc = "A standard CPU used in most computers. It can run up to three programs simultaneously."
	icon_state = "cpu_normal"
	hardware_size = HARDWARE_MEDIUM
	power_usage = 75
	malfunction_probability = 1
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)

	var/max_idle_programs = 2 // 2 idle, + 1 active = 3 as said in description.
	var/processor_strength = PROCESSOR_MEDIUM

/obj/item/computer_hardware/processor_unit/small
	name = "standard microprocessor"
	desc = "A standard miniaturised CPU used in portable devices. It can run up to two programs simultaneously."
	icon_state = "cpu_small"
	hardware_size = HARDWARE_SMALL
	power_usage = 25
	max_idle_programs = 1
	processor_strength = PROCESSOR_SMALL
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

/obj/item/computer_hardware/processor_unit/large
	name = "standard macroprocessor"
	desc = "A standard macro CPU used in fixed devices. It can run up to four programs simultaneously."
	icon_state = "cpu_normal"
	hardware_size = HARDWARE_LARGE
	power_usage = 25
	max_idle_programs = 4
	processor_strength = PROCESSOR_LARGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

/obj/item/computer_hardware/processor_unit/photonic
	name = "photonic processor"
	desc = "An advanced experimental CPU that uses photonic core instead of regular circuitry. It can run up to five programs simultaneously, but uses a lot of power."
	icon_state = "cpu_normal_photonic"
	hardware_size = HARDWARE_MEDIUM
	power_usage = 75
	max_idle_programs = 4
	processor_strength = PROCESSOR_MEDIUM_FAST
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)

/obj/item/computer_hardware/processor_unit/photonic/small
	name = "photonic microprocessor"
	desc = "An advanced miniaturised CPU for use in portable devices. It uses photonic core instead of regular circuitry. It can run up to three programs simultaneously."
	icon_state = "cpu_small_photonic"
	hardware_size = HARDWARE_SMALL
	power_usage = 50
	max_idle_programs = 2
	processor_strength = PROCESSOR_SMALL_FAST
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)

/obj/item/computer_hardware/processor_unit/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("This processor unit has a \"[processor_unit_power(processor_strength)]\" power level."))

/obj/item/computer_hardware/processor_unit/diagnostics(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("Processing Power: [processor_unit_power(processor_strength)]"))

/proc/processor_unit_power(var/strength)
	var/static/list/processor_levels = list(
				PROCESSOR_SMALL = "Mark One",
				PROCESSOR_SMALL_FAST = "Mark Two",
				PROCESSOR_MEDIUM = "Mark Two",
				PROCESSOR_MEDIUM_FAST = "Mark Three",
				PROCESSOR_LARGE = "Mark Four",
				PROCESSOR_LARGE_FAST = "Mark Five"
	)
	var/output = processor_levels[strength] ? processor_levels[strength] : "Unknown"
	return output