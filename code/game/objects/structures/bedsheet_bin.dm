/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	desc_info = "Click to roll and unroll. Alt-click to fold and unfold. Drag and drop to pick up. You can equip it in your backpack slot."
	icon = 'icons/obj/bedsheets.dmi'
	icon_state = "sheetwhite"
	item_state = "sheetwhite"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_bedsheet.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_bedsheet.dmi',
		)
	slot_flags = SLOT_BACK
	layer = BASE_ABOVE_OBJ_LAYER
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_LARGE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	randpixel = 0
	center_of_mass = null
	var/roll = FALSE
	var/fold = FALSE
	var/inuse = FALSE
	var/inside_storage_item = FALSE

/obj/item/bedsheet/afterattack(atom/A, mob/user)
	if(istype(A, /obj/structure/bed))
		user.drop_item()
		forceMove(get_turf(A))
		add_fingerprint(user)
		return

/obj/item/bedsheet/attack_hand(mob/user)
	if(fold || inside_storage_item)
		if(inside_storage_item)
			inside_storage_item = FALSE
		if(!ismob(loc))
			user.put_in_hands(src)
	if(!ismob(loc))
		toggle_roll(user)
	else
		..()
	add_fingerprint(user)

/obj/item/bedsheet/on_enter_storage(obj/item/storage/S)
	inside_storage_item = TRUE
	return

/obj/item/bedsheet/on_exit_storage(obj/item/storage/S)
	inside_storage_item = FALSE
	return

/obj/item/bedsheet/AltClick(mob/user)
	if(!istype(loc,/mob))
		toggle_fold(user)
	else
		user.show_message(SPAN_WARNING("Drop \the [src] first."))
		..()
	add_fingerprint(user)

/obj/item/bedsheet/MouseDrop(mob/user)
	if((user && (!use_check(user))) && (user.contents.Find(src) || in_range(src, user)))
		if(!istype(user, /mob/living/carbon/slime) && !istype(user, /mob/living/simple_animal))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user, SPAN_NOTICE("You pick up \the [src]."))
				user.put_in_hands(src)
	return

/obj/item/bedsheet/update_icon()
	if(fold)
		icon_state = "sheet-fold"
	else if(roll)
		icon_state = "sheet-roll"
	else
		icon_state = initial(icon_state)

/obj/item/bedsheet/Crossed(H as mob) //Basically, stepping on it resets it to below people.
	if(isliving(H))
		var/mob/living/M = H
		if(M.loc == src.loc)
			return
	else
		reset_plane_and_layer()

/obj/item/bedsheet/verb/fold_verb()
	set name = "Fold Bedsheet"
	set category = "Object"
	set src in view(1)

	if(ishuman(usr))
		toggle_fold(usr)

/obj/item/bedsheet/proc/toggle_fold(var/mob/living/user) // Fold sheets to make them more portable through secret janitor-fu.
	if(!user)
		return FALSE
	if(inuse)
		return FALSE
	if(roll)
		user.show_message(SPAN_WARNING("Unroll \the [src] first."))
		return FALSE
	inuse = TRUE
	if (do_after(user, 25, src))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), /singleton/sound_category/rustle_sound, 15, 1, -5)
		var/folds = fold
		user.visible_message(SPAN_NOTICE("\The [user] [folds ? "unfolds" : "folds"] \the [src]."),
				SPAN_NOTICE("You [fold ? "unfold" : "fold"] \the [src]."))
		if(!fold)
			fold = TRUE
			slot_flags = null
			w_class = ITEMSIZE_SMALL
			layer = reset_plane_and_layer()
		else
			fold = FALSE
			slot_flags = SLOT_BACK
			w_class = ITEMSIZE_LARGE
		update_icon()
		inuse = FALSE
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/bedsheet/verb/roll_verb()
	set name = "Roll Bedsheet"
	set category = "Object"
	set src in view(1)

	if(ishuman(usr))
		toggle_roll(usr)

/obj/item/bedsheet/proc/toggle_roll(var/mob/living/user) // Tuck yourself in just by clicking. Also automatically rests you (if you're under it)
	if(!user || inuse || fold)
		return FALSE
	inuse = TRUE
	if (do_after(user, 6, src))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), /singleton/sound_category/rustle_sound, 15, 1, -5)
		var/rolls = roll
		user.visible_message(SPAN_NOTICE("\The [user] [rolls ? "unrolls" : "rolls"] \the [src]."),
							SPAN_NOTICE("You [roll ? "unroll" : "roll"] \the [src]."))
		if(!roll)
			roll = TRUE
			slot_flags = null
			w_class = ITEMSIZE_NORMAL
			layer = reset_plane_and_layer()
			if(user.resting && get_turf(src) == get_turf(user)) // Make them rest
				user.lay_down()
		else
			roll = FALSE
			slot_flags = SLOT_BACK
			w_class = ITEMSIZE_LARGE
			if(layer == initial(layer))
				layer = ABOVE_HUMAN_LAYER
			if(!user.resting && get_turf(src) == get_turf(user)) // Make them get up
				user.lay_down()
		update_icon()
		inuse = FALSE
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/bedsheet/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		user.visible_message(SPAN_NOTICE("\The [user] begins poking eyeholes in \the [src] with \the [attacking_item]."),
							SPAN_NOTICE("You begin poking eyeholes in \the [src] with \the [attacking_item]."))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user, SPAN_NOTICE("You poke eyeholes in \the [src]!"))
			new /obj/item/bedsheet/costume(get_turf(src))
			qdel(src)
		return TRUE
	else if(is_sharp(attacking_item))
		user.visible_message(SPAN_NOTICE("\The [user] begins cutting up \the [src] with \the [attacking_item]."),
							SPAN_NOTICE("You begin cutting up \the [src] with \the [attacking_item]."))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user, SPAN_NOTICE("You cut \the [src] into pieces!"))
			new /obj/item/stack/material/cloth(get_turf(src), rand(2, 5))
			qdel(src)
		return TRUE
	return ..()

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	item_state = "sheetgrey"

