//ghetto shotgun, mostly based on the tg-version. Also this file can be used for more improvised guns in the future - Alberyk

/obj/item/weapon/gun/projectile/shotgun/improvised //similar to the double barrel, but without the option to fire both barrels
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

/obj/item/weapon/gun/projectile/shotgun/improvised/special_check(var/mob/living/carbon/human/M)
	if(prob(fail_chance))
		M.visible_message("<span class='danger'>[M]'s weapon blows up, shattering into pieces!</span>","<span class='danger'>[src] blows up in your face!</span>", "You hear a loud bang!")
		M.take_organ_damage(0,30)
		M.drop_item()
		new /obj/item/weapon/material/shard/shrapnel(get_turf(src))
		qdel(src)
		return 0

	return ..()


/obj/item/weapon/gun/projectile/shotgun/improvised/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/gun/energy/plasmacutter) && w_class != 3)
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

/obj/item/weapon/gun/projectile/shotgun/improvised/examine(mob/user)
	..(user)
	switch(fail_chance)
		if(1) to_chat(user, "All craftsmanship is of the highest quality.")
		if(2 to 25) to_chat(user, "All craftsmanship is of high quality.")
		if(26 to 50) to_chat(user, "All craftsmanship is of average quality.")
		if(51 to 75) to_chat(user, "All craftsmanship is of low quality.")
		if(100) to_chat(user, "All craftsmanship is of the lowest quality.")

/obj/item/weapon/gun/projectile/shotgun/improvised/sawn
	name = "sawn-off improvised shotgun"
	desc = "An improvised pipe assembly that can fire shotgun shells."
	icon_state = "ishotgunsawn"
	item_state = "ishotgunsawn"
	contained_sprite = 1
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
	var/buildpath = 0 //0 is for the Improvised Handgun, 1 is for the Improvised Lasergun

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
		if(1) to_chat(user, "It has a pipe segment installed.")
		if(2) to_chat(user, "It has a stock installed.")
		if(3) to_chat(user, "Its pieces are held together by tape roll.")

