/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"

	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

	if(!..(user, 1))
		return

	if(contents.len <= 0)
		user << "There are no [src.icon_type]s left in the box."
	else if(contents.len == 1)
		user << "There is one [src.icon_type] left in the box."
	else
		user << "There are [src.contents.len] [src.icon_type]s in the box."

	return

/*
 * Egg Box
 */

	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(
		)

	for(var/i=1; i <= storage_slots; i++)

/*
 * Candle Box
 */

	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = 5

	for(var/i=1; i <= 5; i++)

/*
 * Crayon Box
 */

	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	icon_type = "crayon"
	can_hold = list(
	)

	..()
	update_icon()

	cut_overlays()
	add_overlay("crayonbox")
		add_overlay("[crayon.colourName]")

		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	icon_type = "cigarette"

	flags |= NOREACT
	create_reagents(15 * storage_slots)	//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette(src)

	icon_state = "[initial(icon_state)][contents.len]"

		var/obj/item/clothing/mask/smokable/cigarette/C = W
		if(!istype(C)) return // what
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

	if(!istype(M, /mob))
		return

	if(M == user && target_zone == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/W = new /obj/item/clothing/mask/smokable/cigarette(user)
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << "<span class='notice'>You take a cigarette out of the pack.</span>"
		update_icon()
	else
		..()

	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	item_state = "Bpacket" //Doesn't have an inhand state, but neither does dromedary, so, ya know..

	fill()
		..()
		fill_cigarre_package(src,list("fuel" = 15))

	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"

	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)

	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)

	icon_state = "[initial(icon_state)][contents.len]"
	return

		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

	if(!istype(M, /mob))
		return

	if(M == user && target_zone == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/W = new /obj/item/clothing/mask/smokable/cigarette/cigar(user)
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << "<span class='notice'>You take a cigar out of the case.</span>"
		update_icon()
	else
		..()

/*
 * Vial Box
 */

	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6


	..()
	for(var/i=1; i <= storage_slots; i++)

	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 2
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

	. = ..()
	queue_icon_update()

	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	cut_overlays()
	if (!broken)
		add_overlay("led[locked]")
		if(locked)
			add_overlay("cover")
	else
		add_overlay("ledb")

	..()
	update_icon()
