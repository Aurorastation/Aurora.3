/* Holograms!
 * Contains:
 * * Holopad
 * * Hologram
 * * Other stuff
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

#define CAN_HEAR_MASTERS (1<<0)
#define CAN_HEAR_ACTIVE_HOLOCALLS (1<<1)
#define CAN_HEAR_ALL_FLAGS (CAN_HEAR_MASTERS|CAN_HEAR_ACTIVE_HOLOCALLS)

#define HOLOPAD_PASSIVE_POWER_USAGE 1
#define HOLOGRAM_POWER_USAGE 2

/obj/structure/machinery/hologram/holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon_state = "holopad0"
	var/icon_state_suffix = ""

	plane = FLOOR_PLANE
	layer = ABOVE_CATWALK_LAYER

	var/power_per_hologram = 500 //per usage per hologram
	idle_power_usage = 5

	var/holopad_id

	var/list/active_holograms
	var/list/active_holorays
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 7 // Change to change how far the AI can move away from the holopad before deactivating

	var/long_range = FALSE // ignores connected_z_levels check

	var/incoming_connection = FALSE
	var/established_connection = FALSE
	var/obj/structure/machinery/hologram/holopad/connected_pad
	var/forced = FALSE
	var/hacked = FALSE
	var/last_message

	var/forcing_call = FALSE

	var/max_overmap_call_range = 0

	var/list/linked_pdas = list()

	var/can_hear_flags = NONE

/obj/structure/machinery/hologram/holopad/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(connected_pad)
		if(established_connection)
			. += "\The [src] is currently in a call with a holopad with ID: <b>[connected_pad.holopad_id]</b>"
		else
			. += SPAN_NOTICE("\The [src] is currently pending connection with a holopad with ID: <b>[connected_pad.holopad_id]</b>")

/obj/structure/machinery/hologram/holopad/Initialize()
	. = ..()

	if(SSatlas.current_map.use_overmap)
		sync_linked()

	get_holopad_id()
	desc += " Its ID is '[holopad_id]'"

	SSmachinery.all_holopads += src

	light_color = long_range ? rgb(225, 173, 125) : rgb(125, 180, 225)

	GLOB.listening_objects += src

	update_icon()

/obj/structure/machinery/hologram/holopad/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	. = ..()
	if(!loc || !LAZYLEN(active_holorays))
		return
	for(var/owner in active_holorays)
		var/obj/effect/overlay/holoray/ray = active_holorays[owner]
		if(QDELETED(ray))
			continue
		ray.forceMove(get_turf(src))
		update_holoray(owner, get_turf(src))

/obj/structure/machinery/hologram/holopad/proc/get_holopad_id()
	var/area/A = get_area(src)
	var/display_name = get_area_display_name(A)
	holopad_id = "[display_name] ([src.x]-[src.y]-[src.z])"

/obj/structure/machinery/hologram/holopad/update_icon()
	ClearOverlays()

	if(LAZYLEN(active_holograms) || has_established_connection())
		icon_state = "holopad2[icon_state_suffix]"
		AddOverlays(emissive_appearance(icon, "[long_range ? "holopad2_lr-e" : "holopad2-e"]", src))
		set_light(2, l_color = light_color)
	else if(incoming_connection || connected_pad?.incoming_connection)
		icon_state = "holopad1[icon_state_suffix]"
		AddOverlays(emissive_appearance(icon, "[long_range ? "holopad1_lr-e" : "holopad1-e"]", src))
		set_light(1, l_color = light_color)
	else if(powered())
		icon_state = "holopad0[icon_state_suffix]"
		AddOverlays(emissive_appearance(icon, "[long_range ? "holopad0_lr-e" : "holopad0-e"]", src))
		set_light(0.5, l_color = light_color)
	else
		icon_state = "holopad[icon_state_suffix]-off"
		set_light(0)

/obj/structure/machinery/hologram/holopad/attack_hand(var/mob/user)
	if(user.Adjacent(src))
		user.visible_message("<b>[user]</b> presses their foot down on \the [src]'s easy-select multi-function button.", SPAN_NOTICE("You press your foot down on \the [src]'s easy-select multi-function button."))
	if(incoming_connection)
		audible_message("The pad hums quietly as it establishes a connection.")
		take_call()
		return
	else if(connected_pad)
		if(forced && !has_command_auth(user))
			audible_message("Access denied. Termination of a command-level transmission requires command-level authorization.")
			return
		end_call()
		audible_message("Severing connection to distant holopad.")
		return

	if(last_request + 20 SECONDS > world.time)
		to_chat(user, SPAN_WARNING("\The [src] is still cooling down since the last transmission."))
		return

	ui_interact(user)

/obj/structure/machinery/hologram/holopad/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holopad", capitalize(name), 800, 600)
		ui.open()

/obj/structure/machinery/hologram/holopad/ui_data(mob/user)
	var/list/data = list()
	data["holopad_list"] = list()
	for(var/obj/structure/machinery/hologram/holopad/H as anything in SSmachinery.all_holopads - src)
		if(can_connect(H) && H.operable())
			data["holopad_list"] += list(list("id" = H.holopad_id, "busy" = (H.has_established_connection() || H.incoming_connection), "ref" = "[REF(H)]"))
	data["command_auth"] = has_command_auth(user)
	data["forcing_call"] = forcing_call
	data["call_range"] = max_overmap_call_range
	return data

/obj/structure/machinery/hologram/holopad/proc/has_command_auth(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(I && (ACCESS_HEADS in I.access) || I && (ACCESS_LAWYER in I.access))
		return TRUE
	return FALSE

/obj/structure/machinery/hologram/holopad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("call_ai")
			last_request = world.time
			to_chat(usr, SPAN_NOTICE("You request an AI's presence."))
			var/area/area = get_area(src)
			for(var/mob/living/silicon/ai/AI in GLOB.silicon_mob_list)
				if(!AI.client)
					continue
				if(!AreConnectedZLevels(AI.z, z))
					continue
				to_chat(AI, SPAN_INFO("Your presence is requested at <a href='byond://?src=[REF(AI)];jumptoholopad=[REF(src)]'>\the [area]</a>."))
				. = TRUE

		if("call_holopad")
			last_request = world.time
			var/obj/structure/machinery/hologram/holopad/HP = locate(params["call_holopad"])
			if(!HP)
				to_chat(usr, SPAN_DANGER("Could not locate that holopad, this is a bug!"))
				return
			connected_pad = HP
			INVOKE_ASYNC(src, PROC_REF(make_call), connected_pad, usr)
			. = TRUE

		if("toggle_command")
			forcing_call = !forcing_call
			. = TRUE
			return

	SStgui.close_uis(src)

//setters
/**
 * setter for can_hear_flags. handles adding or removing the given flag on can_hear_flags and then adding hearing sensitivity or removing it depending on the final state
 * this is necessary because holopads are a significant fraction of the hearable atoms on station which increases the cost of procs that iterate through hearables
 * so we need holopads to not be hearable until it is needed
 *
 * * flag - one of the can_hear_flags flag defines
 * * set_flag - boolean, if TRUE sets can_hear_flags to that flag and might add hearing sensitivity if can_hear_flags was NONE before,
 * if FALSE unsets the flag and possibly removes hearing sensitivity
 */
