/obj/item/haircomb //sparklysheep's comb
	name = "plastic comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "comb"
	item_state = "comb"

/obj/item/haircomb/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/haircomb/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("[user] uses [src] to comb their hair with incredible style and sophistication. What a [user.gender == FEMALE ? "lady" : "guy"]."))

/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "razor"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/razor/proc/shave(mob/living/carbon/human/H, location)
	if(location == BP_HEAD)
		H.h_style = H.species.default_h_style
	else
		H.f_style = H.species.default_f_style

	H.update_hair()
	playsound(H, 'sound/items/welder_pry.ogg', 20, 1)


/obj/item/razor/attack(mob/M, mob/user, var/target_zone)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, SPAN_DANGER("They are missing that limb!"))
		return FALSE

	if(!ishuman_species(H) && !istajara(H))	//you can only shave humans and tajara for obvious reasons
		return FALSE


	if(target_zone == BP_HEAD)
		if(H.head && (H.head.body_parts_covered & HEAD))
			to_chat(user, SPAN_WARNING("\The [H.head] is in the way!"))
			return FALSE

		if(H.h_style == "Bald" || H.h_style == "Balding Hair" || H.h_style == "Skinhead" || H.h_style == "Tajaran Ears")
			to_chat(user, SPAN_WARNING("There is not enough hair left to shave!"))
			return FALSE

		if(H == user) //shaving yourself
			user.visible_message("\The [user] starts to shave [user.get_pronoun("his")] head with \the [src].", \
									SPAN_NOTICE("You start to shave your head with \the [src]."))
			if(do_mob(user, user, 20))
				user.visible_message("\The [user] shaves [user.get_pronoun("his")] head with \the [src].", \
										SPAN_NOTICE("You finish shaving with \the [src]."))
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message(SPAN_WARNING("\The [user] tries to shave \the [H]'s head with \the [src]!"), \
									SPAN_NOTICE("You start shaving [H]'s head."))
			if(do_mob(user, H, 20))
				user.visible_message(SPAN_WARNING("\The [user] shaves \the [H]'s head bald with \the [src]!"), \
										SPAN_NOTICE("You shave \the [H]'s head bald."))
				shave(H, target_zone)

				return TRUE

	else if(target_zone == BP_MOUTH)

		if(H.head && (H.head.body_parts_covered & FACE))
			to_chat(user, SPAN_WARNING("\The [H.head] is in the way!"))
			return FALSE

		if(H.wear_mask && (H.wear_mask.body_parts_covered & FACE))
			to_chat(user, SPAN_WARNING("\The [H.wear_mask] is in the way!"))
			return FALSE

		if(H.f_style == "Shaved")
			to_chat(user, SPAN_WARNING("There is not enough facial hair left to shave!"))
			return	FALSE

		if(H == user) //shaving yourself
			user.visible_message(SPAN_WARNING("\The [user] starts to shave [user.get_pronoun("his")] facial hair with \the [src]."), \
									SPAN_NOTICE("You take a moment to shave your facial hair with \the [src]."))
			if(do_mob(user, user, 20))
				user.visible_message(SPAN_WARNING("\The [user] shaves [user.get_pronoun("his")] facial hair clean with \the [src]."), \
										SPAN_NOTICE("You finish shaving with \the [src]."))
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message(SPAN_WARNING("\The [user] tries to shave \the [H]'s facial hair with \the [src]."), \
									SPAN_NOTICE("You start shaving [H]'s facial hair."))
			if(do_mob(user, H, 20))
				user.visible_message(SPAN_WARNING("\The [user] shaves off \the [H]'s facial hair with \the [src]."), \
										SPAN_NOTICE("You shave [H]'s facial hair clean off."))
				shave(H, target_zone)

				return TRUE


	else
		to_chat(user, SPAN_WARNING("You need to target the mouth or head to shave \the [H]!"))
		return


