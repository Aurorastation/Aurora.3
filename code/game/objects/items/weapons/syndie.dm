/obj/item/syndie
	icon = 'icons/obj/syndieweapons.dmi'

// C-4 explosive charge
// The explosive charge itself. Flashes for five seconds before exploding.
/obj/item/syndie/c4explosive
	name = "small parcel"
	desc = "A small wrapped package."
	w_class = ITEMSIZE_NORMAL
	var/power = 1		// Size of the explosion
	var/size = "small"	// Used for the icon, this one will make c-4small_0 for the off state.
	var/hidden = TRUE	// Whether it's at least partially disguised
	var/disarmed = FALSE
	var/primed = FALSE

/obj/item/syndie/c4explosive/examine(mob/user, distance)
	..()
	if(hidden && Adjacent(user))
		to_chat(user, SPAN_WARNING("This package has some wiring coming down from the diode on top..."))

/obj/item/syndie/c4explosive/attackby(obj/item/W, mob/user)
	if(W.iswirecutter())
		if(disarmed)
			to_chat(user, SPAN_WARNING("\The [src] has already been disarmed."))
			return
		user.visible_message("<b>[user]</b> begins disarming \the [src]...", SPAN_NOTICE("You begin disarming \the [src]..."))
		if(do_after(user, 100, TRUE))
			explode_chance(user)
			user.visible_message("<b>[user]</b> sucessfully disarms \the [src].", SPAN_NOTICE("You successfully disarm \the [src]."))
			disarmed = TRUE
			icon_state = initial(icon_state)
		else
			explode_chance(user)

/obj/item/syndie/c4explosive/proc/explode_chance(var/mob/user)
	if(prob(10))
		to_chat(user, SPAN_WARNING("You think you cut the wrong wire!"))
		if(!primed)
			prime()
		else
			detonate()

/obj/item/syndie/c4explosive/heavy
	name = "C-4 bundle"
	desc = "Oh shit! That's a bundle of C-4 plastic explosives!"
	power = 2
	hidden = FALSE

/obj/item/syndie/c4explosive/Initialize(mapload, ...)
	. = ..()

	if(power > 1)
		size = "large"
	else
		size = "small"
	icon_state = "c-4[size]_0"
	item_state = "c-4[size]"

	var/K = rand(1, 2000)
	K = md5(num2text(K) + name)
	K = copytext(K, 1, 7)
	desc += " You see [K] engraved on \the [src]."

	var/obj/item/syndie/c4detonator/detonator = new(src.loc)
	detonator.desc += " You see [K] engraved on \the [src]."
	detonator.bomb = src

/obj/item/syndie/c4explosive/proc/prime()
	if(disarmed || primed)
		return
	primed = TRUE
	icon_state = "c-4[size]_1"
	addtimer(CALLBACK(src, .proc/detonate), 50)

/obj/item/syndie/c4explosive/proc/detonate()
	if(disarmed)
		return
	// extra damage to adjacent walls
	for(var/dirn in alldirs)
		var/turf/simulated/wall/T = get_step(src, dirn)
		if(istype(T, /turf/simulated/wall))
			T.take_damage(power * 20)
			continue
	explosion(get_turf(src), power, power*2, power*3, power*4, power*4)
	qdel(src)

// Detonator, disguised as a lighter
// Click it when closed to open, when open to bring up a prompt asking you if you want to close it or press the button.

/obj/item/syndie/c4detonator
	name = "\improper Zippo lighter" // Sneaky, thanks Dreyfus.
	desc = "The zippo. If you've spent that amount of money on a lighter, you're either a badass or a chain smoker."
	desc_antag = "This is a detonator. Upon pressing the button, a signal is sent to the linked bomb. After 5 seconds, it will explode."
	icon_state = "c-4detonator_0"
	item_state = "c-4detonator"
	w_class = ITEMSIZE_TINY

	var/obj/item/syndie/c4explosive/bomb
	var/cap_open = FALSE
	var/pr_open = FALSE // Is the "What do you want to do?" prompt open?

/obj/item/syndie/c4detonator/attack_self(mob/user)
	if(cap_open && !pr_open)
		pr_open = TRUE
		switch(alert(user, "What would you like to do?", "Lighter", "Press the button.", "Close the lighter."))
			if("Press the button.")
				to_chat(user, SPAN_NOTICE("You press the button."))
				flick("c-4detonator_click", src)
				if(bomb)
					bomb.prime()
					log_admin("[key_name(user)] has triggered [bomb] with [src].",ckey=key_name(user))
					message_admins("<span class='danger'>[key_name_admin(user)] has triggered [src.bomb] with [src].</span>")
			if("Close the lighter.")
				icon_state = "c-4detonator_0"
				to_chat(user, SPAN_NOTICE("You close \the [src]."))
				cap_open = FALSE
		pr_open = FALSE
	else
		icon_state = "c-4detonator_1"
		to_chat(user, SPAN_NOTICE( "You flick open \the [src]."))
		cap_open = TRUE

/obj/item/syndie/teleporter
	name = "pen"
	desc = "An instrument for writing or drawing with ink. This one is in black, in a classic, grey casing. Stylish, classic and professional."
	desc_antag = "While this may look like a bog-standard pen, in reality, this is a handheld teleportation device. Simply click on any turf within view to attempt to teleport there! The teleporter will recharge after a minute."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	maptext_x = 3
	maptext_y = 2
	var/ready_to_use = TRUE
	var/recharge_time = 1 MINUTE
	var/held_maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/syndie/teleporter/Initialize()
	. = ..()
	if(ismob(loc) || ismob(loc.loc))
		maptext = held_maptext

/obj/item/syndie/teleporter/attack()
	return

/obj/item/syndie/teleporter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!ready_to_use)
		to_chat(user, SPAN_WARNING("\The [src] isn't ready to use yet!"))
		return
	var/turf/T = target
	if(!istype(T))
		T = get_turf(target)
	if(!T)
		to_chat(user, SPAN_WARNING("Something has gone terribly wrong while choosing a target, please try again somewhere else!"))
		return
	if(T.density || T.contains_dense_objects())
		to_chat(user, SPAN_WARNING("You cannot teleport to a location with solid objects!"))
		return

	user.visible_message("<b>[user]</b> blinks into nothingness!", SPAN_NOTICE("You jump into the nothing."))
	user.forceMove(T)
	spark(user, 3, alldirs)
	user.visible_message("<b>[user]</b> appears out of thin air!", SPAN_NOTICE("You successfully step into your destination."))
	use()

/obj/item/syndie/teleporter/proc/check_maptext(var/new_maptext)
	if(new_maptext)
		held_maptext = new_maptext
	if(ismob(loc) || ismob(loc.loc))
		maptext = held_maptext
	else
		maptext = ""

/obj/item/syndie/teleporter/proc/use()
	addtimer(CALLBACK(src, .proc/recharge), recharge_time)
	ready_to_use = FALSE
	check_maptext("<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charge</span>")

/obj/item/syndie/teleporter/proc/recharge()
	ready_to_use = TRUE
	check_maptext("<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>")

/obj/item/syndie/teleporter/throw_at()
	..()
	check_maptext()

/obj/item/syndie/teleporter/dropped()
	..()
	check_maptext()

/obj/item/syndie/teleporter/on_give()
	check_maptext()

/obj/item/syndie/teleporter/pickup()
	..()
	addtimer(CALLBACK(src, .proc/check_maptext), 1)