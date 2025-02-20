
GLOBAL_LIST_EMPTY_TYPED(holodeck_controls, /obj/machinery/computer/holodeck_control)

/obj/machinery/computer/holodeck_control
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon = 'icons/obj/computer.dmi'
	icon_state  = "computerw"
	icon_screen = "holocontrolw"
	light_color = LIGHT_COLOR_CYAN

	active_power_usage = 2000 //Pretty low, 15 per item too. Will still drain power like crazy on more complex programs

	circuit = /obj/item/circuitboard/holodeckcontrol

	req_one_access = list(ACCESS_HEADS, ACCESS_CHAPEL_OFFICE)

	/// How much power is consumed per item loaded
	var/item_power_usage = 15

	/// The area our holodeck is linked to
	var/area/linkedholodeck = null

	/// The type of area our holodeck will be loaded into
	var/linkedholodeck_area

	/// Whether there's a scene active or not
	var/active = FALSE

	/// The holographic objects our program has loaded
	var/list/holographic_objs = list()

	/// The list of holographic mobs our program has loaded
	var/list/holographic_mobs = list()

	/// The list of landmarks within our holodeck program
	var/list/holodeck_landmarks = list()

	/// Whether the console was damaged or not
	var/damaged = FALSE

	/// Whether the safety has been disabled or not
	var/safety_disabled = FALSE

	/// The last mob to emag us
	var/mob/last_to_emag = null

	/// Indicates the last world.time the holodeck setting was changed
	var/last_change = 0

	/// Indicates the last world.time the gravity was changed
	var/last_gravity_change = 0

	/// Whether the console has been locked or not
	var/locked = FALSE

/obj/machinery/computer/holodeck_control/Initialize()
	. = ..()
	linkedholodeck = locate(linkedholodeck_area)
	GLOB.holodeck_controls += src

