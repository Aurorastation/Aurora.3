/obj/item/organ/internal/augment/head_fluff
	name = "head augmentation"
	desc = "An augment installed inside the head of someone."
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/head_fluff/die()
	..()
	if (owner)
		to_chat(owner, SPAN_DANGER("You sense your [name] stops functioning!"))

/obj/item/organ/internal/augment/head_fluff/process()
	..()
	if (is_broken() && !ORGAN_DEAD)
		if (prob(5))
			to_chat(owner, SPAN_WARNING("You sense your [name] isn't working right!"))

/obj/item/organ/internal/augment/head_fluff/removed()
	if (owner)
		to_chat(owner, SPAN_DANGER("You lose your connection with \the [name]!"))
	..()


/obj/item/organ/internal/augment/head_fluff/chest_fluff
	name = "chest augmentation"
	desc = "An augment installed inside the chest of someone."
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/head_fluff/rhand_fluff
	name = "right hand augmentation"
	desc = "An augment installed inside the right hand of someone."
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/head_fluff/lhand_fluff
	name = "left hand augmentation"
	desc = "An augment installed inside the left hand of someone."
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/bioaug/head_fluff
	name = "head bioaug"
	desc = "A bioaug installed inside the head of someone."
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/bioaug/head_fluff/chest_fluff
	name = "chest bioaug"
	desc = "A bioaug installed inside the chest of someone."
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/bioaug/head_fluff/rhand_fluff
	name = "right hand bioaug"
	desc = "A bioaug installed inside the right hand of someone."
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/bioaug/head_fluff/lhand_fluff
	name = "left hand bioaug"
	desc = "A bioaug installed inside the left hand of someone."
	parent_organ = BP_L_HAND
