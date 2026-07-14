/datum/wires/alarm
	proper_name = "Air Alarm"
	holder_type = /obj/structure/machinery/alarm
	associated_skill = ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT

/datum/wires/alarm/New(atom/holder)
	wires = list(
		WIRE_POWER,
		WIRE_IDSCAN, WIRE_AI,
		WIRE_PANIC, WIRE_ALARM,
		WIRE_RCON
	)
	add_duds(3)
	..()

/datum/wires/alarm/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/structure/machinery/alarm/A = holder
	if(A.panel_open && A.buildstage == 2)
		return TRUE

/datum/wires/alarm/get_status()
	var/obj/structure/machinery/alarm/A = holder
	. = ..()
	. += A.locked ? "The air alarm is locked." : "The air alarm is unlocked."
	. += (A.shorted || (A.stat & (NOPOWER|BROKEN))) ? "The Air Alarm is offline." : "The Air Alarm is working properly!"
	. += A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on."
	. += A.rcon_setting ? "The remote control link is enabled." : "The remote control link is disabled."

/datum/wires/alarm/on_cut(wire, mend, source)
	var/obj/structure/machinery/alarm/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			if(!mend)
				A.locked = 1

		if(WIRE_POWER)
			A.shock(usr, 50)
			A.shorted = !mend
			A.update_icon()

		if (WIRE_AI)
			if (A.aidisabled == !mend)
				A.aidisabled = mend

		if(WIRE_PANIC)
			if(!mend)
				A.mode = 3 // AALARM_MODE_PANIC
				A.apply_mode()

		if(WIRE_ALARM)
			if (A.alarm_area.atmosalert(2, A))
				A.post_alert(2)
			A.update_icon()

		if(WIRE_RCON)
			if(!mend)
				A.rcon_setting = FALSE
			else
				A.rcon_setting = TRUE

/datum/wires/alarm/on_pulse(wire)
	var/obj/structure/machinery/alarm/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			A.locked = !A.locked

		if (WIRE_POWER)
			if(A.shorted == 0)
				A.shorted = 1
				A.update_icon()

			spawn(12000)
				if(A.shorted == 1)
					A.shorted = 0
					A.update_icon()

		if (WIRE_AI)
			if (A.aidisabled == 0)
				A.aidisabled = 1
			A.updateDialog()
			spawn(100)
				if (A.aidisabled == 1)
					A.aidisabled = 0

		if(WIRE_PANIC)
			if(A.mode == 1) // AALARM_MODE_SCRUB
				A.mode = 3 // AALARM_MODE_PANIC
			else
				A.mode = 1 // AALARM_MODE_SCRUB
			A.apply_mode()

		if(WIRE_ALARM, WIRE_RCON)
			if (A.alarm_area.atmosalert(0, A))
				A.post_alert(0)
			A.update_icon()