/obj/machinery/computer/holodeck_control/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/computer/holodeck_control/attack_hand(var/mob/user as mob)
	if(..())
		return 1
	user.set_machine(src)
	var/dat

	dat += "<B>Holodeck Control System</B><BR>"
	dat += "<HR>Current Loaded Programs:<BR>"

	if(!linkedholodeck)
		dat += SPAN_DANGER("Warning: Unable to locate holodeck.<br>")
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	if(!SSatlas.current_map.holodeck_supported_programs.len)
		dat += SPAN_DANGER("Warning: No supported holo-programs loaded.<br>")
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	for(var/prog in SSatlas.current_map.holodeck_supported_programs)
		dat += "<A href='byond://?src=[REF(src)];program=[SSatlas.current_map.holodeck_supported_programs[prog]]'>([prog])</A><BR>"

	dat += "<BR>"
	dat += "<A href='byond://?src=[REF(src)];program=turnoff'>(Turn Off)</A><BR>"

	dat += "<BR>"
	dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

	if(issilicon(user))
		dat += "<BR>"
		if(safety_disabled)
			if (emagged)
				dat += "<font color=red><b>ERROR</b>: Cannot re-enable Safety Protocols.</font><BR>"
			else
				dat += "<A href='byond://?src=[REF(src)];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		else
			dat += "<A href='byond://?src=[REF(src)];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"

	dat += "<BR>"

	if(safety_disabled)
		for(var/prog in SSatlas.current_map.holodeck_restricted_programs)
			dat += "<A href='byond://?src=[REF(src)];program=[SSatlas.current_map.holodeck_restricted_programs[prog]]'>(<font color=red>Begin [prog]</font>)</A><BR>"
			dat += "Ensure the holodeck is empty before testing.<BR>"
			dat += "<BR>"
		dat += "Safety Protocols are <font color=red> DISABLED </font><BR>"
	else
		dat += "Safety Protocols are <font color=green> ENABLED </font><BR>"

	if(linkedholodeck.has_gravity)
		dat += "Gravity is <A href='byond://?src=[REF(src)];gravity=1'><font color=green>(ON)</font></A><BR>"
	else
		dat += "Gravity is <A href='byond://?src=[REF(src)];gravity=1'><font color=blue>(OFF)</font></A><BR>"

	if(!locked)
		dat += "Holodeck is <A href='byond://?src=[REF(src)];togglehololock=1'><font color=green>(UNLOCKED)</font></A><BR>"
	else
		dat = "<B>Holodeck Control System</B><BR>"
		dat += "Holodeck is <A href='byond://?src=[REF(src)];togglehololock=1'><font color=red>(LOCKED)</font></A><BR>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/holodeck_control/Topic(href, href_list)
	if(..())
		return 1

	if(locked && !allowed(usr))
		return

	if(href_list["program"])
		var/prog = href_list["program"]
		if(prog in SSatlas.current_map.holodeck_programs)
			loadProgram(SSatlas.current_map.holodeck_programs[prog])

	else if(href_list["AIoverride"])
		if(!issilicon(usr))
			return

		if(safety_disabled && emagged)
			return //if a traitor has gone through the trouble to emag the thing, let them keep it.

		safety_disabled = !safety_disabled
		update_projections()
		if(safety_disabled)
			message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
			log_game("[key_name(usr)] overrided the holodeck's safeties")
		else
			message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
			log_game("[key_name(usr)] restored the holodeck's safeties")

	else if(href_list["gravity"])
		toggleGravity(linkedholodeck)

	else if(href_list["togglehololock"])
		togglelock(usr)

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/holodeck_control/emag_act(var/remaining_charges, var/mob/user as mob)
	playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	last_to_emag = user //emag again to change the owner
	if (!emagged)
		emagged = 1
		safety_disabled = 1
		req_one_access = list()
		update_projections()
		to_chat(user, SPAN_NOTICE("You vastly increase projector power and override the safety and security protocols."))
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [SSatlas.current_map.company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
		src.updateUsrDialog()
		return 1
	else
		..()

/obj/machinery/computer/holodeck_control/proc/update_projections()
	if (safety_disabled)
		item_power_usage = 2500
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = DAMAGE_BRUTE
	else
		item_power_usage = initial(item_power_usage)
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = initial(H.damtype)

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		C.set_safety(!safety_disabled)
		if (last_to_emag)
			C.friends = list(last_to_emag)

//This could all be done better, but it works for now.
/obj/machinery/computer/holodeck_control/Destroy()
	emergencyShutdown()
	return ..()

/obj/machinery/computer/holodeck_control/ex_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/holodeck_control/power_change()
	var/oldstat
	..()
	if (stat != oldstat && active && (stat & NOPOWER))
		emergencyShutdown()

/obj/machinery/computer/holodeck_control/process(seconds_per_tick)
	for(var/item in holographic_objs) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, 0)

	if (!safety_disabled)
		for(var/mob/living/simple_animal/holo_animal in holographic_mobs)
			if(get_area(holo_animal.loc) != linkedholodeck)
				holographic_mobs -= holo_animal
				holo_animal.derez()

	if(!operable())
		return

	if(active)
		use_power_oneoff(item_power_usage * (holographic_objs.len + holographic_mobs.len))

		if(!checkInteg(linkedholodeck))
			damaged = TRUE
			loadProgram(SSatlas.current_map.holodeck_programs["turnoff"], 0)
			active = 0
			update_use_power(POWER_USE_IDLE)
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					spark(T, 2, GLOB.alldirs)
				T.ex_act(3)
				T.hotspot_expose(1000,500,1)
		else
			for(var/obj/effect/landmark/holodeck/holo_landmark in holodeck_landmarks)
				holo_landmark.handle_process(seconds_per_tick)