/obj/item/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	name = "rainbow bedsheet"
	desc = "A multicolored blanket. It's actually several different sheets cut up and sewn together."
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	item_state = "sheetblack"

/obj/item/bedsheet/mime
	name = "mime's blanket"
	desc = "A very soothing striped blanket.  All the noise just seems to fade out when you're under the covers in this."
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/bedsheet/clown
	name = "clown's blanket"
	desc = "A rainbow blanket with a clown mask woven in. It smells faintly of bananas."
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/bedsheet/captain
	name = "captain's bedsheet"
	desc = "It has a NanoTrasen symbol on it, and was woven with a revolutionary new kind of thread guaranteed to have 0.01% permeability for most non-chemical substances, popular among most modern captains."
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	item_state = "sheetian"

/obj/item/bedsheet/medical
	name = "medical blanket"
	desc = "It's a sterilized blanket commonly used in the Medbay. Well, as sterilized as space cleaner allows."
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/bedsheet/cmo
	name = "chief medical officer's bedsheet"
	desc = "It's a sterilized blanket that has a cross emblem. There's some cat fur on it."
	icon_state = "sheetcmo"
	item_state = "sheetcmo"

/obj/item/bedsheet/operation_manager
	name = "operation manager's bedsheet"
	desc = "It is decorated with a crate emblem in silver lining.  It's rather tough, and just the thing to lie on after a hard day of pushing paper."
	icon_state = "sheetqm"
	item_state = "sheetqm"

/obj/item/bedsheet/xo
	name = "executive officer's bedsheet"
	desc = "It is decorated with a key emblem. For those rare moments when you can rest and cuddle with Ian without someone screaming for you over the radio."
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/bedsheet/ce
	name = "chief engineer's bedsheet"
	desc = "It is decorated with a wrench emblem. It's highly reflective and stain resistant, so you don't need to worry about ruining it with oil."
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/bedsheet/hos
	name = "head of security's bedsheet"
	desc = "It is decorated with a shield emblem. While crime doesn't sleep, you do, but you are still THE LAW!"
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/bedsheet/rd
	name = "research director's bedsheet"
	desc = "It appears to have a beaker emblem, and is made out of fire-resistant material, although it probably won't protect you in the event of fires you're familiar with every day."
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/centcom
	name = "\improper CentCom bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for all officials."
	icon_state = "sheetcentcom"
	item_state = "sheetcentcom"

/obj/item/bedsheet/nanotrasen
	name = "nanotrasen bedsheet"
	desc = "It has the NanoTrasen logo on it and has an aura of duty."
	icon_state = "sheetNT"
	item_state = "sheetNT"

/obj/item/bedsheet/syndie
	name = "syndicate bedsheet"
	desc = "It has a syndicate emblem and it has an aura of evil."
	icon_state = "sheetsyndie"
	item_state = "sheetsyndie"

/obj/item/bedsheet/costume
	name = "ghost bedsheet"
	desc = "It seems to be flipped inside out with eyeholes poked out. "
	icon_state = "sheetcostume"
	item_state = "sheetcostume"
	slot_flags = SLOT_OCLOTHING

/obj/item/bedsheet/random
	name = "random bedsheet"
	icon_state = "sheetrandom"
	item_state = "sheetrainbow"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"

/obj/item/bedsheet/random/Initialize()
	..()
	var/type = pick(typesof(/obj/item/bedsheet) - /obj/item/bedsheet/random)
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/dorms
	name = "random dorms bedsheet"
	icon_state = "sheetrandom"
	item_state = "sheetrainbow"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"

/obj/item/bedsheet/dorms/Initialize()
	..()
	var/type = pickweight(list("Colors" = 80, "Special" = 20))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/grey,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/red,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/black))
		if("Special")
			type = pick(list(/obj/item/bedsheet/rainbow,
				/obj/item/bedsheet/ian,
				/obj/item/bedsheet/nanotrasen))
	new type(loc)
	return INITIALIZE_HINT_QDEL


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(amount < 1)
		. += "There are no bed sheets in the bin."
		return
	if(amount == 1)
		. += "There is one bed sheet in the bin."
		return
	. += "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	var/max_sheets = initial(amount)
	if(amount > (max_sheets/2))
		icon_state = "linenbin-full"
	else if(amount > 0)
		icon_state = "linenbin-half"
	else
		icon_state = "linenbin-empty"

/obj/structure/bedsheetbin/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/bedsheet))
		user.drop_from_inventory(attacking_item,src)
		sheets.Add(attacking_item)
		amount++
		to_chat(user, "<span class='notice'>You put [attacking_item] in [src].</span>")
	else if(amount && !hidden && attacking_item.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_from_inventory(attacking_item,src)
		hidden = attacking_item
		to_chat(user, "<span class='notice'>You hide [attacking_item] among the sheets.</span>")

/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(user.loc)
		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You take [B] out of [src].</span>")

		if(hidden)
			hidden.forceMove(user.loc)
			to_chat(user, "<span class='notice'>[hidden] falls out of [B]!</span>")
			hidden = null


	add_fingerprint(user)

/obj/structure/bedsheetbin/do_simple_ranged_interaction(var/mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove [B] from [src].</span>")
		update_icon()

		if(hidden)
			hidden.forceMove(loc)
			hidden = null


	add_fingerprint(user)
