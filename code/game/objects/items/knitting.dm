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
		add_overlay("[ball.icon_state]")
	else
		cut_overlays()

/obj/item/knittingneedles/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/yarn))
		if(!ball)
			user.unEquip(O)
			O.forceMove(src)
			ball = O
			to_chat(user, "<span class='notice'>You place \the [O] in \the [src]</span>")
			update_icon()

/obj/item/knittingneedles/attack_self(mob/user as mob)
	if(!ball) //if there is no yarn ball, nothing happens
		to_chat(user, "<span class='warning'>You need a yarn ball to stitch.</span>")
		return

	if(working)
		to_chat(user, "<span class='warning'>You are already sitching something.</span>")
		return

	user.visible_message("<span class='notice'>\The [user] is knitting something soft and cozy.</span>")
	working = TRUE
	update_icon()

	if(!do_after(user,2 MINUTES))
		to_chat(user, "<span class='warning'>Your concentration is broken!</span>")
		working = FALSE
		update_icon()
		return

	var/obj/item/clothing/accessory/sweater/S = new(get_turf(user))
	S.color = ball.color
	qdel(ball)
	ball = null
	working = FALSE
	update_icon()
	to_chat(user, "<span class='warning'>You finish \the [S]!</span>")

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