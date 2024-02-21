/singleton/psionic_power/rejuvenate
	name = "Rejuvenate"
	desc = "Restore a creature's blood."
	icon_state = "tech_oxygenate"
	point_cost = 1
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/rejuvenate

/obj/item/spell/rejuvenate
	name = "rejuvenate"
	desc = "Blood bag who?"
	icon_state = "mend_life"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 30

/obj/item/spell/rejuvenate/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!ishuman(hit_atom))
		return

	var/mob/living/carbon/human/target = hit_atom
	if(!target.has_zona_bovinae())
		to_chat(user, SPAN_WARNING("Psionic power cannot flow through this being."))
		return

	if(target.stat == DEAD || target.status_flags & FAKEDEATH)
		to_chat(user, SPAN_WARNING("Psionic power does not flow through a dead person."))
		return

	. = ..()
	if(!.)
		return

	user.visible_message(SPAN_NOTICE("[user] lays both palms on [target]..."), SPAN_NOTICE("You lay your palms on [target] and get to work."))
	if(do_mob(user, target, 10 SECONDS))
		target.restore_blood()
	user.visible_message(SPAN_NOTICE("[user] removes their palms from [target]."), SPAN_NOTICE("You remove your palms from [target], having restored their blood."))
