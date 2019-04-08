/obj/structure/banner
	name = "corporate banner"
	desc = "A blue flag emblazoned with a golden logo of Nanotrasen hanging from a wooden stand."
	anchored = 1
	density = 1
	layer = 9
	var/icon_up = "banner_up"
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner_down"

/obj/structure/banner/verb/toggle()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Banner"

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	if(icon_state == initial(icon_state))
		icon_state = icon_up
		to_chat(usr, "You roll up the cloth.")
	else
		icon_state = initial(icon_state)
		to_chat(usr, "You roll down the cloth.")


	src.update_icon()

/obj/structure/banner/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		switch(anchored)
			if(0)
				anchored = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", "You secure [src.name] to the floor.", "You hear a ratchet")
			if(1)
				anchored = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", "You unsecure [src.name] from the floor.", "You hear a ratchet")
		return

/obj/structure/banner/unmovable

/obj/structure/banner/unmovable/attackby(obj/item/W, mob/user)
	return

//////////////////////////////Cola's cool religious banners/////////////////////////////////////////////////////////


/obj/structure/banner/sunbro
	name = "sun banner"
	desc = "A banner depicting a blazing sun. You feel the urge to praise it."
	icon_state = "sunbro_down"
	icon_up = "sunbro_up" //Thank you for all the help Abby

/obj/structure/banner/anime
	name = "kawaii banner"
	desc = "Just... why what's wrong with you?"
	icon_state = "dankmaymays_down"
	icon_up = "dankmaymays_up"

/obj/structure/banner/christian
	name = "crucifix banner"
	desc = "A banner depicting a crucifix the symbol of christianity."
	icon_state = "crucifix_down"
	icon_up = "crucifix_up"

/obj/structure/banner/jewish
	name = "star of david banner"
	desc = "A banner depicting the star of david the symbol of Judaism."
	icon_state = "starofdavid_down"
	icon_up = "starofdavid_up"

/obj/structure/banner/muslim
	name = "moon and star banner"
	desc = "A banner depicting the moon and star the symbol of Islam."
	icon_state = "moonandstar_down"
	icon_up = "moonandstar_up"

/obj/structure/banner/buddhist
	name = "dharmachakra banner"
	desc = "A banner depicting the Dharmachakra a symbol of Buddhism."
	icon_state = "dharmachakra_down"
	icon_up = "dharmachakra_up"

/obj/structure/banner/hindu
	name = "aum banner"
	desc = "A banner depicting the aum a symbol of Hinduism."
	icon_state = "aum_down"
	icon_up = "aum_up"

/obj/structure/banner/sikh
	name = "khanda banner"
	desc = "A banner depicting the khanda the symbol of sikhism."
	icon_state = "khanda_down"
	icon_up = "khanda_up"

/obj/structure/banner/tengri
	name = "tengri crescent banner"
	desc = "A banner depicting the tengri crescent the symbol of the tengri faith."
	icon_state = "tengricrescent_down"
	icon_up = "tengricrescent_up"

/obj/structure/banner/orthodox
	name = "orthodox cross banner"
	desc = "A banner depicting the orthodox cross the symbol of orthodox christianity."
	icon_state = "orthodoxcross_down"
	icon_up = "orthodoxcross_up"

/obj/structure/banner/knightshospitaller
	name = "knights hospitaller banner"
	desc = "Deus vult. Non nobis domine!"
	icon_state = "hospitallercross_down"
	icon_up = "hospitallercross_up"