/obj/structure/machinery/hologram/holopad/proc/set_can_hear_flags(flag, set_flag = TRUE)
	if(!(flag & CAN_HEAR_ALL_FLAGS))
		return FALSE //the given flag doesnt exist

	if(set_flag)
		if(can_hear_flags == NONE)//we couldnt hear before, so become hearing sensitive
			become_hearing_sensitive()

		can_hear_flags |= flag
		return TRUE

	else
		can_hear_flags &= ~flag
		if(can_hear_flags == NONE)
			lose_hearing_sensitivity()

		return TRUE

/obj/structure/machinery/hologram/holopad/proc/make_call(var/obj/structure/machinery/hologram/holopad/connected_pad, var/mob/user)
	connected_pad.last_request = world.time
	connected_pad.connected_pad = src //This marks the holopad you are making the call from
	connected_pad.incoming_connection = TRUE
	playsound(connected_pad.loc, 'sound/machines/chime.ogg', 25, 5)
	connected_pad.update_icon()
	update_icon()

	if(forcing_call)
		connected_pad.audible_message("<b>[src]</b> announces, \"Incoming call with command authorization from [connected_pad.holopad_id].\"")
		connected_pad.notify_pdas(connected_pad.holopad_id)
		to_chat(user, SPAN_NOTICE("Establishing forced connection to the holopad in [connected_pad.holopad_id]."))
		forcing_call = FALSE // Holopad needs to have forced call turned back on
		connected_pad.forced = TRUE
		sleep(80)
		connected_pad.take_call()
	else
		connected_pad.audible_message("<b>[src]</b> announces, \"Incoming communications request from [connected_pad.connected_pad.holopad_id].\"")
		connected_pad.notify_pdas(connected_pad.connected_pad.holopad_id) //what in the everloving fuck is connected_pad.connected_pad?
		to_chat(user, SPAN_NOTICE("Trying to establish a connection to the holopad in [connected_pad.holopad_id]... Please await confirmation from recipient."))

