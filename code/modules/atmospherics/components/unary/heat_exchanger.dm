/obj/machinery/atmospherics/unary/heat_exchanger
	name = "heat exchanger"
	desc = "Exchanges heat between two input gases."
	icon = 'icons/atmos/heat_exchanger.dmi'
	icon_state = "intact"
	density = TRUE

	var/obj/machinery/atmospherics/unary/heat_exchanger/partner = null
	var/update_cycle

/obj/machinery/atmospherics/unary/heat_exchanger/update_icon()
	if(node)
		icon_state = "intact"
	else
		icon_state = "exposed"

	return

/obj/machinery/atmospherics/unary/heat_exchanger/atmos_init()
	if(!partner)
		var/partner_connect = turn(dir,180)

		for(var/obj/machinery/atmospherics/unary/heat_exchanger/target in get_step(src,partner_connect))
			if(target.dir & get_dir(src,target))
				partner = target
				partner.partner = src
				break

	..()

/obj/machinery/atmospherics/unary/heat_exchanger/process()
	..()
	if(QDELETED(partner))
		return FALSE

	if(!SSair || SSair.times_fired <= update_cycle)
		return FALSE

	update_cycle = SSair.times_fired
	partner.update_cycle = SSair.times_fired

	var/air_heat_capacity = air_contents.heat_capacity()
	var/other_air_heat_capacity = partner.air_contents.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

	var/old_temperature = air_contents.temperature
	var/other_old_temperature = partner.air_contents.temperature

	if(combined_heat_capacity > 0)
		var/combined_energy = partner.air_contents.temperature*other_air_heat_capacity + air_heat_capacity*air_contents.temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		air_contents.temperature = new_temperature
		partner.air_contents.temperature = new_temperature

	if(network)
		if(abs(old_temperature-air_contents.temperature) > 1)
			network.update = 1

	if(partner.network)
		if(abs(other_old_temperature-partner.air_contents.temperature) > 1)
			partner.network.update = 1

	return TRUE

/obj/machinery/atmospherics/unary/heat_exchanger/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!W.iswrench())
		return ..()
	var/turf/T = src.loc
	if(level == 1 && isturf(T) && !T.is_plating())
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if(!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure() - env_air.return_pressure()) > PRESSURE_EXERTED)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
		add_fingerprint(user)
		return TRUE
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(W.use_tool(src, user, istype(W, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message(
			SPAN_NOTICE("\The [user] unfastens \the [src]."),
			SPAN_NOTICE("You have unfastened \the [src]."),
			"You hear a ratchet."
		)
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
