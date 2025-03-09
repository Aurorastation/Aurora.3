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
	contained_sprite = TRUE

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
			..()
	else
		ClearOverlays()
		icon_state = "[initial(icon_state)]" // closed
	..()

/obj/item/storage/box/fancy/handle_item_insertion()
	if(!opened) // makes sure boxes are opened before inserting anything
		opened = TRUE
		update_icon()
	. = ..()

/obj/item/storage/box/fancy/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!icon_type || !storage_type)
		return
	if(contents.len <= 0)
		. += "There are no [src.icon_type]s left in the [src.storage_type]."
	else
		. += "There [src.contents.len == 1 ? "is" : "are"] <b>[src.contents.len]</b> [src.icon_type]\s left in \the [src.storage_type]."

/*
 * Donut Box
 */

/obj/item/storage/box/fancy/donut
	name = "donut box"
	desc = "A box of half-a-dozen donuts sponsored by GetMore Chocolate Corporation. Allegedly contentious with the psychiatrist unions for some reason."
	icon = 'icons/obj/storage/fancy/donutbox.dmi'
	icon_state = "donutbox"
	icon_type = "donut"
	center_of_mass = list("x" = 16,"y" = 9)
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	starts_with = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)
	max_storage_space = DEFAULT_BOX_STORAGE
	storage_slots = 6
	icon_overlays = FALSE
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/fancy/donut/update_icon() // One of the few unique update_icon()s, due to having to store both regular and sprinkled donuts.
	. = ..()
	if(opened)
		ClearOverlays()
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
			AddOverlays("[i][D.overlay_state]")
			i++

/obj/item/storage/box/fancy/donut/empty
	starts_with = null

/*
 * Egg Box
 */

/obj/item/storage/box/fancy/egg_box
	name = "egg carton"
	desc = "A carton of eggs."
	icon = 'icons/obj/storage/fancy/eggcarton.dmi'
	icon_state = "eggcarton"
	item_state = "eggbox"
	icon_type = "egg"
	storage_type = "carton"
	center_of_mass = list("x" = 16,"y" = 7)
	storage_slots = 12
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg = 12)
	foldable = /obj/item/stack/material/cardboard

/obj/item/storage/box/fancy/egg_box/tunneler
	name = "ice tunneler egg carton"
	desc = "A carton of ice tunneler eggs."
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/egg
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers = 12)
	foldable = /obj/item/stack/material/cardboard

/*
 * Cracker Packet
 */

/obj/item/storage/box/fancy/crackers
	name = "\improper Getmore Crackers"
	desc = "Salted crackers, not much for conversation; they're awfully dry."
	icon = 'icons/obj/storage/fancy/crackerbag.dmi'
	icon_state = "crackerbag"
	icon_type = "cracker"
	storage_type = "bag"
	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	closable = FALSE
	storage_slots = 6
	w_class = WEIGHT_CLASS_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks/cracker)
	starts_with = list(/obj/item/reagent_containers/food/snacks/cracker = 6)

/*
 * Candle Box
 */

/obj/item/storage/box/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/storage/fancy/candle.dmi'
	icon_state = "candlepack0"
	item_state = "candlepack"
	icon_type = "candle"
	storage_type = "pack"
	w_class = WEIGHT_CLASS_SMALL
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
	icon = 'icons/obj/storage/fancy/crayon.dmi'
	icon_state = "crayonbox"
	icon_type = "crayon"
	w_class = WEIGHT_CLASS_SMALL
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
	ClearOverlays()
	AddOverlays("crayonbox")
	for(var/obj/item/pen/crayon/crayon in contents)
		AddOverlays("[crayon.colourName]")

/obj/item/storage/box/fancy/crayons/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/pen/crayon))
		var/obj/item/pen/crayon/W = attacking_item
		switch(W.colourName)
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
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/items/drop/matchbox.ogg'
	pickup_sound =  'sound/items/pickup/matchbox.ogg'
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/flame/match, /obj/item/trash/match)
	starts_with = list(/obj/item/flame/match = 10)
	icon_overlays = FALSE

/obj/item/storage/box/fancy/matches/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/flame/match/W = attacking_item
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
	w_class = WEIGHT_CLASS_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter, /obj/item/trash/cigbutt)
	var/cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette

