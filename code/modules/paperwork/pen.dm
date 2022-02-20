/* Pens!
 * Contains:
 *		Pens
 *		PDA Pens
 *		Sleepy Pens
 *		Coloured Pens
 *		Parapens
 *		Fountain Pens
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "An instrument for writing or drawing with ink. This one is in black, in a classic, grey casing. Stylish, classic and professional."
	desc_info = {"This is an item for writing down your thoughts, on paper or elsewhere. The following special commands are available:
Pen and crayon commands
\[br\] : Creates a linebreak.
\[center\] - \[/center\] : Centers the text.
\[h1\] - \[/h1\] : Makes the text a first level heading.
\[h2\] - \[/h2\] : Makes the text a second level headin.
\[h3\] - \[/h3\] : Makes the text a third level heading.
\[b\] - \[/b\] : Makes the text bold.
\[i\] - \[/i\] : Makes the text italic.
\[u\] - \[/u\] : Makes the text underlined.
\[large\] - \[/large\] : Increases the size of the text.
\[redacted\] - \[/redacted\] : Covers the text in an unbreachable black box.
\[sign\] : Inserts a signature of your name in a foolproof way.
\[field\] : Inserts an invisible field which lets you start type from there. Useful for forms.
\[date\] : Inserts today's station date.
\[time\] : Inserts the current station time.
Pen exclusive commands
\[small\] - \[/small\] : Decreases the size of the text.
\[list\] - \[/list\] : A list.
\[*\] : A dot used for lists.
\[hr\] : Adds a horizontal rule."}
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(DEFAULT_WALL_MATERIAL = 10)
	var/colour = "black"	//what colour the ink is!
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/pen/ispen()
	return TRUE

/*
 * PDA Pens
 */

/obj/item/pen/black
	desc = "An instrument for writing or drawing with ink. This one is in black, in a sleek, black casing. Stylish, classic and professional."
	icon_state = "pen_black"

/obj/item/pen/silver
	desc = "An instrument for writing or drawing with ink. This one is in black, in a shiny, silver casing. Stylish, classic and professional."
	icon_state = "pen_silver"

/obj/item/pen/white
	desc = "An instrument for writing or drawing with ink. This one is in black, in a sterile, white casing. Stylish, classic and professional."
	icon_state = "pen_white"

/*
 * Coloured Pens
 */

/obj/item/pen/blue
	desc = "An instrument for writing or drawing with ink. This one is in blue. Ironically used mostly by white-collar workers."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "An instrument for writing or drawing with ink. This one is in red. Favored by teachers and creeps who like to pretend to write in blood."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/yellow
	desc = "An instrument for writing or drawing with ink. Favored by artists who like to draw using bright colors."
	icon_state = "pen_yellow"
	colour = "yellow"

/obj/item/pen/green
	desc = "An instrument for writing or drawing with ink. This one is in green. Favored by students who like to have their notes extra organized with colors."
	icon_state = "pen_green"
	colour = "green"

/obj/item/pen/invisible
	desc = "An instrument for writing or drawing with ink. This one has invisible ink."
	icon_state = "pen"
	colour = "white"

/obj/item/pen/multi
	desc = "An instrument for writing or drawing with ink. This one comes with with multiple colors! Push down all three simultaneously to rule the universe."
	icon_state = "pen_multi"
	var/selectedColor = 1
	var/colors = list("black", "blue", "red", "green", "yellow")

/obj/item/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/obj/item/pen/attack(mob/M as mob, mob/user as mob, var/target_zone)
	if(!ismob(M))
		return
	to_chat(user, "<span class='warning'>You stab [M] with \the [src].</span>")
//	to_chat(M, "\red You feel a tiny prick!" //That's a whole lot of meta!)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [name] to stab [M.name] ([M.ckey])</span>")
	msg_admin_attack("[user.name] ([user.ckey]) Used the [name] to stab [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))
	return

/obj/item/pen/attack_self(var/mob/user)
	playsound(loc, 'sound/items/penclick.ogg', 50, 1)

/*
 * Fountain Pens
 */

/obj/item/pen/fountain
	name = "fountain pen"
	desc = "A traditional fountain pen. Guaranteed never to leak."
	icon_state = "pen_fountain"
	throwforce = 1 //pointy
	colour = "#1c1713" //dark ashy brownish
	var/cursive = FALSE

/obj/item/pen/fountain/attack_self(var/mob/user)
	playsound(loc, 'sound/items/penclick.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You snap the nib into position to write [cursive ? "normally" : "in cursive"]."))
	cursive = !cursive

/*
 * PDA Fountain Pens
 */
/obj/item/pen/fountain/black
	desc = "It's an expensive Sleek Black fountain pen. Guaranteed never to leak."
	icon_state = "pen_fountain-b"

/obj/item/pen/fountain/silver
	desc = "It's an expensive Shiny Silver fountain pen. Guaranteed never to leak."
	icon_state = "pen_fountain-s"

/obj/item/pen/fountain/white
	desc = "It's an expensive Sterile White fountain pen. Guaranteed never to leak."
	icon_state = "pen_fountain-w"

/obj/item/pen/fountain/head
	name = "command fountain pen"
	desc = "It's an expensive Command Navy Blue fountain pen, embellished with silver. Guaranteed never to leak."
	icon_state = "pen_fountain-nb"

/obj/item/pen/fountain/captain
	name = "captain's fountain pen"
	desc = "It's an expensive Command Navy Blue fountain pen, embellished with ornate gold detailing. Guaranteed never to leak."
	icon_state = "pen_fountain-nbc"

/*
 * Reagent pens
 */

/obj/item/pen/reagent
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
/obj/item/pen/reagent/Initialize()
	. = ..()
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
	reagents_to_add = list(/decl/reagent/polysomnine = 22)


/*
 * Parapens
 */
/obj/item/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	reagents_to_add = list(/decl/reagent/toxin/dextrotoxin = 10)

/obj/item/pen/reagent/healing
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	reagents_to_add = list(/decl/reagent/tricordrazine = 10, /decl/reagent/dermaline = 5, /decl/reagent/bicaridine = 5)
	icon_state = "pen_green"
	colour = "green"

/obj/item/pen/reagent/pacifier
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	reagents_to_add = list(/decl/reagent/wulumunusha = 2, /decl/reagent/pacifier = 15, /decl/reagent/cryptobiolin = 10)
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/reagent/hyperzine
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	reagents_to_add = list(/decl/reagent/hyperzine = 10)
	icon_state = "pen_yellow"
	colour = "yellow"

/obj/item/pen/reagent/poison
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	reagents_to_add = list(/decl/reagent/toxin/cyanide = 1, /decl/reagent/lexorin = 20)
	icon_state = "pen_red"
	colour = "red"

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
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	reagents_to_add = list(/decl/reagent/crayon_dust = 10)

/obj/item/pen/crayon/Initialize()
	. = ..()
	name = "[colourName] crayon"
