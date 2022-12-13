/obj/machinery/portable_atmospherics/canister
	name = "canister"
	desc = "Holds gas. Has a built-in valve to allow for filling portable tanks."
	desc_info = "The canister can be connected to a connector port with a wrench.  Tanks of gas (the kind you can hold in your hand) \
	can be filled by the canister, by using the tank on the canister, increasing the release pressure, then opening the valve until it is full, and then close it.  \
	*DO NOT* remove the tank until the valve is closed.  A gas analyzer can be used to check the contents of the canister."

	desc_antag = "Canisters can be damaged, spilling their contents into the air, or you can just leave the release valve open."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow"
	density = 1
	var/health = 100.0
	flags = CONDUCT
	obj_flags = OBJ_FLAG_SIGNALER
	w_class = ITEMSIZE_HUGE

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 5000
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = POWER_USE_OFF
	interact_offline = 1 // Allows this to be used when not in powered area.
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled
	name = "Canister: \[N2 (Cooling)\]"

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "Canister: \[O2 (Cryo)\]"

/obj/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/phoron_scarce // replacing on-station canisters with this for scarcity - full-capacity canisters are staying to avoid mapping errors in future
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "Canister \[H2\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty/
	start_pressure = 0
	can_label = 1

/obj/machinery/portable_atmospherics/canister/empty/air
	name = "Canister: \[Air\]"
	icon_state = "grey"
	canister_color = "grey"

/obj/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	name = "Canister \[N2\]"
	icon_state = "red"
	canister_color = "red"
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
/obj/machinery/portable_atmospherics/canister/empty/sleeping_agent
	name = "Canister \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
/obj/machinery/portable_atmospherics/canister/empty/hydrogen
	name = "Canister \[H2\]"
	icon_state = "purple"
	canister_color = "purple"




/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(signaler)
		update_flag |= 64

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		cut_overlays()
		set_light(FALSE)
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	cut_overlays()
	set_light(FALSE)

	if(signaler)
		add_overlay("signaler")

	if(update_flag & 1)
		add_overlay("can-open")
	if(update_flag & 2)
		add_overlay("can-connector")
	if(update_flag & 4)
		var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o0", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(indicator_overlay)
		set_light(1.4, 1, COLOR_RED_LIGHT)
	if(update_flag & 8)
		var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o1", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(indicator_overlay)
		set_light(1.4, 1, COLOR_RED_LIGHT)
	else if(update_flag & 16)
		var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o2", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(indicator_overlay)
		set_light(1.4, 1, COLOR_YELLOW)
	else if(update_flag & 32)
		var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o3", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(indicator_overlay)
		set_light(1.4, 1, COLOR_BRIGHT_GREEN)

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return TRUE

	if (src.health <= 10)
		var/atom/location = src.loc
		location.assume_air(air_contents)

		destroyed = TRUE
		obj_flags &= ~OBJ_FLAG_SIGNALER
		playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
		density = FALSE

		if (src.holding)
			src.holding.forceMove(src.loc)
			src.holding = null

		detach_signaler()

		update_icon()

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/process()
	if (destroyed)
		return PROCESS_KILL

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/AltClick(var/mob/abstract/observer/admin)
	if (istype(admin))
		if (admin.client && admin.client.holder && ((R_MOD|R_ADMIN) & admin.client.holder.rights))
			if (valve_open)
				if (holding)
					release_log += "Valve was <b>closed</b> by [key_name(admin)] (aghost), stopping the transfer into the [holding]<br>"
				else
					release_log += "Valve was <b>closed</b> by [key_name(admin)] (aghost), stopping the transfer into the <span class='warning'><b>air</b></span><br>"
			else
				if (alert(admin, "The release valve is currently closed. Do you want to open it?", "Open the valve?", "Yes", "No") == "No")
					return

				if (holding)
					release_log += "Valve was <b>opened</b> by [key_name(admin)] (aghost), starting the transfer into the [holding]<br>"
				else
					release_log += "Valve was <b>opened</b> by [key_name(admin)] (aghost), starting the transfer into the <span class='warning'><b>air</b></span><br>"
					log_open(admin)
			valve_open = !valve_open

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/mecha_equipment/clamp))
		return
	if(!W.iswrench() && !is_type_in_list(W, list(/obj/item/tank, /obj/item/device/analyzer, /obj/item/modular_computer)) && !issignaler(W) && !(W.iswirecutter() && signaler))
		if(W.flags & NOBLUDGEON)
			return TRUE
		visible_message(SPAN_WARNING("\The [user] hits \the [src] with \the [W]!"), SPAN_NOTICE("You hit \the [src] with \the [W]."))
		user.do_attack_animation(src, W)
		playsound(src, 'sound/weapons/smash.ogg', 60, 1)
		src.health -= W.force
		if(!istype(W, /obj/item/forensics))
			src.add_fingerprint(user)
		healthcheck()
		return TRUE

	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return TRUE

	..()

	update_icon()
	SSvueui.check_uis_for_change(src) // Update all VueUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(var/mob/user as mob)
	return src.ui_interact(user)

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user)
	// update the ui if it exists, returns null if no ui is passed/found
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		ui = new(user, src, "machinery-atmospherics-canister", 480, 400, "Canister")
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.auto_update_content = TRUE

