/obj/item/grenade
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
	contained_sprite = 1
	var/active = 0
	var/det_time = 30
	var/fake = FALSE

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1

/obj/item/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")


/obj/item/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [fake ? ("fake ") : ("")][src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user))

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()
		return


/obj/item/grenade/proc/prime()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
