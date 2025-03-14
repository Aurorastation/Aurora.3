/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_grenade.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_grenade.dmi',
		)
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	contained_sprite = 1
	var/active = 0
	var/det_time = 30
	var/fake = FALSE
	var/activation_sound = 'sound/weapons/armbomb.ogg'

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_WARNING("Huh? How does this thing work?"))

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1

/obj/item/grenade/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 0)
		if(det_time > 1)
			. += SPAN_NOTICE("The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		. += SPAN_NOTICE("\The [src] is set for instant detonation.")

/obj/item/grenade/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/gun/launcher/grenade))
		var/obj/item/gun/launcher/grenade/G = attacking_item
		G.load(src, user)
	else
		..()

/obj/item/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, SPAN_WARNING("You prime \the [name]! [det_time/10] seconds!"))

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
			message_admins("[user.name] primed \a [fake ? ("fake ") : ("")][src] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = TRUE
	playsound(loc, activation_sound, 75, 1, -3)

	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)
	// Randomize the timing a bit. You wouldn't be aware of when exactly a grenade is going to pop.
	// Nor do we want people to instantly know when to throw a perfectly timed grenade.
	animate(src, det_time + rand(-5, 5), -1, LINEAR_EASING, color = COLOR_RED)

/obj/item/grenade/proc/prime()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

	if(ishuman(loc))
		var/mob/living/carbon/human/victim = loc
		var/obj/item/organ/external/exploded_hand
		if(victim.hand == src)
			exploded_hand = victim.organs_by_name[BP_R_HAND]
		else if(victim.l_hand == src)
			exploded_hand = victim.organs_by_name[BP_L_HAND]
		explode_in_hand(victim, exploded_hand)

/// This proc is called when the grenade explodes in your hand or on you. Exploded_hand can be null in case the grenade explodes in a pocket or something.
/obj/item/grenade/proc/explode_in_hand(var/mob/living/carbon/human/victim, var/obj/item/organ/external/exploded_hand)
	SHOULD_CALL_PARENT(TRUE)
	if(exploded_hand)
		to_chat(victim, SPAN_HIGHDANGER("\The [src] goes off in your hand!"))
	else
		to_chat(victim, SPAN_HIGHDANGER("\The [src] goes off on you!"))

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/grenade/vendor_action(var/obj/machinery/vending/V)
	activate(V)
