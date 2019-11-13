/obj/structure/tranqcabinet
	name = "tranquilizer rifle cabinet"
	desc = "A wall mounted cabinet designed to hold a tranquilizer rifle."
	icon = 'icons/obj/closet.dmi'
	icon_state = "tranq_closed"
	anchored = 1
	density = 0
	var/obj/item/gun/projectile/heavysniper/tranq/has_tranq
	var/opened = 0

/obj/structure/tranqcabinet/New()
	..()
	has_tranq = new/obj/item/gun/projectile/heavysniper/tranq(src)

/obj/structure/tranqcabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/gun/projectile/heavysniper/tranq))
		if(!has_tranq && opened)
			user.remove_from_mob(O)
			contents += O
			has_tranq = O
			to_chat(user, "<span class='notice'>You place [O] in [src].</span>")
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/tranqcabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (!user.can_use_hand())
		return
	if(has_tranq)
		user.put_in_hands(has_tranq)
		to_chat(user, "<span class='notice'>You take [has_tranq] from [src].</span>")
		has_tranq = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/tranqcabinet/attack_tk(mob/user)
	if(has_tranq)
		has_tranq.forceMove(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove [has_tranq] from [src].</span>")
		has_tranq = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/tranqcabinet/update_icon()
	if(!opened)
		icon_state = "tranq_closed"
		return
	if(has_tranq)
		icon_state = "tranq_full"
	else
		icon_state = "tranq_empty"