/obj/item/syndie
	icon = 'icons/obj/syndieweapons.dmi'

/*C-4 explosive charge and etc, replaces the old syndie transfer valve bomb.*/


/*The explosive charge itself.  Flashes for five seconds before exploding.*/

/obj/item/syndie/c4explosive
	icon_state = "c-4small_0"
	item_state = "c-4small"
	name = "normal-sized package"
	desc = "A small wrapped package."
	w_class = 3

	var/power = 1  /*Size of the explosion.*/
	var/size = "small"  /*Used for the icon, this one will make c-4small_0 for the off state.*/

/obj/item/syndie/c4explosive/heavy
	icon_state = "c-4large_0"
	item_state = "c-4large"
	desc = "A mysterious package, it's quite heavy."
	power = 2
	size = "large"

/obj/item/syndie/c4explosive/New()
	var/K = rand(1,2000)
	K = md5(num2text(K)+name)
	K = copytext(K,1,7)
	src.desc += "\n You see [K] engraved on \the [src]."
	var/obj/item/syndie/c4detonator/detonator = new(src.loc)
	detonator.desc += "\n You see [K] engraved on the lighter."
	detonator.bomb = src

/obj/item/syndie/c4explosive/proc/detonate()
	icon_state = "c-4[size]_1"
	spawn(50)
		explosion(get_turf(src), power, power*2, power*3, power*4, power*4)
		for(var/dirn in cardinal)		//This is to guarantee that C4 at least breaks down all immediately adjacent walls and doors.
			var/turf/simulated/wall/T = get_step(src,dirn)
			if(locate(/obj/machinery/door/airlock) in T)
				var/obj/machinery/door/airlock/D = locate() in T
				if(D.density)
					D.open()
			if(istype(T,/turf/simulated/wall))
				T.dismantle_wall(1)
		qdel(src)


/*Detonator, disguised as a lighter*/
/*Click it when closed to open, when open to bring up a prompt asking you if you want to close it or press the button.*/

/obj/item/syndie/c4detonator
	icon_state = "c-4detonator_0"
	item_state = "c-4detonator"
	name = "\improper Zippo lighter"  /*Sneaky, thanks Dreyfus.*/
	desc = "The zippo."
	w_class = 1

	var/obj/item/syndie/c4explosive/bomb
	var/pr_open = 0  /*Is the "What do you want to do?" prompt open?*/

/obj/item/syndie/c4detonator/attack_self(mob/user as mob)
	switch(src.icon_state)
		if("c-4detonator_0")
			src.icon_state = "c-4detonator_1"
			to_chat(user, "You flick open the lighter.")

		if("c-4detonator_1")
			if(!pr_open)
				pr_open = 1
				switch(alert(user, "What would you like to do?", "Lighter", "Press the button.", "Close the lighter."))
					if("Press the button.")
						to_chat(user, "<span class='warning'>You press the button.</span>")
						flick("c-4detonator_click", src)
						if(src.bomb)
							src.bomb.detonate()
							log_admin("[key_name(user)] has triggered [src.bomb] with [src].",ckey=key_name(user))
							message_admins("<span class='danger'>[key_name_admin(user)] has triggered [src.bomb] with [src].</span>")

					if("Close the lighter.")
						src.icon_state = "c-4detonator_0"
						to_chat(user, "You close the lighter.")
				pr_open = 0

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