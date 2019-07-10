#define STATE_AVAILABLE 1
#define STATE_RECHARGING 2
#define STATE_USED 3

/obj/structure/ghostspawner
	name = "cryogenic storage pod"
	desc = "A pod used to store individual in suspended animation"
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "sleeper_1"

	var/identifier = null //identifier of this spawnpoint

	var/recharge_time = 0 //Time it takes until the ghostspawner can be used again
	var/unavailable_time = null //Time that has elapsed since it became unavailable
	var/icon_available = "sleeper_1" //Icon to use when available
	var/icon_recharging = null	//Icon to use when recharging
	var/icon_used = "sleeper_0"	//Icon to use when spwanpoint has been used

	var/state = STATE_AVAILABLE

/obj/structure/ghostspawner/Initialize(mapload)
	. = ..()
	SSghostroles.add_spawnpoints(src)

/obj/structure/ghostspawner/Destroy()
	SSghostroles.remove_spawnpoints(src)
	return ..()

/obj/structure/ghostspawner/update_icon()
	if(state == STATE_AVAILABLE)
		icon_state = icon_available
	else if (state == STATE_RECHARGING)
		icon_state = icon_recharging
	else if (state == STATE_USED)
		icon_state = icon_used
	else
		icon_state = initial(icon_state)

/obj/structure/ghostspawner/process()
	if(recharge_time && (recharge_time * 10) > (world.time - unavailable_time))
		STOP_PROCESSING(SSprocessing, src)
		state = STATE_AVAILABLE
		update_icon()

/obj/structure/mob_spawner/attack_ghost(mob/user)
	//TODO: Open the ui filtered for roles with this identifier

/obj/structure/ghostspawner/proc/is_available()
	return state == STATE_AVAILABLE

/obj/structure/ghostspawner/proc/spawn_mob()
	if(recharge_time) //If we are available again after a certain time -> being processing
		state = STATE_RECHARGING
		unavailable_time = world.time
		START_PROCESSING(SSprocessing, src)
	else
		state = STATE_USED
	update_icon()

#undef STATE_AVAILABLE
#undef STATE_RECHARGING
#undef STATE_USED