/obj/structure/machinery/hologram/holopad/proc/notify_pdas(var/requester)
	for(var/obj/item/modular_computer/MC in linked_pdas)
		if(!QDELETED(MC))
			MC.audible_message("<b>\The [MC]</b> beeps, <i><span class='notice'>\"Incoming communications request from <b>[requester]</b> at <b>[holopad_id]</b>!\"</span></i>")
			playsound(MC, 'sound/machines/chime.ogg', 25)
		else
			linked_pdas -= MC

/obj/structure/machinery/hologram/holopad/proc/take_call()
	incoming_connection = FALSE
	established_connection = TRUE
	connected_pad.established_connection = TRUE
	create_holos()
	connected_pad.create_holos()
	connected_pad.update_icon()
	update_icon()

/obj/structure/machinery/hologram/holopad/proc/end_call()
	connected_pad.incoming_connection = FALSE
	connected_pad.clear_holos(FALSE)
	connected_pad.connected_pad = null
	clear_holos(FALSE)
	set_can_hear_flags(CAN_HEAR_ACTIVE_HOLOCALLS, FALSE)
	established_connection = FALSE
	connected_pad.established_connection = FALSE
	connected_pad.update_icon()
	connected_pad = null
	update_icon()

/obj/structure/machinery/hologram/holopad/proc/has_established_connection()
	if(connected_pad?.established_connection && established_connection)
		return TRUE
	return FALSE

/obj/structure/machinery/hologram/holopad/proc/can_connect(var/obj/structure/machinery/hologram/holopad/HP)
	if(long_range != HP.long_range)
		return FALSE
	if(!AreConnectedZLevels(HP.z, z))
		return FALSE
	return TRUE

/obj/structure/machinery/hologram/holopad/check_eye(mob/user)
	if(LAZYISIN(active_holograms, user))
		return 0
	return -1

/obj/structure/machinery/hologram/holopad/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/modular_computer))
		var/obj/item/modular_computer/MC = attacking_item
		if(!(MC in linked_pdas))
			linked_pdas |= MC
			to_chat(user, SPAN_NOTICE("You link \the [MC] to \the [src]."))
			return TRUE
		else
			linked_pdas -= MC
			to_chat(user, SPAN_NOTICE("You unlink \the [MC] from \the [src]."))
			return TRUE
	return FALSE

/obj/structure/machinery/hologram/holopad/attack_ai(mob/living/silicon/user)
	if(!istype(user))
		return

	if(!ai_can_interact(user))
		return

	if(isrobot(user))
		attack_hand(user)
		return

	var/obj/structure/machinery/hologram/holopad/old_holo = user.holo
	if(old_holo && old_holo != src)
		if(!QDELETED(old_holo))
			old_holo.clear_holo(user)
		user.holo = null

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
/obj/structure/machinery/hologram/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
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
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[M.get_accent_icon()] [name_used]</span> [speaking.format_message(text, verb)]</span></i>"
		else
			rendered = "<i><span class='game say'>Holopad received, <span class='name'>[M.get_accent_icon()] [name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
		master.show_message(rendered, 2)
	if(has_established_connection())
		var/message
		if(speaking)
			message = "<i><span class='game say'>Holopad received, <span class='name'>[M.get_accent_icon()] [name_used]</span> [speaking.format_message(text, verb)]</span></i>"
		else
			message = "<i><span class='game say'>Holopad received, <span class='name'>[M.get_accent_icon()] [name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
		connected_pad.audible_message(message)
		connected_pad.last_message = message

