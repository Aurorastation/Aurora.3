/datum/wires/robot
	random = 1
	holder_type = /mob/living/silicon/robot
	wire_count = 5

var/const/BORG_WIRE_LAWCHECK = 1
var/const/BORG_WIRE_MAIN_POWER = 2 // The power wires do nothing whyyyyyyyyyyyyy
var/const/BORG_WIRE_LOCKED_DOWN = 4
var/const/BORG_WIRE_AI_CONTROL = 8
var/const/BORG_WIRE_CAMERA = 16

/datum/wires/robot/GetInteractWindow()

	. = ..()
	var/mob/living/silicon/robot/R = holder
	. += "<br>\nThe LawSync light is [R.law_update ? "on" : "off"]."
	. += "<br>\nThe AI link light is [R.connected_ai ? "on" : "off"]."
	. += "<br>\nThe Camera light is [(!isnull(R.camera) && R.camera.status == 1) ? "on" : "off"]."
	. += "<br>\nThe lockdown light is [R.lock_charge ? "on" : "off"]."
	return .

/datum/wires/robot/UpdateCut(var/index, var/mended)

	var/mob/living/silicon/robot/R = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK) //Cut the law wire, and the borg will no longer receive law updates from its AI
			if(!mended)
				if (R.law_update == 1)
					to_chat(R, "LawSync protocol engaged.")
					R.show_laws()
			else
				if (R.law_update == 0 && !R.emagged)
					R.law_update = 1

		if (BORG_WIRE_AI_CONTROL) //Cut the AI wire to reset AI control
			if(!mended)
				R.disconnect_from_ai()

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambled_codes)
				R.camera.status = mended
				R.camera.kick_viewers() // Will kick anyone who is watching the Cyborg's camera.

		if(BORG_WIRE_LAWCHECK)	//Forces a law update if the borg is set to receive them. Since an update would happen when the borg checks its laws anyway, not much use, but eh
			if (R.law_update)
				R.lawsync()

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)


/datum/wires/robot/UpdatePulsed(var/index)
	var/mob/living/silicon/robot/R = holder
	switch(index)
		if (BORG_WIRE_AI_CONTROL) //pulse the AI wire to make the borg reselect an AI
			if(!R.emagged)
				var/mob/living/silicon/ai/new_ai = select_active_ai(R)
				R.connect_to_ai(new_ai)

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambled_codes)
				R.camera.kick_viewers() // Kick anyone watching the Cyborg's camera
				R.visible_message("[R]'s camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lock_charge) // Toggle

/datum/wires/robot/CanUse(var/mob/living/L)
	var/mob/living/silicon/robot/R = holder
	if(R.wires_exposed)
		return 1
	return 0

/datum/wires/robot/proc/IsCameraCut()
	return wires_status & BORG_WIRE_CAMERA

/datum/wires/robot/proc/LockedCut()
	return wires_status & BORG_WIRE_LOCKED_DOWN
