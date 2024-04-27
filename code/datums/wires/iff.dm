/datum/wires/iff
	proper_name = "IFF Beacon"
	holder_type = /obj/machinery/iff_beacon

/datum/wires/iff/New()
	wires = list(
		WIRE_RESET
	)
	add_duds(2)
	..()

/datum/wires/iff/get_status()
	var/obj/machinery/iff_beacon/I = holder
	. += ..()
	. += "[(I.use_power ? "The beacon is transmitting." : "The beacon is not transmitting.")]"

/datum/wires/iff/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/iff_beacon/I = holder
	return I.panel_open

/datum/wires/iff/on_cut(wire, mend, source)
	var/obj/machinery/iff_beacon/I = holder

	switch(wire)
		if(WIRE_RESET)
			if(!mend)
				I.shock(usr, 50)
				I.toggle()
				I.disable()
			else
				I.shock(usr, 50)
				I.enable()
				I.toggle()