/obj/structure/machinery/hologram/holopad/see_emote(mob/living/M, text)
	for(var/mob/living/silicon/ai/master in active_holograms)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
		master.show_message(rendered, 2)
	if(has_established_connection())
		connected_pad.visible_message("<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>")

/obj/structure/machinery/hologram/holopad/show_message(msg, type, alt, alt_type)
	for(var/mob/living/silicon/ai/master in active_holograms)
		var/rendered = "<i><span class='game say'>The holographic image of <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)
	if(findtext(msg, "Holopad received,"))
		return
	for(var/mob/living/carbon/master in active_holograms)
		var/rendered = "<i><span class='game say'>The holographic image of <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)

/obj/structure/machinery/hologram/holopad/proc/create_holos()
	for(var/mob/living/M in viewers(world.view, connected_pad))
		if(LAZYISIN(active_holograms, M))
			continue
		create_holo(M)

/obj/structure/machinery/hologram/holopad/proc/create_holo(mob/M)
	var/obj/effect/overlay/hologram/H = new(get_turf(src))
	if(isAI(M))
		set_can_hear_flags(CAN_HEAR_MASTERS)
	if(!isAI(M) && connected_pad)
		H.x = src.x - (connected_pad.x - M.x)
		H.y = src.y - (connected_pad.y - M.y)
		set_can_hear_flags(CAN_HEAR_ACTIVE_HOLOCALLS)
	if(!is_in_sight(H, src))
		qdel(H)
		return
	H.assume_form(M, long_range)
	LAZYSET(active_holograms, M, H)
	create_holoray(M)

	update_icon()

/obj/structure/machinery/hologram/holopad/proc/update_holos()
	for(var/thing in active_holograms)
		var/mob/M = thing
		if(isAI(M))
			continue
		var/obj/effect/overlay/hologram/H = active_holograms[thing]
		if(connected_pad)
			H.x = src.x - (connected_pad.x - M.x)
			H.y = src.y - (connected_pad.y - M.y)
		if(get_dist(H, src) > world.view || !is_in_sight(H, src))
			clear_holo(M)
			return
		H.assume_form(M, long_range)
		update_holoray(M, get_turf(H))

/obj/structure/machinery/hologram/holopad/proc/create_holoray(var/holo_owner)
	var/obj/effect/overlay/holoray/ray = LAZYACCESS(active_holorays, holo_owner)
	if(QDELETED(ray))
		LAZYREMOVE(active_holorays, holo_owner)
		ray = null
	if(!ray)
		ray = new(get_turf(src))
		LAZYSET(active_holorays, holo_owner, ray)
	else if(ray.loc != get_turf(src))
		ray.forceMove(get_turf(src))
	update_holoray(holo_owner, get_turf(src))

/obj/structure/machinery/hologram/holopad/proc/update_holoray(var/holo_owner, turf/new_turf)
	var/obj/effect/overlay/hologram/holo = LAZYACCESS(active_holograms, holo_owner)
	var/obj/effect/overlay/holoray/ray = LAZYACCESS(active_holorays, holo_owner)
	if(QDELETED(holo) || QDELETED(ray))
		return
	if(!new_turf)
		new_turf = get_turf(holo)

	SET_PLANE_EXPLICIT(ray, ABOVE_GAME_PLANE, src)

	var/disty = holo.y - ray.y
	var/distx = holo.x - ray.x
	var/newangle
	if(!disty)
		if(distx >= 0)
			newangle = 90
		else
			newangle = 270
	else
		newangle = arctan(distx / disty)
		if(disty < 0)
			newangle += 180
		else if(distx < 0)
			newangle += 360

	var/matrix/ray_transform = matrix()
	ray_transform.Scale(1, sqrt(distx * distx + disty * disty))
	ray_transform = turn(ray_transform, newangle)
	if(get_dist(get_turf(holo), new_turf) <= 1)
		animate(ray, transform = ray_transform, time = 1)
	else
		ray.transform = ray_transform

