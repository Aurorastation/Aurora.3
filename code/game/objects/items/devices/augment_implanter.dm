/obj/item/device/augment_implanter
	name = "augment implanter"
	desc = "A complex single use injector that is used to implant augments without the need for surgery."
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"
	contained_sprite = TRUE
	var/obj/item/organ/augment_type

/obj/item/device/augment_implanter/Initialize()
	. = ..()
	if(!augment_type)
		augment_type = new augment_type(src)

/obj/item/device/augment_implanter/examine(mob/user)
	..(user)
	if(augment_type)
		to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [augment_type] can be seen floating inside \the [src]'s biogel.")))

/obj/item/device/augment_implanter/afterattack(mob/living/L, mob/user, proximity)
	if(!proximity)
		return

	if(!augment_type)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return

	if(!ishuman(L))
		to_chat(user, SPAN_WARNING("\The [src] has no effect on \the [L]."))
		return

	var/mob/living/carbon/human/H = L

	if(!(H.species.name in augment_type.species_restricted))
		to_chat(user, SPAN_WARNING("\The [augment_type] is not compatible with \the [H]'s body."))
		return

	if(H.internal_organs_by_name[augment_type.organ_tag])
		to_chat(user, SPAN_WARNING("\The [H] already has a [augment_type]."))
		return

	if(!do_mob(user, H, 4 SECONDS))
		return

	augment_type.replaced(H, augment_type.parent_organ)
	H.update_body()
	H.updatehealth()
	H.UpdateDamageIcon()
	augment_type = null

	user.visible_message(SPAN_WARNING("\The [user] thrusts \the [src] deep into \the [H], injecting something!"))

/obj/item/device/augment_implanter/advanced_tesla
	augment_type = /obj/item/organ/internal/augment/tesla/advanced

/obj/item/device/augment_implanter/advanced_suspension
	augment_type =	/obj/item/organ/internal/augment/suspension/advanced
