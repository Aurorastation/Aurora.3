/mob/living/carbon/alien/diona/attack_hand(mob/living/carbon/human/M as mob)
	if(istype(M) && M.a_intent == I_HELP && !(src.stat & DEAD))
		if(M.species && M.species.name == "Diona" && do_merge(M))
			return
		M.visible_message("\blue [M] pets the [src]")
		return
	else if (src.stat & DEAD)
		get_scooped(M)
	..()

/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()
		return ..()
	get_scooped(H, usr)
	return

/mob/living/carbon/alien/diona/attackby(var/obj/item/weapon/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			user << "<span class='warning'>\The [src] is already wearing \the [hat].</span>"
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
