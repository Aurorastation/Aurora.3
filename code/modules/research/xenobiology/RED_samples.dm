/obj/item/red_sample
	name = "red sample"
	desc = "A sample of highly compressed DNA from a living creature."
	icon = 'icons/obj/items.dmi'
	icon_state = ""
	w_class = 2
	var/mob/mobDNA = null // what mob DNA we have

/obj/item/red_sample/proc/set_origin(var/targetmob)
	if(!targetmob)
		return 0
	calculate_origin(targetmob)

/obj/item/red_sample/proc/calculate_origin(var/mob/targetmob)
	var/tech = 0
	if(ishuman(targetmob))
		tech++
		if(targetmob.IsAdvancedToolUser())
			tech++
	origin_tech = list(TECH_BIOLOGY = tech)
	return
