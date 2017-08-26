// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds (AI is faster when it comes to complex electronics)
// Used for advanced grid control (read: Substations)

/obj/machinery/power/breakerbox
	name = "breaker box"
	desc = "A large machine with heavy duty switching circuits used for advanced grid control."
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_off"
	//directwired = 0
	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	density = 1
	anchored = 1
	var/on = 0
	var/busy = 0
	var/directions = list(1,2,4,8,5,6,9,10)
	var/RCon_tag = "NO_TAG"
	var/update_locked = 0

/obj/machinery/power/breakerbox/Initialize()
	LAZYADD(SSpower.breaker_boxes, src)
	return ..()

/obj/machinery/power/breakerbox/Destroy()
	LAZYREMOVE(SSpower.breaker_boxes, src)
	SSmachinery.queue_rcon_update()
	return ..()

/obj/machinery/power/breakerbox/activated
	icon_state = "bbox_on"

	// Enabled on server startup. Used in substations to keep them in bypass mode.
/obj/machinery/power/breakerbox/activated/Initialize()
	. = ..()
	set_state(1)	

/obj/machinery/power/breakerbox/examine(mob/user)
	..()
	if(on)
		user << "<span class='good'>It seems to be online.</span>"
	else
		user << "<span class='bad'>It seems to be offline.</span>"

/obj/machinery/power/breakerbox/attack_ai(mob/user)
	if(update_locked)
		user << "<span class='bad'>System locked. Please try again later.</span>"
		return

	if(busy)
		user << "<span class='bad'>System is busy. Please wait until current operation is finished before changing power settings.</span>"
		return

	busy = 1
	user << "<span class='good'>Updating power settings..</span>"
	if(do_after(user, 50))
		set_state(!on)
		user << "<span class='good'>Update Completed. New setting:[on ? "on": "off"]</span>"
		update_locked = 1
		addtimer(CALLBACK(src, .proc/reset_locked), 600)
	busy = 0

/obj/machinery/power/breakerbox/proc/reset_locked()
	update_locked = 0


/obj/machinery/power/breakerbox/attack_hand(mob/user)
	if(update_locked)
		user << "<span class='bad'>System locked. Please try again later.</span>"
		return

	if(busy)
		user << "<span class='bad'>System is busy. Please wait until current operation is finished before changing power settings.</span>"
		return

	busy = 1
	for(var/mob/O in viewers(user))
		O.show_message(text("<span class='warning'>[user] started reprogramming [src]!</span>"), 1)

	if(do_after(user, 50))
		set_state(!on)
		user.visible_message(\
		"<span class='notice'>[user.name] [on ? "enabled" : "disabled"] the breaker box!</span>",\
		"<span class='notice'>You [on ? "enabled" : "disabled"] the breaker box!</span>")
		update_locked = 1
		addtimer(CALLBACK(src, .proc/reset_locked), 600)
	busy = 0

/obj/machinery/power/breakerbox/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(ismultitool(W))
		var/newtag = input(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system") as text
		if(newtag)
			RCon_tag = newtag
			user << "<span class='notice'>You changed the RCON tag to: [newtag]</span>"
			SSmachinery.queue_rcon_update()

/obj/machinery/power/breakerbox/proc/set_state(var/state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in directions)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			C.breaker_box = src

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)

// Used by RCON to toggle the breaker box.
/obj/machinery/power/breakerbox/proc/auto_toggle()
	if(!update_locked)
		set_state(!on)
		update_locked = 1
		addtimer(CALLBACK(src, .proc/reset_locked), 600)
