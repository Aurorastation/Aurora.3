/obj/item/towel
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/suit.dmi'
	)
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/towel/attack_self(mob/living/user)
	attack(user, user)

/obj/item/towel/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/M = target_mob

	if(istype(M) && user.a_intent == I_HELP)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(user.on_fire)
			user.visible_message(SPAN_WARNING("\The [user] uses \the [src] to pat out \the [M]'s flames with \the [src]!"))
			playsound(M, 'sound/weapons/towelwhip.ogg', 25, 1)
			M.ExtinguishMob(-1)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts drying \the [M] off with \the [src]..."))
			if(do_mob(user, M, 3 SECONDS))
				user.visible_message(SPAN_NOTICE("\The [user] dries \the [M] off with \the [src]."))
				playsound(M, 'sound/weapons/towelwipe.ogg', 25, 1)
				M.adjust_fire_stacks(-clamp(M.fire_stacks,-1.5,1.5))
		return

	. = ..()

/obj/item/towel/random/Initialize()
	. = ..()
	color = get_random_colour(1)

/obj/item/towel/verb/lay_out()
	set name = "Lay Out Towel"
	set category = "Object"
	set src in usr

	to_chat(usr, SPAN_NOTICE("You lay out \the [src] flat on the ground."))
	var/obj/item/towel_flat/T = new /obj/item/towel_flat(usr.loc)
	T.color = src.color
	qdel(src)

/obj/item/towel_flat
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel_flat"

/obj/item/towel_flat/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You pick up and fold \the [src]."))
	var/obj/item/towel/T = new /obj/item/towel(user)
	T.color = src.color
	user.put_in_hands(T)
	qdel(src)
