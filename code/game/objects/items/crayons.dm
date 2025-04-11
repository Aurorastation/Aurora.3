/obj/item/pen/drafting
	name = "white drafting chalk"
	desc = "A piece of white chalk for marking areas of floor."
	icon = 'icons/obj/storage/fancy/crayon.dmi'
	icon_state = "dchalk"
	colour = "#FFFFFF"
	shadeColour = "#EFEFEF"
	var/colourName = "whitec"
	medium = "chalk"

/obj/item/pen/drafting/red
	name = "red drafting chalk"
	desc = "A piece of red chalk for marking areas of floor."
	colour = "#E75344"
	shadeColour = "#D74334"
	colourName = "redc"

/obj/effect/decal/cleanable/draftingchalk/red
	desc = "A line drawn in a red chalk."
	colour = "#E75344"
	shadeColour = "#D74334"

/obj/item/pen/drafting/yellow
	name = "yellow drafting chalk"
	desc = "A piece of yellow chalk for marking areas of floor."
	colour = "#E1CB47"
	shadeColour = "#D1BB37"
	colourName = "yellowc"

/obj/effect/decal/cleanable/draftingchalk/yellow
	desc = "A line drawn in a yellow chalk."
	colour = "#E1CB47"
	shadeColour = "#D1BB37"

/obj/item/pen/drafting/green
	name = "green drafting chalk"
	desc = "A piece of yellow chalk for marking areas of floor."
	colour = "#6CD48F"
	shadeColour = "#5CC47F"
	colourName = "green"

/obj/effect/decal/cleanable/draftingchalk/green
	desc = "A line drawn in a green chalk."
	colour = "#6CD48F"
	shadeColour = "#5CC47F"

/obj/item/pen/drafting/blue
	name = "blue drafting chalk"
	desc = "A piece of blue chalk for marking areas of floor."
	colour = "#9FC8F7"
	shadeColour = "#8FB8E7"
	colourName = "bluec"

/obj/effect/decal/cleanable/draftingchalk/blue
	desc = "A line drawn in a blue chalk."
	colour = "#9FC8F7"
	shadeColour = "#8FB8E7"

/obj/item/pen/drafting/purple
	name = "purple drafting chalk"
	desc = "A piece of purple chalk for marking areas of floor."
	colour = "#a489c2"
	shadeColour = "#9479b2"
	colourName = "purplec"

/obj/effect/decal/cleanable/draftingchalk/purple
	desc = "A line drawn in a purple chalk."
	colour = "#a489c2"
	shadeColour = "#9479b2"

/obj/item/storage/box/fancy/drafting/chalkbox
	name = "box of drafting chalk"
	desc = "A box of drafting chalk for drafting floor plans."
	icon_state = "chalkbox"
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/drafting
	)

/obj/item/storage/box/fancy/drafting/chalkbox/fill()
	new /obj/item/pen/drafting/red(src)
	new /obj/item/pen/drafting(src)
	new /obj/item/pen/drafting/yellow(src)
	new /obj/item/pen/drafting/green(src)
	new /obj/item/pen/drafting/blue(src)
	new /obj/item/pen/drafting/purple(src)
	update_icon()

/obj/item/storage/box/fancy/drafting/chalkbox/update_icon()
	ClearOverlays()
	for(var/obj/item/pen/drafting/chalk in contents)
		AddOverlays("[chalk.colourName]")

/obj/item/pen/crayon
	icon = 'icons/obj/storage/fancy/crayon.dmi'
	medium = "crayon"

/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"
	reagents_to_add = list(/singleton/reagent/crayon_dust/red = 10)

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"
	reagents_to_add = list(/singleton/reagent/crayon_dust/orange = 10)

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"
	reagents_to_add = list(/singleton/reagent/crayon_dust/yellow = 10)

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"
	reagents_to_add = list(/singleton/reagent/crayon_dust/green = 10)

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"
	reagents_to_add = list(/singleton/reagent/crayon_dust/blue = 10)

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"
	reagents_to_add = list(/singleton/reagent/crayon_dust/purple = 10)

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	reagents_to_add = list(/singleton/reagent/crayon_dust/grey = 15)

/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	reagents_to_add = list(/singleton/reagent/crayon_dust/brown = 20)

/obj/item/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/pen/crayon/augment
	icon_state = "crayonaugment"
	colour = "#FFF200"
	shadeColour = "#886422"
	desc = "A crayon that is integrated into a user's finger. It can synthesize a multitude of colors."

/obj/item/pen/crayon/augment/Initialize()
	. = ..()
	name = "integrated crayon"
	update_icon()

/obj/item/pen/crayon/augment/attack_self(mob/living/user)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
	update_icon()

/obj/item/pen/crayon/augment/update_icon()
	ClearOverlays()
	var/image/crayon_tip = image('icons/obj/crayons.dmi', "crayonaugment_tip")
	crayon_tip.color = colour
	AddOverlays(crayon_tip)

/obj/item/pen/crayon/augment/throw_at(atom/target, range, speed, mob/user)
	user.drop_from_inventory(src)

/obj/item/pen/crayon/augment/dropped()
	. = ..()
	loc = null
	qdel(src)

/obj/item/pen/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/originaloc = user.loc
		var/drawtype = input("Choose what you'd like to draw.", "Scribbles") in list("graffiti","rune","letter","arrow","line")
		if (user.loc != originaloc)
			to_chat(user, SPAN_NOTICE("You moved!"))
			return

		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
			if("line")
				to_chat(user, "You start marking a line on the [target.name].")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/drawing(target,colour,shadeColour,drawtype,medium)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			// Chalk currently doesn't have reagents- now that their logic is merged with crayons, disabling this
			// until chalk also has chalk dust as a reagent. Not exactly balance-breaking, sooo... -Batra
			/*
			if(reagents && LAZYLEN(reagents_to_add))
				for(var/singleton/reagent/R in reagents_to_add)
					reagents.remove_reagent(R,0.5/LAZYLEN(reagents_to_add)) //using crayons reduces crayon dust in it.
				if(!reagents.has_all_reagents(reagents_to_add))
					to_chat(user, SPAN_WARNING("You used up your crayon!"))
					qdel(src)
			*/
	return

/obj/item/pen/crayon/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		if(H.check_has_mouth())
			target_mob.visible_message(SPAN_NOTICE("[target_mob] takes a bite of their crayon and swallows it."),
									SPAN_NOTICE("You take a bite of your crayon and swallow it."))

			target_mob.adjustNutritionLoss(-1)
			reagents.trans_to_mob(target_mob, 2, CHEM_INGEST)
			if(reagents.total_volume <= 0)
				target_mob.visible_message(SPAN_NOTICE("[target_mob] finished their crayon!"), SPAN_WARNING("You ate your crayon!"))
				qdel(src)
				return TRUE
	else
		return ..()

/obj/item/pen/attack_self(var/mob/user)
	return