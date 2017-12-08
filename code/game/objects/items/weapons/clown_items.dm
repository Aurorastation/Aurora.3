/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Soap
 */
	..()
	create_reagents(10)
	wet()

	playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	reagents.add_reagent("cleaner", 10)

	if (istype(AM, /mob/living))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		user << "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>"
	else if(istype(target,/obj/effect/decal/cleanable))
		user << "<span class='notice'>You scrub \the [target.name] out.</span>"
		qdel(target)
	else if(istype(target,/turf))
		user << "You start scrubbing the [target.name]"
		if (do_after(user, 30, needhand = 0))
			user << "<span class='notice'>You scrub \the [target.name] clean.</span>"
			var/turf/T = target
			T.clean(src, user)
	else if(istype(target,/obj/structure/sink) || istype(target,/obj/structure/sink))
		user << "<span class='notice'>You wet \the [src] in the sink.</span>"
		wet()
		if (target.reagents && target.reagents.total_volume)
			user << "<span class='notice'>You wet \the [src] in the [target].</span>"
			wet()
		else
			user << "\The [target] is empty!"
	else
		user << "<span class='notice'>You clean \the [target.name].</span>"
		target.clean_blood()
	return

	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("<span class='danger'>\The [user] washes \the [target]'s mouth out with soap!</span>")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/*
 * Bike Horns
 */
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
