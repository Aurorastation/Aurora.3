// super icky event branch code below. none of it runtimes at least :D
// - electrolyser
// - an ice drill to get the steam for the electrolyser

// ELECTROLYSER STUFF.
// based off the ancient as hell /oxyregenerator, only partially prettied up
#define PHASE_FILL 1
#define PHASE_PROCESS 2
#define PHASE_RELEASE 3

/obj/machinery/atmospherics/binary/electrolyser
	name ="electrolyser cell"
	desc = "A device uses electrical current to split water into hydrogen and oxygen."
	icon = 'icons/atmos/oxyregenerator.dmi'
	icon_state = "off"
	level = 1
	density = TRUE
	use_power = POWER_USE_OFF
	obj_flags = OBJ_FLAG_ROTATABLE
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000

	component_types = list(
		/obj/item/circuitboard/electrolyser,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil{amount = 10}
	)

	var/target_pressure = 5*ONE_ATMOSPHERE
	var/steam_stored = 0

	var/phase = PHASE_FILL
	var/datum/gas_mixture/cell = new

/obj/machinery/atmospherics/binary/electrolyser/Initialize()
	. = ..()
	anchored = TRUE
	anchor_helper()

/obj/machinery/atmospherics/binary/electrolyser/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The electrolyser cell requires an input and an output pipe line, as well as an APC power supply. \
	After a the cell has been pressurised to 500 kPa with Steam and is allowed to process, it will release Hydrogen and Oxygen into the output. \
	The outputted gases may require cooling!"

/obj/machinery/atmospherics/binary/electrolyser/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. +=  "Its outlet port is to the [dir2text(dir)]."

	switch(phase)
		if(PHASE_FILL)
			. +=  SPAN_NOTICE("The cell is currently pressurising.")
		if(PHASE_PROCESS)
			. +=  SPAN_NOTICE("The cell's two electrodes bubble away as the electrolysis reaction products form.")
		if(PHASE_RELEASE)
			. +=  SPAN_NOTICE("The cell is currently outputting the products.")

/obj/machinery/atmospherics/binary/electrolyser/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		anchor_helper()

	if(phase == PHASE_PROCESS) // for convenience if its taking too long
		if(attacking_item.ismultitool())
			playsound(src.loc, 'sound/machines/buttonbeep.ogg', 50, 1)
			user.visible_message("[user.name] manually overrides the [src.name], opening the outlet valve.", \
						"You manually override the [src], opening the outlet valve.")
			phase = PHASE_RELEASE

/obj/machinery/atmospherics/binary/electrolyser/proc/anchor_helper()
	if(anchored)
		if(dir & (NORTH|SOUTH))
			initialize_directions = NORTH|SOUTH
		else if(dir & (EAST|WEST))
			initialize_directions = EAST|WEST

		atmos_init()
		build_network()
		if (node1)
			node1.atmos_init()
			node1.build_network()
		if (node2)
			node2.atmos_init()
			node2.build_network()
	else
		if(node1)
			node1.disconnect(src)
			qdel(network1)
		if(node2)
			node2.disconnect(src)
			qdel(network2)

/obj/machinery/atmospherics/binary/electrolyser/attack_hand(mob/user)
	. = ..()
	update_use_power(!use_power)
	update_icon()
	user.visible_message("[user.name] turns [use_power ? "on" : "off"] the [src]].", \
					"You turn [use_power ? "on" : "off"] the [src].")

