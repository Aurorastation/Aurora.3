/datum/wires/apc
	proper_name = "APC"
	holder_type = /obj/machinery/power/apc

/datum/wires/apc/New(atom/holder)
	wires = list(
		WIRE_POWER1, WIRE_POWER2,
		WIRE_IDSCAN, WIRE_AI
	)
	add_duds(6)
	..()

/datum/wires/apc/get_status()
	var/obj/machinery/power/apc/A = holder
	. = ..()
	. += A.locked ? "The APC is locked." : "The APC is unlocked."
	. += A.shorted ? "The APCs power has been shorted." : "The APC is working properly!"
	. += A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on."

/datum/wires/apc/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/power/apc/A = holder
	return A?.panel_open

/datum/wires/apc/on_pulse(wire)

	var/obj/machinery/power/apc/A = holder

	switch(wire)

		if(WIRE_IDSCAN)
			set_locked(A, FALSE)
			addtimer(CALLBACK(src, PROC_REF(set_locked), A, TRUE), 30 SECONDS)

		if (WIRE_POWER1, WIRE_POWER2)
			set_short_out(A, TRUE)
			addtimer(CALLBACK(src, PROC_REF(set_short_out), A, FALSE), 120 SECONDS)

		if (WIRE_AI)
			set_ai_control(A, TRUE)
			addtimer(CALLBACK(src, PROC_REF(set_ai_control), A, FALSE), 1 SECONDS)


/datum/wires/apc/proc/set_locked(var/obj/machinery/power/apc/A, var/setting)
	if(A)
		A.locked = setting

/datum/wires/apc/proc/set_short_out(var/obj/machinery/power/apc/A, var/setting)
	if(setting)
		A.shorted = TRUE
	else if(A && !is_cut(WIRE_POWER1) && !is_cut(WIRE_POWER2))
		A.shorted = FALSE

/datum/wires/apc/proc/set_ai_control(var/obj/machinery/power/apc/A, var/setting)
	if(setting)
		A.aidisabled = TRUE
	else if(A && !is_cut(WIRE_AI))
		A.aidisabled = FALSE

/datum/wires/apc/on_cut(wire, mend, source)
	var/obj/machinery/power/apc/A = holder

	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2)

			if(!mend)
				A.shock(usr, 50)
				A.shorted = TRUE

			else if(!is_cut(WIRE_POWER1) && !is_cut(WIRE_POWER2))
				A.shorted = FALSE
				A.shock(usr, 50)

		if(WIRE_AI)
			A.aidisabled = !mend
