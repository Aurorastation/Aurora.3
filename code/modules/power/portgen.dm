//Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/portgen
	name = "placeholder generator" // Don't use this. It can't be anchored without VV magic.
	desc = "You aren't supposed to see this."
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0_0"
	var/base_icon = "portgen0"
	density = TRUE
	anchored = FALSE

	var/active = FALSE
	var/power_gen = 5000
	var/open = FALSE
	var/power_output = 1
	var/portgen_lightcolour = "#000000"
	var/datum/looping_sound/generator/soundloop

/obj/machinery/power/portgen/Initialize()
	. = ..()
	soundloop = new(src, active)

/obj/machinery/power/portgen/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/portgen/proc/IsBroken()
	return (stat & (BROKEN|EMPED))

/obj/machinery/power/portgen/proc/HasFuel() //Placeholder for fuel check.
	return TRUE

/obj/machinery/power/portgen/proc/UseFuel() //Placeholder for fuel use.
	return

/obj/machinery/power/portgen/proc/DropFuel()
	return

/obj/machinery/power/portgen/proc/handleInactive()
	return

/obj/machinery/power/portgen/process()
	if(active && HasFuel() && !IsBroken() && anchored)
		set_light(2, 1, l_color = portgen_lightcolour)
		if(powernet)
			add_avail(power_gen * power_output)
		UseFuel()
	else
		set_light(0)
		active = FALSE
		soundloop.stop(src)
		icon_state = initial(icon_state)
		handleInactive()

/obj/machinery/power/powered()
	return TRUE //doesn't require an external power source

/obj/machinery/power/portgen/attack_hand(mob/user)
	if(..())
		update_icon()
		return
	if(!anchored)
		update_icon()
		return

/obj/machinery/power/portgen/update_icon()
	icon_state = "[base_icon]_[active]"
	return ..()

/obj/machinery/power/portgen/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		if(active)
			. += SPAN_NOTICE("The generator is on.")
		else
			. += SPAN_NOTICE("The generator is off.")

/obj/machinery/power/portgen/emp_act(severity)
	. = ..()

	var/duration = 6000 //ten minutes
	switch(severity)
		if(EMP_HEAVY)
			stat &= BROKEN
			if(prob(75)) explode()
		if(EMP_LIGHT)
			if(prob(25)) stat &= BROKEN
			if(prob(10)) explode()

	stat |= EMPED
	if(duration)
		spawn(duration)
			stat &= ~EMPED

/obj/machinery/power/portgen/proc/explode()
	explosion(loc, -1, 3, 5, -1)
	qdel(src)

#define TEMPERATURE_DIVISOR 40
#define TEMPERATURE_CHANGE_MAX 20

//
// Portable Generator - Basic
// Runs on graphite.
//
/obj/machinery/power/portgen/basic
	name = "portable generator"
	desc = "A portable generator that runs on graphite. " + SPAN_WARNING("Rated for 100 kW max safe output.")
	portgen_lightcolour = "#BC6E3E"

	var/sheet_name = "graphite bars"
	var/sheet_path = /obj/item/stack/material/graphite
	var/board_path = "/obj/item/circuitboard/portgen"

	/*
		These values were chosen so that the generator can run safely up to 100 kW
		A full 50 graphite bar stack should last 2 hours at power_output = 4
		temperature_gain and max_temperature are set so that the max safe power level is 4.
		Setting to 5 or higher can only be done temporarily before the generator overheats.
	*/
	power_gen = 25000				//Watts output per power_output level
	var/max_power_output = 5		//The maximum power setting without emagging.
	var/max_safe_output = 4			// For UI use, maximal output that won't cause overheat.
	var/time_per_sheet = 576		//fuel efficiency - how long 1 sheet lasts at power level 1
	var/max_sheets = 50 			//max capacity of the hopper
	var/max_temperature = 300		//max temperature before overheating increases
	var/temperature_gain = 50		//how much the temperature increases per power output level, in degrees per level

	var/sheets = 0			//How many sheets of material are loaded in the generator
	var/sheet_left = 0		//How much is left of the current sheet
	var/temperature = 0		//The current temperature
	var/overheating = 0		//if this gets high enough the generator explodes

	component_types = list(
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor
	)

/obj/machinery/power/portgen/basic/Initialize()
	component_types += board_path
	. = ..()

	if(anchored)
		connect_to_network()

