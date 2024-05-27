/proc/createRandomZlevel()
	if(GLOB.awaydestinations.len)	//crude, but it saves another var!
		return

	var/list/potentialRandomZlevels = list()
	admin_notice(SPAN_DANGER("Searching for away missions..."), R_DEBUG)
	var/list/Lines = file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
			// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	var/static/dmm_suite/loader = new
	if(potentialRandomZlevels.len)
		admin_notice(SPAN_DANGER("Loading away mission..."), R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			loader.load_map(file)
			LOG_DEBUG("away mission loaded: [map]")

		for(var/obj/effect/landmark/L in GLOB.landmarks_list)
			if (L.name != "awaystart")
				continue
			GLOB.awaydestinations.Add(L)

		admin_notice(SPAN_DANGER("Away mission loaded."), R_DEBUG)

	else
		admin_notice(SPAN_DANGER("No away missions found."), R_DEBUG)
		return
