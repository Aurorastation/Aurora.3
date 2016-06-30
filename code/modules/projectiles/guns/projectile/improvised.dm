//ghetto shotgun, mostly based on the tg-version. Also this file can be used for more improvised guns in the future - Alberyk

/obj/item/weapon/gun/projectile/shotgun/improvised //similar to the double barrel, but without the option to fire both barrels
	name = "improvised shotgun"
	desc = "An improvised pipe assembly that can fire shotgun shells."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ishotgun"
	item_state = "dshotgun"
	max_shells = 2
	w_class = 4.0
	force = 5
	flags =  CONDUCT
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = "combat=2;materials=2"
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	
/obj/item/weapon/gun/projectile/shotgun/improvised/special_check(var/mob/living/carbon/human/M)
		if(prob(40 - (loaded.len * 10)))
			M << "<span class='danger'>[src] blows up in your face.</span>"
			M.take_organ_damage(0,20)
			M.drop_item()
			del(src)
			return 0
		return 1

/obj/item/weapon/gun/projectile/shotgun/improvised/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
		user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
		if(loaded.len)
			for(var/i in 1 to max_shells)
				afterattack(user, user)	//will this work? //it will. we call it twice, for twice the FUN
				playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "ishotgunsawn"
			item_state = "sawnshotgun"
			w_class = 3
			force = 5
			slot_flags &= ~SLOT_BACK
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
			name = "sawn-off improvised shotgun"
			user << "<span class='warning'>You shorten the barrel of \the [src]!</span>"
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/improvised/sawn
	name = "sawn-off improvised shotgun"
	desc = "An improvised pipe assembly that can fire shotgun shells."
	icon_state = "ishotgunsawn"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = 3
	force = 5

// shotgun construction

/obj/item/weapon/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "riflestock"

/obj/item/weapon/receivergun
	name = "receiver"
	desc = "A receiver and trigger assembly for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"
	var/buildstate = 0

/obj/item/weapon/receivergun/update_icon()
	icon_state = "ishotgun[buildstate]"

/obj/item/weapon/receivergun/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) user << "It has a pipe segment installed."
		if(2) user << "It has a stock installed."
		if(3) user << "Its pieces are held together by tape roll."

/obj/item/weapon/receivergun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You place the pipe and the receiver together.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/stock))
		if(buildstate == 1)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You add the stock to the assembly.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/tape_roll))
		if(buildstate == 2)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You strap the pieces together with tape.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 3)
			if(C.use(10))
				user << "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>"
				new /obj/item/weapon/gun/projectile/shotgun/improvised(get_turf(src))
				qdel(src)
			else
				user << "<span class='notice'>You need at least ten lengths of cable if you want to make a sling!.</span>"
			return

		..()
