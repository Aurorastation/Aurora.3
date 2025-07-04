/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER
	pixel_y = -8
	center_of_mass = list("x"=24, "y"=20)

	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_RESISTANT,
		RAD = ARMOR_RAD_MINOR
	)

	var/mech_health = 600
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/cell/mecha/cell
	var/cell_type = /obj/item/cell/mecha
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

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	AddComponent(/datum/component/armor, armor, ARMOR_TYPE_STANDARD|ARMOR_TYPE_EXOSUIT)
	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"[NORTH]" = list("x" = 8, "y" = 0),
				"[SOUTH]" = list("x" = 8, "y" = 0),
				"[EAST]"  = list("x" = 8, "y" = 0),
				"[WEST]"  = list("x" = 8, "y" = 0)
			)
		)

	cockpit = new
	if(loc)
		cockpit.copy_from(loc.return_air())
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell =        locate() in src
	mech_armor =  locate() in src
	air_supply =  locate() in src

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(diagnostics)
	QDEL_NULL(mech_armor)
	QDEL_NULL(air_supply)
	. = ..()

/obj/item/mech_component/chassis/get_missing_parts_text()
	. = ..()

	if(!cell)
		. += SPAN_WARNING("It is missing a <a href='byond://?src=[REF(src)];info=cell'>power core</a>.")
	if(!diagnostics)
		. += SPAN_WARNING("It is missing a <a href='byond://?src=[REF(src)];info=diagnostics'>diagnostics unit</a>.")
	if(!mech_armor)
		. += SPAN_WARNING("It is missing <a href='byond://?src=[REF(src)];info=diagnostics'>armor plating</a>.")

/obj/item/mech_component/chassis/Topic(href, href_list)
	. = ..()
	if(.)
		return
	switch(href_list["info"])
		if("cell")
			to_chat(usr, SPAN_NOTICE("A power core can be created at a mechatronic fabricator."))
		if("diagnostics")
			to_chat(usr, SPAN_NOTICE("A diagnostics unit can be created at a mechatronic fabricator."))
		if("armor")
			to_chat(usr, SPAN_NOTICE("Armor plating can be created at a mechatronic fabricator."))

/obj/item/mech_component/chassis/return_diagnostics(mob/user)
	..()
	if(diagnostics)
		to_chat(user, SPAN_NOTICE("  - Diagnostics Unit Integrity: <b>[round(((diagnostics.max_dam - diagnostics.total_dam) / diagnostics.max_dam) * 100, 0.1)]%</b>"))
	else
		to_chat(user, SPAN_WARNING("  - Diagnostics Unit Missing or Non-functional."))
	if(mech_armor)
		to_chat(user, SPAN_NOTICE("  - Armor Integrity: <b>[round(((mech_armor.max_dam - mech_armor.total_dam) / mech_armor.max_dam) * 100, 0.1)]%</b>"))
	else
		to_chat(user, SPAN_WARNING("  - Armor Missing or Non-functional."))

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
	if(cell_type)
		cell = new cell_type(src)
		cell.charge = cell.maxcharge

/obj/item/mech_component/chassis/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, SPAN_WARNING("\The [src] already has a diagnostic system installed."))
			return
		if(install_component(attacking_item, user))
			diagnostics = attacking_item
	else if(istype(attacking_item, /obj/item/cell/mecha))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a core installed."))
			return
		if(install_component(attacking_item,user))
			cell = attacking_item
	else if(istype(attacking_item, /obj/item/robot_parts/robot_component/armor/mech))
		if(mech_armor)
			to_chat(user, SPAN_WARNING("\The [src] already has mech armor installed."))
			return
		if(install_component(attacking_item, user))
			mech_armor = attacking_item
	else
		return ..()

/obj/item/mech_component/chassis/mouse_drop_receive(atom/dropped, mob/user, params)
	var/obj/machinery/portable_atmospherics/canister/C = dropped
	if(istype(C) && do_after(user, 5, src))
		to_chat(user, SPAN_NOTICE("You install the canister into \the [src]."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()
