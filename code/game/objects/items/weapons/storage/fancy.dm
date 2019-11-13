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

/obj/item/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"
	var/storage_type = "box"

/obj/item/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

/obj/item/storage/fancy/examine(mob/user)
	if(!..(user, 1))
		return

	if(contents.len <= 0)
		to_chat(user, "There are no [src.icon_type]s left in the [src.storage_type].")
	else if(contents.len == 1)
		to_chat(user, "There is one [src.icon_type] left in the [src.storage_type].")
	else
		to_chat(user, "There are [src.contents.len] [src.icon_type]s in the [src.storage_type].")

	return

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	center_of_mass = list("x" = 16,"y" = 7)
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg = 12)
/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = 5
	starts_with = list(/obj/item/flame/candle = 5)

/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	icon_type = "crayon"
	can_hold = list(
		/obj/item/pen/crayon
	)
	starts_with = list(
		/obj/item/pen/crayon/red = 1,
		/obj/item/pen/crayon/orange = 1,
		/obj/item/pen/crayon/yellow = 1,
		/obj/item/pen/crayon/green = 1,
		/obj/item/pen/crayon/blue = 1,
		/obj/item/pen/crayon/purple = 1
	)

/obj/item/storage/fancy/crayons/fill()
	. = ..()
	update_icon()

/obj/item/storage/fancy/crayons/update_icon()
	cut_overlays()
	add_overlay("crayonbox")
	for(var/obj/item/pen/crayon/crayon in contents)
		add_overlay("[crayon.colourName]")

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(usr, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(usr, "This crayon is too powerful to be contained in this box.")
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	var/cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter)
	icon_type = "cigarette"

/obj/item/storage/fancy/cigarettes/Initialize()
	flags |= NOREACT
	create_reagents(15 * storage_slots)	//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

/obj/item/storage/fancy/cigarettes/fill()
	for(var/i = 1 to storage_slots)
		new cigarette_to_spawn(src)

/obj/item/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		if(!istype(C)) return // what
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob,var/target_zone)
	if(!istype(M, /mob))
		return

	if(M == user && target_zone == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/W = new cigarette_to_spawn(user)
		if(!istype(W))
			to_chat(user, "<span class ='notice'>The [W] is blocking the cigarettes.</span>")
			return
		//Checking contents of packet so lighters won't be cigarettes.
		for (var/i = contents.len; i > 0; i--)
			W = contents[i]
			if (istype(W))
				break
			else
				W = null
		if (!W)
			return
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		to_chat(user, "<span class='notice'>You take a cigarette out of the pack.</span>")
		update_icon()
	else
		..()

// get it? A - AcmeCo, B - Blank, C - Cigar, D - DromedaryCo. How convenient is that? - Wezzy

/obj/item/storage/fancy/cigarettes/acmeco
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Apacket"
	item_state = "Apacket" //Doesn't have an inhand state, but neither does dromedary, so, ya know..
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/acmeco

/obj/item/storage/fancy/cigarettes/blank
	name = "\improper blank packet"
	desc = "A packet of six blank cigarettes. The healthiest cigarettes on the market!"
	icon_state = "Bpacket"
	item_state = "Bpacket" //Doesn't have an inhand state, but neither does dromedary, so, ya know..
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/blank

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/dromedaryco

/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigs_lighters.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"

/obj/item/storage/fancy/cigar/Initialize()
	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigar/fill()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)

/obj/item/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/obj/item/storage/fancy/cigar/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(!istype(M, /mob))
		return

	if(M == user && target_zone == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/W = new /obj/item/clothing/mask/smokable/cigarette/cigar(user)
		reagents.trans_to_obj(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		to_chat(user, "<span class='notice'>You take a cigar out of the case.</span>")
		update_icon()
	else
		..()

/*
 * Vial Box
 */

/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 2
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	cut_overlays()
	if (!broken)
		add_overlay("led[locked]")
		if(locked)
			add_overlay("cover")
	else
		add_overlay("ledb")

/obj/item/storage/lockbox/vials/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/obj/item/storage/fancy/chocolate_box
	icon = 'icons/obj/chocolate.dmi'
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	name = "chocolate box"
	storage_slots = 8
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/truffle/random
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/truffle/random = 8)

/obj/item/storage/fancy/chocolate_box/fill()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/reagent_containers/food/snacks/truffle/random(src)
