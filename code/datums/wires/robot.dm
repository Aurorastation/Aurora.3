/datum/wires/robot
	proper_name = "Synthetic"
	random = TRUE
	holder_type = /mob/living/silicon/robot

/datum/wires/robot/New()
	wires = list(
		WIRE_LAWSYNC,
		WIRE_AI,
		WIRE_CAMERA,
		WIRE_LOCKDOWN
	)
	add_duds(2)
	..()

/datum/wires/robot/get_status()
	var/mob/living/silicon/robot/R = holder
	. = ..()
	. += "[(R.law_update ? "The LawSync light is on." : "The LawSync light is off.")]"
	. += "[(R.connected_ai ? "The AI link light is on." : "The AI link light is off.")]"
	. += "[((!isnull(R.camera) && R.camera.status == 1) ? "The Camera light is on." : "The Camera light is off.")]"
	. += "[(R.lock_charge ? "The lockdown light is on." : "The lockdown light is off.")]"

/datum/wires/robot/on_cut(wire, mend, source)

	var/mob/living/silicon/robot/R = holder
	switch(wire)
		if(WIRE_LAWSYNC) //Cut the law wire, and the borg will no longer receive law updates from its AI
			if(!mend)
				if (R.law_update == 1)
					to_chat(R, "LawSync protocol engaged.")
					R.show_laws()
			else
				if (R.law_update == 0 && !R.emagged)
					R.law_update = 1

		if (WIRE_AI) //Cut the AI wire to reset AI control
			if(!mend)
				R.disconnect_from_ai()

		if (WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambled_codes)
				R.camera.status = mend
				R.camera.kick_viewers() // Will kick anyone who is watching the Cyborg's camera.

		if(WIRE_LAWSYNC)	//Forces a law update if the borg is set to receive them. Since an update would happen when the borg checks its laws anyway, not much use, but eh
			if (R.law_update)
				R.lawsync()

		if(WIRE_LOCKDOWN)
			R.SetLockdown(!mend)

/datum/wires/robot/on_pulse(wire)
	var/mob/living/silicon/robot/R = holder
	switch(wire)
		if (WIRE_AI) //pulse the AI wire to make the borg reselect an AI
			if(!R.emagged)
				var/mob/living/silicon/ai/new_ai = select_active_ai(R)
				R.connect_to_ai(new_ai)

		if (WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambled_codes)
				R.camera.kick_viewers() // Kick anyone watching the Cyborg's camera
				R.visible_message("[R]'s camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")

		if(WIRE_LOCKDOWN)
			R.SetLockdown(!R.lock_charge) // Toggle

/datum/wires/robot/interactable(mob/user)
	if(!..())
		return FALSE
	var/mob/living/silicon/robot/R = holder
	if(R.wires_exposed)
		return TRUE
	return FALSE

/datum/wires/robot/proc/LockedCut()
	return is_cut(WIRE_LOCKDOWN)
