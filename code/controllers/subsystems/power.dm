/var/datum/controller/subsystem/power/SSpower

// This doesn't do a whole lot right now.
// For now.

/datum/controller/subsystem/power
	name = "Power"
	flags = SS_NO_FIRE
	init_order = SS_INIT_POWER

	var/list/rcon_smes_units = list()
	var/list/rcon_smes_units_by_tag = list()
	var/list/rcon_breaker_units = list()
	var/list/rcon_breaker_units_by_tag = list()

	var/list/breaker_boxes = list()
	var/list/smes_units = list()

	var/list/all_cables = list()
	var/list/all_sensors = list()

	var/list/powernets = list()

/datum/controller/subsystem/power/stat_entry()
	..("PN:[powernets.len]")

/datum/controller/subsystem/power/New()
	NEW_SS_GLOBAL(SSpower)

/datum/controller/subsystem/power/Recover()
	all_cables = SSpower.all_cables
	breaker_boxes = SSpower.breaker_boxes
	all_sensors = SSpower.all_sensors

/datum/controller/subsystem/power/Initialize()
	makepowernets()
	build_rcon_lists()
	..()

// This is called by SSmachinery.
/datum/controller/subsystem/power/proc/build_rcon_lists()
	rcon_smes_units.Cut()
	rcon_breaker_units.Cut()
	rcon_breaker_units_by_tag.Cut()

	for(var/obj/machinery/power/smes/buildable/SMES in smes_units)
		if(SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			rcon_smes_units += SMES
			rcon_smes_units_by_tag[SMES.RCon_tag] = SMES

	for(var/obj/machinery/power/breakerbox/breaker in breaker_boxes)
		if(breaker.RCon_tag != "NO_TAG")
			rcon_breaker_units += breaker
			rcon_breaker_units_by_tag[breaker.RCon_tag] = breaker

	sortTim(rcon_smes_units, /proc/cmp_rcon_smes)
	sortTim(rcon_breaker_units, /proc/cmp_rcon_bbox)

/datum/controller/subsystem/power/proc/reset_powernets()
	for (var/thing in powernets)
		var/datum/powernet/PN = thing

		PN.reset()
