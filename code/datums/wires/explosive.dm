/datum/wires/explosive/New()
	wires = list(
		WIRE_EXPLODE
	)
	add_duds(4)
	..()

/datum/wires/explosive/proc/explode()
	return

/datum/wires/explosive/on_pulse(wire)
	switch(wire)
		if(WIRE_EXPLODE)
			explode()

/datum/wires/explosive/on_cut(wire, mend, source)
	switch(wire)
		if(WIRE_EXPLODE)
			if(!mend)
				explode()

/datum/wires/explosive/c4
	holder_type = /obj/item/plastique

/datum/wires/explosive/c4/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/item/plastique/P = holder
	if(P.open_panel)
		return TRUE
	return FALSE

/datum/wires/explosive/c4/explode()
	var/obj/item/plastique/P = holder
	P.explode(get_turf(P))