/obj/machinery/power/portgen/basic/Destroy()
	DropFuel()
	return ..()

/obj/machinery/power/portgen/basic/RefreshParts()
	var/temp_rating = 0

	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/matter_bin))
			max_sheets = SP.rating * SP.rating * 50
		else if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating

	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/portgen/basic/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "\The [src] appears to be producing [power_gen*power_output] W."
	. += "There [sheets == 1 ? "is" : "are"] [sheets] sheet\s left in the hopper."
	if(IsBroken())
		. += SPAN_WARNING("\The [src] seems to have broken down.")
	if(overheating)
		. += SPAN_DANGER("\The [src] is overheating!")

/obj/machinery/power/portgen/basic/HasFuel()
	var/needed_sheets = power_output / time_per_sheet
	if(sheets >= needed_sheets - sheet_left)
		return TRUE

//Removes one stack's worth of material from the generator.
/obj/machinery/power/portgen/basic/DropFuel()
	if(sheets)
		var/obj/item/stack/material/S = new sheet_path(loc)
		var/amount = min(sheets, S.max_amount)
		S.amount = amount
		sheets -= amount

/obj/machinery/power/portgen/basic/UseFuel()

	//how much material are we using this iteration?
	var/needed_sheets = power_output / time_per_sheet

	//HasFuel() should guarantee us that there is enough fuel left, so no need to check that
	//the only thing we need to worry about is if we are going to rollover to the next sheet
	if (needed_sheets > sheet_left)
		sheets--
		sheet_left = (1 + sheet_left) - needed_sheets
	else
		sheet_left -= needed_sheets

	//calculate the "target" temperature range
	//This should probably depend on the external temperature somehow, but whatever.
	var/lower_limit = 56 + power_output * temperature_gain
	var/upper_limit = 76 + power_output * temperature_gain

	/*
		Hot or cold environments can affect the equilibrium temperature
		The lower the pressure the less effect it has. I guess it cools using a radiator or something when in vacuum.
		Gives traitors more opportunities to sabotage the generator or allows enterprising engineers to build additional
		cooling in order to get more power out.
	*/
	if(!loc) return
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		lower_limit += ambient*ratio
		upper_limit += ambient*ratio

	var/average = (upper_limit + lower_limit)/2

	//calculate the temperature increase
	var/bias = 0
	if (temperature < lower_limit)
		bias = min(round((average - temperature)/TEMPERATURE_DIVISOR, 1), TEMPERATURE_CHANGE_MAX)
	else if (temperature > upper_limit)
		bias = max(round((temperature - average)/TEMPERATURE_DIVISOR, 1), -TEMPERATURE_CHANGE_MAX)

	//limit temperature increase so that it cannot raise temperature above upper_limit,
	//or if it is already above upper_limit, limit the increase to 0.
	var/inc_limit = max(upper_limit - temperature, 0)
	var/dec_limit = min(temperature - lower_limit, 0)
	temperature += between(dec_limit, rand(-7 + bias, 7 + bias), inc_limit)

	if (temperature > max_temperature)
		overheat()
	else if (overheating > 0)
		overheating--

/obj/machinery/power/portgen/basic/handleInactive()
	var/cooling_temperature = 20

	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if (environment)
			var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
			var/ambient = environment.temperature - T20C
			cooling_temperature += ambient*ratio

	if (temperature > cooling_temperature)
		var/temp_loss = (temperature - cooling_temperature)/TEMPERATURE_DIVISOR
		temp_loss = between(2, round(temp_loss, 1), TEMPERATURE_CHANGE_MAX)
		temperature = max(temperature - temp_loss, cooling_temperature)

	if(overheating)
		overheating--

/obj/machinery/power/portgen/basic/proc/overheat()
	overheating++
	if (overheating > 60)
		explode()

/obj/machinery/power/portgen/basic/emag_act(var/remaining_charges, var/mob/user)
	if (active && prob(25))
		explode() //if they're foolish enough to emag while it's running

	if (!emagged)
		emagged = TRUE
		return TRUE

