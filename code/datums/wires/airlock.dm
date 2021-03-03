// Wires for airlocks

/datum/wires/airlock
	holder_type = /obj/machinery/door/airlock
	wire_count = 12
	window_y = 570

/datum/wires/airlock/secure
	random = TRUE
	wire_count = 14

/datum/wires/airlock/blueprint
	cares_about_holder = FALSE

var/const/AIRLOCK_WIRE_IDSCAN = 1
var/const/AIRLOCK_WIRE_MAIN_POWER1 = 2
var/const/AIRLOCK_WIRE_MAIN_POWER2 = 4
var/const/AIRLOCK_WIRE_DOOR_BOLTS = 8
var/const/AIRLOCK_WIRE_BACKUP_POWER1 = 16
var/const/AIRLOCK_WIRE_BACKUP_POWER2 = 32
var/const/AIRLOCK_WIRE_OPEN_DOOR = 64
var/const/AIRLOCK_WIRE_AI_CONTROL = 128
var/const/AIRLOCK_WIRE_ELECTRIFY = 256
var/const/AIRLOCK_WIRE_SAFETY = 512
var/const/AIRLOCK_WIRE_SPEED = 1024
var/const/AIRLOCK_WIRE_LIGHT = 2048

/datum/wires/airlock/CanUse(var/mob/living/L)
	var/obj/machinery/door/airlock/A = holder
	if(!istype(L, /mob/living/silicon))
		if(A.isElectrified())
			if(A.shock(L, 100))
				return 0
	if(A.p_open)
		return 1
	return 0

/datum/wires/airlock/GetInteractWindow()
	var/obj/machinery/door/airlock/A = holder
	var/haspower = A.arePowerSystemsOn() //If there's no power, then no lights will be on.

	. += ..()
	var/list/text = list()

	if(!haspower)
		text += "The test light and all the other indicator lights are [SPAN_BAD("off")]!"
		text += A.locked ? "The door bolts seem to be down!" : "The door bolts seem to be up."
	else
		text += "The test light is [SPAN_GOOD("on")]."
		text += A.backup_power_lost_until ? "The backup power light is [SPAN_BAD("off")]!" : "The backup power light is [SPAN_GOOD("on")]."
		if(A.lights) // show different bolt message depending on whether we have lights
			text += "The door bolt indicator lights are [SPAN_GOOD("on")]."
			text += "They show the bolts are [A.locked ? SPAN_BAD("down") : SPAN_GOOD("up")]."
		else
			text += "The door bolt indicator lights are [SPAN_BAD("off")]!"
			text += A.locked ? "The door bolts seem to be down!" : "The door bolts seem to be up." // this is a closer inspection
		if(A.aiControlDisabled==0)
			if(A.emagged)
				text += "The 'AI control allowed' light is <span style='color:red'>red</span>."
			else if(A.aiBolting)
				text += "The 'AI control allowed' light is <span style='color:green'>green</span>."
			else
				text += "The 'AI control allowed' light is <span style='color:orange'>orange</span>."
		else
			text += "The 'AI control allowed' light is [SPAN_BAD("off")]."
		text += A.safe==0 ? "The 'Check Wiring' light is [SPAN_GOOD("on")]." : "The 'Check Wiring' light is [SPAN_BAD("off")]."
		text += A.normalspeed==0 ? "The 'Check Timing Mechanism' light is [SPAN_GOOD("on")]." : "The 'Check Timing Mechanism' light is [SPAN_BAD("off")]."
		text += A.aiDisabledIdScanner==0 ? "The IDScan light is [SPAN_GOOD("on")]." : "The IDScan light is [SPAN_BAD("off")]."
	. += "<br>\n" + jointext(text, "<br>\n")

