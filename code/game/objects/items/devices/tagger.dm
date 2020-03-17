

/obj/item/device/animaltagger
	name = "animal tagger"
	desc = "Used for tagging animals to be identified by a ear tag."
	icon_state = "animal_tagger0"
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	var/animaltag = null

	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 1)


/obj/item/device/animaltagger/Destroy()
	return ..()


/obj/item/device/animaltagger/attack()
	return

/obj/item/device/animaltagger/afterattack(atom/A as mob|obj, mob/user as mob)

	if(isanimal(A))
		A.name = animaltag
		to_chat(user,"<span class='notice'>You tag the animal as [animaltag].</span>")

	else
		to_chat(user, "<span class='notice'>You can't tag non animals.</span>")
		return

/obj/item/device/animaltagger/attack_self(mob/user as mob)

	var/inputtag = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
	if(!inputtag || !length(inputtag))
		to_chat(user, "<span class='notice'>Invalid tag line.</span>")
		return
	animaltag = inputtag
