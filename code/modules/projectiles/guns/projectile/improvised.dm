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
	if(prob(35))
		M.visible_message("<span class='danger'>[M]'s weapon blows up, shattering into pieces!</span>","<span class='danger'>[src] blows up in your face!</span>", "You hear a loud bang!")
		M.take_organ_damage(0,30)
		M.drop_item()
		new /obj/item/weapon/material/shard/shrapnel(get_turf(src))
		qdel(src)
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
	var/buildstate = 0

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

//ghetto handgun, sprites by datberry

/obj/item/weapon/gun/projectile/improvised_handgun
	name = "\improper improvised handgun"
	desc = "A common sight in an amateur's workshop, a simple yet effective assembly made to chamber and fire .45 Rounds."
	max_shells = 7
	recoil = 2
	accuracy = -2
	fire_delay = 9
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ipistol"
	item_state = "gun"
	caliber = ".45"
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	origin_tech = "combat=2;materials=2"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	jam_chance = 30

/obj/item/weapon/stock/update_icon()
	icon_state = "ipistol[buildstate]"

/obj/item/weapon/stock/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) user << "It is carved in the shape of a pistol handle."
		if(2) user << "It has a receiver installed."
		if(3) user << "It has a pipe installed."

/obj/item/weapon/stock/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/hatchet))
		if(buildstate == 0)
			user << "<span class='notice'>You carve the rifle stock.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/receivergun))
		if(buildstate == 1)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You add the receiver to the assembly.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/pipe))
		if(buildstate == 2)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You strap the pipe to the assembly.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 3)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "<span class='notice'>You shorten the barrel with the welding tool.</span>"
				new /obj/item/weapon/gun/projectile/improvised_handgun(get_turf(src))
				qdel(src)
		..()
