/client/proc/clear_toxins()
	set category = "Special Verbs"
	set name = "Clear Toxin/Fire in Zone"
	set desc = "Remove fires from your current zone and reset the atmosphere to human-perfect gas mix, pressure, and temp."

	if (!check_rights(R_ADMIN) && !isstoryteller(usr))
		return

	if(!usr.loc) return

	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.gas[GAS_PHORON] = 0
	environment.gas[GAS_NITROGEN] = 82.1472
	environment.gas[GAS_OXYGEN] = 21.8366
	environment.gas[GAS_CO2] = 0
	environment.gas[GAS_N2O] = 0
	environment.gas[GAS_HYDROGEN] = 0
	environment.temperature = 293.15
	environment.update_values()
	var/turf/simulated/location = get_turf(usr)
	if (istype(location, /turf/space))
		return

	if (location.zone)
		for (var/turf/T in location.zone.contents)
			for (var/obj/fire/F in T.contents)
				qdel(F)

		log_and_message_admins("cleared air and fire in area [get_area(usr)].")
