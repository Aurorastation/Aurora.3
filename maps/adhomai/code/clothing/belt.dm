/obj/item/weapon/storage/belt/security/tactical/nka
	name = "military belt"
	desc = "A belt designated to hold ammunition and other related military gear.."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "nkacombat"
	item_state = "nkacombat"
	contained_sprite = TRUE

/obj/item/weapon/storage/belt/bandolier/nka
	name = "rifle bandolier"
	desc = "A pocketed belt designated to hold rifle cartridges."
	can_hold = list(/obj/item/ammo_casing/a762)
	var/amount = 30
	var/list/cartridges = new/list()

/obj/item/weapon/storage/belt/bandolier/nka/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user, "<span class='notice'>You pick up the [src].</span>")
				user.put_in_hands(src)

	return

/obj/item/weapon/storage/belt/bandolier/nka/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
	if(amount >= 1)
		amount--

		var/obj/item/ammo_casing/a762/P
		if(cartridges.len > 0)
			P = cartridges[cartridges.len]
			cartridges.Remove(P)
		else
			P = new /obj/item/ammo_casing/a762

		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return


/obj/item/weapon/storage/belt/bandolier/nka/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/ammo_casing/a762))
		var/obj/item/ammo_casing/a762/i = O
		user.drop_from_inventory(i,src)
		to_chat(user, "<span class='notice'>You put [i] in [src].</span>")
		cartridges.Add(i)
		amount++


/obj/item/weapon/storage/belt/bandolier/nka/examine(mob/user)
	if(get_dist(src, user) <= 1)
		if(amount)
			to_chat(user, "<span class='notice'>There " + (amount > 1 ? "are [amount] cartridges" : "is one catridge") + " in the bandolier.</span>")
		else
			to_chat(user, "<span class='notice'>There are no cartridges in the bandolier.</span>")
	return