/obj/machinery/atmospherics/binary/electrolyser/process()
	. = ..()
	if((!operable()) || !use_power)
		return

	var/power_draw
	last_power_draw = 0

	// Fill the electrolyser's cell with an inputted gas.
	if (phase == PHASE_FILL)
		var/pressure_delta = target_pressure - cell.return_pressure()
		if (pressure_delta > 0.01 && air1.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(air1, cell, pressure_delta)
			power_draw = pump_gas(src, air1, cell, transfer_moles, power_rating)
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power_oneoff(power_draw)
				if(network1)
					network1.update = 1
		if (air1.return_pressure() < 0.1 * ONE_ATMOSPHERE || cell.return_pressure() >= target_pressure * 0.95)
			phase = PHASE_PROCESS

	// Turn any inputted Steam into a mix of Oxygen and Hydrogen.
	if (phase == PHASE_PROCESS)
		if (cell.gas[GAS_STEAM])
			// Steam intake
			var/steam_intake = clamp(cell.gas[GAS_STEAM], 0, 10)
			last_flow_rate = steam_intake
			cell.adjust_gas(GAS_STEAM, -steam_intake, 1)

			// Turning the steam into H2 + O
			var/datum/gas_mixture/new_gasmix = new
			var/heat_gain = rand(25, 250)
			new_gasmix.adjust_gas(GAS_OXYGEN,  steam_intake/0.6) // 1 oxygen and 2 hydrogen from H2O
			new_gasmix.adjust_gas(GAS_HYDROGEN, steam_intake/0.3)
			new_gasmix.temperature = T20C + heat_gain // hot, risk of ignition if left unchecked
			cell.merge(new_gasmix)

			// Power draw
			power_draw = power_rating * steam_intake
			last_power_draw = power_draw
			use_power_oneoff(power_draw)
		else
			phase = PHASE_RELEASE

	// Output the Oxygen and Hydrogen gas mix.
	if (phase == PHASE_RELEASE)
		var/pressure_delta = target_pressure - air2.return_pressure()
		if (pressure_delta > 0.01 && cell.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(cell, air2, pressure_delta, (network2)? network2.volume : 0)
			power_draw = pump_gas(src, cell, air2, transfer_moles, power_rating)
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power_oneoff(power_draw)
				if(network2)
					network2.update = 1
		else//can't push outside harder than target pressure. Device is not intended to be used as a pump after all
			phase = PHASE_FILL
		if (cell.return_pressure() <= 0.1)
			phase = PHASE_FILL

/obj/machinery/atmospherics/binary/electrolyser/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

// ICE DRILL STUFF
/obj/machinery/atmospherics/unary/ice_drill
	name = "ice drill"
	desc = "A large, specialist drill used to mine ice. The output is definitely ice and not steam."
	icon = 'icons/obj/mining_drill.dmi'
	icon_state = "mining_drill"
	level = 1
	layer = MOB_LAYER + 0.1 //So it draws over mobs in the tile north of it.
	density = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000

	component_types = list(
		/obj/item/circuitboard/ice_drill,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/cell/high
	)

/obj/machinery/atmospherics/unary/ice_drill/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The ice drill needs to be anchored over ice. \
	Once anchored, pipes will connect to the drill and it can be turned on. \
	Ignore that the output is Steam — it is definitely water ice, definitely."

/obj/machinery/atmospherics/unary/ice_drill/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")

/obj/machinery/atmospherics/unary/ice_drill/attack_hand(mob/user)
	. = ..()
	update_use_power(!use_power)
	update_icon()
	user.visible_message("[user.name] turns [use_power ? "on" : "off"] the [src]].", \
					"You turn [use_power ? "on" : "off"] the [src].")

/obj/machinery/atmospherics/unary/ice_drill/process()
	. = ..()

	if((!operable()) || !use_power || !network)
		return

	// Check if the drill is on ice. If on ice, make water (steam)
	if(istype(get_turf(src), /turf/simulated/floor/ice) || istype(get_turf(src), /turf/simulated/floor/exoplanet/ice))
		use_power_oneoff(power_rating)
		var/temp_range = rand(T0C, T0C+5)
		air_contents.adjust_gas_temp(GAS_STEAM, 100, temp_range, 1)

/obj/machinery/atmospherics/unary/ice_drill/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "mining_drill"

	if (use_power == POWER_USE_IDLE)
		icon_state = "mining_drill_active"
	else
		icon_state = "mining_drill_error"
