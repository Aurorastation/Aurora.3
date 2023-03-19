/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_grenade.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_grenade.dmi',
		)
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
	var/activation_sound = 'sound/weapons/armbomb.ogg'

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

/obj/item/grenade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/gun/launcher/grenade))
		var/obj/item/gun/launcher/grenade/G = W
		G.load(src, user)
	else
		..()

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


/obj/item/grenade/proc/activate(var/atom/user)
	if(active)
		return

	if(user) //Prevents runtimes with grenade launchers, which create their own admin message
		if(ismob(user))
			var/mob/M = user
			admin_attack_log(M, attacker_message = "primed \a [fake ? (" fake") : ("")][src]!", admin_message = "primed \a [fake ? ("fake ") : ("")][src]!")
		else
			message_admins("[user.name] primed \a [fake ? ("fake ") : ("")][src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = TRUE
	playsound(loc, activation_sound, 75, 1, -3)

	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)

/obj/item/grenade/proc/prime()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/grenade/vendor_action(var/obj/machinery/vending/V)
	activate(V)
