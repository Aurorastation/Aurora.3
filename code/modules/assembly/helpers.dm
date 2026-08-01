/proc/isassembly(O)
	return istype(O, /obj/item/assembly)

/proc/isigniter(O)
	return istype(O, /obj/item/assembly/igniter)

/proc/isinfared(O)
	return istype(O, /obj/item/assembly/infra)

/proc/isprox(O)
	return istype(O, /obj/item/assembly/prox_sensor)

/proc/issignaler(O)
	return istype(O, /obj/item/assembly/signaler)

/proc/istimer(O)
	return istype(O, /obj/item/assembly/timer)

// IsSpecialAssemblyIf true is an object that can be attached to an assembly holder but is a special thing like a phoron can or door
/obj/proc/IsSpecialAssembly()
	return FALSE

// If true is an object that can hold an assemblyholder object
/obj/proc/IsAssemblyHolder()
	return FALSE
