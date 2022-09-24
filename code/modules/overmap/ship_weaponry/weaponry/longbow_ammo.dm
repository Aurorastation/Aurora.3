/obj/item/ship_ammunition/longbow
	name = "longbow casing"
	desc = "The Longbow's bread and butter. When loaded, this thing can pack an extreme punch."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "generic_casing"
	item_state = "generic_casing_obj"
	caliber = SHIP_CALIBER_406MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	var/obj/item/primer/primer
	var/obj/item/warhead/warhead

/obj/item/ship_ammunition/longbow/attackby(obj/item/I, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(I, /obj/item/primer) && !primer)
			var/obj/item/primer/P = I
			visible_message(SPAN_NOTICE("You start connecting \the [P] to the casing..."), SPAN_NOTICE("[H] starts connecting \the [P] to the casing..."))
			if(do_after(H, 3 SECONDS))
				visible_message(SPAN_NOTICE("You connect \the [P] to the casing!"), SPAN_NOTICE("[H] connects \the [P] to the casing!"))
				H.drop_from_inventory(P)
				add_primer(P)
		if(istype(I, /obj/item/warhead) && !warhead)
			var/obj/item/warhead/W = I
			visible_message(SPAN_NOTICE("You start connecting \the [W] to the casing..."), SPAN_NOTICE("[H] starts connecting \the [W] to the casing..."))
			if(do_after(H, 5 SECONDS))
				visible_message(SPAN_NOTICE("You connect \the [W] to the casing!"), SPAN_NOTICE("[H] connects \the [W] to the casing!"))
				H.drop_from_inventory(W)
				add_warhead(W)
	update_status()

/obj/item/ship_ammunition/longbow/can_be_loaded()
	if(primer && warhead)
		return TRUE
	return FALSE

/obj/item/ship_ammunition/longbow/proc/add_primer(var/obj/item/primer/P)
	if(P && !QDELETED(P))
		primer = P
		P.forceMove(src)
		var/image/OL = image(P.icon, P.primer_state, layer = layer - 0.01)
		add_overlay(OL)

/obj/item/ship_ammunition/longbow/proc/add_warhead(var/obj/item/warhead/W)
	if(W && !QDELETED(W))
		warhead = W
		W.forceMove(src)
		add_overlay(W.warhead_state)

/obj/item/ship_ammunition/longbow/update_status()
	desc = initial(desc)
	if(primer && !warhead)
		desc += "It is loaded with [primer], but no warhead."
		name = "longbow casing"
	else if(warhead && !primer)
		desc += "It has a [warhead], but no primer."
		name = "longbow casing"
	else if(warhead && primer)
		desc += "It has a [warhead] and is loaded with [primer]! It's ready to go."
		name = "longbow shell"
	else
		desc += "It isn't loaded with a warhead and has no primer."

/obj/item/ship_ammunition/longbow/get_speed()
	return primer ? primer.speed : 0

/obj/item/primer
	name = "primer"
	desc = "This is a medium power primer for Longbow warheads."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "primer_med_obj"
	var/primer_state = "primer_med" //This is the overlay state when it gets applied to the projectile.
	var/speed = 30 //Somewhat of a misleading name. This is the lag in world ticks between each walk() called by the overmap projectile. Lower is better.

/obj/item/primer/low
	name = "low power primer"
	desc = "This is a low power primer for Longbow warheads."
	icon_state = "primer_low_obj"
	primer_state = "primer_low"
	speed = 40

/obj/item/primer/high
	name = "high power primer"
	desc = "This is a high power primer for Longbow warheads."
	icon_state = "primer_high_obj"
	primer_state = "primer_high"
	speed = 20

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
	desc = "A high-explosive warhead for the Longbow cannon. It packs a stronger punch than all the others, but does not penetrate through the hull on initial contact. <span class='danger'>Don't drop it!</span>"
	icon_state = "high_ex_obj"
	warhead_state = "high_ex"
	caliber = SHIP_CALIBER_406MM
	warhead_type = SHIP_AMMO_IMPACT_HE

/obj/item/warhead/longbow/ap
	name = "longbow armor-piercing warhead"
	desc = "An armor-piercing warhead for the Longbow cannon. It penetrates through the hull and then explodes inside the target, albeit at the cost of less explosive power. <span class='danger'>Don't drop it!</span>"
	icon_state = "armor_piercing_obj"
	warhead_state = "armor_piercing"
	warhead_type = SHIP_AMMO_IMPACT_AP

/obj/item/warhead/longbow/bunker
	name = "longbow bunker-buster warhead"
	desc = "A bunker-buster warhead for the Longbow cannon. This will pierce straight through anything, but won't explode! <span class='danger'>Don't drop it!</span>"
	icon_state = "bunker_buster_obj"
	warhead_state = "bunker_buster"
	warhead_type = SHIP_AMMO_IMPACT_BUNKERBUSTER

/obj/item/ship_ammunition/longbow/preset_he/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/W = new()
	add_warhead(W)
	update_status()

/obj/item/ship_ammunition/longbow/preset_ap/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/ap/W = new()
	add_warhead(W)
	update_status()

/obj/item/ship_ammunition/longbow/preset_bb/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/bunker/W = new()
	add_warhead(W)
	update_status()