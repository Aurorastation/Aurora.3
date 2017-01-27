/obj/structure/lamarr
	name = "lab cage"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "labcage1"
	desc = "A glass lab container for storing interesting creatures."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete Lamarr
	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/lamarr/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/material/shard( src.loc )
			Break()
			qdel(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/lamarr/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	src.healthcheck()
	return

/obj/structure/lamarr/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = 0
			src.destroyed = 1
			new /obj/item/weapon/material/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			Break()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return

/obj/structure/lamarr/update_icon()
	if(src.destroyed)
		src.icon_state = "labcageb[src.occupied]"
	else
		src.icon_state = "labcage[src.occupied]"
	return


/obj/structure/lamarr/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/structure/lamarr/attack_hand(mob/user as mob)
	if (src.destroyed)
		return
	else
		usr << "<span class='warning'>You kick the lab cage.</span>"
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << "<span class='warning'>[user] kicks the lab cage.</span>"

		src.health -= 2
		healthcheck()
		return

/obj/structure/lamarr/proc/Break()
	if(occupied)
		new /obj/item/clothing/mask/lamarr(src.loc)
		occupied = 0
	update_icon()
	return

var/const/MIN_ACTIVE_TIME = 200 //time between being dropped and going idle
var/const/MAX_ACTIVE_TIME = 400

/obj/item/clothing/mask/lamarr
	name = "Lamarr"
	desc = "The worst she might do is attempt to... couple with your head."//hope we don't get sued over a harmless reference, rite?
	gender = FEMALE
	icon = 'icons/mob/alien.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = 3 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = PROXMOVE
	body_parts_covered = FACE|EYES
	throw_range = 5

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/strength = 5
	var/attached = 0
	var/sterile = 1

/obj/item/clothing/mask/lamarr/New()//to prevent deleting it if aliums are disabled
	return

/obj/item/clothing/mask/lamarr/attack_hand(user as mob)

	if((stat == CONSCIOUS))
		if(Attach(user))
			return

	..()

/obj/item/clothing/mask/lamarr/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	user.drop_from_inventory(src)
	if(hit_zone == "head")
		Attach(target)


/obj/item/clothing/mask/lamarr/examine(mob/user)
	..(user)
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			user << "<span class='warning'>[src] is not moving.</span>"
		if(CONSCIOUS)
			user << "<span class='warning'>[src] seems to be active.</span>"
	if (sterile)
		user << "<span class='warning'> It looks like the proboscis has been removed.</span>"
	return

/obj/item/clothing/mask/lamarr/attackby(obj/item/I, mob/user)
	if(I.force)
		user.do_attack_animation(src)
		Die()
	return

/obj/item/clothing/mask/lamarr/bullet_act()
	Die()
	return

/obj/item/clothing/mask/lamarr/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+80)
		Die()
	return

/obj/item/clothing/mask/lamarr/equipped(mob/M)
	..()
	Attach(M)

/obj/item/clothing/mask/lamarr/Crossed(atom/target)
	HasProximity(target)
	return

/obj/item/clothing/mask/lamarr/on_found(mob/finder as mob)
	if(stat == CONSCIOUS)
		HasProximity(finder)
		return 1
	return

/obj/item/clothing/mask/lamarr/HasProximity(atom/movable/AM as mob|obj)
	if(CanHug(AM))
		Attach(AM)

/obj/item/clothing/mask/lamarr/throw_at(atom/target, range, speed)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		spawn(15)
			if(icon_state == "[initial(icon_state)]_thrown")
				icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/lamarr/proc/Attach(M as mob)

	if((!iscarbon(M)))
		return

	if(attached)
		return

	var/mob/living/L = M //just so I don't need to use :

	if(loc == L) return
	if(stat != CONSCIOUS)	return
	if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

	L.visible_message("<span class='danger'>[src] leaps at [L]'s face!</span>")


	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.head && H.head.flags & AIRTIGHT)
			H.visible_message("<span class='danger'>\The [src] smashes against [H]'s [H.head]!</span>")
			Die()
			return


	if(iscarbon(M))
		var/mob/living/carbon/target = L

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			target.drop_from_inventory(W)

			target.visible_message("<span class='danger'>\The [src] tears [W] off of [target]'s face!</span>")

		target.equip_to_slot(src, slot_wear_mask)
		target.contents += src // Monkey sanity check - Snapshot

	GoIdle() //so it doesn't jump the people that tear it off

	return

/obj/item/clothing/mask/lamarr/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

	return

/obj/item/clothing/mask/lamarr/proc/GoIdle(var/min_time=MIN_ACTIVE_TIME, var/max_time=MAX_ACTIVE_TIME)
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

/*		RemoveActiveIndicators()	*/

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	spawn(rand(min_time,max_time))
		GoActive()
	return

/obj/item/clothing/mask/lamarr/proc/Die()
	if(stat == DEAD)
		return

/*		RemoveActiveIndicators()	*/

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	src.visible_message("<span class='danger'>\The [src] curls up into a ball!</span>")

	return

/proc/CanHug(var/mob/M)

	if(!iscarbon(M))
		return 0

	var/mob/living/carbon/C = M
	if(istype(C) && locate(/obj/item/organ/xenos/hivenode) in C.internal_organs)
		return 0

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.head && (H.head.body_parts_covered & FACE) && !(H.head.item_flags & FLEXIBLEMATERIAL))
			return 0
	return 1
