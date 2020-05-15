/obj/proc/cultify(var/check_only = FALSE)
	if(check_only)
		return
	qdel(src)

/obj/effect/decal/cleanable/blood/cultify()
	return

/obj/effect/decal/remains/cultify()
	return

/obj/effect/overlay/cultify()
	return

/obj/item/device/flashlight/lamp/cultify()
	new /obj/structure/cult/pylon(get_turf(src))
	qdel(src)
	return "As you cast \the [src] into the forge, a great pylon grows beneath your feet, achieving its form in seconds."

/obj/item/stack/material/wood/cultify()
	return

/obj/item/book/cultify()
	var/obj/item/book/tome/T = new /obj/item/book/tome(get_turf(src))
	qdel(src)
	return T

/obj/item/tank/emergency_oxygen/cultify()
	var/obj/item/tank/oxygen/brown/B = new /obj/item/tank/oxygen/brown(get_turf(src))
	qdel(src)
	return B

/obj/item/material/sword/cultify()
	var/obj/item/melee/cultblade/CBT = new /obj/item/melee/cultblade(get_turf(src)) // AHAHAHAHAHAHAHA - Geeves
	qdel(src)
	return CBT

/obj/item/storage/backpack/cultify()
	var/obj/item/storage/backpack/cultpack/CP = new /obj/item/storage/backpack/cultpack(get_turf(src))
	for(var/obj/O in src)
		CP.handle_item_insertion(O)
	qdel(src)
	return CP

/obj/item/storage/backpack/cultpack/cultify()
	return

/obj/machinery/cultify()
	// We keep the number of cultified machines down by only converting those that are dense
	// The alternative is to keep a separate file of exceptions.
	if(density)
		var/list/random_structure = list(
			/obj/structure/cult/talisman,
			/obj/structure/cult/forge,
			/obj/structure/cult/tome
			)
		var/I = pick(random_structure)
		new I(get_turf(src))
	qdel(src)

/obj/machinery/atmospherics/cultify()
	if(src.invisibility != INVISIBILITY_MAXIMUM)
		src.invisibility = INVISIBILITY_MAXIMUM
		density = FALSE

/obj/machinery/cooker/cultify()
	new /obj/structure/cult/talisman(get_turf(src))
	qdel(src)

/obj/machinery/computer/cultify()
	new /obj/structure/cult/tome(get_turf(src))
	qdel(src)

/obj/machinery/door/cultify()
	new /obj/structure/simple_door/cult(get_turf(src))
	qdel(src)

/obj/machinery/door/airlock/cultify()
	if(secured_wires)
		return
	new /obj/structure/simple_door/cult(get_turf(src))
	qdel(src)

/obj/machinery/door/airlock/lift/cultify()
	return

/obj/machinery/door/firedoor/cultify()
	qdel(src)

/obj/machinery/light/cultify()
	new /obj/structure/cult/pylon(get_turf(src))
	qdel(src)

/obj/machinery/mech_sensor/cultify()
	qdel(src)

/obj/machinery/power/apc/cultify()
	if(src.invisibility != INVISIBILITY_MAXIMUM)
		src.invisibility = INVISIBILITY_MAXIMUM

/obj/machinery/vending/cultify()
	new /obj/structure/cult/forge(get_turf(src))
	qdel(src)

/obj/structure/bed/chair/cultify()
	var/obj/structure/bed/chair/wood/wings/I = new /obj/structure/bed/chair/wood/wings(get_turf(src))
	I.dir = dir
	qdel(src)

/obj/structure/bed/chair/wood/wings/cultify()
	return

/obj/structure/bookcase/cultify()
	return

/obj/structure/grille/cultify()
	new /obj/structure/grille/cult(get_turf(src))
	qdel(src)

/obj/structure/grille/cult/cultify()
	return

/obj/structure/simple_door/cultify()
	new /obj/structure/simple_door/cult(get_turf(src))
	qdel(src)

/obj/structure/simple_door/cult/cultify()
	return

/obj/singularity/cultify()
	var/dist = max((current_size - 2), 1)
	explosion(get_turf(src), dist, dist * 2, dist * 4)
	qdel(src)

/obj/structure/shuttle/engine/heater/cultify()
	new /obj/structure/cult/pylon(get_turf(src))
	qdel(src)

/obj/structure/shuttle/engine/propulsion/cultify()
	var/turf/T = get_turf(src)
	if(T)
		T.ChangeTurf(/turf/simulated/wall/cult)
	qdel(src)

/obj/structure/table/cultify()
	if(material == SSmaterials.get_material_by_name(MATERIAL_CULT) || reinforced == SSmaterials.get_material_by_name(MATERIAL_CULT))
		return
	material = SSmaterials.get_material_by_name(MATERIAL_CULT)
	reinforced = SSmaterials.get_material_by_name(MATERIAL_CULT)
	update_desc()
	update_connections(1)
	update_icon()
	update_material()

/obj/structure/table/holotable/cultify()
	return

/obj/structure/window/cult/cultify()
	return