/obj/item/storage/box/fancy/cigarettes/Initialize()
	atom_flags |= ATOM_FLAG_NO_REACT
	create_reagents(15 * storage_slots)	//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

/obj/item/storage/box/fancy/cigarettes/fill()
	for(var/i = 1 to storage_slots)
		new cigarette_to_spawn(src)

/obj/item/storage/box/fancy/cigarettes/update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)][contents.len]"

/obj/item/storage/box/fancy/cigarettes/remove_from_storage(obj/item/removed_item, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/C = removed_item
	if(!istype(C))
		return ..()
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	return ..()

/obj/item/storage/box/fancy/cigarettes/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!ismob(target_mob))
		return
	if(!opened)
		to_chat(user, SPAN_WARNING("\The [src] is closed."))
		return
	if(target_zone == BP_MOUTH && contents.len > 0)
		if(target_mob.wear_mask)
			to_chat(user, SPAN_WARNING("\The [target_mob.wear_mask] is in the way."))
			return
		var/obj/item/clothing/mask/smokable/cigarette/cig = locate() in src
		if(!istype(cig))
			to_chat(user, SPAN_WARNING("There isn't a cigarette in \the [src]!"))
			return
		if(target_mob != user)
			if(!use_check(target_mob))
				to_chat(user, SPAN_WARNING("[target_mob.name] is in no condition to handle items!"))
				return
			user.visible_message(SPAN_NOTICE("\The <b>[user]</b> holds up the open [src.name] to \the [target_mob]'s mouth."), SPAN_NOTICE("You hold up the open [src.name] to \the [target_mob]'s mouth, waiting for them to accept."))
			var/response = alert(target_mob, "\The [user] offers you \a [cig.name]. Do you accept?", "Smokable Offer", "Accept", "Decline")
			if(response != "Accept")
				target_mob.visible_message(SPAN_NOTICE("<b>[target_mob]</b> pushes [user]'s [src.name] away."))
				return
			if(!target_mob.Adjacent(user))
				to_chat(user, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
				to_chat(target_mob, SPAN_WARNING("\The [user] moved too far away."))
				return
		remove_from_storage(cig, get_turf(target_mob))
		target_mob.equip_to_slot_if_possible(cig, slot_wear_mask)
		target_mob.visible_message(SPAN_NOTICE("<b>[target_mob]</b> casually pulls out a [icon_type] from \the [src] with [target_mob.get_pronoun("his")] mouth."), SPAN_NOTICE("You casually pull out a [icon_type] from \the [src] with your mouth."), range = 3)
		update_icon()
		return
	if(target_mob == user && target_zone == BP_R_HAND || target_zone == BP_L_HAND) // Cig packing. Because obsessive smokers do it.
		user.visible_message(SPAN_NOTICE("<b>[user]</b> taps \the [src] against [user.get_pronoun("his")] palm."), SPAN_NOTICE("You tap \the [src] against your palm."))
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

/obj/item/storage/box/fancy/cigarettes/cigar/prank
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/cigar/prank

/obj/item/storage/box/fancy/cigarettes/oracle
	name = "\improper Natural Vysokan Soothsayer oracle cigarette packet"
	desc = "Featuring an illustration of a soothsayer from Vysoka on its packaging, these cigarettes are advertised as containing oracle instead of the normal tobacco. A warning box stating \"These oracle cigarettes are not healthier than tobacco alternatives\" appears to have been haphazardly placed on the packet."
	icon_state = "Opacket"
	item_state = "Fpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/oracle

/*
 * Vial Box
 */
/obj/item/storage/box/fancy/vials
	name = "vial storage box"
	desc = "A box of vials."
	icon = 'icons/obj/storage/fancy/vialbox.dmi'
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
	icon = 'icons/obj/storage/fancy/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "box"
	use_sound = 'sound/items/drop/glass.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	max_w_class = WEIGHT_CLASS_SMALL
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	make_exact_fit = TRUE
	storage_slots = 6
	req_access = list(ACCESS_VIROLOGY)

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	. = ..()
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	ClearOverlays()
	if (!broken)
		AddOverlays("led[locked]")
		if(locked)
			AddOverlays("cover")
	else
		AddOverlays("ledb")

/obj/item/storage/lockbox/vials/attackby(obj/item/attacking_item, mob/user, params)
	..()
	update_icon()

/obj/item/storage/lockbox/vials/forensic
	icon_state = "vialbox6"
	locked = FALSE
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)
	req_access = list(ACCESS_FORENSICS_LOCKERS)

