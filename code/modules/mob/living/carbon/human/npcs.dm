/obj/item/clothing/under/punpun
	name = "fancy uniform"
	desc = "It looks like it was tailored for a monkey."
	icon_state = "punpun"
	worn_state = "punpun"
	species_restricted = list("Monkey")

/mob/living/carbon/human/monkey/punpun/New()
	..()
	spawn(1)
		name = "Pun Pun"
		real_name = name
		if(prob(10))
			w_uniform = new /obj/item/clothing/under/nupnup(src)
		else
			w_uniform = new /obj/item/clothing/under/punpun(src)

/obj/item/clothing/under/nupnup
	name = "christmas uniform"
	desc = "The uniform of Nup Nup, the Christmas monkey."
	icon_state = "punpun"
	worn_state = "nupnup"
	species_restricted = list("Monkey")

/mob/living/carbon/human/monkey/nupnup/New()
	..()
	spawn(1)
		name = "Winston, the Christmas Monkey"
		real_name = name
		w_uniform = new /obj/item/clothing/under/nupnup(src)