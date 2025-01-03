// Wires for airlocks

/datum/wires/airlock
	proper_name = "Airlock"
	holder_type = /obj/machinery/door/airlock

/datum/wires/airlock/New(atom/holder)
	wires = list(
		WIRE_AI,
		WIRE_BACKUP1,
		WIRE_BACKUP2,
		WIRE_BOLTS,
		WIRE_IDSCAN,
		WIRE_BOLTLIGHT,
		WIRE_OPEN,
		WIRE_POWER1,
		WIRE_POWER2,
		WIRE_SAFETY,
		WIRE_SHOCK,
		WIRE_TIMING
	)
	add_duds(4)
	..()

/datum/wires/airlock/secure
	random = TRUE

/datum/wires/airlock/blueprint
	cares_about_holder = FALSE

/datum/wires/airlock/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/door/airlock/A = holder
	if(!A.p_open)
		return FALSE
	return TRUE

/datum/wires/airlock/get_status()
	var/obj/machinery/door/airlock/A = holder
	var/haspower = A.arePowerSystemsOn() //If there's no power, then no lights will be on.
	. = ..()

	if(!haspower)
		. += "The test light and all the other indicator lights are off!"
		. += A.locked ? "The door bolts seem to be down!" : "The door bolts seem to be up."
	else
		. += "The test light is on."
		. += A.backup_power_lost_until ? "The backup power light is off!" : "The backup power light is on."
		if(A.lights) // show different bolt message depending on whether we have lights
			. += "The door bolt indicator lights are on."
			. += "They show the bolts are [A.locked ? "down" : "up"]."
		else
			. += "The door bolt indicator lights are off!"
			. += A.locked ? "The door bolts seem to be down!" : "The door bolts seem to be up." // this is a closer inspection
		if(A.ai_control_disabled==0)
			if(A.emagged)
				. += "The 'AI control allowed' light red."
			else if(A.ai_bolting)
				. += "The 'AI control allowed' light is green."
			else
				. += "The 'AI control allowed' light is orange."
		else
			. += "The 'AI control allowed' light is off."
		. += A.safe==0 ? "The 'Check Wiring' light is on." : "The 'Check Wiring' light is off."
		. += A.normalspeed==0 ? "The 'Check Timing Mechanism' light is on." : "The 'Check Timing Mechanism' light is off."
		. += A.ai_disabled_id_scanner==0 ? "The IDScan light is on." : "The IDScan light is off."

/datum/wires/airlock/on_cut(wire, mend, source)

	var/obj/machinery/door/airlock/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			A.ai_disabled_id_scanner = !mend

		if(WIRE_POWER1, WIRE_POWER2)
			if(!mend)
				//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
				A.loseMainPower()
				A.shock(usr, 50)
			else
				A.regainMainPower()
				A.shock(usr, 50)

		if(WIRE_BACKUP1, WIRE_BACKUP2)
			if(!mend)
				//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
				A.loseBackupPower()
				A.shock(usr, 50)
			else
				A.regainBackupPower()
				A.shock(usr, 50)

		if(WIRE_BOLTS)
			if(!mend)
				//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
				A.lock(1)
				A.update_icon()

		if(WIRE_AI)
			if(!mend)
				//one wire for AI control. Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
				//ai_control_disabled: If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
				if(A.ai_control_disabled == 0)
					A.ai_control_disabled = 1
				else if(A.ai_control_disabled == -1)
					A.ai_control_disabled = 2
			else
				if(A.ai_control_disabled == 1)
					A.ai_control_disabled = 0
				else if(A.ai_control_disabled == 2)
					A.ai_control_disabled = -1

		if(WIRE_SHOCK)
			if(!mend)
				//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
				A.electrify(-1)
			else
				A.electrify(0)
			return // Don't update the dialog.

		if (WIRE_SAFETY)
			A.safe = mend

		if(WIRE_TIMING)
			A.autoclose = mend
			if(mend)
				if(!A.density)
					A.close()

		if(WIRE_BOLTLIGHT)
			A.lights = mend
			A.update_icon()


/datum/wires/airlock/on_pulse(wire, user)

	var/obj/machinery/door/airlock/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			//Sending a pulse through flashes the red light on the door (if the door has power).
			if(A.arePowerSystemsOn() && A.density)
				A.do_animate("deny")

		if(WIRE_POWER1, WIRE_POWER2)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			A.loseMainPower()

		if(WIRE_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!A.locked)
				A.lock()
			else
				A.unlock()

		if(WIRE_BACKUP1, WIRE_BACKUP2)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			A.loseBackupPower()

		if(WIRE_AI)
			//Sending a pulse toggles whether AI can bolt the doors (if not emagged)
			if(A.emagged)
				return
			A.ai_bolting = !A.ai_bolting

		if(WIRE_SHOCK)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			if(ismob(user))
				A.shock(user, 100)
			A.electrify(30)

		if(WIRE_OPEN)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access and it's not emagged
			if(A.emagged)
				return
			if(!A.requiresID() || A.check_access(null))
				if(A.density)
					A.open()
				else
					A.close()

		if(WIRE_SAFETY)
			A.safe = !A.safe
			if(!A.density)
				A.close()

		if(WIRE_TIMING)
			A.normalspeed = !A.normalspeed

		if(WIRE_BOLTLIGHT)
			A.lights = !A.lights
			A.update_icon()

/datum/wires/airlock/get_wire_diagram(var/mob/user)
	var/dat = ""
	for(var/color in colors)
		if(is_dud_color(color))
			continue
		dat += "<font color='[color]'>[capitalize(color)]</font>: [get_wire(color)]<br>"

	var/datum/browser/wire_win = new(user, "airlockwires", "Airlock Wires", 450, 500)
	wire_win.set_content(dat)
	wire_win.open()
