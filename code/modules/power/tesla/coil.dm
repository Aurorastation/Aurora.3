/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "For the union!"
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil"
	anchored = 0
	density = 1
	var/power_loss = 2
	var/input_power_multiplier = 1

	component_types = list(
		/obj/item/circuitboard/tesla_coil,
		/obj/item/stock_parts/capacitor
	)

/obj/machinery/power/tesla_coil/RefreshParts()
	var/power_multiplier = 0

	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		power_multiplier += C.rating
	input_power_multiplier = power_multiplier

/obj/machinery/power/tesla_coil/attackby(obj/item/W, mob/user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	if(W.iswrench())
		playsound(src.loc, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "unfasten" : "fasten"] [src] to the flooring.</span>")
		anchored = !anchored
		if(!anchored)
			disconnect_from_network()
		else
			connect_to_network()
		return

/obj/machinery/power/tesla_coil/tesla_act(var/power, var/melt = FALSE)
	if(anchored && !melt)
		being_shocked = 1
		//don't lose arc power when it's not connected to anything
		//please place tesla coils all around the station to maximize effectiveness
		var/power_produced = powernet ? power / power_loss : power
		add_avail(power_produced*input_power_multiplier)
		flick("coilhit", src)
		playsound(src.loc, 'sound/magic/LightningShock.ogg', 100, 1, extrarange = 5)
		tesla_zap(src, 5, power_produced)
		addtimer(CALLBACK(src, .proc/reset_shocked), 10)
	else
		..()

/obj/machinery/power/grounding_rod
	name = "Grounding Rod"
	desc = "Keep an area from being fried from Edison's Bane."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod"
	anchored = 0
	density = 1

	component_types = list(
		/obj/item/circuitboard/grounding_rod,
		/obj/item/stock_parts/capacitor
	)


/obj/machinery/power/grounding_rod/attackby(obj/item/W, mob/user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	if(W.iswrench())
		playsound(src.loc, W.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "unfasten" : "fasten"] [src] to the flooring.</span>")
		anchored = !anchored
		return


/obj/machinery/power/grounding_rod/tesla_act(var/power, var/melt = FALSE)
	flick("coil_shock_1", src)

/obj/item/circuitboard/tesla_coil
	name = "tesla coil circuitry"
	desc = "The circuitboard for a tesla coil."
	build_path = "/obj/machinery/power/tesla_coil"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list("/obj/item/stock_parts/capacitor" = 1)
	board_type = "machine"

/obj/item/circuitboard/grounding_rod
	name = "grounding rod circuitry"
	desc = "The circuitboard for a grounding rod."
	build_path = "/obj/machinery/power/grounding_rod"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list("/obj/item/stock_parts/capacitor" = 1)
	board_type = "machine"