/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *
 *
 * Contains:
 *		Donut Box
 *		Egg Carton
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 *		Match Box
 */

/obj/item/storage/box/fancy
	var/icon_type = null // what's in the box. remember to keep it singular.
	var/storage_type = "box" // what type of box it is.
	var/opened = FALSE // handles open/closing icons. also a failsafe.
	var/closable = TRUE // if you can close the icon after opening.
	var/icon_overlays = TRUE // whether the icon uses the update_icon() or a unique one.
	var/open_sound = null // if you want to play a special sound if you open it for the first time
	var/open_message = null // same as above, but a message
	foldable = null // most of this stuff isn't foldable by default, e.g. cig packets and vial boxes

/obj/item/storage/box/fancy/open(mob/user)
	. = ..()
	if(!opened)
		if(!closable)
			if(open_sound)
				playsound(src, open_sound, 50, 1, -5)
			if(open_message)
				to_chat(user, SPAN_NOTICE(open_message))
		opened = TRUE
		update_icon() // the reason why this isn't a clean catch-all update_icon() for fancy boxes is because of cigarette packets and donut boxes being different.

/obj/item/storage/box/fancy/Initialize()
	. = ..()
	update_icon()
	if(closable)
		desc_info += "Alt-click to open and close the box. " //aka force override icon state. for you know, style.

/obj/item/storage/box/fancy/AltClick(mob/user)
	if(opened && !closable) // opened, non-closable items do nothing
		return
	if(!Adjacent(user))
		return

	opened = !opened
	playsound(src.loc, src.use_sound, 50, 0, -5)
	update_icon()
	if(!opened)
		close(user)
		return 1

/obj/item/storage/box/fancy/update_icon(var/itemremoved = 0)
	if(opened) //use the open icon.
		if(icon_overlays) //whether it uses the overlays/uses its own version.
			src.icon_state = "[src.icon_type][src.storage_type][contents.len - itemremoved]"
		else
			icon_state = "[initial(icon_state)][src.opened]"
	else
		cut_overlays()
		icon_state = "[initial(icon_state)]" // closed

/obj/item/storage/box/fancy/handle_item_insertion()
	if(!opened) // makes sure boxes are opened before inserting anything
		opened = TRUE
		update_icon()
	. = ..()

/obj/item/storage/box/fancy/examine(mob/user)
	..()
	if(!icon_type || !storage_type)
		return
	if(contents.len <= 0)
		to_chat(user, "There are no [src.icon_type]s left in the [src.storage_type].")
	else
		to_chat(user, "There [src.contents.len == 1 ? "is" : "are"] <b>[src.contents.len]</b> [src.icon_type]\s left in \the [src.storage_type].")

/*
 * Donut Box
 */

/obj/item/storage/box/fancy/donut
	name = "donut box"
	desc = "A box of half-a-dozen donuts sponsored by GetMore Chocolate Corporation. Allegedly contentious with the psychiatrist unions for some reason."
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	icon_type = "donut"
	center_of_mass = list("x" = 16,"y" = 9)
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	starts_with = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)
	storage_slots = 6
	icon_overlays = FALSE
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/fancy/donut/update_icon() // One of the few unique update_icon()s, due to having to store both regular and sprinkled donuts.
	. = ..()
	if(opened)
		cut_overlays()
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
			add_overlay("[i][D.overlay_state]")
			i++

/obj/item/storage/box/fancy/donut/empty
	starts_with = null
	max_storage_space = 12

/*
 * Egg Box
 */

/obj/item/storage/box/fancy/egg_box
	name = "egg carton"
	desc = "A carton of eggs."
	icon = 'icons/obj/food.dmi'
	icon_state = "eggcarton"
	icon_type = "egg"
	storage_type = "carton"
	center_of_mass = list("x" = 16,"y" = 7)
	storage_slots = 12
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg = 12)
	foldable = /obj/item/stack/material/cardboard

/*
 * Cracker Packet
 */

/obj/item/storage/box/fancy/crackers
	name = "\improper Getmore Crackers"
	desc = "Salted crackers, not much for conversation; they're awfully dry."
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbag"
	icon_type = "cracker"
	storage_type = "bag"
	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	closable = FALSE
	storage_slots = 6
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks/cracker)
	starts_with = list(/obj/item/reagent_containers/food/snacks/cracker = 6)

/*
 * Candle Box
 */

/obj/item/storage/box/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlepack0"
	item_state = "candlepack"
	icon_type = "candle"
	storage_type = "pack"
	w_class = ITEMSIZE_SMALL
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 5
	can_hold = list(/obj/item/flame/candle)
	starts_with = list(/obj/item/flame/candle = 5)
	opened = TRUE
	closable = FALSE
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/fancy/candle_box/empty
	starts_with = null

/*
 * Crayon Box
 */

/obj/item/storage/box/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	icon_type = "crayon"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/pen/crayon)
	starts_with = list(
		/obj/item/pen/crayon/red = 1,
		/obj/item/pen/crayon/orange = 1,
		/obj/item/pen/crayon/yellow = 1,
		/obj/item/pen/crayon/green = 1,
		/obj/item/pen/crayon/blue = 1,
		/obj/item/pen/crayon/purple = 1
	)
	opened = TRUE
	closable = FALSE
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/fancy/crayons/empty
	starts_with = null

/obj/item/storage/box/fancy/crayons/update_icon()
	. = ..()
	cut_overlays()
	add_overlay("crayonbox")
	for(var/obj/item/pen/crayon/crayon in contents)
		add_overlay("[crayon.colourName]")

