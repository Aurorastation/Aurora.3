/* Pens!
 * Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "An instrument for writing or drawing with ink. This one is in black. Stylish, classic and professional."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	matter = list(DEFAULT_WALL_MATERIAL = 10)
	var/colour = "black"	//what colour the ink is!
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/pen/ispen()
	return TRUE

/obj/item/pen/blue
	desc = "An instrument for writing or drawing with ink. This one is in blue. Ironically used mostly by white-collar workers."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "An instrument for writing or drawing with ink. This one is in red. Favored by teachers and creeps who like to pretend to write in blood."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/multi
	desc = "An instrument for writing or drawing with ink. This one comes with with multiple colors! Push down all three simultaneously to rule the universe."
	icon_state = "pen_multi"
	var/selectedColor = 1
	var/colors = list("black","blue","red")

/obj/item/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/obj/item/pen/invisible
	desc = "An instrument for writing or drawing with ink. This one has invisible ink."
	icon_state = "pen"
	colour = "white"


/obj/item/pen/attack(mob/M as mob, mob/user as mob, var/target_zone)
	if(!ismob(M))
		return
	to_chat(user, "<span class='warning'>You stab [M] with \the [src].</span>")
//	to_chat(M, "\red You feel a tiny prick!" //That's a whole lot of meta!)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to stab [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) Used the [name] to stab [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))
	return

/obj/item/pen/attack_self(var/mob/user)
	playsound(loc, 'sound/items/penclick.ogg', 50, 1)

/*
 * Reagent pens
 */

/obj/item/pen/reagent
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/pen/reagent/attack(mob/living/M as mob, mob/user as mob)

	if(!istype(M))
		return

	. = ..()

	if(M.can_inject(user,1))
		if(reagents.total_volume)
			if(M.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
				admin_inject_log(user, M, src, contained_reagents, reagents.get_temperature(), trans)

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin//30 Chloral seems to be fatal, reducing it to 22./N


/*
 * Parapens
 */
/obj/item/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/paralysis/New()
	..()
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("cryptobiolin", 15)

/*
 * Chameleon pen
 */
/obj/item/pen/chameleon
	var/signature = ""

/obj/item/pen/chameleon/attack_self(mob/user as mob)
	signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/pen/proc/get_signature(var/mob/user)
	if (user)
		if (user.mind && user.mind.signature)
			return user.mind.signature
		else if (user.real_name)
			return "<i>[user.real_name]</i>"

	return "<i>Anonymous</i>"

/obj/item/pen/chameleon/get_signature(var/mob/user)
	return signature ? "<i>[signature]</i>" : "<i>Anonymous</i>"

/obj/item/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick new colour.", "Pen Colour", null, null) as null|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
			if("Green")
				colour = COLOR_LIME
			if("Pink")
				colour = COLOR_PINK
			if("Blue")
				colour = COLOR_BLUE
			if("Orange")
				colour = COLOR_ORANGE
			if("Cyan")
				colour = COLOR_CYAN
			if("Red")
				colour = COLOR_RED
			if("Invisible")
				colour = COLOR_WHITE
			else
				colour = COLOR_BLACK
		to_chat(usr, "<span class='info'>You select the [lowertext(selected_type)] ink container.</span>")


/*
 * Crayons
 */

/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1.0
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/chem_volume = 10 //crayon dust
	var/dust = "crayon_dust"

	New()
		name = "[colourName] crayon"
		..()

/obj/item/pen/crayon/Initialize()
	. = ..()
	create_reagents(chem_volume)
	reagents.add_reagent(dust,chem_volume)