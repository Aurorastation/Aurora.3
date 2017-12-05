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

/obj/item/weapon/towel/attack_self(mob/living/user as mob)
	user.visible_message("<span class='notice'>\The [user] uses \the [src] to towel themselves off.</span>")
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)
	if(user.fire_stacks > 0)
		user.fire_stacks = (max(0, user.fire_stacks - 1.5))
	else if(user.fire_stacks < 0)
		user.fire_stacks = (min(0, user.fire_stacks + 1.5))

/obj/item/weapon/towel/random/Initialize()
	. = ..()
	color = get_random_colour(1)