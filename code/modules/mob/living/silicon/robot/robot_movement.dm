/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module?.no_slip)
		return FALSE
	..(prob_slip)

/mob/living/silicon/robot/Allow_Spacemove()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.modules)
			if(J && J.allow_thrust(0.01))
				return TRUE
	. = ..()

// NEW: Different power usage depending on whether driving or jetpacking. space movement is easier
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if(istype(n, /turf/space))
		if(cell_use_power(jetpackComponent.active_usage))
			return ..()

	if(!is_component_functioning("actuator"))
		return FALSE

	if(cell_use_power(actuatorComponent.active_usage))
		return ..()