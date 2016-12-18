/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Process_Spacemove(var/check_drift = 0)//Cleaned up, fixed and simplified this function
	//If checkdrift is 0, we're checking to see if we can manually move, return true if jetpack is on
	//if checkdrift is 1, we're checking to see if we drift. Return true if jetpack AND stabilisers are on
	if(jetpack)
		//var/obj/item/weapon/tank/jetpack/J = internals

		if (check_drift)
			if (jetpack.stabilization_on && jetpack.allow_thrust(0.01))
				inertia_dir = 0
				return 1

		else if(jetpack.allow_thrust(0.01))
			inertia_dir = 0
			return 1
	if(..())//The parent function checks for nearby objects to hold onto
		return 1
	return 0

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3

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