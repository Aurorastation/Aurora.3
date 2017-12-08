// CPU that allows the computer to run programs.
// Better CPUs are obtainable via research and can run more programs on background.

	name = "standard processor"
	desc = "A standard CPU used in most computers. It can run up to three programs simultaneously."
	icon_state = "cpu_normal"
	hardware_size = 2
	power_usage = 75
	critical = 1
	malfunction_probability = 1
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)

	var/max_idle_programs = 2 // 2 idle, + 1 active = 3 as said in description.

	name = "standard microprocessor"
	desc = "A standard miniaturised CPU used in portable devices. It can run up to two programs simultaneously."
	icon_state = "cpu_small"
	hardware_size = 1
	power_usage = 25
	max_idle_programs = 1
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	name = "photonic processor"
	desc = "An advanced experimental CPU that uses photonic core instead of regular circuitry. It can run up to five programs simultaneously, but uses a lot of power."
	icon_state = "cpu_normal_photonic"
	hardware_size = 2
	power_usage = 250
	max_idle_programs = 4
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)

	name = "photonic microprocessor"
	desc = "An advanced miniaturised CPU for use in portable devices. It uses photonic core instead of regular circuitry. It can run up to three programs simultaneously."
	icon_state = "cpu_small_photonic"
	hardware_size = 1
	power_usage = 100
	max_idle_programs = 2
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