/obj/machinery/power/portgen/basic/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, sheet_path))
		var/obj/item/stack/addstack = attacking_item
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			to_chat(user, SPAN_NOTICE("The [name] is full!"))
			return
		to_chat(user, SPAN_NOTICE("You add [amount] sheet\s to the [name]."))
		sheets += amount
		addstack.use(amount)
		return
	else if(!active)
		if(attacking_item.iswrench())

			if(!anchored)
				connect_to_network()
				to_chat(user, SPAN_NOTICE("You secure the generator to the floor."))
			else
				disconnect_from_network()
				to_chat(user, SPAN_NOTICE("You unsecure the generator from the floor."))

			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			anchored = !anchored

		else if(attacking_item.isscrewdriver())
			open = !open
			attacking_item.play_tool_sound(get_turf(src), 50)
			if(open)
				to_chat(user, SPAN_NOTICE("You open the access panel."))
			else
				to_chat(user, SPAN_NOTICE("You close the access panel."))
		else if(open && attacking_item.iscrowbar())
			var/obj/machinery/constructable_frame/machine_frame/new_frame = new /obj/machinery/constructable_frame/machine_frame(loc)
			for(var/obj/item/I in component_parts)
				I.forceMove(loc)
			while (sheets > 0)
				DropFuel()

			new_frame.state = 2
			new_frame.icon_state = "box_1"
			qdel(src)

/obj/machinery/power/portgen/basic/attack_hand(mob/user)
	..()
	if (!anchored)
		return
	ui_interact(user)

/obj/machinery/power/portgen/basic/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/power/portgen/basic/ui_data(var/mob/user)
	var/list/data = list()

	data["active"] = active
	data["output_set"] = power_output
	data["output_max"] = max_power_output
	data["output_safe"] = max_safe_output
	data["temperature_current"] = temperature
	data["temperature_max"] = max_temperature
	data["temperature_overheat"] = overheating

	if(loc)
		var/datum/gas_mixture/environment = loc.return_air()
		if(environment)
			data["temperature_min"] = FLOOR(environment.temperature - T0C, 1)

	data["output_min"] = initial(power_output)
	data["is_broken"] = IsBroken()
	data["is_ai"] = (isAI(user) || (isrobot(user) && !Adjacent(user)))

	var/list/fuel = list(
		"fuel_stored" = round((sheets * 1000) + (sheet_left * 1000)),
		"fuel_capacity" = round(max_sheets * 1000, 0.1),
		"fuel_usage" = active ? round((power_output / time_per_sheet) * 1000) : FALSE,
		"fuel_type" = sheet_name
		)

	//coolant stuff
	data["uses_coolant"] = !!reagents
	data["coolant_stored"] = reagents?.total_volume
	data["coolant_capacity"] = reagents?.maximum_volume

	data["fuel"] = fuel
	data["output_watts"] = power_output * power_gen

	return data

/obj/machinery/power/portgen/basic/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableGenerator", name, 500, 560)
		ui.open()

/obj/machinery/power/portgen/basic/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)
	switch(action)
		if("enable")
			if(!active && HasFuel() && !IsBroken())
				active = TRUE
				update_icon()
				soundloop.start(src)
				. = TRUE
		if("disable")
			if (active)
				active = FALSE
				update_icon()
				soundloop.stop(src)
				. = TRUE
		if("eject")
			if(!active)
				DropFuel()
				. = TRUE
		if("set_power")
			var/new_power = text2num(params["set_power"])
			if(new_power < power_output)
				if (power_output > initial(power_output))
					power_output = new_power
					. = TRUE
			else
				if ((power_output < max_power_output) || (emagged && (power_output < round(max_power_output*2.5))))
					power_output = new_power
					. = TRUE

//
// Portable Generator - Advanced
// Runs on uranium.
//
/obj/machinery/power/portgen/basic/advanced
	name = "advanced portable generator"
	desc = "An advanced portable generator that runs on uranium. Runs much more efficiently than the basic graphite model due to the higher energy density of uranium. " + SPAN_WARNING("Rated for 200 kW max safe output.")
	icon_state = "portgen1_0"
	base_icon = "portgen1"
	portgen_lightcolour = "#458943"

	sheet_name = "uranium sheets"
	sheet_path = /obj/item/stack/material/uranium
	board_path = "/obj/item/circuitboard/portgen/advanced"

	power_gen = 50000 // 200 kW = safe max, 250 kW = unsafe max.
	temperature_gain = 60

