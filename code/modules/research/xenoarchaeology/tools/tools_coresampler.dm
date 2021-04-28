//device to take core samples from mineral turfs - used for various types of analysis

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."
	New()
		for(var/i=0, i<7, i++)
			var/obj/item/evidencebag/S = new(src)
			S.name = "sample bag"
			S.desc = "a bag for holding research samples."
		..()
		return

//////////////////////////////////////////////////////////////////

/obj/item/device/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEMSIZE_TINY
	var/obj/item/evidencebag/filled_bag

/obj/item/device/core_sampler/examine(mob/user)
	if(..(user, 2))
		to_chat(user, SPAN_NOTICE("This one is [filled_bag ? "full" : "empty"]."))

/obj/item/device/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/geosample/geo_data

	if(istype(item_to_sample, /turf/simulated/mineral))
		var/turf/simulated/mineral/T = item_to_sample
		geo_data = T.get_geodata()
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, SPAN_WARNING("The core sampler is full."))
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag/sample(src)
			var/obj/item/rocksliver/R = new(filled_bag, geo_data)
			filled_bag.store_item(R)
			update_icon()

			to_chat(user, SPAN_NOTICE("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, SPAN_WARNING("You are unable to take a geological sample of [item_to_sample]."))

/obj/item/device/core_sampler/update_icon()
	icon_state = "sampler[!!filled_bag]"

/obj/item/device/core_sampler/attack_self(var/mob/living/user)
	if(filled_bag)
		to_chat(user, SPAN_NOTICE("You eject the full sample bag."))
		user.put_in_hands(filled_bag)
		filled_bag = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("The core sampler is empty."))

/obj/item/evidencebag/sample
	name = "sample bag"
	desc = "A bag for holding research samples."