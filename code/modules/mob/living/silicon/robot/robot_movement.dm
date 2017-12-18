/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Allow_Spacemove()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.modules)
			if(J && J.allow_thrust(0.01))
				return 1
	. = ..()

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3

	if(overclocked == 1)
		tally-=1

	return tally+config.robot_delay

// NEW: Different power usage depending on whether driving or jetpacking. space movement is easier
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (istype(n, /turf/space))
		if (cell_use_power(jetpackComponent.active_usage))
			return ..()

	if (!is_component_functioning("actuator"))
		return 0

	if (cell_use_power(actuatorComponent.active_usage))
		return ..()
