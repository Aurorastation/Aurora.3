/datum/wires/landmine/New()
	wires = list(
		WIRE_EXPLODE
	)
	add_duds(3)
	..()

/datum/wires/landmine/proc/explode()
	return

/datum/wires/landmine/on_pulse(wire, user)
	switch(wire)
		if(WIRE_EXPLODE)
			explode()

/datum/wires/landmine/on_cut(wire, mend, source)
	switch(wire)
		if(WIRE_EXPLODE)
			if(!mend)
				explode()

/datum/wires/landmine/claymore
	holder_type = /obj/item/landmine/claymore

/datum/wires/landmine/claymore/interactable(mob/user)
	if(!..())
		return
	var/obj/item/landmine/claymore/claymore = holder
	if(!claymore.deactivated && claymore.deployed)
		return TRUE
	return FALSE

/datum/wires/landmine/claymore/explode()
	var/obj/item/landmine/claymore/claymore = holder
	claymore.trigger()
