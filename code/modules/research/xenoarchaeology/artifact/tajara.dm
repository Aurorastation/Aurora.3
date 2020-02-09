/obj/item/incarnate_banner
	name = "tattered banner"
	desc = "An old tattered flag bearing a long forgotten symbol."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "banner"
	item_state = "banner"
	var/real_deal = FALSE

/obj/item/incarnate_banner/proc/burnup()
	if(real_deal)
		return
	var/turf/O = get_turf(src)
	new /obj/effect/decal/cleanable/ash(O)
	qdel(src)

/obj/item/incarnate_banner/pickup(mob/living/user as mob)
	..()
	if(real_deal)
		if(istajara(user))
			if(prob(5))
				to_chat(user, "<span class='warning'>As you pick up \the [src], your mind is invaded by the visions of an ancient Tajaran battlefield..</span>")
				flick("e_flash", user.flash)

/obj/item/incarnate_banner/ex_act(severity)
	if(real_deal)
		return
	else
		qdel(src)

/obj/item/incarnate_banner/fire_act()
	if(real_deal)
		return
	else
		burnup()

/obj/item/incarnate_banner/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			if(real_deal)
				user.visible_message("<span class='danger'>\The [user] fails to lights \the [name] on fire.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] lights \the [name] with [W].</span>")
				burnup()

	else if(isflamesource(W))
		if(real_deal)
			user.visible_message("<span class='danger'>\The [user] fails to lights \the [name] on fire.</span>")
		else
			user.visible_message("<span class='danger'>\The [user] lights \the [name] with [W].</span>")
			burnup()

	else if(istype(W, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = W
		if(C.lit)
			if(real_deal)
				user.visible_message("<span class='danger'>\The [user] fails to lights \the [name] on fire.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] lights \the [name] with [W].</span>")
				burnup()

	else if(istype(W, /obj/item/grenade/dynamite))
		var/obj/item/grenade/dynamite/C = W
		if(C.active)
			if(real_deal)
				user.visible_message("<span class='danger'>\The [user] fails to lights \the [name] on fire.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] lights \the [name] with [W].</span>")
				burnup()


/obj/item/incarnate_banner/real
	real_deal = TRUE

/obj/item/storage/box/dynamite/fake
	starts_with = list(/obj/item/incarnate_banner = 1)

/obj/item/storage/box/dynamite/real
	starts_with = list(/obj/item/incarnate_banner/real = 1)