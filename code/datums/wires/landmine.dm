/datum/wires/landmine
	wire_count = 1

/datum/wires/landmine/proc/explode()
	return

/datum/wires/landmine/UpdatePulsed(var/index)
	switch(index)
		if(WIRE_EXPLODE)
			explode()

/datum/wires/landmine/UpdateCut(var/index, var/mended)
	switch(index)
		if(WIRE_EXPLODE)
			if(!mended)
				explode()

/datum/wires/landmine/claymore
	holder_type = /obj/item/landmine/claymore

/datum/wires/landmine/claymore/CanUse(var/mob/living/L)
	var/obj/item/landmine/claymore/claymore = holder
	if(!claymore.deactivated && claymore.deployed)
		return TRUE
	return FALSE

/datum/wires/landmine/claymore/explode()
	var/obj/item/landmine/claymore/claymore = holder
	claymore.trigger()
