/obj/effect/decal/cleanable/draftingchalk
	name = "chalk marking"
	desc = "A line drawn in chalk."
	icon = 'icons/obj/smooth/chalkline-smooth.dmi'
	icon_state = "preview"
	color = "#FFFFFF"
	layer = 2.1
	anchored = TRUE
	smooth = SMOOTH_TRUE

/obj/effect/decal/cleanable/draftingchalk/Initialize(mapload)
	. = ..()
	if (mapload)
		queue_smooth(src)
	else
		smooth_icon(src)
		for (var/obj/effect/decal/cleanable/draftingchalk/C in orange(1, src))
			smooth_icon(C)

/obj/item/pen/drafting
	name = "white drafting chalk"
	desc = "A piece of white chalk for marking areas of floor."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "dchalk"
	color = "#FFFFFF"
	var/colorName = "whitec"

/obj/item/pen/drafting/attack_self(var/mob/user)
	return

/obj/item/pen/drafting/afterattack(turf/target, mob/user, proximity)
	if (!proximity || !istype(target, /turf/simulated) || target.density || target.is_hole)
		return

	to_chat(user, "You start marking a line on [target].")

	if (!do_after(user, 1 SECONDS, act_target = target))
		return

	for (var/obj/effect/decal/cleanable/draftingchalk/C in target)
		qdel(C)

	to_chat(user, "You mark a line on [target].")

	var/obj/effect/decal/cleanable/draftingchalk/C = new(target)
	C.color = color
	target.add_fingerprint(user)

/obj/item/pen/drafting/red
	name = "red drafting chalk"
	desc = "A piece of red chalk for marking areas of floor."
	color = "#E75344"
	colorName = "redc"

/obj/effect/decal/cleanable/draftingchalk/red
	desc = "A line drawn in a red chalk."
	color = "#E75344"

/obj/item/pen/drafting/yellow
	name = "yellow drafting chalk"
	desc = "A piece of yellow chalk for marking areas of floor."
	color = "#E1CB47"
	colorName = "yellowc"

/obj/effect/decal/cleanable/draftingchalk/yellow
	desc = "A line drawn in a yellow chalk."
	color = "#E1CB47"

/obj/item/pen/drafting/green
	name = "green drafting chalk"
	desc = "A piece of yellow chalk for marking areas of floor."
	color = "#6CD48F"
	colorName = "green"

/obj/effect/decal/cleanable/draftingchalk/green
	desc = "A line drawn in a green chalk."
	color = "#6CD48F"

/obj/item/pen/drafting/blue
	name = "blue drafting chalk"
	desc = "A piece of blue chalk for marking areas of floor."
	color = "#9FC8F7"
	colorName = "bluec"

/obj/effect/decal/cleanable/draftingchalk/blue
	desc = "A line drawn in a blue chalk."
	color = "#9FC8F7"

/obj/item/pen/drafting/purple
	name = "purple drafting chalk"
	desc = "A piece of purple chalk for marking areas of floor."
	color = "#a489c2"
	colorName = "purplec"

/obj/effect/decal/cleanable/draftingchalk/purple
	desc = "A line drawn in a purple chalk."
	color = "#a489c2"

/obj/item/storage/fancy/crayons/chalkbox
	name = "box of drafting chalk"
	desc = "A box of drafting chalk for drafting floor plans."
	icon_state = "chalkbox"
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/drafting
	)

/obj/item/storage/fancy/crayons/chalkbox/fill()
	new /obj/item/pen/drafting/red(src)
	new /obj/item/pen/drafting(src)
	new /obj/item/pen/drafting/yellow(src)
	new /obj/item/pen/drafting/green(src)
	new /obj/item/pen/drafting/blue(src)
	new /obj/item/pen/drafting/purple(src)
	update_icon()

/obj/item/storage/fancy/crayons/chalkbox/update_icon()
	cut_overlays()
	for(var/obj/item/pen/drafting/chalk in contents)
		add_overlay("[chalk.colorName]")