/obj/item/storage/box/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(usr, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(usr, "This crayon is too powerful to be contained in this box.")
				return
	..()

/*
 * Matchbox
 */

/obj/item/storage/box/fancy/matches
	name = "safety match box"
	desc = "A small box of 'Space-Proof' premium safety matches." //can't strike these anywhere other than matchboxes, so they're safety matches
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "matchbox"
	item_state = "box"
	icon_type = "match"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/matchbox.ogg'
	pickup_sound =  'sound/items/pickup/matchbox.ogg'
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/flame/match, /obj/item/trash/match)
	starts_with = list(/obj/item/flame/match = 10)
	icon_overlays = FALSE

/obj/item/storage/box/fancy/matches/attackby(obj/item/flame/match/W, mob/user)
	if(istype(W) && !W.lit)
		if(prob(25))
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_lit.ogg', 25, 0, -1)
			user.visible_message("<b>[user]</b> manages to light \the [W] by striking it on \the [src].", range = 3)
			W.light()
		else
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_hit.ogg', 25, 0, -1)
	W.update_icon()
	return

/obj/item/storage/box/fancy/matches/update_icon()
	. = ..()
	if(opened)
		if(contents.len == 0)
			icon_state = "matchbox_e"
		else if(contents.len <= 3)
			icon_state = "matchbox_almostempty"
		else if(contents.len <= 6)
			icon_state = "matchbox_almostfull"

////////////
//CIG PACK//
////////////
/obj/item/storage/box/fancy/cigarettes
	name = "Trans-Stellar Duty Frees cigarette packet"
	desc = "A ubiquitous brand of cigarettes, found in the facilities of every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	desc_info = "You can put a cigarette directly in your mouth by selecting the mouth region and clicking on yourself with a cigarette packet in hand. "
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	icon_type = "cigarette"
	storage_type = "packet"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter, /obj/item/trash/cigbutt)
	var/cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette

/obj/item/storage/box/fancy/cigarettes/Initialize()
	flags |= NOREACT
	create_reagents(15 * storage_slots)	//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

/obj/item/storage/box/fancy/cigarettes/fill()
	for(var/i = 1 to storage_slots)
		new cigarette_to_spawn(src)

/obj/item/storage/box/fancy/cigarettes/update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)][contents.len]"

/obj/item/storage/box/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		if(!istype(C)) return // what
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/obj/item/storage/box/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, target_zone)
	if(!istype(M, /mob))
		return
	if(!opened)
		to_chat(user, SPAN_NOTICE("The [src] is closed."))
		return

	if(M == user && target_zone == BP_MOUTH && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/smokable/cigarette/W = new cigarette_to_spawn(user)
		if(!istype(W))
			to_chat(user, SPAN_NOTICE("The [W] is in the way."))
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
		user.visible_message(SPAN_NOTICE("<b>[user]</b> casually pulls out a [icon_type] from \the [src] with their mouth."), SPAN_NOTICE("You casually pull out a [icon_type] from \the [src] with your mouth."), range = 3)
		update_icon()
	if(M == user && target_zone == BP_R_HAND || target_zone == BP_L_HAND) // Cig packing. Because obsessive smokers do it.
		user.visible_message(SPAN_NOTICE("<b>[user]</b> taps \the [src] against their palm."), SPAN_NOTICE("You tap \the [src] against your palm."))
	else
		..()

// get it? A - AcmeCo, B - Blank, C - Cigar, D - DromedaryCo. How convenient is that? - Wezzy

/obj/item/storage/box/fancy/cigarettes/acmeco
	name = "\improper AcmeCo cigarette packet"
	desc = "For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Apacket"
	item_state = "Apacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/acmeco

/obj/item/storage/box/fancy/cigarettes/blank
	name = "\improper blank cigarette packet"
	desc = "The healthiest cigarettes on the market! Wait, isn't this just a roll of paper?"
	icon_state = "Bpacket"
	item_state = "Bpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/blank

/obj/item/storage/box/fancy/cigarettes/cigar
	name = "cigar case"
	desc = "A luxurious tote for your fat tokes."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon_type = "cigar"
	storage_type = "case"
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	use_sound = 'sound/items/storage/briefcase.ogg'
	storage_slots = 8
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/cigar
	chewable = FALSE

/obj/item/storage/box/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo cigarette packet"
	desc = "A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/dromedaryco

/obj/item/storage/box/fancy/cigarettes/nicotine
	name = "\improper Nico-Tine cigarette packet"
	desc = "An Eridani marketing triumph - the jingle still torments people to this day."
	icon_state = "Epacket"
	item_state = "Epacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/nicotine

/obj/item/storage/box/fancy/cigarettes/rugged
	name = "\improper Laissez-Faires cigarette packet"
	desc = "Rumored to have outlived its original purpose as part of an Idris money laundering scheme."
	icon_state = "Fpacket"
	item_state = "Fpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/rugged

/*
 * Vial Box
 */
/obj/item/storage/box/fancy/vials
	name = "vial storage box"
	desc = "A box of vials."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	use_sound = 'sound/items/drop/glass.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)
	chewable = FALSE
	opened = TRUE
	closable = FALSE

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "box"
	use_sound = 'sound/items/drop/glass.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	max_w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	. = ..()
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

/obj/item/storage/lockbox/vials/forensic
	icon_state = "vialbox6"
	locked = FALSE
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)
	req_access = list(access_forensics_lockers)

/obj/item/storage/box/fancy/chocolate_box
	name = "chocolate box"
	desc = "A lot like life, you never know what you're going to get."
	icon = 'icons/obj/chocolate.dmi'
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	storage_slots = 8
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/truffle/random
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/truffle/random = 8)
	maxHealth = 40

/obj/item/storage/box/fancy/chocolate_box/fill()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/reagent_containers/food/snacks/truffle/random(src)
