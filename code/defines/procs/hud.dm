/* Using the HUD procs is simple. Call these procs in the life.dm of the intended mob.
Use the regular_hud_updates() proc before process_med_hud(mob) or process_sec_hud(mob) so
the HUD updates properly! */

//HUD image type used to properly clear client.images precisely
/image/hud_overlay
	appearance_flags = APPEARANCE_UI

	///Owner of the hud_overlay, aka who has the overlay
	var/mob/living/owner = null

/image/hud_overlay/New(icon, loc, icon_state, layer, dir)
	. = ..()

	if(ismob(loc))
		owner = loc

/image/hud_overlay/Destroy()
	if(owner)
		owner?.client?.images -= src
		owner = null

	. = ..()

//Medical HUD outputs. Called by the Life() proc of the mob using it, usually.
/proc/process_med_hud(var/mob/M, var/local_scanner, var/mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, GLOB.med_hud_users)
	for(var/mob/living/carbon/human/patient in P.Mob.in_view(P.Turf))
		if(patient.is_invisible_to(M))
			continue

		if(local_scanner)
			P.Client.images += patient.hud_list[HEALTH_HUD]
			P.Client.images += patient.hud_list[STATUS_HUD]
			P.Client.images += patient.hud_list[TRIAGE_HUD]
		else
			var/sensor_level = getsensorlevel(patient)
			if(sensor_level >= SUIT_SENSOR_VITAL)
				P.Client.images += patient.hud_list[HEALTH_HUD]
			if(sensor_level >= SUIT_SENSOR_BINARY)
				P.Client.images += patient.hud_list[LIFE_HUD]
				P.Client.images += patient.hud_list[TRIAGE_HUD]

//Security HUDs. Pass a value for the second argument to enable implant viewing or other special features.
/proc/process_sec_hud(var/mob/M, var/advanced_mode, var/mob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, GLOB.sec_hud_users)
	for(var/mob/living/carbon/human/perp in P.Mob.in_view(P.Turf))
		if(perp.is_invisible_to(M))
			continue

		P.Client.images += perp.hud_list[ID_HUD]
		if(advanced_mode)
			P.Client.images += perp.hud_list[WANTED_HUD]
			P.Client.images += perp.hud_list[IMPTRACK_HUD]
			P.Client.images += perp.hud_list[IMPLOYAL_HUD]
			P.Client.images += perp.hud_list[IMPCHEM_HUD]

/datum/arranged_hud_process
	var/client/Client
	var/mob/Mob
	var/turf/Turf

/datum/arranged_hud_process/Destroy(force)
	Client = null
	Mob = null
	Turf = null
	. = ..()

/proc/arrange_hud_process(var/mob/M, var/mob/Alt, var/list/hud_list)
	hud_list |= M
	var/datum/arranged_hud_process/P = new
	P.Client = M.client
	P.Mob = Alt ? Alt : M
	P.Turf = get_turf(P.Mob)
	return P

/proc/can_process_hud(var/mob/M)
	if(!M)
		return 0
	if(!M.client)
		return 0
	if(M.stat != CONSCIOUS)
		return 0
	return 1

//Deletes the current HUD images so they can be refreshed with new ones.
/mob/proc/handle_hud_glasses() //Used in the life.dm of mobs that can use HUDs.
	if(client)
		for(var/image/hud_overlay/hud in client.images)
			client.images -= hud
	GLOB.med_hud_users -= src
	GLOB.sec_hud_users -= src

/mob/proc/in_view(var/turf/T)
	RETURN_TYPE(/list)

	return get_hearers_in_LOS(client?.view, T)

/mob/abstract/eye/in_view(var/turf/T)
	RETURN_TYPE(/list)

	// This was like this before, honestly i don't see the point of doing it this way hence the change, but I left the code for reference in case shit hits the fan
	// var/list/viewed = new
	// for(var/mob/living/carbon/human/H in GLOB.mob_list)
	// 	if(get_dist(H, T) <= client?.view)
	// 		viewed += H
	// return viewed

	//Some virtual eyes eg. the AI eye doesn't have a client but an owner, select it as preferred if so, otherwise use the mob's client itself
	return get_hearers_in_range((src.owner ? src.owner.client?.view : src.client?.view), T)

/proc/get_sec_hud_icon(var/mob/living/carbon/human/H)//This function is called from human/life,dm, ~line 1663
	var/state
	var/obj/item/card/id/I = H.GetIdCard()
	if(I)
		state = "hud[ckey(I.GetJobName())]"
	else
		state = "hudunknown"

	return state

/// Wrapper for adding anything to a client's screen
/client/proc/add_to_screen(screen_add)
	screen += screen_add
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_ADD, screen_add)

/// Wrapper for removing anything from a client's screen
/client/proc/remove_from_screen(screen_remove)
	screen -= screen_remove
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_REMOVE, screen_remove)
