/client/proc/clear_toxins()
	set category = "Special Verbs"
	set name = "Clear Toxin/Fire in Zone"

	if (!check_rights(R_ADMIN))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.gas["phoron"] = 0
	environment.gas["nitrogen"] = 82.1472
	environment.gas["oxygen"] = 21.8366
	environment.gas["carbon_dioxide"] = 0
	environment.gas["sleeping_agent"] = 0
	environment.gas["oxygen_agent_b"] = 0
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
