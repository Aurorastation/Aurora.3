/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheets.dmi'
	icon_state = "bedsheet"
	item_state = "bedsheet"
	slot_flags = SLOT_BACK
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 4.0
	drop_sound = 'sound/items/drop/clothing.ogg'
	randpixel = 0
	center_of_mass = null
	var/roll = FALSE
	var/fold = FALSE
	var/inuse = FALSE
	var/list/dream_messages = list("white")

/obj/item/weapon/bedsheet/afterattack(atom/A, mob/user)
	if(istype(A, /obj/structure/bed))
		user.drop_item()
		forceMove(get_turf(A))
		add_fingerprint(user)
		return

/obj/item/weapon/bedsheet/attack_hand(mob/user as mob)
	if(fold)
		user.put_in_hands(src)
	if(!istype(loc,/mob))
		toggle_roll(user)
	else
		..()
	add_fingerprint(user)

/obj/item/weapon/bedsheet/AltClick(mob/user as mob)
	if(!istype(loc,/mob))
		toggle_fold(user)
	else
		user.show_message("<span class='warning'>Drop \the [src] first.</span>")
		..()
	add_fingerprint(user)

/obj/item/weapon/bedsheet/MouseDrop(mob/user as mob)
	if((user && (!( user.restrained() ) && (!( user.stat ) && (user.contents.Find(src) || in_range(src, user))))))
		if(!istype(user, /mob/living/carbon/slime) && !istype(user, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user, "<span class='notice'>You pick up the [src].</span>")
				user.put_in_hands(src)
	return

/obj/item/weapon/bedsheet/update_icon()
	if(fold)
		icon_state = "sheet-fold"
	else if(roll)
		icon_state = "sheet-roll"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/bedsheet/Crossed(H as mob) //Basically, stepping on it resets it to below people.
	if(isliving(H))
		var/mob/living/M = H
		if(M.loc == src.loc)
			return
	else
		layer = initial(layer)

/obj/item/weapon/bedsheet/verb/fold_verb(var/mob/living/user)
	set name = "Fold Bedsheet"
	set category = "Object"
	set src in view(1)

	if(ishuman(user))
		toggle_fold(user)

/obj/item/weapon/bedsheet/proc/toggle_fold(var/mob/living/user) // Fold sheets to make them more portable through secret janitor-fu.
	if(!user)
		return FALSE
	if(inuse)
		return FALSE
	if(roll)
		user.show_message("<span class='warning'>Unroll \the [src] first.</span>")
		return FALSE
	inuse = TRUE
	if (do_after(user, 25, src))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), "rustle", 15, 1, -5)
		var/folds = fold
		user.visible_message("<span class='notice'>\The [user] [folds ? "unfolds" : "folds"] \the [src].", "You [fold ? "unfold" : "fold"] \the [src].</span>")
		if(!fold)
			fold = TRUE
			slot_flags = null
			w_class = 2.0
			layer = initial(layer)
		else
			fold = FALSE
			slot_flags = SLOT_BACK
			w_class = 4.0
		update_icon()
		inuse = FALSE
		return TRUE
	inuse = FALSE
	return FALSE

/obj/item/weapon/bedsheet/verb/roll_verb(var/mob/living/user)
	set name = "Roll Bedsheet"
	set category = "Object"
	set src in view(1)

	if(ishuman(user))
		toggle_roll(user)

