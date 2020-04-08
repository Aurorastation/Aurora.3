/obj/item/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "cleaner"
	item_state = "cleaner"
	center_of_mass = list("x" = 16,"y" = 10)
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
	var/spray_sound = 'sound/effects/spray2.ogg'

/obj/item/reagent_containers/spray/Initialize()
	. = ..()
	src.verbs -= /obj/item/reagent_containers/verb/set_APTFT

/obj/item/reagent_containers/spray/AltClick()
	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	safety = !safety
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	to_chat(usr, "<span class = 'notice'>You twist the locking cap on the end of the nozzle. \The [src] is now [safety ? "locked" : "unlocked"].</span>")


/obj/item/reagent_containers/spray/afterattack(atom/A as mob|obj, mob/user as mob, proximity)

	if(istype(A, /obj/item/reagent_containers))
		. = ..()
		return

	if(is_type_in_list(A,can_be_placed_into))
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
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
		return

	if(safety)
		playsound(src.loc, 'sound/weapons/empty.ogg', 25, 1)
		to_chat(user, "<span class='notice'>The safety is on!</span>")
		return

	Spray_at(A, user, proximity)

	playsound(src.loc, spray_sound, 50, 1, -6)

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

/obj/item/reagent_containers/spray/proc/Spray_at(atom/A as mob|obj, mob/user as mob, proximity)
	if(istype(A, /obj) && A.loc == user)
		return
	if (A.density && proximity)
		A.visible_message("[user] sprays [A] with [src].")
		reagents.splash(A, amount_per_transfer_from_this)
	else
		var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
		var/turf/my_target = get_turf(A)
		D.create_reagents(amount_per_transfer_from_this)
		if(!src)
			return
		reagents.trans_to_obj(D, amount_per_transfer_from_this)
		D.set_color()
		D.set_up(my_target, spray_size, 10)

	if(ishuman(user) && user.invisibility == INVISIBILITY_LEVEL_TWO) //shooting will disable a rig cloaking device
		var/mob/living/carbon/human/H = user
		if(istype(H.back,/obj/item/rig))
			var/obj/item/rig/R = H.back
			for(var/obj/item/rig_module/stealth_field/S in R.installed_modules)
				S.deactivate()

/obj/item/reagent_containers/spray/attack_self(var/mob/user)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, "<span class='notice'>You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")

/obj/item/reagent_containers/spray/examine(mob/user)
	if(..(user, 0) && loc == user)
		to_chat(user, "[round(reagents.total_volume)] units left.")
	return

/obj/item/reagent_containers/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, "<span class='notice'>You empty \the [src] onto the floor.</span>")
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
/obj/item/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"

/obj/item/reagent_containers/spray/cleaner/drone
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

/obj/item/reagent_containers/spray/cleaner/Initialize()
	. = ..()
	reagents.add_reagent("cleaner", volume)

/obj/item/reagent_containers/spray/sterilizine
	name = "sterilizine"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/reagent_containers/spray/sterilizine/Initialize()
	. = ..()
	reagents.add_reagent("sterilizine", volume)

/obj/item/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	center_of_mass = list("x" = 16,"y" = 16)
	possible_transfer_amounts = null
	volume = 40
	safety = 1
	hitsound = "swing_hit"


/obj/item/reagent_containers/spray/pepper/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", 40)

/obj/item/reagent_containers/spray/pepper/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "The safety is [safety ? "on" : "off"].")

/obj/item/reagent_containers/spray/pepper/AltClick()
	return //No altclick functionality for pepper spray

/obj/item/reagent_containers/spray/pepper/attack_self(var/mob/user)
	safety = !safety
	to_chat(user, "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>")
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

/obj/item/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

/obj/item/reagent_containers/spray/waterflower/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)

/obj/item/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/guns/chemsprayer.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	contained_sprite = TRUE
	center_of_mass = list("x" = 16,"y" = 16)
	throwforce = 3
	w_class = 3.0
	possible_transfer_amounts = null
	volume = 600
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/reagent_containers/spray/chemsprayer/Spray_at(atom/A as mob|obj)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to spray_size)
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

/obj/item/reagent_containers/spray/chemsprayer/xenobiology
	name = "xenoblaster"
	desc = "A child's plastic watergun repurposed for the use in pacifying slimes. Has an adjustable nozzle that controls precision as well as strength."
	icon = 'icons/obj/guns/xenoblaster.dmi'
	icon_state = "xenoblaster"
	item_state = "xenoblaster"
	contained_sprite = TRUE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	volume = 200
	spray_size = 3
	spray_sizes = list(1,3)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,15)

/obj/item/reagent_containers/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics_machines.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/reagent_containers/spray/plantbgone/Initialize()
	. = ..()
	reagents.add_reagent("plantbgone", 100)

/obj/item/reagent_containers/spray/plantbgone/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return

	if(istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()
