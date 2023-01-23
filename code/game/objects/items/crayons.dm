/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"
	reagents_to_add = list(/decl/reagent/crayon_dust/red = 10)

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"
	reagents_to_add = list(/decl/reagent/crayon_dust/orange = 10)

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"
	reagents_to_add = list(/decl/reagent/crayon_dust/yellow = 10)

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"
	reagents_to_add = list(/decl/reagent/crayon_dust/green = 10)

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"
	reagents_to_add = list(/decl/reagent/crayon_dust/blue = 10)

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"
	reagents_to_add = list(/decl/reagent/crayon_dust/purple = 10)

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	reagents_to_add = list(/decl/reagent/crayon_dust/grey = 15)

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
	reagents_to_add = list(/decl/reagent/crayon_dust/brown = 20)

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
	cut_overlays()
	var/image/crayon_tip = image('icons/obj/crayons.dmi', "crayonaugment_tip")
	crayon_tip.color = colour
	add_overlay(crayon_tip)

/obj/item/pen/crayon/augment/throw_at(atom/target, range, speed, mob/user)
	user.drop_from_inventory(src)

/obj/item/pen/crayon/augment/dropped()
	loc = null
	qdel(src)

/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/originaloc = user.loc
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		if (user.loc != originaloc)
			to_chat(user, "<span class='notice'>You moved!</span>")
			return

		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(reagents && LAZYLEN(reagents_to_add))
				for(var/decl/reagent/R in reagents_to_add)
					reagents.remove_reagent(R,0.5/LAZYLEN(reagents_to_add)) //using crayons reduces crayon dust in it.
				if(!reagents.has_all_reagents(reagents_to_add))
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/user, var/target_zone)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.check_has_mouth())
			user.visible_message("<span class='notice'>[user] takes a bite of their crayon and swallows it.</span>", "<span class='notice'>You take a bite of your crayon and swallow it.</span>")
			user.adjustNutritionLoss(-1)
			reagents.trans_to_mob(user, 2, CHEM_INGEST)
			if(reagents.total_volume <= 0)
				user.visible_message("<span class='notice'>[user] finished their crayon!</span>", "<span class='warning'>You ate your crayon!</span>")
				qdel(src)
				return TRUE
	else
		..(user, target_zone)

/obj/item/pen/crayon/attack_self(var/mob/user)
	return
