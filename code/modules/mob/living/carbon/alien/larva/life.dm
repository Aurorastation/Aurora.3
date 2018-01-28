//Larvae regenerate health and nutrition from plasma and alien weeds.
/mob/living/carbon/alien/larva/handle_environment(var/datum/gas_mixture/environment)

	if(!environment) return

	var/turf/T = get_turf(src)
	var/obj/effect/plant/plant = locate() in T
	if(environment.gas["phoron"] > 0 || (plant && plant.seed.type == /datum/seed/xenomorph))
		update_progression()
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)