/obj/machinery/computer/holodeck_control/proc/derez(var/obj/obj , var/silent = 1)
	holographic_objs.Remove(obj)

	if(obj == null)
		return

	if(isobj(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.remove_from_mob(obj)
			M.update_icon()	//so their overlays update

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/obj/machinery/computer/holodeck_control/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

//Why is it called toggle if it doesn't toggle?
/obj/machinery/computer/holodeck_control/proc/togglePower(var/toggleOn = 0)
	if(toggleOn)
		loadProgram(SSatlas.current_map.holodeck_programs["emptycourt"], 0)
	else
		loadProgram(SSatlas.current_map.holodeck_programs["turnoff"], 0)

		if(!linkedholodeck.has_gravity)
			linkedholodeck.gravitychange(TRUE)

		active = 0
		update_use_power(POWER_USE_IDLE)


/obj/machinery/computer/holodeck_control/proc/loadProgram(var/datum/holodeck_program/HP, var/check_delay = 1)
	if(!HP)
		return

	var/area/A = locate(HP.target)
	if(!A)
		return

	if(check_delay)
		if(world.time < (last_change + 25))
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return
			for(var/mob/M in range(3,src))
				M.show_message("\b ERROR. Recalibrating projection apparatus.")
				last_change = world.time
				return

	last_change = world.time
	active = 1
	update_use_power(POWER_USE_ACTIVE)

	for(var/item in holographic_objs)
		derez(item)

	for(var/mob/living/simple_animal/holo_animal in holographic_mobs)
		holographic_mobs -= holo_animal
		holo_animal.derez()

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	holographic_objs = A.copy_contents_to(linkedholodeck , 1)

	if(HP.ambience)
		linkedholodeck.music = HP.ambience
	else
		linkedholodeck.music = list()

	for(var/mob/living/M in mobs_in_area(linkedholodeck))
		if(M.mind)
			linkedholodeck.play_ambience(M)

	linkedholodeck.sound_environment = A.sound_environment

	addtimer(CALLBACK(src, PROC_REF(load_landmarks)), 3 SECONDS)

/obj/machinery/computer/holodeck_control/proc/load_landmarks()
	holodeck_landmarks = list()
	for(var/obj/effect/landmark/holodeck/holo_landmark in linkedholodeck)
		holo_landmark.initialize_holodeck_landmark(src)
	update_projections()

/obj/machinery/computer/holodeck_control/proc/toggleGravity(var/area/A)
	if(world.time < (last_gravity_change + 25))
		if(world.time < (last_gravity_change + 15))//To prevent super-spam clicking
			return
		for(var/mob/M in range(3,src))
			M.show_message("\b ERROR. Recalibrating gravity field.")
			last_change = world.time
			return

	last_gravity_change = world.time
	active = 1
	update_use_power(POWER_USE_IDLE)

	if(A.has_gravity())
		A.gravitychange(FALSE)
	else
		A.gravitychange(TRUE)

/obj/machinery/computer/holodeck_control/proc/emergencyShutdown()
	//Turn it back to the regular non-holographic room
	loadProgram(SSatlas.current_map.holodeck_programs["turnoff"], 0)

	if(!linkedholodeck.has_gravity)
		linkedholodeck.gravitychange(TRUE)

	active = 0
	update_use_power(POWER_USE_IDLE)

/obj/machinery/computer/holodeck_control/proc/togglelock(var/mob/user)
	if(allowed(user))
		locked = !locked
		visible_message(SPAN_NOTICE("\The [src] emits a series of beeps to announce it has been [locked ? null : "un"]locked."), range = 3)
		return FALSE
	else
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

/obj/machinery/computer/holodeck_control/proc/load_random_program()
	var/datum/holodeck_program/prog_to_load = pick(SSatlas.current_map.holodeck_programs)
	loadProgram(SSatlas.current_map.holodeck_programs[prog_to_load])

/obj/machinery/computer/holodeck_control/Aurora
	density = 0
	linkedholodeck_area = /area/holodeck/alphadeck

/obj/machinery/computer/holodeck_control/Horizon
	density = 0
	linkedholodeck_area = /area/horizon/holodeck/alphadeck

/obj/machinery/computer/holodeck_control/Horizon/beta
	linkedholodeck_area = /area/horizon/holodeck/betadeck