/obj/item/weapon/receivergun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			qdel(W)
			to_chat(user, "<span class='notice'>You place the pipe and the receiver together.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/stock))
		if(buildstate == 1)
			qdel(W)
			to_chat(user, "<span class='notice'>You add the stock to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/tape_roll))
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
				var/obj/item/weapon/gun/projectile/shotgun/improvised/G = new(get_turf(src))
				G.fail_chance = rand(1,100)
				qdel(src)
			else
				to_chat(user, "<span class='notice'>You need at least ten lengths of cable if you want to make a sling!.</span>")
			return

		..()

//ghetto handgun, sprites by datberry

/obj/item/weapon/gun/projectile/improvised_handgun
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

/obj/item/weapon/gun/projectile/improvised_handgun/examine(mob/user)
	..(user)
	switch(jam_chance)
		if(1) to_chat(user, "All craftsmanship is of the highest quality.")
		if(2 to 25) to_chat(user, "All craftsmanship is of high quality.")
		if(26 to 50) to_chat(user, "All craftsmanship is of average quality.")
		if(51 to 75) to_chat(user, "All craftsmanship is of low quality.")
		if(100) to_chat(user, "All craftsmanship is of the lowest quality.")
		
//Ghetto Lasergun, sprites by DronzTheWolf
		
/obj/item/weapon/gun/energy/improvised_laser
	name = "improvised lasergun"
	desc = "A hodgepodge of parts in the shape of an pistol. Most notably, a high capacity battery wired to inefficiently blast energy through thick lenses."
	projectile_type = /obj/item/projectile/beam/custom
	max_shots = 8
	accuracy = -1
	fire_delay = 10
	icon = 'icons/obj/improvised.dmi'
	icon_state = "ilaser"
	item_state = "blaster"
	burst = 1
	burst_delay = 0
	dispersion = list(15)
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	var/tuning = 0 //the lower this value is, the better tuned the lens is, and the better the gun will operate
	var/stability = 2 //this value is a counter, when it reaches 0, the next shot will cause the gun to gain tuning faults

/obj/item/weapon/gun/energy/improvised_laser/New()
	..()
	projectile_type = new /obj/item/projectile/beam/custom(20)

/obj/item/weapon/gun/energy/improvised_laser/afterattack(atom/A, mob/living/user)
	..()
	if(stability > 0)
		stability--
	if(stability == 0)
		if (tuning < 3)
			tuning++
		switch(tuning)
			if(0)
				burst = 1
				projectile_type = new /obj/item/projectile/beam/custom(20)
				stability = 2
			if(1)
				burst = 2
				projectile_type = new /obj/item/projectile/beam/custom(10)
				stability = 2
			if(2)
				burst = 4
				projectile_type = new /obj/item/projectile/beam/custom(5)
				stability = 2
			if(3)
				burst = 4
				projectile_type = new /obj/item/projectile/beam/custom(2)
				stability = 2

/obj/item/weapon/gun/energy/improvised_laser/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(C.isscrewdriver())
		tuning = 0
		stability = 2
		projectile_type = new /obj/item/projectile/beam/custom(20)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, span("notice", "You retune the lens using the screwdriver."))

	
obj/item/weapon/gun/energy/improvised_laser/examine(mob/user)
	..(user)
	switch(tuning)
		if(0) to_chat(user, "This amalgamation looks as tuned as it can be.")
		if(1) to_chat(user, "This horrible device is starting to rattle a bit.")
		if(2) to_chat(user, "This mash-up has parts starting to peel off.")
		if(3) to_chat(user, "This fusion of bad ideas has its lens shifted completely out of line.")

/obj/item/weapon/stock/update_icon()
	if(buildpath == 0)
		icon_state = "ipistol[buildstate]"
	else if(buildpath == 1)
		icon_state = "ilaser[buildstate]"

/obj/item/weapon/stock/examine(mob/user)
	..(user)
	if(buildpath == 0)
		switch(buildstate)
			if(1) to_chat(user, "It is carved in the shape of a pistol handle.")
			if(2) to_chat(user, "It has a receiver installed.")
			if(3) to_chat(user, "It has a pipe installed.")
	if(buildpath == 1)
		switch(buildstate)
			if(4) to_chat(user, "It has a wire frame installed.")
			if(5) to_chat(user, "It has a lenses installed.")
			if(6) to_chat(user, "It has a battery attached.")
			if(7) to_chat(user, "It has a its battery fastened.")
			if(8) to_chat(user, "It has a wires installed.")

/obj/item/weapon/stock/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/hatchet))
		if(buildstate == 0)
			to_chat(user, "<span class='notice'>You carve the rifle stock.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/receivergun))
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
	//Diverges path: Improvised Lasergun
	else if(istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(buildstate == 3)
			if (R.use(2))
				to_chat(user, "<span class='notice'>You attach a wired frame to the top of the assembly.</span>")
				buildstate++
				buildpath++ //Not strictly needed, as paths will never cross right now, but will prevent issues with additions in future
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least two rods if you want to make the frame!</span>")
			return
	else if(istype(W,/obj/item/device/camera))
		if(buildstate == 4 && buildpath == 1)
			qdel(W)
			to_chat(user, "<span class='notice'>You attach the lenses of the camera to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/cell/high))
		if(buildstate == 5 && buildpath == 1)
			qdel(W)
			to_chat(user, "<span class='notice'>You add the high capacity battery to the assembly.</span>")
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/wrench))
		if(buildstate == 6 && buildpath == 1)
			to_chat(user, "<span class='notice'>You wrench the battery into place.</span>")
			buildstate++
			update_icon()
			return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 7 && buildpath == 1)
			if(C.use(5))
				to_chat(user, "<span class='notice'>You attach wires to the battery.</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least ten lengths of cable if you want to make a sling!</span>")
			return
	else if(istype(W,/obj/item/weapon/screwdriver))
		if(buildstate == 8 && buildpath == 1)
			to_chat(user, "<span class='notice'>You use the screwdriver to secure the assembly, finalizing it.</span>")
			new /obj/item/weapon/gun/energy/improvised_laser(get_turf(src))
			qdel(src)
			return
	//Diverges path: Improvised .45 Handgun
	else if(W.iswelder())
		if(buildstate == 3 && buildpath == 0)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You shorten the barrel with the welding tool.</span>")
				var/obj/item/weapon/gun/projectile/improvised_handgun/G = new(get_turf(src))
				G.jam_chance = rand(1,100)
				qdel(src)
		..()

/obj/item/weapon/gun/projectile/automatic/improvised
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
