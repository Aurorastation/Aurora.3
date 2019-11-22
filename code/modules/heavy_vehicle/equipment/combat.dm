/obj/item/mecha_equipment/mounted_system/taser
	name = "mounted electrolaser carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	icon_state = "mecha_taser"
	holding_type = /obj/item/gun/energy/taser/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mecha_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mecha_ion"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	holding_type = /obj/item/gun/energy/rifle/ionrifle/mounted/mech

/obj/item/mecha_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mecha_laser"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	holding_type = /obj/item/gun/energy/laser/mounted/mech

/obj/item/mecha_equipment/mounted_system/taser/smg
	name = "mounted machinegun"
	desc = "An exosuit-mounted automatic weapon. Handle with care."
	icon_state = "mecha_ballistic"
	holding_type = /obj/item/gun/energy/mountedsmg

/obj/item/gun/energy/taser/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/rifle/ionrifle/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null