/obj/machinery/portable_atmospherics/canister/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = ..() || list()

	// this is the data which will be sent to the ui
	data["name"] = name
	data["canLabel"] = can_label
	data["portConnected"] = !!connected_port
	data["tankPressure"] = round(air_contents.return_pressure() || 0)
	data["releasePressure"] = round(release_pressure || 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open

	data["hasHoldingTank"] = !!holding
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))
	return data

/obj/machinery/portable_atmospherics/canister/Topic(href, href_list)

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["toggle"])
		if (valve_open)
			if (holding)
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the <span class='warning'><b>air</b></span><br>"
		else
			if (holding)
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the <span class='warning'><b>air</b></span><br>"
				log_open()
		valve_open = !valve_open

	if (href_list["remove_tank"])
		if(holding)
			if (valve_open)
				valve_open = 0
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into [holding]<br>"
			if(istype(holding, /obj/item/tank))
				holding.manipulated_by = usr.real_name
			usr.put_in_hands(holding)
			holding = null

	if (href_list["pressure_set"])
		release_pressure = between(ONE_ATMOSPHERE/10, text2num(href_list["pressure_set"]), 10*ONE_ATMOSPHERE)

	if (href_list["relabel"])
		if (can_label)
			var/list/colors = list(
				"\[N2O\]" = "redws",
				"\[N2\]" = "red",
				"\[O2\]" = "blue",
				"\[Phoron\]" = "orange",
				"\[CO2\]" = "black",
				"\[Air\]" = "grey",
				"\[Hydrogen\]" = "purple",
				"\[CAUTION\]" = "yellow"
			)
			var/label = input("Choose canister label", "Gas canister") as null|anything in colors
			if (label)
				src.canister_color = colors[label]
				src.icon_state = colors[label]
				src.name = "Canister: [label]"

	src.add_fingerprint(usr)
	update_icon()

	return 1

/obj/machinery/portable_atmospherics/canister/do_signaler()
	valve_open = !valve_open
	if(valve_open)
		log_open_userless("a signaler")

/obj/machinery/portable_atmospherics/canister/phoron/Initialize()
	. = ..()

	src.air_contents.adjust_gas(GAS_PHORON, MolesForPressure())

/obj/machinery/portable_atmospherics/canister/phoron_scarce/Initialize()
	. = ..()

	src.air_contents.adjust_gas(GAS_PHORON, MolesForPressure()/2) // half of the default value

/obj/machinery/portable_atmospherics/canister/oxygen/Initialize()
	. = ..()

	src.air_contents.adjust_gas(GAS_OXYGEN, MolesForPressure())

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/Initialize()
	. = ..()
	src.air_contents.temperature = 80

/obj/machinery/portable_atmospherics/canister/sleeping_agent/Initialize()
	. = ..()

	air_contents.adjust_gas(GAS_N2O, MolesForPressure())

/obj/machinery/portable_atmospherics/canister/hydrogen/Initialize()
	. = ..()

	air_contents.adjust_gas(GAS_HYDROGEN, MolesForPressure())

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/sleeping_agent/roomfiller/Initialize()
	. = ..()
	air_contents.gas[GAS_N2O] = 9*4000
	spawn(10)
		var/turf/simulated/location = src.loc
		if (istype(src.loc))
			while (!location.air)
				sleep(10)
			location.assume_air(air_contents)
			air_contents = new

/obj/machinery/portable_atmospherics/canister/nitrogen/Initialize()
	. = ..()
	src.air_contents.adjust_gas(GAS_NITROGEN, MolesForPressure())

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled/Initialize()
	. = ..()
	src.air_contents.temperature = 80

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/Initialize()
	. = ..()
	src.air_contents.adjust_gas(GAS_CO2, MolesForPressure())

/obj/machinery/portable_atmospherics/canister/air/Initialize()
	. = ..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN], GAS_NITROGEN, air_mix[GAS_NITROGEN])

/obj/machinery/portable_atmospherics/canister/air/cold/Initialize()
	. = ..()
	src.air_contents.temperature = 283
