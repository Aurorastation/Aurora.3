/obj/item/weapon/mecha_equipment/mounted_system/rcd
	icon_state = "mecha_rcd"
	holding_type = /obj/item/weapon/rcd/borg
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

/obj/item/weapon/rcd/borg/get_hardpoint_status_value()
	var/obj/item/weapon/mecha_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner.body && MS.owner.body && MS.owner.body.cell)
		return MS.owner.body.cell.charge/MS.owner.body.cell.maxcharge
	return null