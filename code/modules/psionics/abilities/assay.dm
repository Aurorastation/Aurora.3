/singleton/psionic_power/assay
	name = "Assay"
	desc = "Assay a creature's psionic level. Using Assay will also allow you to see psionic auras."
	icon_state = "wiz_blind"
	point_cost = 0
	ability_flags = PSI_FLAG_FOUNDATIONAL
	spell_path = /obj/item/spell/assay

/obj/item/spell/assay
	name = "assay"
	desc = "Read someone's psionic potential."
	icon_state = "generic"
	item_icons = null
	cast_methods = CAST_MELEE|CAST_INNATE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 2

/obj/item/spell/assay/on_innate_cast(mob/user)
	if(!isliving(user))
		return

	. = ..()
	if(!.)
		return

	var/mob/living/L = user

	to_chat(user, SPAN_NOTICE("You can now see psionic auras."))
	L.psi.show_auras()

/obj/item/spell/assay/Destroy()
	if(isliving(owner))
		var/mob/living/L = owner
		to_chat(L, SPAN_NOTICE("You can no longer see psionic auras."))
		L.psi.hide_auras()

	return ..()

/obj/item/spell/assay/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return

	if(!ishuman(hit_atom))
		return

	if(!isliving(user))
		return

	var/mob/living/carbon/human/target = hit_atom

	if(target.stat == DEAD || (target.status_flags & FAKEDEATH))
		to_chat(user, SPAN_WARNING("Psionic power does not flow through a dead person."))
		return

	var/psi_blocked = target.is_psi_blocked(user, FALSE)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	user.visible_message(SPAN_NOTICE("[user] lays both [user.get_pronoun("his")] palms on [target]'s temples..."),
						SPAN_NOTICE("You lay your palms on [target]'s temples and begin tracing their Nlom signature..."))
	if(do_mob(user, target, 4 SECONDS))
		var/target_psi_sensitivity = target.check_psi_sensitivity()

		// Not using a switch case here because I need finer control of the domain than is permitted by TO statements.
		if (target_psi_sensitivity < 0)
			to_chat(user, SPAN_NOTICE("[target] has little to no ability to sense the fabric that weaves this universe."))
		else if (target_psi_sensitivity < PSI_RANK_SENSITIVE)
			to_chat(user, SPAN_NOTICE("[target] has only a limited perception of psionic signals, like a typical human. They can hear psionics, but have limited ability to interpret them."))
		else if (target_psi_sensitivity < PSI_RANK_HARMONIOUS)
			to_chat(user, SPAN_NOTICE("[target] is psionically sensitive, just like your typical skrell. They are capable of interpreting telepathic signals."))
		else
			to_chat(user, SPAN_NOTICE("[target] is exceptionally capable of handling and interpreting psionic messages, doing so trivially and intuitively."))
