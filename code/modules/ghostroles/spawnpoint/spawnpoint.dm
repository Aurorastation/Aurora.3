#define STATE_AVAILABLE 1
#define STATE_RECHARGING 2
#define STATE_USED 3

/obj/effect/ghostspawner
	name = "invisible ghost spawner - single"
	desc = "A Invisible ghost spawner"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"

	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/identifier = null //identifier of this spawnpoint

	var/recharge_time = 0 //Time it takes until the ghostspawner can be used again
	var/unavailable_time = null //Time when the ghost spawner became unavailable
	var/icon_available = "x2" //Icon to use when available
	var/icon_recharging = "x2"	//Icon to use when recharging
	var/icon_used = "x2"	//Icon to use when spwanpoint has been used

	var/state = STATE_AVAILABLE

/obj/effect/ghostspawner/Initialize(mapload)
	. = ..()
	SSghostroles.add_spawnpoints(src)

/obj/effect/ghostspawner/Destroy()
	SSghostroles.remove_spawnpoints(src)
	return ..()

/obj/effect/ghostspawner/update_icon()
	if(state == STATE_AVAILABLE)
		icon_state = icon_available
	else if (state == STATE_RECHARGING)
		icon_state = icon_recharging
	else if (state == STATE_USED)
		icon_state = icon_used
	else
		icon_state = initial(icon_state)

/obj/effect/ghostspawner/process()
	if(recharge_time && (recharge_time * 10) > (world.time - unavailable_time))
		STOP_PROCESSING(SSprocessing, src)
		state = STATE_AVAILABLE
		update_icon()

/obj/structure/mob_spawner/attack_ghost(mob/user)
	//TODO: Open the ui filtered for roles with this identifier

/obj/effect/ghostspawner/proc/is_available()
	return state == STATE_AVAILABLE

/obj/effect/ghostspawner/proc/spawn_mob()
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

/obj/effect/ghostspawner/repeat
	name = "invisible ghost spawner - repeat"
	desc = "A Invisible ghost spawner"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x3"

	icon_available = "x3" //Icon to use when available
	icon_recharging = "x3" //Icon to use when recharging
	icon_used = "x3" //Icon to use when spwanpoint has been used

	recharge_time = 1


/obj/effect/ghostspawner/cryo
	name = "cryogenic storage pod"
	desc = "A pod used to store individual in suspended animation"
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "sleeper-closed"

	identifier = null //identifier of this spawnpoint

	icon_available = "sleeper-closed" //Icon to use when available
	icon_recharging = "sleeper"	//Icon to use when recharging
	icon_used = "sleeper"	//Icon to use when spwanpoint has been used

	anchored = 1
	unacidable = 1
	simulated = 1
	invisibility = 0