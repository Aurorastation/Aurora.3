	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	flags = OPENCONTAINER|NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	unacidable = 1 //plastic
	possible_transfer_amounts = list(5,10) //Set to null instead of list, if there is only one.
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	volume = 250
	var/safety = 0

	. = ..()

	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	safety = !safety
	usr << "<span class = 'notice'>You twist the locking cap on the end of the nozzle, the spraybottle is now [safety ? "locked" : "unlocked"].</span>"


		return

	if(istype(A, /mob))
		user.setClickCooldown(25)
	else
		user.setClickCooldown(4)

	if(istype(A, /spell))
		return

	if(proximity)
		if(standard_dispenser_refill(user, A))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		user << "<span class='notice'>\The [src] is empty!</span>"
		return

	if(safety)
		user << "<span class='notice'>The safety is on!</span>"
		return

	Spray_at(A, user, proximity)

	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)



	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from \a [src].")
		log_game("[key_name(user)] fired sulphuric acid from \a [src].",ckey=key_name(user))
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from \a [src].")
		log_game("[key_name(user)] fired Polyacid from \a [src].",ckey=key_name(user))
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from \a [src].")
		log_game("[key_name(user)] fired Space lube from \a [src].",ckey=key_name(user))
	return

	if (A.density && proximity)
		A.visible_message("[user] sprays [A] with [src].")
		reagents.splash(A, amount_per_transfer_from_this)
	else
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, spray_size, 10)
	return

	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_in_list(spray_size, spray_sizes)
	user << "<span class='notice'>You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>"

	if(..(user, 0) && loc == user)
		user << "[round(reagents.total_volume)] units left."
	return


	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		usr << "<span class='notice'>You empty \the [src] onto the floor.</span>"
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"

	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

	. = ..()
	reagents.add_reagent("cleaner", volume)

	name = "sterilizine"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

	. = ..()
	reagents.add_reagent("sterilizine", volume)

	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon_state = "pepperspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	volume = 40
	safety = 1


	. = ..()
	reagents.add_reagent("condensedcapsaicin", 40)

	if(..(user, 1))
		user << "The safety is [safety ? "on" : "off"]."

	return //No altclick functionality for pepper spray

	safety = !safety
	user << "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>"

	if(safety)
		user << "<span class = 'warning'>The safety is on!</span>"
		return
	..()

	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

	. = ..()
	reagents.add_reagent("water", 10)

	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/gun.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 3
	w_class = 3.0
	possible_transfer_amounts = null
	volume = 600
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return

	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

	. = ..()
	reagents.add_reagent("plantbgone", 100)

	if(!proximity) return

	if(istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()
