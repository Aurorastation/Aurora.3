/// Look up levels[z].traits[trait]
/datum/controller/subsystem/mapping/proc/level_trait(z, trait)
	if (!isnum(z) || z < 1)
		return null
	if (z_list)
		if (z > z_list.len)
			stack_trace("Unmanaged z-level [z]! maxz = [world.maxz], z_list.len = [z_list.len]")
			return list()
		var/datum/space_level/S = z_list[z]
		return S.traits[trait]
	else
		var/list/default = DEFAULT_MAP_TRAITS
		if (z > default.len)
			stack_trace("Unmanaged z-level [z]! maxz = [world.maxz], default.len = [default.len]")
			return list()
		return default[z][DL_TRAITS][trait]
