/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"
	desc = "Used to fill or drain rooms without differentiating between gasses."
	desc_info = "Invaluable for filling air in a room rapidly after a breach repair.  The internal gas container can be filled by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the air pump."

	icon = 'icons/obj/atmos.dmi'
	icon_state = "psiphon:0"
	density = TRUE
	w_class = ITEMSIZE_NORMAL

	var/on = FALSE
	var/direction_out = 0 //0 = siphoning, 1 = releasing
	var/target_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = PRESSURE_ONE_THOUSAND

	volume = 1000

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = PRESSURE_ONE_THOUSAND * 5

/obj/machinery/portable_atmospherics/powered/pump/Initialize()
	. = ..()
	cell = new/obj/item/cell/apc(src)

	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN], GAS_NITROGEN, air_mix[GAS_NITROGEN])

/obj/machinery/portable_atmospherics/powered/pump/update_icon()
	cut_overlays()

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holding)
		add_overlay("siphon-open")

	if(connected_port)
		add_overlay("siphon-connector")

	return

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on

	if(prob(100/severity))
		direction_out = !direction_out

	target_pressure = rand(0,1300)
	update_icon()
	SSvueui.check_uis_for_change(src)

	..(severity)

/obj/machinery/portable_atmospherics/powered/pump/process()
	..()
	var/power_draw = -1

	if(on && cell && cell.charge)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else if(loc)
			environment = loc.return_air()
		else return

		var/pressure_delta
		var/output_volume
		var/air_temperature
		if(direction_out)
			pressure_delta = target_pressure - environment.return_pressure()
			output_volume = environment.volume * environment.group_multiplier
			air_temperature = environment.temperature? environment.temperature : air_contents.temperature
		else
			pressure_delta = environment.return_pressure() - target_pressure
			output_volume = air_contents.volume * air_contents.group_multiplier
			air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

		if (pressure_delta > 0.01)
			if (direction_out)
				power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else
				power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge)
			power_change()
			update_icon()

	src.updateDialog()
	SSvueui.check_uis_for_change(src)

/obj/machinery/portable_atmospherics/powered/pump/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/pump/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_ghost(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/portable_atmospherics/powered/pump/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = ..() || list()
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["targetpressure"] = round(target_pressure)
	data["pump_dir"] = direction_out
	data["minpressure"] = round(pressuremin)
	data["maxpressure"] = round(pressuremax)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = on ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))
	return data

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "machinery-atmospherics-portpump", 480, 410, "Portable Pump")
		ui.open()

/obj/machinery/portable_atmospherics/powered/pump/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["power"])
		on = !on
		. = 1
	if(href_list["direction"])
		direction_out = !direction_out
		. = 1
	if (href_list["remove_tank"])
		if(holding)
			holding.forceMove(loc)
			holding = null
		. = 1
	if (href_list["pressure_set"])
		target_pressure = between(pressuremin, text2num(href_list["pressure_set"]), pressuremax)
		. = 1

	if(.)
		update_icon()
		SSvueui.check_uis_for_change(src)
