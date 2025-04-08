/obj/effect/decal/cleanable/draftingchalk
	name = "chalk marking"
	desc = "A line drawn in chalk."
	icon = 'icons/obj/smooth/chalkline-smooth.dmi'
	icon_state = "preview"
	color = "#FFFFFF"
	anchored = TRUE
	smoothing_flags = SMOOTH_TRUE

/obj/effect/decal/cleanable/draftingchalk/Initialize(mapload)
	. = ..()
	if (mapload)
		QUEUE_SMOOTH(src)
	else
		smooth_icon()
		for (var/obj/effect/decal/cleanable/draftingchalk/C in orange(1, src))
			C.smooth_icon()

/obj/item/pen/drafting
	name = "white drafting chalk"
	desc = "A piece of white chalk for marking areas of floor."
	icon = 'icons/obj/storage/fancy/crayon.dmi'
	icon_state = "dchalk"
	color = "#FFFFFF"
	var/colorName = "whitec"

/obj/item/pen/drafting/attack_self(var/mob/user)
	return

/obj/item/pen/drafting/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/originaloc = user.loc
		var/drawtype = input("Choose what you'd like to draw.", "Chalk scribbles") in list("line","graffiti","rune","letter","arrow")
		C.color = color
		if (user.loc != originaloc)
			to_chat(user, SPAN_NOTICE("You moved!"))
			return

		switch(drawtype)
			if("line")
				for (var/obj/effect/decal/cleanable/draftingchalk/C in target)
					qdel(C)
				var/obj/effect/decal/cleanable/draftingchalk/C = new(target)
					if (!do_after(user, 1 SECONDS, target))
						return
				to_chat(user, "You mark a line on [target].")
				target.add_fingerprint(user)
				return
			if("letter")
				drawtype = input("Choose the letter.", "Chalk scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Chalk scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,color,color,drawtype,"chalk")
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the chalk is drawn on.
	return

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

/obj/item/storage/box/fancy/crayons/chalkbox
	name = "box of drafting chalk"
	desc = "A box of drafting chalk for drafting floor plans."
	icon_state = "chalkbox"
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/drafting
	)

/obj/item/storage/box/fancy/crayons/chalkbox/fill()
	new /obj/item/pen/drafting/red(src)
	new /obj/item/pen/drafting(src)
	new /obj/item/pen/drafting/yellow(src)
	new /obj/item/pen/drafting/green(src)
	new /obj/item/pen/drafting/blue(src)
	new /obj/item/pen/drafting/purple(src)
	update_icon()

/obj/item/storage/box/fancy/crayons/chalkbox/update_icon()
	ClearOverlays()
	for(var/obj/item/pen/drafting/chalk in contents)
		AddOverlays("[chalk.colorName]")