/obj/structure/machinery/hologram/holopad/proc/clear_holos(var/clear_ai = TRUE)
	for(var/M in active_holograms)
		if(!clear_ai && isAI(M))
			continue
		else if(isAI(M))
			set_can_hear_flags(CAN_HEAR_MASTERS, FALSE)
		clear_holo(M)

/obj/structure/machinery/hologram/holopad/proc/clear_holo(var/mob/M)
	var/obj/effect/overlay/holoray/ray = LAZYACCESS(active_holorays, M)
	if(ray)
		qdel(ray)
		LAZYREMOVE(active_holorays, M)

	var/obj/effect/overlay/hologram/hologram = LAZYACCESS(active_holograms, M)
	if(hologram)
		qdel(hologram)
	LAZYREMOVE(active_holograms, M)
	if(isAI(M))
		var/has_ai_holograms = FALSE
		for(var/mob/living/silicon/ai/AI in active_holograms)
			has_ai_holograms = TRUE
			break
		if(!has_ai_holograms)
			set_can_hear_flags(CAN_HEAR_MASTERS, FALSE)
	update_icon()

/obj/structure/machinery/hologram/holopad/process()
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
		if(!check_connected_pad())
			return TRUE

	use_power_oneoff(power_per_hologram * LAZYLEN(active_holograms))

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

/obj/structure/machinery/hologram/holopad/proc/check_connected_pad()
	if(connected_pad.stat & NOPOWER)
		end_call()
		return FALSE
	if(!hacked)
		create_holos()
		update_holos()
	return TRUE

/obj/structure/machinery/hologram/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(LAZYISIN(active_holograms, user))
		if(!user.facing_dir)
			step_to(active_holograms[user], user.eyeobj) // So it turns.
		var/obj/effect/overlay/H = active_holograms[user]
		var/turf/new_turf = get_turf(user.eyeobj)
		H.forceMove(new_turf)
		active_holograms[user] = H

		if(!(H in view(src)))
			clear_holo(user)
			return 0

		if(get_dist(user.eyeobj, src) > holo_range || !is_in_sight(H, src))
			user.holo = null
			clear_holo(user)
			return TRUE
		update_holoray(user, new_turf)
	return TRUE

/obj/structure/machinery/hologram/holopad/long_range
	name = "long-range holopad"
	icon_state = "holopad0_lr"
	icon_state_suffix = "_lr"
	long_range = TRUE
	max_overmap_call_range = 6

/obj/structure/machinery/hologram/holopad/long_range/get_holopad_id()
	holopad_id = ""

	if(SSatlas.current_map.use_overmap && linked)
		holopad_id = "[linked.name] | "

	var/area/A = get_area(src)
	var/display_name = get_area_display_name(A)
	holopad_id += "[display_name]"

/obj/structure/machinery/hologram/holopad/long_range/can_connect(var/obj/structure/machinery/hologram/holopad/HP)
	if(HP.long_range != long_range)
		return FALSE
	if(SSatlas.current_map.use_overmap)
		if(!linked || !HP.linked)
			return FALSE
		if(get_dist(HP.linked, linked) > 1 && !(HP.linked in view(max_overmap_call_range, linked)))
			return FALSE
	return TRUE

/obj/structure/machinery/hologram/holopad/long_range/has_command_auth(var/mob/user)
	return FALSE

/obj/structure/machinery/hologram/holopad/long_range/check_connected_pad()
	return ..() && can_connect(connected_pad)

/*
 * Hologram
 */

/obj/structure/machinery/hologram
	icon = 'icons/obj/holopad.dmi'
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 100

//Destruction procs.
/obj/structure/machinery/hologram/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(5))
				qdel(src)

