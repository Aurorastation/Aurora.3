/obj/aura/radiant_aura
	name = "radiant aura"
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield1"
	alpha = 75
	layer = ABOVE_WINDOW_LAYER

/obj/aura/radiant_aura/added_to(mob/living/user)
	..()
	to_chat(user, SPAN_NOTICE("A bubble of light appears around you, exuding protection and warmth."))
	set_light(6, 6, COLOR_AMBER)

/obj/aura/radiant_aura/Destroy()
	to_chat(user, SPAN_WARNING("Your protective aura dissipates, leaving you feeling cold and unsafe."))
	return ..()

/obj/aura/radiant_aura/bullet_act(obj/item/projectile/P, var/def_zone)
	if(P.check_armor == LASER)
		user.visible_message(SPAN_WARNING("\The [P] refracts, bending into \the [user]'s aura."))
		return AURA_FALSE
	return FALSE