/obj/item/storage/box/fancy/chocolate_box
	name = "chocolate box"
	desc = "A lot like life, you never know what you're going to get."
	icon = 'icons/obj/storage/fancy/chocolate.dmi'
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

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/storage/fancy/pizzabox.dmi'
	icon_state = "pizzabox1"
	item_state = "pizzabox" // don't touch this shit unless you know what you're doing
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	contained_sprite = TRUE
	center_of_mass = list("x" = 16,"y" = 6)

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/pizza_type
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/Initialize()
	. = ..()
	if(pizza_type)
		pizza = new pizza_type(src)
	update_icon()

/obj/item/pizzabox/update_icon()
	ClearOverlays()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image(pizza.icon, pizza.icon_state)
			pizzaimg.pixel_y = -2
			AddOverlays(pizzaimg)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image(icon, icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			AddOverlays(tagimg)

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, SPAN_WARNING("You take \the [src.pizza] out of \the [src]."))
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, SPAN_WARNING("You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = attacking_item

		if(!box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if((boxes.len+1) + boxestoadd.len <= 5)
				user.drop_from_inventory(box,src)
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, SPAN_WARNING("You put \the [box] ontop of \the [src]!"))
			else
				to_chat(user, SPAN_WARNING("The stack is too high!"))
		else
			to_chat(user, SPAN_WARNING("Close \the [box] first!"))

		return

	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/sliceable/pizza/)) // Long ass fucking object name

		if(src.open)
			user.drop_from_inventory(attacking_item, src)
			src.pizza = attacking_item

			update_icon()

			to_chat(user, SPAN_WARNING("You put \the [attacking_item] in \the [src]!"))
		else
			to_chat(user, SPAN_WARNING("You try to push \the [attacking_item] through the lid but it doesn't work!"))
		return

	if(attacking_item.ispen())

		if(src.open)
			return

		var/t = sanitize( tgui_input_text(user, "Enter what you want to add to the tag:", "Write", max_length = 30), 30 )

		var/obj/item/pizzabox/boxtotagto = src
		if(boxes.len > 0)
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	boxtag = "Meatlover's Supreme"

/obj/item/pizzabox/pineapple
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple
	boxtag = "Silversun Sunrise"

/obj/item/pizzabox/pepperoni
	pizza_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pepperoni
	boxtag = "Pepperoni Power"

/obj/item/storage/box/fancy/chips
	name = "\improper Getmore salted chip multipack"
	desc = "A six-pack bag of Getmore salted potato chips!"
	icon = 'icons/obj/storage/fancy/multichips.dmi'
	icon_state = "multichips"
	icon_type = "chip packet"
	storage_type = "bag"
	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	closable = FALSE
	icon_overlays = FALSE
	storage_slots = 6
	w_class = WEIGHT_CLASS_NORMAL
	can_hold = list(/obj/item/reagent_containers/food/snacks/chips)
	starts_with = list(/obj/item/reagent_containers/food/snacks/chips = 6)

/obj/item/storage/box/fancy/chips/cucumber
	name = "\improper Getmore cucumber chip multipack"
	desc = "A six-pack bag of Getmore cucumber potato chips!"
	icon_state = "multichipscucumber"
	starts_with = list(/obj/item/reagent_containers/food/snacks/chips/cucumber = 6)

/obj/item/storage/box/fancy/chips/chicken
	name = "\improper Getmore chicken chip multipack"
	desc = "A six-pack bag of Getmore chicken potato chips!"
	icon_state = "multichipschicken"
	starts_with = list(/obj/item/reagent_containers/food/snacks/chips/chicken = 6)

/obj/item/storage/box/fancy/chips/dirtberry
	name = "\improper Getmore dirtberry chip multipack"
	desc = "A six-pack bag of Getmore dirtberry potato chips!"
	icon_state = "multichipsdirtberry"
	starts_with = list(/obj/item/reagent_containers/food/snacks/chips/dirtberry = 6)

