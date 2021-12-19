/datum/export/phoron_canister
	cost = 2000 // on average, the bounty would be 3 canisters giving 9000 credits, meaning 3000 credits per. however, this is repeatable, so lower it by 1000
	k_elasticity = 0
	unit_name = "phoron canister"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
	var/moles_required = 2000 //Roundstart total_moles for a FULL tank is about 1871 per tank. However during the arc this bounty is relevant, tanks are half full.

/datum/export/phoron_canister/applies_to(obj/machinery/portable_atmospherics/canister/O, contr, emag)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE

	var/datum/gas_mixture/environment = O.return_air()
	if(!environment || !O.air_contents.gas["phoron"])
		return FALSE

	return O.air_contents.gas["phoron"] >= moles_required
