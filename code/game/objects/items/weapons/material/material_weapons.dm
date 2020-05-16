// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = 3
	sharp = 0
	edge = 0
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"

	var/use_material_name = TRUE // Does the finished item put the material name in front of it?
	var/applies_material_colour = 1
	var/unbreakable
	var/force_divisor = 0.5
	var/thrown_force_divisor = 0.5
	var/default_material = DEFAULT_WALL_MATERIAL
	var/material/material
	var/drops_debris = 1

/obj/item/material/New(var/newloc, var/material_key)
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

/obj/item/material/get_material()
	return material

/obj/item/material/proc/update_force()
	if(edge || sharp)
		force = material.get_edge_damage()
	else
		force = material.get_blunt_damage()
	force = round(force*force_divisor)
	throwforce = round(material.get_blunt_damage()*thrown_force_divisor)

/obj/item/material/proc/set_material(var/new_material)
	material = SSmaterials.get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		if(use_material_name)
			name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_colour)
			color = material.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSprocessing, src)
		update_force()

/obj/item/material/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/material/apply_hit_effect()
	. = ..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

/obj/item/material/proc/check_health(var/consumed)
	if(health<=0)
		shatter(consumed)

/obj/item/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris) material.place_shard(T)
	qdel(src)

