/obj/item/knittingneedles
	name = "knitting needles"
	desc = "Silver knitting needles used for stitching yarn."
	icon = 'icons/obj/contained_items/tools/knitting.dmi'
	icon_state = "knittingneedles"
	item_state = "knittingneedles"
	w_class = ITEMSIZE_SMALL
	contained_sprite = TRUE
	var/working = FALSE
	var/obj/item/yarn/ball
	var/static/list/knitables = list(/obj/item/clothing/accessory/sweater, /obj/item/clothing/suit/storage/toggle/cardigan, /obj/item/clothing/suit/storage/toggle/cardigan/sweater, /obj/item/clothing/suit/storage/toggle/cardigan/argyle, /obj/item/clothing/accessory/sweater_vest, /obj/item/clothing/accessory/sweater/turtleneck, /obj/item/clothing/gloves/fingerless/colour/knitted, /obj/item/clothing/gloves/knitted, /obj/item/clothing/accessory/bandanna/colorable/knitted, /obj/item/clothing/accessory/scarf)
	var/static/list/name2knit

/obj/item/knittingneedles/verb/remove_yarn()
	set name = "Remove Yarn"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(!ball)
		to_chat(usr, SPAN_WARNING("There is no yarn on \the [src]!"))
		return

	if(working)
		to_chat(usr, SPAN_WARNING("You can't remove \the [ball] while using \the [src]!"))
		return

	var/mob/living/carbon/human/H = usr

	H.put_in_hands(ball)
	ball = null
	to_chat(usr, SPAN_NOTICE("You remove \the [ball] from \the [src]."))
	update_icon()

/obj/item/knittingneedles/Destroy()
	if(ball)
		QDEL_NULL(ball)
	return ..()

/obj/item/knittingneedles/examine(mob/user)
	if(..(user, 1))
		if(ball)
			to_chat(user, "There is \the [ball] between the needles.")

/obj/item/knittingneedles/update_icon()
	if(working)
		icon_state = "knittingneedles_on"
		item_state = "knittingneedles_on"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

	if(ball)
		var/mutable_appearance/yarn_overlay = mutable_appearance(icon, "[ball.icon_state]")
		if(ball.color)
			yarn_overlay.color = ball.color
		else
			yarn_overlay.appearance_flags = RESET_COLOR
		add_overlay(yarn_overlay)
	else
		cut_overlays()
	update_held_icon()

/obj/item/knittingneedles/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/yarn))
		if(!ball)
			user.unEquip(O)
			O.forceMove(src)
			ball = O
			to_chat(user, SPAN_NOTICE("You place \the [O] in \the [src]"))
			update_icon()
		return TRUE

/obj/item/knittingneedles/attack_self(mob/user as mob)
	if(!ball) //if there is no yarn ball, nothing happens
		to_chat(user, SPAN_WARNING("You need a yarn ball to stitch."))
		return

	if(working)
		to_chat(user, SPAN_WARNING("You are already sitching something."))
		return

	if (!name2knit)
		name2knit = list()
		for(var/obj/thing as anything in knitables)
			name2knit[initial(thing.name)] = thing

	var/list/options = list()
	for (var/obj/item/clothing/i as anything in knitables)
		var/image/radial_button = image(icon = initial(i.icon), icon_state = initial(i.icon_state))
		options[initial(i.name)] = radial_button
	var/knit_name = show_radial_menu(user, user, options, radius = 42, tooltips = TRUE)
	if(!knit_name)
		return
	var/type_path = name2knit[knit_name]

	user.visible_message("<b>[user]</b> begins knitting something soft and cozy.")
	working = TRUE
	update_icon()

	if(!do_after(user,2 MINUTES))
		to_chat(user, SPAN_WARNING("Your concentration is broken!"))
		working = FALSE
		update_icon()
		return

	var/obj/item/clothing/S = new type_path(get_turf(user))
	user.put_in_hands(S)
	S.color = ball.color
	qdel(ball)
	ball = null
	working = FALSE
	update_icon()
	user.visible_message("<b>[user]</b> finishes working on \the [S].")

/obj/item/yarn
	name = "ball of yarn"
	desc = "A ball of yarn, this one is white."
	icon = 'icons/obj/contained_items/tools/knitting.dmi'
	icon_state = "white_ball"
	w_class = ITEMSIZE_TINY

/obj/item/yarn/red
	desc = "A ball of yarn, this one is red."
	color = "#ff0000"

/obj/item/yarn/blue
	desc = "A ball of yarn, this one is blue."
	color = "#0000FF"

/obj/item/yarn/green
	desc = "A ball of yarn, this one is green."
	color = "#00ff00"

/obj/item/yarn/purple
	desc = "A ball of yarn, this one is purple."
	color = "#800080"

/obj/item/yarn/yellow
	desc = "A ball of yarn, this one is yellow."
	color = "#FFFF00"

/obj/item/storage/box/knitting //a bunch of things, so it goes into the box
	name = "knitting supplies"

/obj/item/storage/box/knitting/fill()
	..()
	new /obj/item/knittingneedles(src)
	new /obj/item/yarn(src)
	new /obj/item/yarn/red(src)
	new /obj/item/yarn/blue(src)
	new /obj/item/yarn/green(src)
	new /obj/item/yarn/purple(src)
	new /obj/item/yarn/yellow(src)

/obj/item/storage/box/yarn
	name = "yarn box"

/obj/item/storage/box/yarn/fill()
	..()
	new /obj/item/yarn(src)
	new /obj/item/yarn/red(src)
	new /obj/item/yarn/blue(src)
	new /obj/item/yarn/green(src)
	new /obj/item/yarn/purple(src)
	new /obj/item/yarn/yellow(src)
