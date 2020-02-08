/obj/item/incarnate_banner
	name = "tattered banner"
	desc = "An old tattered flag bearing a long forgotten symbol."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "banner"
	item_state = "banner"
	var/real_deal = FALSE

/obj/item/incarnate_banner/pickup(mob/living/user as mob)
	..()
	if(real_deal)
		if(istajara(user))
			if(prob(5))
				to_chat(user, "<span class='warning'>As you pick up \the [src], your mind is invaded by the visions of an ancient Tajaran battlefield..</span>")
				flick("e_flash", user.flash)

/obj/item/incarnate_banner/real
	real_deal = TRUE

/obj/item/storage/box/dynamite/fake
	starts_with = list(/obj/item/incarnate_banner = 1)

/obj/item/storage/box/dynamite/real
	starts_with = list(/obj/item/incarnate_banner/real = 1)