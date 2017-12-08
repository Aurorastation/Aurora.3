// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// They are also fragile based on material data and many can break/smash apart.
	health = 10
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = 3
	sharp = 0
	edge = 0

	var/applies_material_colour = 1
	var/unbreakable
	var/force_divisor = 0.5
	var/thrown_force_divisor = 0.5
	var/default_material = DEFAULT_WALL_MATERIAL
	var/material/material
	var/drops_debris = 1

	..(newloc)
	if(!material_key)
		material_key = default_material
	set_material(material_key)
	if(!material)
		qdel(src)
		return

	matter = material.get_matter()
	if(matter.len)
		for(var/material_type in matter)
			if(!isnull(matter[material_type]))
				matter[material_type] *= force_divisor // May require a new var instead.

	return material

	if(edge || sharp)
		force = material.get_edge_damage()
	else
		force = material.get_blunt_damage()
	force = round(force*force_divisor)
	throwforce = round(material.get_blunt_damage()*thrown_force_divisor)
	//spawn(1)
	//	world << "[src] has force [force] and throwforce [throwforce] when made from default material [material.name]"

	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_colour)
			color = material.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSprocessing, src)
		update_force()

	STOP_PROCESSING(SSprocessing, src)
	return ..()

	. = ..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

	if(health<=0)
		shatter(consumed)

	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris) material.place_shard(T)
	qdel(src)
/*
Commenting this out pending rebalancing of radiation based on small objects.
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/30),IRRADIATE, blocked = L.getarmor(null, "rad"))
*/

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
	TemperatureAct(exposed_temperature)

// This might need adjustment. Will work that out later.
	health -= material.combustion_effect(get_turf(src), temperature, 0.1)
	check_health(1)

	if(iswelder(W))
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		return ..()
*/
