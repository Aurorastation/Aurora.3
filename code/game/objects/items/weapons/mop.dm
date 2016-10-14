/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = 3.0
	attack_verb = list("mopped", "bashed", "cleaned", "scrubbed", "whacked")
	var/mopping = 0
	var/mopcount = 0
	var/cleaningTime = 40//Time in deciseconds needed to clean a tile
	var/capacity = 30//Quantity of reagents the mop holds


/obj/item/weapon/mop/New()
	create_reagents(capacity)

/obj/item/weapon/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
		if(reagents.total_volume < 1)
			user << "<span class='notice'>Your mop is too dry to clean things!</span>"
			return

		user.visible_message("<span class='warning'>[user] begins to clean \the [get_turf(A)].</span>")
		var/datum/reagent/main = reagents.get_master_reagent()
		var/cleaningdiv = 1
		if (main.cleaning_power)
			cleaningdiv = main.cleaning_power//better cleaners clean faster

		if(do_after(user, cleaningTime/cleaningdiv))
			var/turf/T = get_turf(A)
			if(T)
				reagents.trans_to_turf(T, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

				if (main.cleaning_power)
					T.clean(src)

			user << "<span class='notice'>You have finished mopping!</span>"

		else
			user << "<span class='warning'>You gave up on mopping the floor.</span>"
	else
		reagents.trans_to(A, 4, 2.5, 0)//transfer reagents to mobs and objects



/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/soap))
		return
	..()
