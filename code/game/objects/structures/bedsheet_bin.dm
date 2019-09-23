/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheets.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	slot_flags = SLOT_BACK
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 2.0
	drop_sound = 'sound/items/drop/clothing.ogg'
	randpixel = 0
	center_of_mass = null
	var/rolled = FALSE
	var/folded = FALSE
	var/inuse = FALSE

/obj/item/weapon/bedsheet/afterattack(atom/A, mob/user)
	if(!user || user.incapacitated() || !user.Adjacent(A))
		return
	if(toggle_fold(user))
		user.drop_item()
		forceMove(get_turf(A))
		add_fingerprint(user)
		return

/obj/item/weapon/bedsheet/attack_hand(mob/user as mob)
	if(!folded)
		toggle_roll(user)
	add_fingerprint(user)

/obj/item/weapon/bedsheet/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return
				if(!folded)
					toggle_fold(usr)
				if(folded)
					to_chat(user, "<span class='notice'>You pick up the [src].</span>")
					user.put_in_hands(src)

	return

/obj/item/weapon/bedsheet/update_icon()
	if (folded)
		icon_state = "sheet-folded"
	else if (rolled)
		icon_state = "sheet-rolled"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/bedsheet/proc/toggle_roll(var/mob/living/user, var/message = TRUE)
	if(!user)
		return FALSE
	if(inuse)
		user.show_message("Someone's already using \the [src].")
		return FALSE
	inuse = TRUE
	if (do_after(user, 6, src))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), "rustle", 15, 1, -5)
		if(!message)
			user.visible_message("<span class='notice'>\The [user] [rolled ? "unrolled" : "rolled"] \the [src].", "You [rolled ? "unrolled" : "rolled"] \the [src].</span>")
		if(!rolled)
			rolled = TRUE
			layer = initial(layer)
		else
			rolled = FALSE
			if(layer == initial(layer))
				layer = ABOVE_MOB_LAYER
		inuse = FALSE
		update_icon()
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/weapon/bedsheet/verb/roll_verb(mob/living/user as mob)
	set name = "Roll bedsheet"
	set category = "Object"
	set src in view(1)

	if(folded)
		user.show_message("<span class='warning'>Unfold \the [src] first.</span>")
	else if(istype(loc,/mob))
		user.show_message("<span class='warning'>Drop \the [src] first.</span>")
	else if(ishuman(usr))
		toggle_roll(usr)

/obj/item/weapon/bedsheet/proc/toggle_fold(var/mob/user, var/message = TRUE)
	if(!user)
		return FALSE
	if(inuse)
		user.show_message("Someone's already using \the [src].")
		return FALSE
	inuse = TRUE
	if (do_after(user, 25, src))
		rolled = FALSE
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), "rustle", 15, 1, -5)
		if(message)
			user.visible_message("<span class='notice'>\The [user] [folded ? "unfolded" : "folded"] \the [src].", "You [folded ? "unfolded" : "folded"] \the [src].</span>")
		if(!folded)
			folded = TRUE
		else
			folded = FALSE
		inuse = FALSE
		update_icon()
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/weapon/bedsheet/verb/fold_verb(mob/living/user as mob)
	set name = "Fold bedsheet"
	set category = "Object"
	set src in view(1)

	if(istype(loc,/mob))
		user.show_message("<span class='warning'>Drop \the [src] first.</span>")
	else if(ishuman(usr))
		toggle_fold(usr)

/obj/item/weapon/bedsheet/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [I].</span>", "<span class='notice'>You begin cutting up [src] with [I].</span>")
		if(do_after(user, 50/I.toolspeed))
			to_chat(user, "<span class='notice'>You cut [src] into pieces!</span>")
			for(var/i in 1 to rand(2,5))
				new /obj/item/weapon/reagent_containers/glass/rag(get_turf(src))
			qdel(src)
		return
	..()

/obj/item/weapon/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/weapon/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/weapon/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/weapon/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/weapon/bedsheet/rainbow
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/weapon/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/weapon/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/weapon/bedsheet/mime
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/weapon/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/weapon/bedsheet/captain
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/weapon/bedsheet/rd
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/weapon/bedsheet/medical
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/weapon/bedsheet/hos
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/weapon/bedsheet/hop
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/weapon/bedsheet/ce
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/weapon/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"

/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine(mob/user)
	..(user)

	if(amount < 1)
		to_chat(user, "There are no bed sheets in the bin.")
		return
	if(amount == 1)
		to_chat(user, "There is one bed sheet in the bin.")
		return
	to_chat(user, "There are [amount] bed sheets in the bin.")


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)				icon_state = "linenbin-empty"
		if(1 to amount / 2)	icon_state = "linenbin-half"
		else				icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/bedsheet))
		user.drop_from_inventory(I,src)
		sheets.Add(I)
		amount++
		to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
	else if(amount && !hidden && I.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_from_inventory(I,src)
		hidden = I
		to_chat(user, "<span class='notice'>You hide [I] among the sheets.</span>")

/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		B.forceMove(user.loc)
		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You take [B] out of [src].</span>")

		if(hidden)
			hidden.forceMove(user.loc)
			to_chat(user, "<span class='notice'>[hidden] falls out of [B]!</span>")
			hidden = null


	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		B.forceMove(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove [B] from [src].</span>")
		update_icon()

		if(hidden)
			hidden.forceMove(loc)
			hidden = null


	add_fingerprint(user)