/obj/item/weapon/bedsheet/proc/toggle_roll(var/mob/living/user) // Tuck yourself in just by clicking. Also automatically rests you (if you're under it)
	if(!user)
		return FALSE
	if(inuse)
		return FALSE
	if(fold)
		return FALSE
	inuse = TRUE
	if (do_after(user, 6, src))
		if(user.loc != loc)
			user.do_attack_animation(src)
		playsound(get_turf(loc), "rustle", 15, 1, -5)
		var/rolls = roll
		user.visible_message("<span class='notice'>\The [user] [rolls ? "unrolls" : "rolls"] \the [src].", "You [roll ? "unroll" : "roll"] \the [src].</span>")
		if(!roll)
			roll = TRUE
			slot_flags = null
			w_class = 3.0
			layer = initial(layer)
			if(user.resting && get_turf(src) == get_turf(user)) // Make them rest
				user.lay_down()
		else
			roll = FALSE
			slot_flags = SLOT_BACK
			w_class = 4.0
			if(layer == initial(layer))
				layer = ABOVE_MOB_LAYER
			if(!user.resting && get_turf(src) == get_turf(user)) // Make them get up
				user.lay_down()
		update_icon()
		inuse = FALSE
		return TRUE
	inuse = FALSE
	return FALSE

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
/obj/item/weapon/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/weapon/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/weapon/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/weapon/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/weapon/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/weapon/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/weapon/bedsheet/rainbow
	name = "rainbow bedsheet"
	desc = "A multicolored blanket. It's actually several different sheets cut up and sewn together."
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/weapon/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"

/obj/item/weapon/bedsheet/black
	icon_state = "sheetblack"
	item_state = "sheetblack"

/obj/item/weapon/bedsheet/mime
	name = "mime's blanket"
	desc = "A very soothing striped blanket.  All the noise just seems to fade out when you're under the covers in this."
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/weapon/bedsheet/clown
	name = "clown's blanket"
	desc = "A rainbow blanket with a clown mask woven in. It smells faintly of bananas."
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/weapon/bedsheet/captain
	name = "captain's bedsheet"
	desc = "It has a Nanotrasen symbol on it, and was woven with a revolutionary new kind of thread guaranteed to have 0.01% permeability for most non-chemical substances, popular among most modern captains."
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/weapon/bedsheet/ian
	icon_state = "sheetian"
	item_state = "sheetian"

/obj/item/weapon/bedsheet/medical
	name = "medical blanket"
	desc = "It's a sterilized blanket commonly used in the Medbay. Well, as sterilized as space cleaner allows."
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/weapon/bedsheet/cmo
	name = "chief medical officer's bedsheet"
	desc = "It's a sterilized blanket that has a cross emblem. There's some cat fur on it."
	icon_state = "sheetcmo"
	item_state = "sheetcmo"

/obj/item/weapon/bedsheet/qm
	name = "quartermaster's bedsheet"
	desc = "It is decorated with a crate emblem in silver lining.  It's rather tough, and just the thing to lie on after a hard day of pushing paper."
	icon_state = "sheetqm"
	item_state = "sheetqm"

/obj/item/weapon/bedsheet/hop
	name = "head of personnel's bedsheet"
	desc = "It is decorated with a key emblem. For those rare moments when you can rest and cuddle with Ian without someone screaming for you over the radio."
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/weapon/bedsheet/ce
	name = "chief engineer's bedsheet"
	desc = "It is decorated with a wrench emblem. It's highly reflective and stain resistant, so you don't need to worry about ruining it with oil."
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/weapon/bedsheet/hos
	name = "head of security's bedsheet"
	desc = "It is decorated with a shield emblem. While crime doesn't sleep, you do, but you are still THE LAW!"
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/weapon/bedsheet/rd
	name = "research director's bedsheet"
	desc = "It appears to have a beaker emblem, and is made out of fire-resistant material, although it probably won't protect you in the event of fires you're familiar with every day."
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/centcom
	name = "\improper CentCom bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for all officials."
	icon_state = "sheetcentcom"
	item_state = "sheetcentcom"

/obj/item/weapon/bedsheet/nanotrasen
	name = "nanotrasen bedsheet"
	desc = "It has the Nanotrasen logo on it and has an aura of duty."
	icon_state = "sheetNT"
	item_state = "sheetNT"

/obj/item/weapon/bedsheet/syndie
	name = "syndicate bedsheet"
	desc = "It has a syndicate emblem and it has an aura of evil."
	icon_state = "sheetsyndie"
	item_state = "sheetsyndie"

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
