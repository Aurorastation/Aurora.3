/datum/wires/nuclearbomb
	proper_name = "Nuclear Fission Device"
	holder_type = /obj/machinery/nuclearbomb
	random = 1

/datum/wires/nuclearbomb/New()
	wires = list(
		WIRE_LIGHT, WIRE_TIMING,
		WIRE_SAFETY
	)
	/// Listen, Derek. I know you're a surgeon, but...
	add_duds(2)
	..()

/datum/wires/nuclearbomb/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/nuclearbomb/N = holder
	return N.panel_open

/datum/wires/nuclearbomb/get_status()
	var/obj/machinery/nuclearbomb/N = holder
	. += ..()
	. += "The device is [N.timing ? "shaking!" : "still."]"
	. += "The device is is [N.safety ? "quiet" : "whirring"]."
	. += "The lights are [N.lighthack ? "static" : "functional"]."

/datum/wires/nuclearbomb/on_pulse(wire)
	var/obj/machinery/nuclearbomb/N = holder
	switch(wire)
		if(WIRE_LIGHT)
			N.lighthack = !N.lighthack
			N.update_icon()
			spawn(100)
				N.lighthack = !N.lighthack
				N.update_icon()
		if(WIRE_TIMING)
			if(N.timing)
				spawn
					log_and_message_admins("pulsed a nuclear bomb's detonation wire, causing it to explode.")
					N.explode()
		if(WIRE_SAFETY)
			N.safety = !N.safety
			spawn(100)
				N.safety = !N.safety
				if(N.safety == 1)
					N.visible_message("<span class='notice'>\The [N] quiets down.</span>")
					N.secure_device()
				else
					N.visible_message("<span class='notice'>\The [N] emits a quiet whirling noise!</span>")

/datum/wires/nuclearbomb/on_cut(wire, mend, source)
	var/obj/machinery/nuclearbomb/N = holder
	switch(wire)
		if(WIRE_SAFETY)
			N.safety = mend
			if(N.timing)
				spawn
					log_and_message_admins("cut a nuclear bomb's timing wire, causing it to explode.")
					N.explode()
		if(WIRE_TIMING)
			N.secure_device()
		if(WIRE_LIGHT)
			N.lighthack = !mend
			N.update_icon()
