/obj/item/device/augment_implanter
	name = "augment implanter"
	desc = "A complex single use injector that is used to implant augments without the need for surgery."
	w_class = 3
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"
	contained_sprite = TRUE
	var/obj/item/organ/aug = null
	var/augument_type

/obj/item/device/augment_implanter/Initialize()
	. = ..()
	if(!aug && augument_type)
		aug = new augument_type(src)

/obj/item/device/augment_implanter/examine(mob/user)
	..(user)
	if(aug)
		to_chat(user, "\The [aug] can be seen floating inside \the [src]'s biogel.")

/obj/item/device/augment_implanter/afterattack(var/mob/living/L, var/mob/user, proximity)
	if(!proximity) return

	if(!aug)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return

	if(!ishuman(L))
		to_chat(user, SPAN_WARNING("\The [src] has no effect on \the [L]."))
		return

	var/mob/living/carbon/human/H = L

	if(!H.species.name in aug.species_restricted)
		to_chat(user, SPAN_WARNING("\The [aug] is not compatible with \the [H]'s body."))
		return

	aug.replaced(H, aug.parent_organ)
	H.update_body()
	aug = null

	user.visible_message(SPAN_DANGER("\The [user] thrusts \the [src] deep into \the [H], injecting something!"))

	return

/obj/item/device/augment_implanter/advanced_tesla
	augument_type = /obj/item/organ/internal/augment/tesla/advanced

/obj/item/device/augment_implanter/advanced_suspension
	augument_type =	/obj/item/organ/internal/augment/suspension/advanced

