/decl/prefab/proc/create(var/atom/location)
	if(!location)
		CRASH("Invalid location supplied: [location]")
		return FALSE
	return TRUE

/decl/prefab/ic_assembly
	var/assembly_name
	var/data
	var/power_cell_type

/decl/prefab/ic_assembly/create(var/atom/location)
	if(..())
		var/result = SSelectronics.validate_electronic_assembly(data)
		if(istext(result))
			CRASH("Invalid prefab [type]: [result]")
		else
			var/obj/item/device/electronic_assembly/assembly = SSelectronics.load_electronic_assembly(location, result)
			if(!assembly)
				return null
				
			assembly.opened = FALSE
			assembly.update_icon()
			if(power_cell_type)
				var/obj/item/cell/device/cell = new power_cell_type(assembly)
				assembly.battery = cell

			return assembly
	return null

/obj/prefab
	name = "prefab spawn"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	var/prefab_type

/obj/prefab/Initialize()
	..()
	var/decl/prefab/prefab = prefab_type
	prefab.create(loc)
	return INITIALIZE_HINT_QDEL