/datum/reagents/proc/get_color()
	if(!LAZYLEN(reagent_volumes))
		return "#ffffffff"
	if(reagent_volumes.len == 1) // It's pretty common and saves a lot of work
		var/singleton/reagent/R = GET_SINGLETON(reagent_volumes[1])
		return R.get_color(src)

	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0
	for(var/rtype in reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(rtype)
		if(R.color_weight <= 0)
			continue
		var/hex = uppertext(R.color)
		if(length(hex) == 7)
			hex += "FF"
		var/mod = REAGENT_VOLUME(src, rtype) * R.color_weight
		colors[1] += hex2num(copytext(hex, 2, 4))  * mod
		colors[2] += hex2num(copytext(hex, 4, 6))  * mod
		colors[3] += hex2num(copytext(hex, 6, 8))  * mod
		colors[4] += hex2num(copytext(hex, 8, 10)) * mod
		tot_w += mod

	return rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)

/singleton/reagent/proc/get_color(var/datum/reagents/holder)
	return color

/singleton/reagent/blood/get_color(var/datum/reagents/holder)
	if(!holder || isemptylist(REAGENT_DATA(holder, type)))
		return color

	return LAZYACCESS(holder.reagent_data[type], "blood_colour") || color // return default colour if not set
