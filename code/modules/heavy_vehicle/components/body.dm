/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER
	pixel_y = -8
	center_of_mass = list("x"=24, "y"=20)

	var/mech_health = 600
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/cell/cell
	var/obj/item/robot_parts/robot_component/armor/mech_armor
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/pilot_offset_x = 0
	var/pilot_offset_y = 0
	var/open_cabin = 0
	var/hatch_descriptor = "cockpit"
	var/list/pilot_positions
	var/pilot_coverage = 100
	var/transparent_cabin = FALSE
	var/hide_pilot = TRUE
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell =        locate() in src
	mech_armor =  locate() in src
	air_supply =  locate() in src

/obj/item/mech_component/chassis/New()
	..()
	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"[NORTH]" = list("x" = 8, "y" = 0),
				"[SOUTH]" = list("x" = 8, "y" = 0),
				"[EAST]"  = list("x" = 8, "y" = 0),
				"[WEST]"  = list("x" = 8, "y" = 0)
			)
		)

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(diagnostics)
	QDEL_NULL(mech_armor)
	QDEL_NULL(air_supply)
	. = ..()

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, "<span class='warning'>It is missing a power cell.</span>")
	if(!diagnostics)
		to_chat(user, "<span class='warning'>It is missing a diagnostics unit.</span>")
	if(!mech_armor)
		to_chat(user, "<span class='warning'>It is missing armor plating.</span>")

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	cockpit = new(20)
	if(loc)
		cockpit.equalize(loc.return_air())
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)

	var/changed
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = TRUE
	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && mech_armor)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/cell/mecha(src)
	cell.charge = cell.maxcharge

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, "<span class='warning'>\The [src] already has a diagnostic system installed.</span>")
			return
		if(install_component(thing, user)) diagnostics = thing
	else if(istype(thing, /obj/item/cell))
		if(cell)
			to_chat(user, "<span class='warning'>\The [src] already has a cell installed.</span>")
			return
		if(install_component(thing,user)) cell = thing
	else if(istype(thing, /obj/item/robot_parts/robot_component/armor/mech))
		if(mech_armor)
			to_chat(user, "<span class='warning'>\The [src] already has mech_armor installed.</span>")
			return
		if(install_component(thing, user))
			mech_armor = thing
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C) && do_after(user, 5, src))
		to_chat(user, "<span class='notice'>You install the canister in the [src].</span>")
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()