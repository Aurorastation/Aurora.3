/obj/item/ship_ammunition/longbow
	name = "longbow casing"
	desc = "The Longbow's bread and butter. When loaded, this thing can pack an extreme punch."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "generic_casing"
	item_state = "generic_casing_obj"
	caliber = SHIP_CALIBER_406MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	var/obj/item/primer/primer
	var/obj/item/warhead/longbow/warhead

/obj/item/ship_ammunition/longbow/attackby(obj/item/attacking_item, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(attacking_item, /obj/item/primer) && !primer)
			var/obj/item/primer/P = attacking_item
			user.visible_message(SPAN_NOTICE("[H] starts connecting \the [P] to the casing..."), SPAN_NOTICE("You start connecting \the [P] to the casing..."))
			if(do_after(H, 3 SECONDS))
				visible_message(SPAN_NOTICE("You connect \the [P] to the casing!"), SPAN_NOTICE("[H] connects \the [P] to the casing!"))
				H.drop_from_inventory(P)
				add_primer(P)
				playsound(src, 'sound/machines/rig/rig_deploy.ogg', 40)
		if(istype(attacking_item, /obj/item/warhead) && !warhead)
			var/obj/item/warhead/W = attacking_item
			user.visible_message( SPAN_NOTICE("[H] starts connecting \the [W] to the casing..."), SPAN_NOTICE("You start connecting \the [W] to the casing..."))
			if(do_after(H, 5 SECONDS))
				visible_message(SPAN_NOTICE("You connect \the [W] to the casing!"), SPAN_NOTICE("[H] connects \the [W] to the casing!"))
				H.drop_from_inventory(W)
				add_warhead(W)
				playsound(src, 'sound/machines/rig/rig_deploy.ogg', 40)
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
	update_status()

/obj/item/ship_ammunition/longbow/proc/add_warhead(var/obj/item/warhead/W)
	if(W && !QDELETED(W))
		warhead = W
		W.forceMove(src)
		add_overlay(W.warhead_state)
		impact_type = W.warhead_type
		ammunition_flags = initial(ammunition_flags)
		ammunition_flags |= SHIP_AMMO_FLAG_VERY_FRAGILE
		ammunition_flags |= SHIP_AMMO_FLAG_INFLAMMABLE
		cookoff_devastation = warhead.cookoff_devastation
		cookoff_heavy = warhead.cookoff_heavy
		cookoff_light = warhead.cookoff_light
	update_status()

/obj/item/ship_ammunition/longbow/update_status()
	desc = initial(desc)
	desc += "<br>"
	if(primer && !warhead)
		desc += "It is loaded with [primer], but no warhead."
		name = "longbow casing"
		ammunition_flags = initial(ammunition_flags)
	else if(warhead && !primer)
		desc += "It has a [warhead], but no primer."
		name = "[warhead.warhead_type] longbow casing"
	else if(warhead && primer)
		desc += "It has a [warhead] and is loaded with [primer]! It's ready to go."
		name = "[warhead.warhead_type] longbow shell"
	else
		name = "longbow casing"
		desc += "It isn't loaded with a warhead and has no primer."
		ammunition_flags = initial(ammunition_flags)

/obj/item/ship_ammunition/longbow/get_speed()
	return primer ? primer.speed : 0

/obj/item/ship_ammunition/longbow/throw_fail_consequences(var/mob/living/carbon/C)
	. = ..()
	if(warhead)
		if(prob(75))
			visible_message(SPAN_DANGER("\The [src] goes off!"))
			warhead.cookoff()
			qdel(src)

/obj/item/primer
	name = "primer"
	desc = "This is a medium power primer for Longbow warheads."
	icon = 'icons/obj/guns/ship/ship_ammo_longarm.dmi'
	icon_state = "primer_med_obj"
	w_class = ITEMSIZE_HUGE
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
	w_class = ITEMSIZE_HUGE
	var/warhead_state = "generic_warhead" //This is the overlay state when it gets applied to the projectile.
	var/caliber
	var/warhead_type

/obj/item/warhead/longbow
	name = "longbow high-explosive warhead"
	desc = "A high-explosive warhead for the Longbow cannon. It packs a stronger punch than all the others, but does not penetrate through the hull on initial contact. <span class='danger'>Handle with care!</span>"
	icon_state = "high_ex_obj"
	warhead_state = "high_ex"
	caliber = SHIP_CALIBER_406MM
	warhead_type = SHIP_AMMO_IMPACT_HE
	slowdown = 2
	var/drop_counter = 0
	var/cookoff_devastation = 0
	var/cookoff_heavy = 3
	var/cookoff_light = 4

/obj/item/warhead/longbow/too_heavy_to_throw()
	return TRUE

/obj/item/warhead/longbow/throw_impact(atom/hit_atom)
	. = ..()
	if(prob(10))
		cookoff(FALSE)

/obj/item/warhead/longbow/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(P.damage > 5)
		cookoff(TRUE)

/obj/item/warhead/longbow/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(istype(attacking_item, /obj/item/mecha_equipment/clamp)) //loading a warhead into a mech shouldn't explode it
		return
	if(attacking_item.force > 10 && user.a_intent == I_HURT) //presumably you need to hit it pretty hard to actually set the thing off
		cookoff(FALSE)

/obj/item/warhead/longbow/ex_act(severity)
	cookoff(TRUE)

/obj/item/warhead/longbow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= T0C+200)
		cookoff(TRUE)

/obj/item/warhead/longbow/proc/cookoff(var/caused_by_heat = TRUE)
	visible_message(SPAN_DANGER("\The [src] [caused_by_heat ? "cooks" : "goes"] off and explodes!"))
	explosion(get_turf(src), cookoff_devastation, cookoff_heavy, cookoff_light)
	qdel(src)

/obj/item/warhead/longbow/ap
	name = "longbow armor-piercing warhead"
	desc = "An armor-piercing warhead for the Longbow cannon. It penetrates through the hull and then explodes inside the target, albeit at the cost of less explosive power. <span class='danger'>Handle with care!</span>"
	icon_state = "armor_piercing_obj"
	warhead_state = "armor_piercing"
	warhead_type = SHIP_AMMO_IMPACT_AP
	cookoff_devastation = 0
	cookoff_heavy = 2
	cookoff_light = 6

/obj/item/warhead/longbow/bunker
	name = "longbow bunker-buster warhead"
	desc = "A bunker-buster warhead for the Longbow cannon. This will pierce straight through anything, but won't explode! <span class='danger'>Handle with care!</span>"
	icon_state = "bunker_buster_obj"
	warhead_state = "bunker_buster"
	warhead_type = SHIP_AMMO_IMPACT_BUNKERBUSTER
	cookoff_devastation = 0
	cookoff_heavy = 1
	cookoff_light = 4

/obj/item/ship_ammunition/longbow/preset_he/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/W = new()
	add_warhead(W)

/obj/item/ship_ammunition/longbow/preset_ap/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/ap/W = new()
	add_warhead(W)

/obj/item/ship_ammunition/longbow/preset_bb/Initialize()
	. = ..()
	var/obj/item/primer/P = new()
	add_primer(P)
	var/obj/item/warhead/longbow/bunker/W = new()
	add_warhead(W)
