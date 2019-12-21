/obj/item/bee_net
	name = "bee net"
	desc = "For catching rogue bees."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "bee_net"
	item_state = "bee_net"
	w_class = 3
	var/caught_bees = 0
	var/feralbees

/obj/item/bee_net/examine(var/mob/user)
	..()
	if (caught_bees)
		to_chat(user, span("notice", "It contains [caught_bees] bees"))
	else
		to_chat(user, span("notice", "It is empty"))

/obj/item/bee_net/attack_self(mob/user as mob)
	var/turf/T = get_step(get_turf(user), user.dir)
	for(var/mob/living/simple_animal/bee/B in T)
		capture_bees(B, user)
		break
	..()



/obj/item/bee_net/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if (istype(A, /turf))
		var/turf/T = A
		for(var/mob/living/simple_animal/bee/B in T)
			capture_bees(B, user)
			return 1
	else if (istype(A, /mob/living/simple_animal/bee))
		capture_bees(A, user)
		return 1
	else if (istype(A, /obj/machinery/beehive) && caught_bees)
		deposit_bees(A, user)
		return 1
	..(A, user, click_parameters)


/obj/item/bee_net/proc/capture_bees(var/mob/living/simple_animal/bee/target, var/mob/living/user)

	if (user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2)//make it harder to spamclick bees into submission
		user.do_attack_animation(target)


	//Instead of a hard limit on bee storage, a chance of critical failure equal to the number of contained bees
	if (caught_bees)
		if (prob(caught_bees))
			user.visible_message(span("danger","[user] fails at capturing bees and spills their overstuffed net."),span("danger","All the bees break free of your overstuffed net!"))
			empty_bees()
			return

	var/success = 0
	if(target.feral <= 0)
		success = 1//Caught em all
	else if (prob((target.feral*2)+15))
		success = 0//Missed and made them mad
	else
		success = rand()+0.2//Caught some of them
		success = min(success, 1)


	switch(success)
		if (1)
			user.visible_message(span("notice","[user] scoops up the bees."),span("notice","You scoop up [target.strength] of the docile bees."))
			caught_bees += target.strength
			target.strength = 0
			qdel(target)
		if (0)
			user.visible_message(span("danger","[user] swings at some angry bees, they don't seem to like it."),span("danger","You swing at some angry bees, and just manage to make them madder"))
			target.feral = 5
			target.target_mob = user
		else
			var/delta = round((target.strength*success), 1)
			delta = min(max(delta, 1), target.strength)
			if (delta >= target.strength)
				user.visible_message(span("warning","[user] scoops up the angry bees."),span("warning","You all [delta] of the angry bees, lucky!"))
			else
				user.visible_message(span("warning","[user] nets a couple of bees."),span("warning","You catch [delta] of the angry bees, others slip through your net"))

			caught_bees += delta
			target.strength -= delta
			feralbees = 1



			if (target.strength <= 0)
				qdel(target)

	if (!QDELETED(target))
		target.update_icons()



/obj/item/bee_net/proc/deposit_bees(var/obj/machinery/beehive/newhome, var/mob/user)
	if (!newhome.closed)
		var/delta = min(100 - newhome.bee_count, caught_bees)

		newhome.bee_count += delta
		caught_bees -= delta
		if (caught_bees <= 0)
			feralbees = 0
		user.visible_message(span("notice","[user] deposits [delta] bees into the hive."),span("notice","You deposit [delta] bees into the hive."))

		newhome.update_icon()
	else
		to_chat(user, span("warning", "You'll have to open the lid before you can place bees inside"))

/obj/item/bee_net/verb/empty_bees()
	set src in usr
	set name = "Empty bee net"
	set category = "Object"
	var/mob/living/carbon/M
	if(iscarbon(usr))
		M = usr

	while(caught_bees > 0)
		//release a few super massive swarms
		while(caught_bees >= 5)
			var/mob/living/simple_animal/bee/B = new(get_turf(src), null)
			B.feral = 0
			if (feralbees)
				//Theyre only angry when they come out if any of them were angry when they went in
				//Anger is contagious though
				B.feral = 5
				B.target_mob = M
			B.strength = 6
			B.update_icons()
			caught_bees -= 6

		//what's left over
		var/mob/living/simple_animal/bee/B = new(get_turf(src), null)
		B.strength = caught_bees
		B.feral = 0
		if (feralbees)
			B.feral = 5
			B.target_mob = M
		B.update_icons()
		caught_bees = 0

	feralbees = 0
