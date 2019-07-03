/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER

	var/mech_health = 300
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/weapon/cell/cell
	var/obj/item/mech_component/plating/armour
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/pilot_offset_x = 0
	var/pilot_offset_y = 0
	var/open_cabin = 0
	var/hatch_descriptor = "cockpit"
	var/pilot_coverage = 100

/obj/item/mech_component/chassis/New()
	..()
	cockpit = new(200)
	update_air()

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)
	var/changed
	if(!take_from_supply || open_cabin)
		var/turf/T = get_turf(src)
		cockpit.equalize(T.return_air())
		//T.air_update_turf(1) //TODO: Fix undefined proc
		changed = 1
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = 1
	if(changed) cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && armour)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/weapon/cell/hyper(src)
	cell.charge = cell.maxcharge
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			user << "<span class='warning'>\The [src] already has a diagnostic system installed.</span>"
			return
		diagnostics = thing
		install_component(thing, user)
	else if(istype(thing, /obj/item/weapon/cell))
		if(cell)
			user << "<span class='warning'>\The [src] already has a cell installed.</span>"
			return
		cell = thing
		install_component(thing,user)
	else if(istype(thing, /obj/item/mech_component/plating))
		if(armour)
			user << "<span class='warning'>\The [src] already has armour installed.</span>"
			return
		armour = thing
		install_component(thing, user)
	else
		return ..()

/obj/item/mech_component/plating
	name = "vehicle armour"
	armor = list(melee = 80, bullet = 65, laser = 50, energy = 15, bomb = 80, bio = 100, rad = 60) // Rebalance this.
	icon_state = "armour"
	icon = 'icons/mecha/mech_part_items.dmi'
	pixel_x = 0