/obj/machinery/power/portgen/basic/advanced/UseFuel()
	//produces a tiny amount of radiation when in use
	if (prob(2 * power_output))
		SSradiation.radiate(src, 4)
	..()

/obj/machinery/power/portgen/basic/advanced/explode()
	//a nice burst of radiation
	var/rads = 50 + (sheets + sheet_left)*1.5
	SSradiation.radiate(src, max(40, rads))
	explosion(loc, 3, 3, 5, 3)
	qdel(src)

//
// Portable Generator - Super
// Runs on tritium.
//
/obj/machinery/power/portgen/basic/super
	name = "super portable generator"
	desc = "An advanced portable generator that runs on tritium. Runs even more efficiently than the uranium-driven model due to the higher energy density of tritium. " + SPAN_WARNING("Rated for 400 kW max safe output.")
	icon_state = "portgen2_0"
	base_icon = "portgen2"
	portgen_lightcolour = "#476ACC"

	sheet_name = "tritium sheets"
	sheet_path = /obj/item/stack/material/tritium
	board_path = "/obj/item/circuitboard/portgen/super"

	power_gen = 80000 // 400 kW = safe max, 640 kW = unsafe max
	max_power_output = 8
	max_safe_output = 5
	time_per_sheet = 576
	max_temperature = 720
	temperature_gain = 90

/obj/machinery/power/portgen/basic/super/explode()
	explosion(loc, 3, 6, 12, 16, 1) // No special effects, but the explosion is pretty big (same as a supermatter shard).
	qdel(src)

/obj/machinery/power/portgen/basic/fusion
	name = "minature fusion reactor"
	desc = "The RT7-0, an industrial all-in-one nuclear fusion power plant created by Hephaestus. It uses tritium as a fuel source and relies on coolant to keep the reactor cool. Rated for 500 kW max safe output."
	power_gen =  100000
	icon_state = "reactor"
	base_icon = "reactor"
	portgen_lightcolour = "#458943"
	max_safe_output = 5
	max_power_output = 8	//The maximum power setting without emagging.
	temperature_gain = 70	//how much the temperature increases per power output level, in degrees per level
	max_temperature = 450
	time_per_sheet = 400

	sheet_name = "tritium sheets"
	sheet_path = /obj/item/stack/material/tritium
	board_path = "/obj/item/circuitboard/portgen/fusion"

	anchored = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/coolant_volume = 360
	var/coolant_use = 0.2
	var/coolant_reagent = /singleton/reagent/coolant

/obj/machinery/power/portgen/basic/fusion/explode()
	//a nice burst of radiation
	var/rads = 50 + (sheets + sheet_left)*1.5
	for (var/mob/living/L in range(src, 10))
		//should really fall with the square of the distance, but that makes the rads value drop too fast
		//I dunno, maybe physics works different when you live in 2D -- SM radiation also works like this, apparently
		L.apply_damage(max(20, round(rads/get_dist(L,src))), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

	explosion(loc, 3, 6, 12, 16, 1)
	qdel(src)

/obj/machinery/power/portgen/basic/fusion/New()
	create_reagents(coolant_volume)
	..()

/obj/machinery/power/portgen/basic/fusion/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "The auxilary tank shows [reagents.total_volume]u of liquid in it."

/obj/machinery/power/portgen/basic/fusion/UseFuel()
	if(reagents.has_reagent(coolant_reagent))
		temperature_gain = 60
		reagents.remove_any(coolant_use)
		if(prob(2))
			audible_message("<span class='notice'>[src] churns happily.</span>")
	else
		temperature_gain = initial(temperature_gain)
	..()
	if (prob(2 * power_output))
		SSradiation.radiate(src, 6)
	..()

/obj/machinery/power/portgen/basic/fusion/update_icon()
	if(..())
		return 1
	if(power_output > max_safe_output)
		icon_state = "reactordanger"

/obj/machinery/power/portgen/basic/fusion/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/R = attacking_item
		if(R.standard_pour_into(user, src))
			if(reagents.has_reagent(/singleton/reagent/coolant))
				audible_message("<span class='notice'>[src] blips happily!</span>")
				playsound(get_turf(src),'sound/machines/synth_yes.ogg', 50, 0)
			else
				audible_message("<span class='warning'>[src] blips in disappointment!</span>")
				playsound(get_turf(src), 'sound/machines/synth_no.ogg', 50, 0)
		return
	..()
