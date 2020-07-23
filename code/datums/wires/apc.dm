/datum/wires/apc
	holder_type = /obj/machinery/power/apc
	wire_count = 4

#define APC_WIRE_IDSCAN		 (1<<0)
#define APC_WIRE_MAIN_POWER1 (1<<1)
#define APC_WIRE_MAIN_POWER2 (1<<2)
#define APC_WIRE_AI_CONTROL  (1<<3)

/datum/wires/apc/GetInteractWindow()
	var/obj/machinery/power/apc/A = holder
	. += ..()
	. += text("<br>\n[(A.locked ? "The APC is locked." : "The APC is unlocked.")]<br>\n[(A.shorted ? "The APCs power has been shorted." : "The APC is working properly!")]<br>\n[(A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")

/datum/wires/apc/CanUse(var/mob/living/L)
	var/obj/machinery/power/apc/A = holder
	return A?.wiresexposed

/datum/wires/apc/UpdatePulsed(var/index)

	var/obj/machinery/power/apc/A = holder

	switch(index)

		if(APC_WIRE_IDSCAN)
			set_locked(A, FALSE)
			addtimer(CALLBACK(src, .proc/set_locked, A, TRUE), 30 SECONDS)

		if (APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)
			set_short_out(A, TRUE)
			addtimer(CALLBACK(src, .proc/set_short_out, A, FALSE), 120 SECONDS)

		if (APC_WIRE_AI_CONTROL)
			set_ai_control(A, TRUE)
			addtimer(CALLBACK(src, .proc/set_ai_control, A, FALSE), 1 SECONDS)


/datum/wires/apc/proc/set_locked(var/obj/machinery/power/apc/A, var/setting)
	if(A)
		A.locked = setting

/datum/wires/apc/proc/set_short_out(var/obj/machinery/power/apc/A, var/setting)
	if(setting)
		A.shorted = TRUE
	else if(A && !IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
		A.shorted = FALSE

/datum/wires/apc/proc/set_ai_control(var/obj/machinery/power/apc/A, var/setting)
	if(setting)
		A.aidisabled = TRUE
	else if(A && !IsIndexCut(APC_WIRE_AI_CONTROL))
		A.aidisabled = FALSE

/datum/wires/apc/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/apc/A = holder

	switch(index)
		if(APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)

			if(!mended)
				A.shock(usr, 50)
				A.shorted = TRUE

			else if(!IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
				A.shorted = FALSE
				A.shock(usr, 50)

		if(APC_WIRE_AI_CONTROL)
			A.aidisabled = !mended