/obj/structure/machinery/hologram/holopad/Destroy()
	if(connected_pad)
		end_call()
	clear_holos(TRUE)
	QDEL_LIST_ASSOC_VAL(active_holorays)
	SSmachinery.all_holopads -= src
	linked_pdas.Cut()
	GLOB.listening_objects -= src
	return ..()

/obj/effect/overlay/hologram
	name = "hologram"
	layer = FLY_LAYER
	anchored = TRUE //So space wind cannot drag it.
	no_clean = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //So you can't click on it.
	appearance_flags = TILE_BOUND|PIXEL_SCALE|LONG_GLIDE|KEEP_TOGETHER
	var/list/hologram_source_overlays
	var/mutable_appearance/hologram_glow

/obj/effect/overlay/hologram/Destroy()
	clear_hologram_appearances()
	if(hologram_glow)
		CutOverlays(hologram_glow)
		LAZYREMOVE(update_overlays_on_z, hologram_glow)
		hologram_glow = null
	return ..()

/obj/effect/overlay/hologram/proc/get_hologram_source(atom/A)
	if(isAI(A))
		var/mob/living/silicon/ai/AI = A
		if(AI.holo_icon)
			return AI.holo_icon
	return A

/obj/effect/overlay/hologram/proc/clear_hologram_appearances()
	if(hologram_source_overlays)
		CutOverlays(hologram_source_overlays)
		hologram_source_overlays = null

/obj/effect/overlay/hologram/proc/should_copy_source_base_icon(atom/original, atom/source)
	if(!source?.icon)
		return FALSE
	if(ishuman(original) || ishuman(source))
		return FALSE
	if(isAI(original) && LAZYLEN(source.overlays))
		return FALSE
	return TRUE

/obj/effect/overlay/hologram/proc/copy_base_appearance(atom/source)
	icon = source.icon
	icon_state = source.icon_state
	dir = source.dir
	pixel_x = source.pixel_x
	pixel_y = source.pixel_y
	pixel_z = source.pixel_z

/obj/effect/overlay/hologram/proc/clear_base_appearance()
	icon = null
	icon_state = ""
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	pixel_z = initial(pixel_z)

/obj/effect/overlay/hologram/proc/copy_hologram_source_overlays(atom/source)
	clear_hologram_appearances()

	if(!source)
		return

	if(source.atom_flags & ATOM_AWAITING_OVERLAY_UPDATE)
		source.UpdateOverlays()

	if(length(source.overlays))
		hologram_source_overlays = source.overlays.Copy()
		AddOverlays(hologram_source_overlays)

/obj/effect/overlay/hologram/proc/assume_form(var/atom/A, var/long_range = FALSE)
	var/atom/hologram_source = get_hologram_source(A)
	if(should_copy_source_base_icon(A, hologram_source))
		copy_base_appearance(hologram_source)
	else
		clear_base_appearance()
	copy_hologram_source_overlays(hologram_source)

	dir = A.dir
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
	SET_PLANE_EXPLICIT(src, ABOVE_GAME_PLANE, src)

	var/hologram_color = long_range ? rgb(225, 173, 125) : rgb(125, 180, 225)
	if(!hologram_glow)
		hologram_glow = makeHologram(0.5, hologram_color)
	set_light(2, 1, hologram_color)

/obj/effect/overlay/holoray
	name = "holoray"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "holoray"
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	density = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -32
	pixel_y = -32
	alpha = 100
	var/atom/movable/render_step/emissive/glow

/obj/effect/overlay/holoray/Initialize(mapload)
	. = ..()
	SET_PLANE_EXPLICIT(src, initial(plane), src)
	if(!render_target)
		var/static/uid = 0
		render_target = "holoray#[uid]"
		uid++
	glow = new(null, src)
	AddOverlays(glow)
	LAZYADD(update_overlays_on_z, glow)

/obj/effect/overlay/holoray/Destroy()
	QDEL_NULL(glow)
	. = ..()

#undef HOLOPAD_PASSIVE_POWER_USAGE
#undef HOLOGRAM_POWER_USAGE
#undef CAN_HEAR_MASTERS
#undef CAN_HEAR_ACTIVE_HOLOCALLS
#undef CAN_HEAR_ALL_FLAGS
