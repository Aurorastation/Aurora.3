/mob/living/carbon/human/proc/mech_selection(var/list/network)
	var/list/mech = list()
	mech["Return"] = null

	for(var/mob/living/heavy_vehicle/R in network)
		var/turf/T = get_turf(R)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(!R.remote)
			continue
		if(!R.pilots.len)
			continue
		if(R.pilots[1].client || R.pilots[1].ckey)
			continue
		mech[R.name] = R

	if(mech.len == 1)
		to_chat(src, span("warning", "No active remote mechs are available."))
		return

	var/desc = input("Please select a remote control compatible mech to take over.", "Remote Mech Selection") in mech|null
	if(!desc)
		return

	var/mob/living/heavy_vehicle/chosen_mech = mech[desc]
	var/mob/living/remote_pilot = chosen_mech.pilots[1] // the first pilot
	mind_swap(src, remote_pilot)

	return