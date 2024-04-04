
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

	var/item_power_usage = 15

	var/area/linkedholodeck = null
	var/linkedholodeck_area
	var/active = 0
	var/list/holographic_objs = list()
	var/list/holographic_mobs = list()
	var/damaged = 0
	var/safety_disabled = 0
	var/mob/last_to_emag = null
	var/last_change = 0
	var/last_gravity_change = 0

	req_one_access = list(ACCESS_HEADS, ACCESS_CHAPEL_OFFICE)
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
		dat += "<span class='danger'>Warning: Unable to locate holodeck.<br></span>"
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	if(!SSatlas.current_map.holodeck_supported_programs.len)
		dat += "<span class='danger'>Warning: No supported holo-programs loaded.<br></span>"
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	for(var/prog in SSatlas.current_map.holodeck_supported_programs)
		dat += "<A href='?src=\ref[src];program=[SSatlas.current_map.holodeck_supported_programs[prog]]'>([prog])</A><BR>"

	dat += "<BR>"
	dat += "<A href='?src=\ref[src];program=turnoff'>(Turn Off)</A><BR>"

	dat += "<BR>"
	dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

	if(issilicon(user))
		dat += "<BR>"
		if(safety_disabled)
			if (emagged)
				dat += "<font color=red><b>ERROR</b>: Cannot re-enable Safety Protocols.</font><BR>"
			else
				dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		else
			dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"

	dat += "<BR>"

	if(safety_disabled)
		for(var/prog in SSatlas.current_map.holodeck_restricted_programs)
			dat += "<A href='?src=\ref[src];program=[SSatlas.current_map.holodeck_restricted_programs[prog]]'>(<font color=red>Begin [prog]</font>)</A><BR>"
			dat += "Ensure the holodeck is empty before testing.<BR>"
			dat += "<BR>"
		dat += "Safety Protocols are <font color=red> DISABLED </font><BR>"
	else
		dat += "Safety Protocols are <font color=green> ENABLED </font><BR>"

	if(linkedholodeck.has_gravity)
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'><font color=green>(ON)</font></A><BR>"
	else
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'><font color=blue>(OFF)</font></A><BR>"

	if(!locked)
		dat += "Holodeck is <A href='?src=\ref[src];togglehololock=1'><font color=green>(UNLOCKED)</font></A><BR>"
	else
		dat = "<B>Holodeck Control System</B><BR>"
		dat += "Holodeck is <A href='?src=\ref[src];togglehololock=1'><font color=red>(LOCKED)</font></A><BR>"

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
			log_game("[key_name(usr)] overrided the holodeck's safeties",ckey=key_name(usr))
		else
			message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
			log_game("[key_name(usr)] restored the holodeck's safeties",ckey=key_name(usr))

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
		to_chat(user, "<span class='notice'>You vastly increase projector power and override the safety and security protocols.</span>")
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [SSatlas.current_map.company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer",ckey=key_name(usr))
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

/obj/machinery/computer/holodeck_control/process()
	for(var/item in holographic_objs) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, 0)

	if (!safety_disabled)
		for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
			if (get_area(C.loc) != linkedholodeck)
				holographic_mobs -= C
				C.derez()
		for(var/mob/living/simple_animal/penguin/holodeck/P in holographic_mobs)
			if (get_area(P.loc) != linkedholodeck)
				holographic_mobs -= P
				P.derez()

	if(inoperable())
		return
	if(active)
		use_power_oneoff(item_power_usage * (holographic_objs.len + holographic_mobs.len))

		if(!checkInteg(linkedholodeck))
			damaged = 1
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

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		holographic_mobs -= C
		C.derez()

	for(var/mob/living/simple_animal/penguin/holodeck/P in holographic_mobs)
		holographic_mobs -= P
		P.derez()

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	holographic_objs = A.copy_contents_to(linkedholodeck , 1)
	for(var/obj/holo_obj in holographic_objs)
		holo_obj.alpha *= 1 //no more transparency, otherwise new presets look like crap -kyres

	if(HP.ambience)
		linkedholodeck.music = HP.ambience
	else
		linkedholodeck.music = list()

	for(var/mob/living/M in mobs_in_area(linkedholodeck))
		if(M.mind)
			linkedholodeck.play_ambience(M)

	linkedholodeck.sound_environment = A.sound_environment

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					spark(T, 2, GLOB.alldirs)
					if(T)
						T.temperature = 5000
						T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

			if(L.name=="Penguin Spawn Random")
				if (prob(50))
					holographic_mobs += new /mob/living/simple_animal/penguin/holodeck(L.loc)
				else
					holographic_mobs += new /mob/living/simple_animal/penguin/holodeck/baby(L.loc)

			if(L.name=="Penguin Spawn Emperor")
				holographic_mobs += new /mob/living/simple_animal/penguin/holodeck/emperor(L.loc)

			if(L.name=="Holocarp Spawn Random")
				if (prob(4)) //With 4 spawn points, carp should only appear 15% of the time.
					holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

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
		visible_message("<span class='notice'>\The [src] emits a series of beeps to announce it has been [locked ? null : "un"]locked.</span>", range = 3)
		return FALSE
	else
		to_chat(user, "<span class='warning'>Access denied.</span>")
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
