/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.
Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

#define HOLOPAD_PASSIVE_POWER_USAGE 1
#define HOLOGRAM_POWER_USAGE 2

/obj/machinery/hologram/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon_state = "holopad0"

	layer = ON_TURF_LAYER //Preventing rats and drones from sneaking under them.

	var/power_per_hologram = 500 //per usage per hologram
	idle_power_usage = 5
	use_power = POWER_USE_IDLE

	var/holopad_id

	var/list/active_holograms
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 7 // Change to change how far the AI can move away from the holopad before deactivating

	var/incoming_connection = FALSE
	var/established_connection = FALSE
	var/obj/machinery/hologram/holopad/connected_pad
	var/forced = FALSE
	var/hacked = FALSE
	var/last_message

/obj/machinery/hologram/holopad/Initialize()
	. = ..()
	var/area/A = get_area(src)
	holopad_id = "[A.name] ([src.x]-[src.y]-[src.z])"
	desc += " Its ID is '[holopad_id]'"

	listening_objects += src

/obj/machinery/hologram/holopad/examine(mob/user)
	. = ..()
	if(connected_pad)
		if(established_connection)
			to_chat(user, SPAN_NOTICE("\The [src] is currently in a call with a holopad with ID: [connected_pad.holopad_id]"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is currently pending connection with a holopad with ID: [connected_pad.holopad_id]"))

/obj/machinery/hologram/holopad/update_icon(var/recurse = TRUE)
	if(LAZYLEN(active_holograms) || has_established_connection())
		icon_state = "holopad2"
		set_light(2)
	else if(incoming_connection || connected_pad?.incoming_connection)
		icon_state = "holopad1"
		set_light(1)
	else
		icon_state = "holopad0"
		set_light(0)

/obj/machinery/hologram/holopad/attack_hand(var/mob/user) //Carn: Hologram requests.
	user.visible_message("<b>[user]</b> presses their foot down on \the [src]'s easy-select multi-function button.", SPAN_NOTICE("You press your foot down on \the [src]'s easy-select multi-function button."))
	if(incoming_connection)
		audible_message("The pad hums quietly as it establishes a connection.")
		take_call()
		return
	else if(connected_pad)
		if(forced)
			audible_message("Access denied. Terminating a command-level transmission locally is not permitted.")
			return
		end_call()
		audible_message("Severing connection to distant holopad.")
		return

	if(last_request + 20 SECONDS > world.time)
		to_chat(user, SPAN_WARNING("\The [src] is still cooling down since the last transmission."))
		return

	switch(alert(user, "Would you like to request an AI's presence or establish communications with another pad?", "Holopad", "AI", "Holocomms", "Cancel"))
		if("AI")
			last_request = world.time
			to_chat(user, SPAN_NOTICE("You request an AI's presence."))
			var/area/area = get_area(src)
			for(var/mob/living/silicon/ai/AI in silicon_mob_list)
				if(!AI.client)
					continue
				to_chat(AI, SPAN_INFO("Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>."))
		if("Holocomms")
			last_request = world.time
			var/obj/item/card/id/I = user.GetIdCard()
			if(!I)
				to_chat(user, SPAN_NOTICE("You need authorization to use the holocall system. Please equip a valid ID card."))
				return
			var/forced_call = FALSE
			if(access_heads in I.access) //Special functions for command level people
				switch(alert(user,"Command level authorization detected. Additional functions available.", "Command Level Menu", "Forced Call", "Regular Call"))
					if("Forced Call")
						forced_call = TRUE
			var/list/holopadlist = list()
			for(var/obj/machinery/hologram/holopad/H in SSmachinery.processing_machines - src)
				if(AreConnectedZLevels(H.z, z) && H.operable())
					holopadlist["[H.holopad_id]"] = H	//Define a list and fill it with the area of every holopad in the world
			holopadlist = sortAssoc(holopadlist)
			var/chosen_pad = input(user, "Which holopad would you like to contact?", "Holopad List") as null|anything in holopadlist
			if(!chosen_pad)
				last_request = world.time - 15 SECONDS
				return
			var/obj/machinery/hologram/holopad/HP = holopadlist[chosen_pad]
			if(HP.has_established_connection() || HP.incoming_connection)
				audible_message("The selected holopad is already in, or is waiting to accept, a call.")
				last_request = world.time - 15 SECONDS
				return
			connected_pad = HP
			make_call(connected_pad, user, forced_call)

/obj/machinery/hologram/holopad/proc/make_call(var/obj/machinery/hologram/holopad/connected_pad, var/mob/user, forced_call)
	connected_pad.last_request = world.time
	connected_pad.connected_pad = src //This marks the holopad you are making the call from
	connected_pad.incoming_connection = TRUE
	playsound(connected_pad.loc, 'sound/machines/chime.ogg', 25, 5)
	connected_pad.update_icon()
	update_icon()

	if(forced_call)
		connected_pad.audible_message("<b>[src]</b> announces, \"Incoming call with command authorization from [connected_pad.holopad_id].\"")
		to_chat(user, SPAN_NOTICE("Establishing forced connection to the holopad in [connected_pad.holopad_id]."))
		connected_pad.forced = TRUE
		sleep(80)
		connected_pad.take_call()
	else
		connected_pad.audible_message("<b>[src]</b> announces, \"Incoming communications request from [connected_pad.connected_pad.holopad_id].\"")
		to_chat(user, SPAN_NOTICE("Trying to establish a connection to the holopad in [connected_pad.holopad_id]... Please await confirmation from recipient."))

/obj/machinery/hologram/holopad/proc/take_call()
	incoming_connection = FALSE
	established_connection = TRUE
	connected_pad.established_connection = TRUE
	create_holos()
	connected_pad.create_holos()
	connected_pad.update_icon()
	update_icon()

/obj/machinery/hologram/holopad/proc/end_call()
	connected_pad.incoming_connection = FALSE
	connected_pad.clear_holos(FALSE)
	connected_pad.connected_pad = null
	clear_holos(FALSE)
	established_connection = FALSE
	connected_pad.established_connection = FALSE
	connected_pad.update_icon()
	connected_pad = null
	update_icon()

/obj/machinery/hologram/holopad/proc/has_established_connection()
	if(connected_pad?.established_connection && established_connection)
		return TRUE
	return FALSE

/obj/machinery/hologram/holopad/check_eye(mob/user)
	if(LAZYISIN(active_holograms, user))
		return 0
	return -1

/obj/machinery/hologram/holopad/attack_ai(mob/living/silicon/user)
	if(!istype(user))
		return

	if(!ai_can_interact(user))
		return

	if(isrobot(user))
		attack_hand(user)
		return

	if(user.eyeobj.loc != src.loc)
		user.eyeobj.setLoc(get_turf(src))

	if(!LAZYISIN(active_holograms, user)) //If there is no hologram, possibly make one.
		visible_message("A holographic image of [user] flicks to life right before your eyes!")
		user.holo = src
		create_holo(user)
	else //If there is a hologram, remove it.
		user.holo = null
		clear_holo(user)

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/hologram/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	var/name_used = M.GetVoice()
	if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		if(!SA.universal_speak && !length(SA.languages))
			text = pick(SA.speak)
	for(var/mob/living/silicon/ai/master in active_holograms)
		if(!master.say_understands(M, speaking))//The AI will be able to understand most mobs talking through the holopad.
			if(speaking)
				text = speaking.scramble(text)
			else
				text = stars(text)

		//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
		var/rendered
		if(speaking)
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
		else
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
		master.show_message(rendered, 2)
	if(has_established_connection())
		var/message
		if(speaking)
			message = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
		else
			message = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
		connected_pad.audible_message(message)
		connected_pad.last_message = message

/obj/machinery/hologram/holopad/see_emote(mob/living/M, text)
	for(var/mob/living/silicon/ai/master in active_holograms)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
		master.show_message(rendered, 2)
	if(has_established_connection())
		connected_pad.visible_message("<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>")

/obj/machinery/hologram/holopad/show_message(msg, type, alt, alt_type)
	for(var/mob/living/silicon/ai/master in active_holograms)
		var/rendered = "<i><span class='game say'>The holographic image of <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)
	if(findtext(msg, "Holopad received,"))
		return
	for(var/mob/living/carbon/master in active_holograms)
		var/rendered = "<i><span class='game say'>The holographic image of <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)

/obj/machinery/hologram/holopad/proc/create_holos()
	for(var/mob/living/M in viewers(world.view, connected_pad))
		if(LAZYISIN(active_holograms, M))
			continue
		create_holo(M)

/obj/machinery/hologram/holopad/proc/create_holo(mob/M)
	var/obj/effect/overlay/hologram/H = new(get_turf(src))
	if(!isAI(M) && connected_pad)
		H.x = src.x - (connected_pad.x - M.x)
		H.y = src.y - (connected_pad.y - M.y)
	if(!isInSight(H, src))
		qdel(H)
		return
	H.assume_form(M)
	LAZYSET(active_holograms, M, H)

	update_icon()

/obj/machinery/hologram/holopad/proc/update_holos()
	for(var/thing in active_holograms)
		var/mob/M = thing
		if(isAI(M))
			continue
		var/obj/effect/overlay/hologram/H = active_holograms[thing]
		if(connected_pad)
			H.x = src.x - (connected_pad.x - M.x)
			H.y = src.y - (connected_pad.y - M.y)
		if(get_dist(H, src) > world.view || !isInSight(H, src))
			clear_holo(M)
			return
		H.assume_form(M)

/obj/machinery/hologram/holopad/proc/clear_holos(var/clear_ai = TRUE)
	for(var/M in active_holograms)
		if(!clear_ai && isAI(M))
			continue
		clear_holo(M)

/obj/machinery/hologram/holopad/proc/clear_holo(var/mob/M)
	if(!LAZYLEN(active_holograms))
		return
	qdel(active_holograms[M])
	LAZYREMOVE(active_holograms, M)
	update_icon()

/obj/machinery/hologram/holopad/machinery_process()
	for(var/thing in active_holograms)
		var/mob/M = thing
		var/is_inactive_ai = FALSE
		if(isAI(M))
			var/mob/living/silicon/ai/master = M
			is_inactive_ai = !(master && !master.incapacitated() && master.client && master.eyeobj) //If there is an AI with an eye attached, it's not incapacitated, and it has a client
		if((stat & NOPOWER) || is_inactive_ai)
			clear_holo(M)
			continue

	if(has_established_connection())
		if(connected_pad.stat & NOPOWER)
			end_call()
			return TRUE
		if(!hacked)
			create_holos()
			update_holos()

	use_power(power_per_hologram * LAZYLEN(active_holograms))

	if(last_request + 20 SECONDS < world.time && incoming_connection)
		incoming_connection = FALSE
		clear_holos(FALSE)
		audible_message("<i><span class='game say'>The holopad connection timed out.</span></i>")
		if(connected_pad)
			connected_pad.audible_message("<i><span class='game say'>The holopad connection timed out.</span></i>")
			connected_pad.connected_pad = null
			connected_pad.update_icon()
			connected_pad = null
			update_icon()
	return TRUE

/obj/machinery/hologram/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(LAZYISIN(active_holograms, user))
		step_to(active_holograms[user], user.eyeobj) // So it turns.
		var/obj/effect/overlay/H = active_holograms[user]
		H.forceMove(get_turf(user.eyeobj))
		active_holograms[user] = H

		if(!(H in view(src)))
			clear_holo(user)
			return 0

		if(get_dist(user.eyeobj, src) > holo_range || !isInSight(H, src))
			user.holo = null
			clear_holo(user)
	return TRUE

/*
 * Hologram
 */

/obj/machinery/hologram
	icon = 'icons/obj/holopad.dmi'
	anchored = 1
	use_power = POWER_USE_IDLE
	idle_power_usage = 5
	active_power_usage = 100

//Destruction procs.
/obj/machinery/hologram/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(5))
				qdel(src)

/obj/machinery/hologram/holopad/Destroy()
	if(connected_pad)
		end_call()
	clear_holos(TRUE)
	listening_objects -= src
	return ..()

/obj/effect/overlay/hologram
	name = "hologram"
	layer = FLY_LAYER
	anchored = TRUE //So space wind cannot drag it.
	no_clean = TRUE

/obj/effect/overlay/hologram/proc/assume_form(var/atom/A)
	if(isAI(A))
		var/mob/living/silicon/ai/AI = A
		appearance = AI.holo_icon.appearance
	else
		appearance = A.appearance
	mouse_opacity = 0 //So you can't click on it.
	dir = A.dir
	color = rgb(125, 180, 225)
	alpha = 100
	set_light(2, 1, rgb(125, 180, 225))

#undef HOLOPAD_PASSIVE_POWER_USAGE
#undef HOLOGRAM_POWER_USAGE
