//device to take core samples from mineral turfs - used for various types of analysis

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."

/obj/item/storage/box/samplebags/fill()
	for(var/i = 1 to 7)
		new /obj/item/evidencebag/sample(src)

/obj/item/evidencebag/sample
	name = "sample bag"
	desc = "A bag for holding research samples."

//////////////////////////////////////////////////////////////////

/obj/item/device/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEMSIZE_TINY
	var/obj/item/sample

/obj/item/device/core_sampler/examine(mob/user)
	if(..(user, 2))
		to_chat(user, SPAN_NOTICE("This one is [sample ? "full" : "empty"]."))

/obj/item/device/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/geosample/geo_data

	if(istype(item_to_sample, /turf/simulated/mineral))
		var/turf/simulated/mineral/T = item_to_sample
		geo_data = T.get_geodata()
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(sample)
			to_chat(user, SPAN_WARNING("The core sampler is full."))
		else
			sample = new /obj/item/rocksliver(src, geo_data)
			update_icon()

			to_chat(user, SPAN_NOTICE("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, SPAN_WARNING("You are unable to take a geological sample of [item_to_sample]."))

/obj/item/device/core_sampler/update_icon()
	icon_state = "sampler[!!sample]"

/obj/item/device/core_sampler/attack_self(var/mob/living/user)
	if(sample)
		to_chat(user, SPAN_NOTICE("You eject the sample."))
		user.put_in_hands(sample)
		sample = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("The core sampler is empty."))