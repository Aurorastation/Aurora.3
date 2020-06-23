/obj/item/ammo_pile
	name = "ammo pile"
	desc = "A handful of some kind of ammunition."
	w_class = ITEMSIZE_SMALL

	var/list/ammo = list()
	var/list/ammo_overlays = list()
	var/image/ammo_overlay = list()
	var/ammo_type // the type of ammo this ammo pile accepts
	var/max_ammo = 5

/obj/item/ammo_pile/Initialize(mapload, ...)
	. = ..()
	if(ammo_type && max_ammo)
		for(var/i = 1, i <= max_ammo, i++)
			var/obj/C = new ammo_type(get_turf(src))
			add_ammo(C)
		check_name()
	addtimer(CALLBACK(src, .proc/check_ammo), 5) // if we don't have any ammo in 5 deciseconds, we're an empty pile, which is worthless, so self-delete

/obj/item/ammo_pile/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, SPAN_NOTICE("It contains [length(ammo)] rounds."))

/obj/item/ammo_pile/attack()
	return

/obj/item/ammo_pile/afterattack(atom/A, mob/living/user, proximity_flag)
	if(!proximity_flag)
		return
	if(!length(ammo))
		check_ammo()

	if(A.type == ammo_type)
		if(length(ammo) >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stacked."))
			return
		var/obj/item/ammo_casing/B = A
		if(!B.BB)
			to_chat(user, SPAN_WARNING("\The [B] is spent!"))
			return
		to_chat(user, SPAN_NOTICE("You add \the [A] to \the [src]."))
		add_ammo(A)
	else if(istype(A, /obj/item/ammo_pile))
		if(length(ammo) >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stacked."))
			return
		var/obj/item/ammo_pile/target_pile = A
		if(target_pile.ammo_type != src.ammo_type)
			to_chat(user, SPAN_WARNING("\The [target_pile] has a different type of ammunition!"))
			return
		var/amount_taken = 0
		for(var/obj/bullet in target_pile.ammo)
			if(length(src.ammo) >= src.max_ammo)
				break
			src.add_ammo(bullet)
			target_pile.remove_ammo()
			amount_taken++
		to_chat(user, SPAN_NOTICE("You take [amount_taken] rounds from the other pile and add it to yours."))
	else if(istype(A, /obj/item/gun) || istype(A, /obj/item/ammo_magazine))
		var/obj/bullet = get_next_ammo()
		A.attackby(bullet, user)
		if(!(bullet in src)) // if the gun / mag acceoted the bullet, it will no longer be in our pile
			remove_ammo()

/obj/item/ammo_pile/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_casing))
		if(W.type != ammo_type)
			to_chat(user, SPAN_WARNING("\The [W] has a different type of ammunition!"))
			return
		if(length(ammo) >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stacked."))
			return
		var/obj/item/ammo_casing/B = W
		if(!B.BB)
			to_chat(user, SPAN_WARNING("\The [B] is spent!"))
			return
		to_chat(user, SPAN_NOTICE("You add \the [W] to \the [src]."))
		add_ammo(W)
		return
	..()

/obj/item/ammo_pile/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		var/obj/item/ammo_casing/C = get_next_ammo()
		user.put_in_hands(C)
		remove_ammo()
	else
		..()

/obj/item/ammo_pile/proc/check_name()
	if(length(ammo))
		var/obj/item/ammo_casing/first_round = ammo[1]
		name = "[first_round.caliber] pile"
		desc = "A pile of [first_round.caliber] rounds."

/obj/item/ammo_pile/proc/get_next_ammo() //Returns the next shell to be used.
	if(!length(ammo))
		qdel(src)
		return null
	var/obj/item/ammo_casing/to_load = ammo[1]
	return to_load

/obj/item/ammo_pile/proc/check_ammo()
	switch(length(ammo))
		if(0)
			qdel(src)
		if(1)
			var/obj/bullet = ammo[1]
			bullet.forceMove(get_turf(src))
			var/mob/gunman
			if(ismob(loc))
				gunman = loc
			qdel(src)
			if(gunman)
				gunman.put_in_hands(bullet)

/obj/item/ammo_pile/proc/add_ammo(var/obj/item/ammo_casing/bullet)
	if(!bullet.BB)
		return
	if(ismob(bullet.loc))
		var/mob/gunman = bullet.loc
		gunman.drop_from_inventory(bullet, src)
	bullet.forceMove(src)
	ammo += bullet
	var/image/ammo_picture = image(bullet.icon, bullet.icon_state, dir = pick(alldirs))
	ammo_picture.pixel_x = rand(-6, 6)
	ammo_picture.pixel_y = rand(-6, 6)
	ammo_overlay[bullet] = ammo_picture
	add_overlay(ammo_overlay[bullet])

/obj/item/ammo_pile/proc/remove_ammo(var/atom/target)
	var/obj/bullet = ammo[1]
	if(target)
		bullet.forceMove(target)
	cut_overlay(ammo_overlay[bullet])
	ammo -= bullet
	check_ammo()

/obj/item/ammo_pile/slug
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_pile/fourty_five
	ammo_type = /obj/item/ammo_casing/c45