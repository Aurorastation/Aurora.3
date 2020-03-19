/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "mousetrap"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	var/armed = 0


	examine(mob/user)
		..(user)
		if(armed)
			to_chat(user, "It looks like it's armed.")

	update_icon()
		if(armed)
			icon_state = "mousetraparmed"
		else
			icon_state = "mousetrap"
		if(holder)
			holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(var/mob/living/target, var/type = "feet")
	if(!armed || !istype(target))
		return

	var/types = target.find_type()
	if(israt(target))
		var/mob/living/simple_animal/rat/M = target
		visible_message("<span class='danger'>SPLAT!</span>")
		M.splat()
	else
		var/zone = BP_CHEST
		if(ishuman(target) && target.mob_size)
			var/mob/living/carbon/human/H = target
			switch(type)
				if("feet")
					zone = pick(BP_L_FOOT, BP_R_FOOT)
					if(!H.shoes)
						H.apply_effect(400/(target.mob_size*(target.mob_size*0.25)), PAIN)//Halloss instead of instant knockdown
						//Mainly for the benefit of giant monsters like vaurca breeders
				if(BP_L_HAND, BP_R_HAND)
					zone = type
					if(!H.gloves)
						H.apply_effect(250/(target.mob_size*(target.mob_size*0.25)), PAIN)
		if (!(types & TYPE_SYNTHETIC))
			target.apply_damage(rand(6,14), PAIN, def_zone = zone, used_weapon = src)
			target.apply_damage(rand(1,3), BRUTE, def_zone = zone, used_weapon = src)

	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	layer = MOB_LAYER - 0.2
	armed = 0
	update_icon()
	pulse(0)


/obj/item/device/assembly/mousetrap/attack_self(mob/living/user as mob)
	if(!armed)
		to_chat(user, "<span class='notice'>You arm [src].</span>")
	else
		if(((user.is_clumsy()) || (DUMB in user.mutations)) && prob(50))
			var/which_hand = BP_L_HAND
			if(!user.hand)
				which_hand = BP_R_HAND
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
		to_chat(user, "<span class='notice'>You disarm [src].</span>")
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user as mob)
	if(armed)
		if(((user.is_clumsy()) || (DUMB in user.mutations)) && prob(50))
			var/which_hand = BP_L_HAND
			if(!user.hand)
				which_hand = BP_R_HAND
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(AM as mob|obj)
	if(armed)
		if(israt(AM))
			triggered(AM)
		else if(istype(AM, /mob/living))
			var/mob/living/L = AM
			triggered(L)
			L.visible_message("<span class='warning'>[L] accidentally steps on [src].</span>", \
							  "<span class='warning'>You accidentally step on [src]</span>")

	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder as mob)
	if(armed)
		finder.visible_message("<span class='warning'>[finder] accidentally sets off [src], breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger [src]!</span>")
		triggered(finder, finder.hand ? BP_L_HAND : BP_R_HAND)
		return 1	//end the search!
	return 0


/obj/item/device/assembly/mousetrap/hitby(A as mob|obj)
	if(!armed)
		return ..()
	visible_message("<span class='warning'>[src] is triggered by [A].</span>")
	triggered(null)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1


/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	layer = TURF_LAYER+0.2
	to_chat(usr, "<span class='notice'>You hide [src].</span>")