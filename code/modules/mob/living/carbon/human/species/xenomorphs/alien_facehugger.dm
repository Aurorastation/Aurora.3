//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_animals

var/const/MIN_IMPREGNATION_TIME = 100 //time it takes to impregnate someone
var/const/MAX_IMPREGNATION_TIME = 150

var/const/MIN_ACTIVE_TIME = 200 //time between being dropped and going idle
var/const/MAX_ACTIVE_TIME = 400

/obj/item/clothing/mask/facehugger
	name = "alien"
	desc = "It has some sort of a tube at the end of its tail."
	icon = 'icons/mob/alien.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = 3 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = PROXMOVE
	body_parts_covered = FACE|EYES
	throw_range = 5

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = 0
	var/strength = 5
	var/attached = 0

/obj/item/clothing/mask/facehugger/attack_hand(user as mob)

	if((stat == CONSCIOUS && !sterile))
		if(Attach(user))
			return

	..()

/obj/item/clothing/mask/facehugger/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	user.drop_from_inventory(src)
	Attach(target)


/obj/item/clothing/mask/facehugger/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !user.stat)
		user.drop_from_inventory(src)
		Attach(target)
		return
	..()

/obj/item/clothing/mask/facehugger/examine(mob/user)
	..(user)
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			user << "<span class='danger'>\The [src] is not moving.</span>"
		if(CONSCIOUS)
			user << "<span class='danger'>\The [src] seems to be active.</span>"
	if (sterile)
		user << "<span class='danger'>It looks like the proboscis has been removed.</span>"
	return

/obj/item/clothing/mask/facehugger/attackby(obj/item/I, mob/user)
	if(I.force)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		Die()
	return

/obj/item/clothing/mask/facehugger/bullet_act()
	Die()
	return

/obj/item/clothing/mask/facehugger/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+80)
		Die()
	return

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	..()
	Attach(M)

/obj/item/clothing/mask/facehugger/Crossed(atom/target)
	HasProximity(target)
	return

/obj/item/clothing/mask/facehugger/on_found(mob/finder as mob)
	if(stat == CONSCIOUS)
		HasProximity(finder)
		return 1
	return

/obj/item/clothing/mask/facehugger/HasProximity(atom/movable/AM as mob|obj)
	if(CanHug(AM))
		Attach(AM)

/obj/item/clothing/mask/facehugger/throw_at(atom/target, range, speed)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		spawn(15)
			if(icon_state == "[initial(icon_state)]_thrown")
				icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/facehugger/throw_impact(atom/hit_atom)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		throwing = 0
	GoIdle(30,100) //stunned for a few seconds - allows throwing them to be useful for positioning but not as an offensive action (unless you're setting up a trap)

/obj/item/clothing/mask/facehugger/proc/Attach(mob/living/M as mob)

	if((!iscarbon(M)))
		return

	if(attached)
		return

	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/C = M
	if(istype(C) && locate(/obj/item/organ/parasite/alien_embryo) in C.internal_organs)
		return

	if(locate(/obj/item/organ/xenos/hivenode) in C.internal_organs)
		return

	if(!C.check_has_mouth())
		return

	attached++
	spawn(MAX_IMPREGNATION_TIME)
		attached = 0

	var/mob/living/L = M //just so I don't need to use :

	if(loc == L) return
	if(stat != CONSCIOUS)	return
	if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

	L.visible_message("<span class='danger'>\The [src] leaps at \the [L]'s face!</span>")


	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.head && H.head.body_parts_covered & FACE)
			H.visible_message("<span class='danger'>\The [src] smashes against the [H]'s \the [H.head]!</span>")
			Die()
			return


	if(iscarbon(M))
		var/mob/living/carbon/target = L

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			target.drop_from_inventory(W)

			target.visible_message("<span class='danger'>\The [src] tears \the [W] off of \the [target]'s face!</span>")

		target.equip_to_slot(src, slot_wear_mask)
		target.contents += src // Monkey sanity check - Snapshot

		if(!sterile) L.Paralyse(MAX_IMPREGNATION_TIME/6) //something like 25 ticks = 20 seconds with the default settings

	GoIdle() //so it doesn't jump the people that tear it off

	spawn(rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME))
		Impregnate(L)

	return

/obj/item/clothing/mask/facehugger/proc/Impregnate(mob/living/carbon/human/target as mob)
	if(!target || target.wear_mask != src || target.stat == DEAD) //was taken off or something
		return

	if(!sterile)
		//target.contract_disease(new /datum/disease/alien_embryo(0)) //so infection chance is same as virus infection chance
		var/obj/item/organ/affecting = target.get_organ("chest")
		var/obj/item/organ/parasite/alien_embryo/kid = new(affecting)
		kid.replaced(target,affecting)
		target.status_flags |= XENO_HOST

		target.visible_message("<span class='danger'>\The [src] falls limp after violating \the [target]'s face!</span>")

		Die()
		icon_state = "[initial(icon_state)]_impregnated"

	else
		target.visible_message("<span class='danger'>\The [src] violates \the [target]'s face!</span>")
	return

/obj/item/clothing/mask/facehugger/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

	return

/obj/item/clothing/mask/facehugger/proc/GoIdle(var/min_time=MIN_ACTIVE_TIME, var/max_time=MAX_ACTIVE_TIME)
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

/*		RemoveActiveIndicators()	*/

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	spawn(rand(min_time,max_time))
		GoActive()
	return

/obj/item/clothing/mask/facehugger/proc/Die()
	if(stat == DEAD)
		return

/*		RemoveActiveIndicators()	*/

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	src.visible_message("<span class='danger'>\The [src] curls up into a ball!</span>")

	return


/obj/item/clothing/mask/facehugger/lamarr
	name = "Lamarr"
	desc = "The worst she might do is attempt to... couple with your head."//hope we don't get sued over a harmless reference, rite?
	gender = FEMALE
	sterile = 1

/proc/CanHug(var/mob/M)

	if(iscorgi(M))
		return 1

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
