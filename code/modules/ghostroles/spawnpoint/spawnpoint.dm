#define STATE_UNAVAILABLE 1
#define STATE_AVAILABLE 2
#define STATE_RECHARGING 3
#define STATE_USED 4

/obj/effect/ghostspawpoint
	name = "invisible ghost spawner - single"
	desc = "A Invisible ghost spawner"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"

	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

	var/identifier = null //identifier of this spawnpoint

	var/single_use = FALSE //Ghost spawners with this set to TRUE will not be disabled.
	var/recharge_time = 0 //Time it takes until the ghostspawner can be used again
	var/unavailable_time = null //Time when the ghost spawner became unavailable
	var/icon_unavailable = "x2"
	var/icon_available = "x2" //Icon to use when available
	var/icon_recharging = "x2"	//Icon to use when recharging
	var/icon_used = "x2"	//Icon to use when spwanpoint has been used

	var/state = STATE_AVAILABLE

/obj/effect/ghostspawpoint/Initialize(mapload)
	. = ..()
	SSghostroles.add_spawnpoints(src)

/obj/effect/ghostspawpoint/update_icon()
	if(state == STATE_UNAVAILABLE)
		icon_state = icon_unavailable
	else if(state == STATE_AVAILABLE)
		icon_state = icon_available
	else if (state == STATE_RECHARGING)
		icon_state = icon_recharging
	else if (state == STATE_USED)
		icon_state = icon_used
	else
		icon_state = initial(icon_state)

/obj/effect/ghostspawpoint/process()
	if(recharge_time && (recharge_time * 10) > (world.time - unavailable_time))
		STOP_PROCESSING(SSprocessing, src)
		state = STATE_AVAILABLE
		update_icon()

/obj/effect/ghostspawpoint/attack_ghost(mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	SSghostroles.vui_interact(user,identifier)

/obj/effect/ghostspawpoint/attack_hand(mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	SSghostroles.vui_interact(user,identifier)

/obj/effect/ghostspawpoint/proc/is_available()
	return TRUE

/obj/effect/ghostspawpoint/proc/set_spawned()
	if(recharge_time) //If we are available again after a certain time -> being processing
		state = STATE_RECHARGING
		unavailable_time = world.time
		START_PROCESSING(SSprocessing, src)
	else
		if(single_use)
			state = STATE_USED
	update_icon()

/obj/effect/ghostspawpoint/proc/set_available()
	if(state == STATE_USED)
		return //if its a one-use spawner and it got used already, dont reset it
	state = STATE_AVAILABLE
	update_icon()

/obj/effect/ghostspawpoint/proc/set_unavailable()
	if(state == STATE_USED)
		return //if its a one-use spawner and it got used already, dont reset it
	else if(state == STATE_RECHARGING)
		STOP_PROCESSING(SSprocessing, src)

	state = STATE_UNAVAILABLE
	update_icon()

#undef STATE_UNAVAILABLE
#undef STATE_AVAILABLE
#undef STATE_RECHARGING
#undef STATE_USED

/obj/effect/ghostspawpoint/repeat
	name = "invisible ghost spawner - repeat"
	desc = "A Invisible ghost spawner"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x3"

	icon_unavailable = "x3" //Icon to use when unavailable
	icon_available = "x3" //Icon to use when available
	icon_recharging = "x3" //Icon to use when recharging
	icon_used = "x3" //Icon to use when spwanpoint has been used

	recharge_time = 1
	single_use = TRUE

/obj/effect/ghostspawpoint/one_use
	name = "single use ghost spawner"
	single_use = TRUE

/obj/effect/ghostspawpoint/cryo
	name = "cryogenic storage pod"
	desc = "A pod used to store individual in suspended animation"
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "sleeper-closed"

	identifier = null //identifier of this spawnpoint

	icon_unavailable = "sleeper-closed" //Icon to use when unavailable
	icon_available = "sleeper-closed" //Icon to use when available
	icon_recharging = "sleeper"	//Icon to use when recharging
	icon_used = "sleeper"	//Icon to use when spwanpoint has been used

	anchored = 1
	unacidable = 1
	simulated = 1
	invisibility = 0

/obj/effect/ghostspawpoint/button
	name = "button"
	desc = "A button used for some kind of purpose."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"

	identifier = null

	icon_unavailable = "doorctrl0"
	icon_available = "doorctrl-p"
	icon_recharging = "doorctrl-p"
	icon_used = "doorctrl-p"

	anchored = 1
	unacidable = 1
	simulated = 1
	invisibility = 0

	var/use_message = "An assistant has been requested. One will be with you shortly if available."
	var/message_used = FALSE

/obj/effect/ghostspawpoint/button/set_available()
	..()
	if(use_message && !message_used)
		message_used = TRUE
		visible_message(SPAN_NOTICE(use_message))
		playsound(src.loc, 'sound/machines/chime.ogg', 25, 1)