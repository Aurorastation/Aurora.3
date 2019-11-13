//ghetto shotgun, mostly based on the tg-version. Also this file can be used for more improvised guns in the future - Alberyk

/obj/item/gun/projectile/shotgun/improvised //similar to the double barrel, but without the option to fire both barrels
	name = "improvised shotgun"
	desc = "An improvised pipe assembly that can fire shotgun shells."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ishotgun"
	item_state = "ishotgun"
	contained_sprite = 1
	max_shells = 2
	w_class = 4.0
	force = 5
	recoil = 2
	accuracy = -1
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	needspin = FALSE
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'
	var/fail_chance = 35

/obj/item/gun/projectile/shotgun/improvised/special_check(var/mob/living/carbon/human/M)
	if(prob(fail_chance))
		M.visible_message("<span class='danger'>[M]'s weapon blows up, shattering into pieces!</span>","<span class='danger'>[src] blows up in your face!</span>", "You hear a loud bang!")
		M.take_organ_damage(0,30)
		M.drop_item()
		new /obj/item/material/shard/shrapnel(get_turf(src))
		qdel(src)
		return 0

	return ..()


/obj/item/gun/projectile/shotgun/improvised/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/gun/energy/plasmacutter) && w_class != 3)
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "ishotgunsawn"
			item_state = "ishotgunsawn"
			w_class = 3
			force = 5
			slot_flags &= ~SLOT_BACK
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
			name = "sawn-off improvised shotgun"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/shotgun/improvised/examine(mob/user)
	..(user)
	switch(fail_chance)
		if(1) to_chat(user, "All craftsmanship is of the highest quality.")
		if(2 to 25) to_chat(user, "All craftsmanship is of high quality.")
		if(26 to 50) to_chat(user, "All craftsmanship is of average quality.")
		if(51 to 75) to_chat(user, "All craftsmanship is of low quality.")
		if(100) to_chat(user, "All craftsmanship is of the lowest quality.")

/obj/item/gun/projectile/shotgun/improvised/sawn
	name = "sawn-off improvised shotgun"
	desc = "An improvised pipe assembly that can fire shotgun shells."
	icon_state = "ishotgunsawn"
	item_state = "ishotgunsawn"
	contained_sprite = 1
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = 3
	force = 5

// shotgun construction

/obj/item/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "riflestock"
	var/buildstate = 0

/obj/item/receivergun
	name = "receiver"
	desc = "A receiver and trigger assembly for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"
	var/buildstate = 0

/obj/item/receivergun/update_icon()
	icon_state = "ishotgun[buildstate]"

/obj/item/receivergun/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has a pipe segment installed.")
		if(2) to_chat(user, "It has a stock installed.")
		if(3) to_chat(user, "Its pieces are held together by tape roll.")

/obj/item/receivergun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			qdel(W)
			to_chat(user, "<span class='notice'>You place the pipe and the receiver together.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/stock))
		if(buildstate == 1)
			qdel(W)
			to_chat(user, "<span class='notice'>You add the stock to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/tape_roll))
		if(buildstate == 2)
			qdel(W)
			to_chat(user, "<span class='notice'>You strap the pieces together with tape.</span>")
			buildstate++
			update_icon()
			return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 3)
			if(C.use(10))
				to_chat(user, "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>")
				var/obj/item/gun/projectile/shotgun/improvised/G = new(get_turf(src))
				G.fail_chance = rand(1,100)
				qdel(src)
			else
				to_chat(user, "<span class='notice'>You need at least ten lengths of cable if you want to make a sling!.</span>")
			return

		..()

//ghetto handgun, sprites by datberry

/obj/item/gun/projectile/improvised_handgun
	name = "improvised handgun"
	desc = "A common sight in an amateur's workshop, a simple yet effective assembly made to chamber and fire .45 Rounds."
	max_shells = 7
	recoil = 2
	accuracy = -1
	fire_delay = 9
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ipistol"
	item_state = "gun"
	caliber = ".45"
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE
	jam_chance = 20
	needspin = FALSE

/obj/item/gun/projectile/improvised_handgun/examine(mob/user)
	..(user)
	switch(jam_chance)
		if(1) to_chat(user, "All craftsmanship is of the highest quality.")
		if(2 to 25) to_chat(user, "All craftsmanship is of high quality.")
		if(26 to 50) to_chat(user, "All craftsmanship is of average quality.")
		if(51 to 75) to_chat(user, "All craftsmanship is of low quality.")
		if(100) to_chat(user, "All craftsmanship is of the lowest quality.")

/obj/item/stock/update_icon()
	icon_state = "ipistol[buildstate]"

/obj/item/stock/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It is carved in the shape of a pistol handle.")
		if(2) to_chat(user, "It has a receiver installed.")
		if(3) to_chat(user, "It has a pipe installed.")

/obj/item/stock/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/hatchet))
		if(buildstate == 0)
			to_chat(user, "<span class='notice'>You carve the rifle stock.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/receivergun))
		if(buildstate == 1)
			qdel(W)
			to_chat(user, "<span class='notice'>You add the receiver to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/pipe))
		if(buildstate == 2)
			qdel(W)
			to_chat(user, "<span class='notice'>You strap the pipe to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(W.iswelder())
		if(buildstate == 3)
			var/obj/item/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You shorten the barrel with the welding tool.</span>")
				var/obj/item/gun/projectile/improvised_handgun/G = new(get_turf(src))
				G.jam_chance = rand(1,100)
				qdel(src)
		..()

/obj/item/gun/projectile/automatic/improvised
	name = "improvised machine pistol"
	desc = "An improvised automatic handgun. Uses .45 rounds."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ismg"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/c45uzi)
	max_shells = 16
	caliber = ".45"
	sel_mode = 1
	accuracy = -1
	fire_delay = 5
	burst = 3
	burst_delay = 3
	move_delay = 3
	fire_delay = 2
	dispersion = list(5, 10, 15, 20)
	jam_chance = 20

	needspin = FALSE

	firemodes = null
