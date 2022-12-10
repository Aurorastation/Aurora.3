/obj/item/clothing/under/punpun
	name = "fancy uniform"
	desc = "It looks like it was tailored for a monkey."
	icon_state = "punpun"
	worn_state = "punpun"
	species_restricted = list(BODYTYPE_MONKEY)

/mob/living/carbon/human/monkey/punpun/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/monkey/punpun/LateInitialize()
	name = "Pun Pun"
	real_name = name
	named = TRUE
	gender = MALE

	equip_to_slot(new /obj/item/clothing/under/punpun(src), slot_w_uniform)

/obj/item/clothing/under/nupnup
	name = "christmas uniform"
	desc = "The uniform of Nup Nup, the Christmas monkey."
	icon_state = "punpun"
	worn_state = "nupnup"
	species_restricted = list(BODYTYPE_MONKEY)

/mob/living/carbon/human/monkey/nupnup/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/monkey/nupnup/LateInitialize()
	name = "Winston, the Christmas Monkey"
	real_name = name
	gender = MALE
	w_uniform = new /obj/item/clothing/under/nupnup(src)
