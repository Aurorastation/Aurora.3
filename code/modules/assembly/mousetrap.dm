/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 100, "waste" = 10)
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
	if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message("<span class='danger'>SPLAT!</span>")
		M.splat()
	else
		var/zone = "chest"
		if(ishuman(target) && target.mob_size)
			var/mob/living/carbon/human/H = target
			switch(type)
				if("feet")
					zone = pick("l_foot", "r_foot")
					if(!H.shoes)
						H.apply_effect(400/(target.mob_size*(target.mob_size*0.25)), AGONY)//Halloss instead of instant knockdown
						//Mainly for the benefit of giant monsters like vaurca breeders
				if("l_hand", "r_hand")
					zone = type
					if(!H.gloves)
						H.apply_effect(250/(target.mob_size*(target.mob_size*0.25)), AGONY)
		if (!(types & TYPE_SYNTHETIC))
			target.apply_damage(rand(6,14), AGONY, def_zone = zone, used_weapon = src)
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
		if(((CLUMSY in user.mutations) || (DUMB in user.mutations)) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
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
		if(((CLUMSY in user.mutations) || (DUMB in user.mutations)) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(AM as mob|obj)
	if(armed)
		if(ismouse(AM))
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
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
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