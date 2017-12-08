	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = 2.0
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/active = 0
	var/det_time = 50

	if((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>Huh? How does this thing work?</span>"

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1


	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		user << "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>"
		active = 1
		icon_state = initial(icon_state) + "_active"
		spawn(det_time)
			prime()
			return
		user.set_dir(get_dir(user, target))
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


	if(..(user, 0))
		if(det_time > 1)
			user << "The timer is set to [det_time/10] seconds."
			return
		if(det_time == null)
			return
		user << "\The [src] is set for instant detonation."


	if(!active)
		if(clown_check(user))
			user << "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>"

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user))

	icon_state = initial(icon_state) + "_active"
	active = 1

	spawn(det_time)
		prime()
		return


//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


	if(isscrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				user << "<span class='notice'>You set the [name] for 1 second detonation time.</span>"
			if (10)
				det_time = 30
				user << "<span class='notice'>You set the [name] for 3 second detonation time.</span>"
			if (30)
				det_time = 50
				user << "<span class='notice'>You set the [name] for 5 second detonation time.</span>"
			if (50)
				det_time = 1
				user << "<span class='notice'>You set the [name] for instant detonation.</span>"
		add_fingerprint(user)
	..()
	return

	walk(src, null, null)
	..()
	return
