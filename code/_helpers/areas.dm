//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
/proc/get_area_turfs(areatype, var/list/predicates, target_z = 0, subtypes=TRUE)
	if(istext(areatype))
		areatype = text2path(areatype)
	else if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type
	else if(!ispath(areatype))
		return null

	var/list/turfs = list()
	if(subtypes)
		var/list/cache = typecacheof(areatype)
		for(var/V in the_station_areas)
			var/area/A = V
			if(!cache[A.type])
				continue
			for(var/turf/T in A)
				if(target_z == 0 || target_z == T.z)
					if (predicates && predicates.len)
						var/predicates_true = TRUE
						for (var/predicate in predicates)
							if (!call(predicate)(T))
								predicates_true = FALSE
								break
						if (predicates_true)
							turfs += T
					else
						turfs += T
	else
		for(var/V in the_station_areas)
			var/area/A = V
			if(A.type != areatype)
				continue
			for(var/turf/T in A)
				if (target_z == 0 || target_z == T.z)
					if (predicates && predicates.len)
						var/predicates_true = TRUE
						for (var/predicate in predicates)
							if (!call(predicate)(T))
								predicates_true = FALSE
								break
						if (predicates_true)
							turfs += T
					else
						turfs += T
	return turfs

/proc/pick_area_turf(var/areatype, var/list/predicates)
	var/list/turfs = get_area_turfs(areatype, predicates)
	if(turfs && turfs.len)
		return pick(turfs)
