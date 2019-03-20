/obj/item/weapon/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	w_class = 1.0
	slot_flags = SLOT_EARS
	var/colour = "red"
	var/open = 0


/obj/item/weapon/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/weapon/lipstick/jade
	name = "jade lipstick"
	colour = "jade"

/obj/item/weapon/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/weapon/lipstick/pink
	name = "pink lipstick"
	colour = "pink"

/obj/item/weapon/lipstick/random
	name = "lipstick"

/obj/item/weapon/lipstick/random/New()
	colour = pick("red","purple","jade","pink","black")
	name = "[colour] lipstick"


/obj/item/weapon/lipstick/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You twist \the [src] [open ? "closed" : "open"].</span>")
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)	return

	if(!istype(M, /mob))	return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, "<span class='notice'>You need to wipe off the old lipstick first!</span>")
			return
		if(H == user)
			user.visible_message("<span class='notice'>[user] does their lips with \the [src].</span>", \
								 "<span class='notice'>You take a moment to apply \the [src]. Perfect!</span>")
			H.lip_style = colour
			H.update_body()
		else
			user.visible_message("<span class='warning'>[user] begins to do [H]'s lips with \the [src].</span>", \
								 "<span class='notice'>You begin to apply \the [src].</span>")
			if(do_after(user, 20) && do_after(H, 20, 0))	//user needs to keep their active hand, H does not.
				user.visible_message("<span class='notice'>[user] does [H]'s lips with \the [src].</span>", \
									 "<span class='notice'>You apply \the [src].</span>")
				H.lip_style = colour
				H.update_body()
	else
		to_chat(user, "<span class='notice'>Where are the lips on that?</span>")

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()


/obj/item/weapon/haircomb //sparklysheep's comb
	name = "purple comb"
	desc = "A pristine purple comb made from flexible plastic."
	w_class = 1.0
	slot_flags = SLOT_EARS
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	item_state = "purplecomb"

/obj/item/weapon/haircomb/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] uses [src] to comb their hair with incredible style and sophistication. What a [user.gender == FEMALE ? "lady" : "guy"].</span>")

/obj/item/weapon/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "razor"
	w_class = 2

/obj/item/weapon/razor/proc/shave(mob/living/carbon/human/H, location)
	if(location == "head")
		H.h_style = H.species.default_h_style
	else
		H.f_style = H.species.default_f_style

	H.update_hair()
	playsound(H, 'sound/items/welder2.ogg', 20, 1)


/obj/item/weapon/razor/attack(mob/M, mob/user, var/target_zone)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return FALSE

	if(!ishuman_species(H) && !istajara(H))	//you can only shave humans and tajara for obvious reasons
		return FALSE


	if(target_zone == "head")
		if(H.head && (H.head.body_parts_covered & HEAD))
			to_chat(user, "<span class='warning'>\The [H.head] is in the way!</span>")
			return FALSE

		if(H.h_style == "Bald" || H.h_style == "Balding Hair" || H.h_style == "Skinhead" || H.h_style == "Tajaran Ears")
			to_chat(user, "<span class='warning'>There is not enough hair left to shave!</span>")
			return FALSE

		if(H == user) //shaving yourself
			user.visible_message("\The [user] starts to shave \his head with \the [src].", \
									 "<span class='notice'>You start to shave your head with \the [src].</span>")
			if(do_mob(user, user, 20))
				user.visible_message("\The [user] shaves \his head with \the [src].", \
										 "<span class='notice'>You finish shaving with \the [src].</span>")
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message("<span class='warning'>\The [user] tries to shave \the [H]'s head with \the [src]!</span>", \
									 "<span class='notice'>You start shaving [H]'s head.</span>")
			if(do_mob(user, H, 20))
				user.visible_message("<span class='warning'>\The [user] shaves \the [H]'s head bald with \the [src]!</span>", \
											 "<span class='notice'>You shave \the [H]'s head bald.</span>")
				shave(H, target_zone)

				return TRUE

	else if(target_zone == "mouth")

		if(H.head && (H.head.body_parts_covered & FACE))
			to_chat(user, "<span class='warning'>\The [H.head] is in the way!</span>")
			return FALSE

		if(H.wear_mask && (H.wear_mask.body_parts_covered & FACE))
			to_chat(user, "<span class='warning'>\The [H.wear_mask] is in the way!</span>")
			return FALSE

		if(H.f_style == "Shaved")
			to_chat(user, "<span class='warning'>There is not enough facial hair left to shave!</span>")
			return	FALSE

		if(H == user) //shaving yourself
			user.visible_message("<span class='warning'>\The [user] starts to shave \his facial hair with \the [src].</span>", \
									 "<span class='notice'>You take a moment to shave your facial hair with \the [src].</span>")
			if(do_mob(user, user, 20))
				user.visible_message("<span class='warning'>\The [user] shaves \his facial hair clean with \the [src].</span>", \
										 "<span class='notice'>You finish shaving with \the [src].</span>")
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message("<span class='warning'>\The [user] tries to shave \the [H]'s facial hair with \the [src].</span>", \
									 "<span class='notice'>You start shaving [H]'s facial hair.</span>")
			if(do_mob(user, H, 20))
				user.visible_message("<span class='warning'>\The [user] shaves off \the [H]'s facial hair with \the [src].</span>", \
											 "<span class='notice'>You shave [H]'s facial hair clean off.</span>")
				shave(H, target_zone)

				return TRUE


	else
		to_chat(user, "<span class='warning'>You need to target the mouth or head to shave \the [H]!</span>")
		return


