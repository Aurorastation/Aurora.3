/obj/item/ship_ammunition/longbow
	name = "longbow casing"
	desc = "The Longbow's bread and butter. When loaded, this thing can pack an extreme punch."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "generic_casing"
	item_state = "generic_casing_obj"
	var/obj/item/primer/primer
	var/obj/item/warhead/warhead

/obj/item/ship_ammunition/longbow/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/primer) && !primer)
		var/obj/item/primer/P = I
		visible_message(SPAN_NOTICE("You start connecting \the [P] to the casing..."), SPAN_NOTICE("[user] starts connecting \the [P] to the casing..."))
		if(do_after(user, 3 SECONDS))
			visible_message(SPAN_NOTICE("You connect \the [P] to the casing!"), SPAN_NOTICE("[user] connects \the [P] to the casing!"))
			primer = P
			P.forceMove(src)
			var/image/OL = image(P.icon, P.primer_state, layer = layer - 0.01)
			add_overlay(OL)
	if(istype(I, /obj/item/warhead) && !warhead)
		var/obj/item/warhead/W = I
		visible_message(SPAN_NOTICE("You start connecting \the [W] to the casing..."), SPAN_NOTICE("[user] starts connecting \the [W] to the casing..."))
		if(do_after(user, 5 SECONDS))
			visible_message(SPAN_NOTICE("You connect \the [W] to the casing!"), SPAN_NOTICE("[user] connects \the [W] to the casing!"))
			warhead = W
			W.forceMove(src)
			add_overlay(W.warhead_state)
	update_status()

/obj/item/ship_ammunition/longbow/update_status()
	desc = initial(desc)
	if(primer && !warhead)
		desc += "It is loaded with [primer], but no warhead."
	else if(warhead && !primer)
		desc += "It has a [warhead], but no primer."
	else if(warhead && primer)
		desc += "It has a [warhead] and is loaded with [primer]! It's ready to go."
	else
		desc += "It isn't loaded with a warhead and has no primer."

/obj/item/primer
	name = "primer"
	desc = "This is a medium power primer for Longbow warheads."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "primer_med_obj"
	var/primer_state = "primer_med" //This is the overlay state when it gets applied to the projectile.
	var/speed = 2

/obj/item/primer/low
	name = "low power primer"
	desc = "This is a low power primer for Longbow warheads."
	icon_state = "primer_low_obj"
	primer_state = "primer_low"
	speed = 1

/obj/item/primer/high
	name = "high power primer"
	desc = "This is a high power primer for Longbow warheads."
	icon_state = "primer_high_obj"
	primer_state = "primer_high"
	speed = 3

/obj/item/warhead
	name = "warhead"
	desc = "This is a generic warhead. Not for use."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "generic_warhead_obj"
	var/warhead_state = "generic_warhead" //This is the overlay state when it gets applied to the projectile.
	var/caliber
	var/warhead_type

/obj/item/warhead/longbow
	name = "longbow high-explosive warhead"
	desc = "A high-explosive warhead for the Longbow cannon. <span class='danger'>Don't drop it!</span>"
	icon_state = "high_ex_obj"
	warhead_state = "high_ex"
	caliber = SHIP_CALIBER_406MM
	warhead_type = SHIP_AMMO_IMPACT_HE

/obj/item/warhead/longbow/ap
	name = "longbow armor-piercing warhead"
	desc = "An armor-piercing warhead for the Longbow cannon. <span class='danger'>Don't drop it!</span>"
	icon_state = "armor_piercing_obj"
	warhead_state = "armor_piercing"
	warhead_type = SHIP_AMMO_IMPACT_AP

/obj/item/warhead/longbow/bunker
	name = "longbow bunker-buster warhead"
	desc = "A bunker-buster warhead for the Longbow cannon. <span class='danger'>Don't drop it!</span>"
	icon_state = "bunker_buster_obj"
	warhead_state = "bunker_buster"
	warhead_type = SHIP_AMMO_IMPACT_BUNKERBUSTER