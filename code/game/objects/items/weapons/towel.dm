/obj/item/weapon/towel
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	force = 1
	w_class = 3
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/weapon/towel/attack_self(mob/living/user as mob)
	attack(user,user)

/obj/item/weapon/towel/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	if(istype(M) && user.a_intent == I_HELP)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(user.on_fire)
			user.visible_message("<span class='warning'>\The [user] uses \the [src] to pat out \the [M]'s flames with \the [src]!</span>")
			playsound(M, 'sound/weapons/towelwhip.ogg', 25, 1)
			M.ExtinguishMob(-1)
		else
			user.visible_message("<span class='notice'>\The [user] starts drying \the [M] off with \the [src]...</span>")
			if(do_mob(user, M, 3 SECONDS))
				user.visible_message("<span class='notice'>\The [user] dries \the [M] off with \the [src].</span>")
				playsound(M, 'sound/weapons/towelwipe.ogg', 25, 1)
				M.adjust_fire_stacks(-Clamp(M.fire_stacks,-1.5,1.5))
		return

	. = ..()

/obj/item/weapon/towel/random/Initialize()
	. = ..()
	color = get_random_colour(1)