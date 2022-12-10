// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	health = 10
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	edge = FALSE
	icon = 'icons/obj/weapons.dmi'

	var/use_material_name = TRUE // Does the finished item put the material name in front of it?
	var/use_material_sound = TRUE
	var/use_material_shatter = TRUE // If it has a custom shatter message.
	var/applies_material_colour = TRUE
	var/unbreakable
	var/force_divisor = 0.5
	var/thrown_force_divisor = 0.5
	var/default_material = DEFAULT_WALL_MATERIAL
	var/material/material
	var/drops_debris = TRUE

/obj/item/material/Initialize(var/newloc, var/material_key)
	. = ..()
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

/obj/item/material/should_equip()
	return TRUE

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
		if(use_material_sound)
			if(sharp && !material.weapon_hitsound == 'sound/weapons/metalhit.ogg' || !sharp)
				// wooden swords don't sound like metal swords.
				// metalhit check is so swords when metal use their regular slice sfx.
				hitsound = material.weapon_hitsound
				drop_sound = material.weapon_drop_sound
				pickup_sound = material.weapon_pickup_sound
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
	if(use_material_shatter)
		T.visible_message(SPAN_DANGER("\The [src] [material.destruction_desc]!"))
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, material.shatter_sound, 70, 1)
	if(!consumed && drops_debris) material.place_shard(T)
	qdel(src)
