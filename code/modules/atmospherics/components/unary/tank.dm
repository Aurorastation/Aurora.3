/obj/machinery/atmospherics/unary/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air_map"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	var/gas_volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25 * ONE_ATMOSPHERE
	/// List of gas ratios to use
	var/list/filling
	/// Temperature to fill at
	var/filling_temperature = T20C

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH
	density = TRUE

	build_icon = 'icons/atmos/tank.dmi'
	build_icon_state = "air"

/obj/machinery/atmospherics/unary/tank/Initialize()
	. = ..()
	icon_state = "air"

	if(filling)
		air_contents.temperature = filling_temperature

		var/list/gases = list()
		for(var/gas in filling)
			gases += gas
			gases += start_pressure * filling[gas] * (air_contents.volume)/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
		air_contents.adjust_multi(arglist(gases))
		queue_icon_update()


/obj/machinery/atmospherics/unary/tank/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paint_sprayer))
		return FALSE

	if(istype(attacking_item, /obj/item/analyzer) && in_range(user, src))
		var/obj/item/analyzer/A = attacking_item
		A.analyze_gases(src, user)
		return TRUE

/obj/machinery/atmospherics/unary/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air_map"
	filling = list(GAS_OXYGEN = O2STANDARD, GAS_NITROGEN = N2STANDARD)

/obj/machinery/atmospherics/unary/tank/air/Initialize()
	. = ..()
	icon_state = "air"

/obj/machinery/atmospherics/unary/tank/air/scc_shuttle
	icon = 'icons/atmos/tank_scc.dmi'

/obj/machinery/atmospherics/unary/tank/air/scc_shuttle/airlock
	start_pressure = 607.95

/obj/machinery/atmospherics/unary/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2_map"
	filling = list(GAS_OXYGEN = 1)

/obj/machinery/atmospherics/unary/tank/oxygen/Initialize()
	. = ..()
	icon_state = "o2"

/obj/machinery/atmospherics/unary/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2_map"
	filling = list(GAS_NITROGEN = 1)

/obj/machinery/atmospherics/unary/tank/nitrogen/Initialize()
	. = ..()
	icon_state = "n2"

/obj/machinery/atmospherics/unary/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2_map"
	filling = list(GAS_CO2 = 1)

/obj/machinery/atmospherics/unary/tank/carbon_dioxide/Initialize()
	. = ..()
	icon_state = "co2"

/obj/machinery/atmospherics/unary/tank/carbon_dioxide/scc_shuttle
	icon = 'icons/atmos/tank_scc.dmi'

/obj/machinery/atmospherics/unary/tank/phoron
	name = "Pressure Tank (Phoron)"
	icon_state = "phoron_map"
	filling = list(GAS_PHORON = 1)

/obj/machinery/atmospherics/unary/tank/phoron/Initialize()
	. = ..()
	icon_state = "phoron"

/obj/machinery/atmospherics/unary/tank/hydrogen
	name = "Pressure Tank (Hydrogen)"
	icon_state = "h2_map"
	filling = list(GAS_HYDROGEN = 1)
	filling_temperature = T0C

/obj/machinery/atmospherics/unary/tank/hydrogen/Initialize()
	. = ..()
	icon_state = "h2"

/obj/machinery/atmospherics/unary/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o_map"
	filling = list(GAS_N2O = 1)
	filling_temperature = T0C

/obj/machinery/atmospherics/unary/tank/nitrous_oxide/Initialize()
	. = ..()
	icon_state = "n2o"

/obj/item/pipe/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"
	name =  "Pressure Tank"
	desc = "A large vessel containing pressurized gas."
	color =  PIPE_COLOR_WHITE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	w_class = WEIGHT_CLASS_BULKY
	dir = SOUTH
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY
