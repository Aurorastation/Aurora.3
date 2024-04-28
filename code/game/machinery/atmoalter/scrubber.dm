/obj/machinery/portable_atmospherics/powered/scrubber
	name = "portable air scrubber"
	desc = "Scrubs contaminants from the local atmosphere or the connected portable tank."
	desc_info = "Filters the air, placing harmful gases into the internal gas container.  The container can be emptied by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the scrubber. "

	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE
	w_class = ITEMSIZE_NORMAL

	var/on = FALSE
	var/volume_rate = 800

	volume = 750

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = PRESSURE_ONE_THOUSAND

	var/list/scrubbing_gas = list(GAS_PHORON, GAS_CO2, GAS_N2O, GAS_HYDROGEN, GAS_HELIUM, GAS_DEUTERIUM, GAS_TRITIUM, GAS_BORON, GAS_SULFUR, GAS_NO2, GAS_CHLORINE, GAS_STEAM)

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize()
	. = ..()
	cell = new/obj/item/cell/apc(src)

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return

	if(prob(50/severity))
		on = !on
		update_icon()


/obj/machinery/portable_atmospherics/powered/scrubber/update_icon()
	cut_overlays()

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holding)
		add_overlay("scrubber-open")

	if(connected_port)
		add_overlay("scrubber-connector")

	return

/obj/machinery/portable_atmospherics/powered/scrubber/process()
	..()

	var/power_draw = -1

	if(on && cell && cell.charge)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else if(loc)
			environment = loc.return_air()
		else return

		var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

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

	//src.update_icon()
	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/scrubber/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ghost(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_hand(var/mob/user)
	ui_interact(user)
	return

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmoScrubber", ui_x=500, ui_y=380)
		ui.open()

/obj/machinery/portable_atmospherics/powered/scrubber/ui_data(mob/user)
	var/list/data = list()
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["rate"] = round(volume_rate)
	data["minrate"] = round(minrate)
	data["maxrate"] = round(maxrate)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = on ? 1 : 0
	data["hasHoldingTank"] = holding ? 1 : 0
	if(holding)
		data["holdingTankName"] = holding?.name
		data["holdingTankPressure"] = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0)
	else
		data["holdingTankName"] = null
		data["holdingTankPressure"] = null
	return data

/obj/machinery/portable_atmospherics/powered/scrubber/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(action=="togglePower")
		on = !on
		update_icon()
		. = TRUE
	if(action=="removeTank")
		if(holding)
			holding.forceMove(loc)
			holding = null
		. = TRUE
		update_icon()
	if(action=="setVolume")
		volume_rate = Clamp(text2num(params["targetVolume"]), minrate, maxrate)
		. = TRUE
		update_icon()

//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	icon_state = "scrubber:0"
	anchored = 1
	volume = 50000
	volume_rate = 5000

	idle_power_usage = 500		//internal circuitry, friction losses and stuff
	active_power_usage = 100000	//100 kW ~ 135 HP

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Initialize()
	. = ..()
	QDEL_NULL(cell)

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		to_chat(usr, "<span class='notice'>You can't directly interact with this machine. Use the scrubber control console.</span>")

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/process()
	if(!on || (stat & (NOPOWER|BROKEN)))
		update_use_power(POWER_USE_OFF)
		last_flow_rate = 0
		last_power_draw = 0
		return 0

	var/power_draw = -1

	if(!loc)
		return
	var/datum/gas_mixture/environment = loc.return_air()

	var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power_oneoff(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(on)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
			return TRUE

		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 50)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return TRUE

	//doesn't use power cells
	if(istype(attacking_item, /obj/item/cell))
		return TRUE
	if (attacking_item.isscrewdriver())
		return TRUE

	//doesn't hold tanks
	if(istype(attacking_item, /obj/item/tank))
		return TRUE

	return ..()
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		to_chat(user, "<span class='warning'>The bolts are too tight for you to unscrew!</span>")
		return TRUE

	return ..()
