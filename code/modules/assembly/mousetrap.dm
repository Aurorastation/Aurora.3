/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "mousetrap"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	var/armed = FALSE

/obj/item/device/assembly/mousetrap/examine(mob/user)
	. = ..()
	if(. && armed)
		to_chat(user, "It looks like it's armed.")

/obj/item/device/assembly/mousetrap/update_icon()
	icon_state = armed ? "mousetraparmed" : "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(var/mob/living/target, var/type = "feet")
	if(!armed || !istype(target))
		return

	var/types = target.find_type()
	if(israt(target))
		var/mob/living/simple_animal/rat/M = target
		audible_message(SPAN_DANGER("SPLAT!"))
		M.splat()
	else
		var/zone = BP_CHEST
		if(ishuman(target) && target.mob_size)
			var/mob/living/carbon/human/H = target
			switch(type)
				if("feet")
					zone = pick(BP_L_FOOT, BP_R_FOOT)
					if(!H.shoes)
						H.apply_effect(400 / (target.mob_size * (target.mob_size * 0.25)), PAIN)//Halloss instead of instant knockdown
						//Mainly for the benefit of giant monsters like vaurca breeders
				if(BP_L_HAND, BP_R_HAND)
					zone = type
					if(!H.gloves)
						H.apply_effect(250 / (target.mob_size * (target.mob_size * 0.25)), PAIN)
		if(!(types & TYPE_SYNTHETIC))
			target.apply_damage(rand(6 , 14), PAIN, def_zone = zone, used_weapon = src)
			target.apply_damage(rand(1 , 3), BRUTE, def_zone = zone, used_weapon = src)

	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	layer = MOB_LAYER - 0.2
	armed = FALSE
	update_icon()
	pulse(FALSE)

/obj/item/device/assembly/mousetrap/attack_self(mob/living/user)
	if(!armed)
		to_chat(user, SPAN_NOTICE("You arm \the [src]."))
	else
		if(clumsy_check(user))
			return
		to_chat(user, SPAN_NOTICE("You disarm \the [src]."))
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)

/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user)
	if(armed && clumsy_check(user))
		return
	return ..()

/obj/item/device/assembly/mousetrap/proc/clumsy_check(var/mob/living/user)
	if((user.is_clumsy() || HAS_FLAG(user.mutations, DUMB)) && prob(50))
		var/which_hand = BP_L_HAND
		if(!user.hand)
			which_hand = BP_R_HAND
		triggered(user, which_hand)
		user.visible_message(SPAN_WARNING("[user] accidentally sets off \the [src]!"), SPAN_WARNING("You accidentally trigger \the [src]!"))
		return TRUE
	return FALSE

/obj/item/device/assembly/mousetrap/Crossed(AM as mob|obj)
	if(armed)
		if(israt(AM))
			triggered(AM)
		else if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(!(H.shoes?.item_flags & LIGHTSTEP))
				triggered(H)
				H.visible_message(SPAN_WARNING("\The [H] accidentally steps on \the [src]."), SPAN_WARNING("You accidentally step on \the [src]."))
		else if(isliving(AM))
			var/mob/living/L = AM
			triggered(L)
			L.visible_message(SPAN_WARNING("\The [L] accidentally steps on \the [src]."), SPAN_WARNING("You accidentally step on \the [src]."))
	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder)
	if(armed)
		finder.visible_message(SPAN_WARNING("[finder] accidentally sets off \the [src]!"), SPAN_WARNING("You accidentally trigger \the [src]!"))
		triggered(finder, finder.hand ? BP_L_HAND : BP_R_HAND)
		return TRUE
	return FALSE

/obj/item/device/assembly/mousetrap/hitby(A as mob|obj)
	if(!armed)
		return ..()
	visible_message(SPAN_WARNING("\The [src] is triggered by \the [A]."))
	triggered(null)

/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = TRUE

/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	layer = TURF_LAYER + 0.2
	to_chat(usr, SPAN_NOTICE("You hide \the [src]."))