/datum/wires/airlock/UpdateCut(var/index, var/mended)

	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(AIRLOCK_WIRE_IDSCAN)
			A.aiDisabledIdScanner = !mended

		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			if(!mended)
				//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
				A.loseMainPower()
				A.shock(usr, 50)
			else
				A.regainMainPower()
				A.shock(usr, 50)

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			if(!mended)
				//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
				A.loseBackupPower()
				A.shock(usr, 50)
			else
				A.regainBackupPower()
				A.shock(usr, 50)

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			if(!mended)
				//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
				A.lock(1)
				A.update_icon()

		if(AIRLOCK_WIRE_AI_CONTROL)
			if(!mended)
				//one wire for AI control. Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
				//aiControlDisabled: If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
				if(A.aiControlDisabled == 0)
					A.aiControlDisabled = 1
				else if(A.aiControlDisabled == -1)
					A.aiControlDisabled = 2
			else
				if(A.aiControlDisabled == 1)
					A.aiControlDisabled = 0
				else if(A.aiControlDisabled == 2)
					A.aiControlDisabled = -1

		if(AIRLOCK_WIRE_ELECTRIFY)
			if(!mended)
				//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
				A.electrify(-1)
			else
				A.electrify(0)
			return // Don't update the dialog.

		if (AIRLOCK_WIRE_SAFETY)
			A.safe = mended

		if(AIRLOCK_WIRE_SPEED)
			A.autoclose = mended
			if(mended)
				if(!A.density)
					A.close()

		if(AIRLOCK_WIRE_LIGHT)
			A.lights = mended
			A.update_icon()


/datum/wires/airlock/UpdatePulsed(var/index)

	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(AIRLOCK_WIRE_IDSCAN)
			//Sending a pulse through flashes the red light on the door (if the door has power).
			if(A.arePowerSystemsOn() && A.density)
				A.do_animate("deny")

		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			A.loseMainPower()

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!A.locked)
				A.lock()
			else
				A.unlock()

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			A.loseBackupPower()

		if(AIRLOCK_WIRE_AI_CONTROL)
			//Sending a pulse toggles whether AI can bolt the doors (if not emagged)
			if(A.emagged)
				return
			A.aiBolting = !A.aiBolting

		if(AIRLOCK_WIRE_ELECTRIFY)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			A.electrify(30)

		if(AIRLOCK_WIRE_OPEN_DOOR)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access and it's not emagged
			if(A.emagged)
				return
			if(!A.requiresID() || A.check_access(null))
				if(A.density)
					A.open()
				else
					A.close()

		if(AIRLOCK_WIRE_SAFETY)
			A.safe = !A.safe
			if(!A.density)
				A.close()

		if(AIRLOCK_WIRE_SPEED)
			A.normalspeed = !A.normalspeed

		if(AIRLOCK_WIRE_LIGHT)
			A.lights = !A.lights
			A.update_icon()

/datum/wires/airlock/get_wire_diagram(var/mob/user)
	var/dat = ""
	for(var/color in wires)
		dat += "<font color='[color]'>[capitalize(color)]</font>: [index_to_type(GetIndex(color))]<br>"

	var/datum/browser/wire_win = new(user, "airlockwires", "Airlock Wires", 450, 500)
	wire_win.set_content(dat)
	wire_win.open()

/datum/wires/airlock/proc/index_to_type(var/index)
	switch(index)
		if(AIRLOCK_WIRE_IDSCAN)
			return "ID Scan"
		if(AIRLOCK_WIRE_MAIN_POWER1)
			return "Power"
		if(AIRLOCK_WIRE_MAIN_POWER2)
			return "Power"
		if(AIRLOCK_WIRE_DOOR_BOLTS)
			return "Bolts"
		if(AIRLOCK_WIRE_BACKUP_POWER1)
			return "Backup Power"
		if(AIRLOCK_WIRE_BACKUP_POWER2)
			return "Backup Power"
		if(AIRLOCK_WIRE_OPEN_DOOR)
			return "Actuation"
		if(AIRLOCK_WIRE_AI_CONTROL)
			return "AI Control"
		if(AIRLOCK_WIRE_ELECTRIFY)
			return "Anti-tampering"
		if(AIRLOCK_WIRE_SAFETY)
			return "Safety"
		if(AIRLOCK_WIRE_SPEED)
			return "Speed"
		if(AIRLOCK_WIRE_LIGHT)
			return "Bolt Lights"