/obj/item/storage/box/fancy/chips/phoron
	name = "\improper Getmore phoron chip multipack"
	desc = "A six-pack bag of Getmore 'phoron' potato chips!"
	icon_state = "multichipsphoron"
	starts_with = list(/obj/item/reagent_containers/food/snacks/chips/phoron = 6)

/obj/item/storage/box/fancy/chips/variety
	name = "\improper Getmore chips variety pack"
	desc = "A Getmore variety pack, containing bags of salted, cucumber, and chicken chips!"
	icon_state = "multichipsvariety"
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chips = 2,
		/obj/item/reagent_containers/food/snacks/chips/cucumber = 2,
		/obj/item/reagent_containers/food/snacks/chips/chicken = 2
	)


/obj/item/storage/box/fancy/food/cakepopjar
	name = "cake pops"
	desc = "Unhealthy? Don't be silly! If sprinkles of unnatural colors, intensely concentrated sugar, and bright, oil-based food dyes were bad for you, why would our children be evolutionarily drawn to eating them?!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cakepopsfull"
	icon_type = "cake pop"
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	storage_type = "glass"
	storage_slots = 20
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/cakepopselection
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/cakepopselection = 5)
	trash = /obj/item/reagent_containers/food/drinks/drinkingglass
	opened = TRUE
	closable = FALSE
	throwforce = 4


/obj/item/storage/box/fancy/food/cakepopjar/fill()
	. = ..()
	for(var/obj/item/reagent_containers/food/snacks/cakepopselection/cakepop in src.contents)
		var/MM = text2num(time2text(world.timeofday, "MM"))
		if(MM == 10) //this checks if the month is october and if so gives the cake pops themselves halloween colors!
			switch(roll("1d2"))
				if(1)
					cakepop.icon_state = "cakepop5"
				if(2)
					cakepop.icon_state = "cakepop6"
		else //otherwise it randomly gives them one of the "normal" colors
			switch(roll("1d4"))
				if(1)
					cakepop.icon_state = "cakepop1"
				if(2)
					cakepop.icon_state = "cakepop2"
				if(3)
					cakepop.icon_state = "cakepop3"
				if(4)
					cakepop.icon_state = "cakepop4"

/obj/item/storage/box/fancy/food/cakepopjar/update_icon()
	. = ..()
	var/MM = text2num(time2text(world.timeofday, "MM"))
	if(MM == 10) //checks if it's october to give the cake pop jar halloween colors
		if(contents.len == 0)
			icon_state = "cakepopsempty"
		else if(contents.len == 1)
			icon_state = "halloweencakepopsone"
		else if(contents.len <= 3)
			icon_state = "halloweencakepopshalf"
		else if(contents.len <= 5)
			icon_state = "halloweencakepopsfull"
		else if(contents.len <= 10)
			icon_state = "halloweencakepopsstuffed"
		else
			icon_state = "halloweencakepopshalf"
	else //or else normal colors
		if(contents.len == 0)
			icon_state = "cakepopsempty"
		else if(contents.len == 1)
			icon_state = "cakepopsone"
		else if(contents.len <= 3)
			icon_state = "cakepopshalf"
		else if(contents.len <= 5)
			icon_state = "cakepopsfull"
		else if(contents.len <= 10)
			icon_state = "cakepopsstuffed"
		else
			icon_state = "cakepopshalf"

/obj/item/storage/box/fancy/food/pralinebox
	name = "box of pralines"
	desc = "A heart shaped box filled with assorted delicious chocolate pralines. Used to show love either for another person, or more commonly - for chocolate."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "heartbox_closed"
	item_state = "heartbox_closed"
	icon_type = "chocolate praline"
	contained_sprite = TRUE
	storage_slots = 10
	make_exact_fit = TRUE
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/pralines
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/pralines/praline1 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline2 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline3 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline4 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline5 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline6 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline7 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline8 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline9 = 1,
		/obj/item/reagent_containers/food/snacks/pralines/praline10 = 1
	)
	throwforce = 2

/obj/item/storage/box/fancy/food/pralinebox/update_icon()
	. = ..()
	if(opened)
		if(contents.len == 0)
			icon_state = "heartbox_empty"
			item_state = "heartbox_open"
		else if(contents.len <= 9)
			icon_state = "heartbox_half"
			item_state = "heartbox_open"
		else if(contents.len <= 10)
			item_state = "heartbox_open"
			icon_state = "heartbox_full"
