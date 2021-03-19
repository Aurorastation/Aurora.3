/mob/living/heavy_vehicle/proc/can_move(var/mob/user)
	. = 0
	if(world.time < next_mecha_move)
		return

	if(incapacitated() || (user && user.incapacitated()) || lockdown)
		return

	if(!legs)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] has no means of propulsion!</span>")
		next_mecha_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return

	if(!legs.motivator || legs.total_damage > 45)
		if(user)
			to_chat(user, "<span class='warning'>Your motivators are damaged! You can't move!</span>")
		next_mecha_move = world.time + 15
		return

	next_mecha_move = world.time + legs.move_delay

	if(maintenance_protocols)
		if(user)
			to_chat(user, "<span class='warning'>Maintenance protocols are in effect.</span>")
		return

	var/obj/item/cell/C = get_cell()
	if(!C || !C.check_charge(legs.power_use * CELLRATE))
		if(user)
			to_chat(user, "<span class='warning'>The power indicator flashes briefly.</span>")
		return

	return TRUE

/mob/living/heavy_vehicle/get_standard_pixel_x()
	return offset_x

/mob/living/heavy_vehicle/proc/toggle_maintenance_protocols()
	var/obj/screen/mecha/toggle/maint/M = locate() in hud_elements
	M.toggled()
	return TRUE

/mob/living/heavy_vehicle/proc/toggle_hatch()
	var/obj/screen/mecha/toggle/hatch_open/H = locate() in hud_elements
	H.toggled()
	return TRUE

/mob/living/heavy_vehicle/proc/toggle_lock()
	var/obj/screen/mecha/toggle/hatch/L = locate() in hud_elements
	L.toggled()
	return TRUE

/mob/living/heavy_vehicle/proc/can_listen()
	return TRUE

/mob/living/heavy_vehicle/proc/assign_leader(var/mob/living/carbon/human/H)
	leader_name = H.name
	leader = WEAKREF(H)

/mob/living/heavy_vehicle/proc/unassign_leader()
	leader = null
	leader_name = null

/mob/living/heavy_vehicle/proc/assign_following(var/mob/living/carbon/human/H)
	following_name = H.name
	following = WEAKREF(H)

/mob/living/heavy_vehicle/proc/unassign_following()
	following = null
	following_name = null

/mob/living/heavy_vehicle/proc/prepare_nickname(var/text)
	text = replacemany(text, list("\"" = "", "." = "", "," = ""))
	text = trim_left(text)
	text = trim_right(text)
	return text