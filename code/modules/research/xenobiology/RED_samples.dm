/obj/item/red_sample
	name = "red sample"
	desc = "A sample of highly compressed DNA from a living creature."
	icon = 'icons/obj/items.dmi'
	icon_state = ""
	w_class = 2
	var/mob/mobDNA
	var/long_desc
	var/mob_name

/obj/item/red_sample/proc/set_origin()
	if(!mobDNA)
		return 0
	calculate_origin(mobDNA)
	long_desc = mobDNA.long_desc
	mob_name = mobDNA.name
	mobDNA = null

/obj/item/red_sample/proc/calculate_origin(var/mob/targetmob)
	var/tech = 0
	if(ishuman(targetmob))
		tech++
		if(targetmob.IsAdvancedToolUser())
			tech++
	origin_tech = list(TECH_BIOLOGY = tech)
