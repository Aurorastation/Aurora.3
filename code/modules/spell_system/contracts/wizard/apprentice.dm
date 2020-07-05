/obj/item/contract/apprentice
	name = "apprentice wizarding contract"
	desc = "A wizarding school contract for those who want to sign their soul for a piece of the magic pie."
	color = "#993300"
	var/list/additional_spells = list()

/obj/item/contract/apprentice/contract_effect(mob/user)
	if(user.mind.assigned_role == "Apprentice")
		to_chat(user, SPAN_WARNING("You are already a wizarding apprentice!"))
		return FALSE
	if(wizards.add_antagonist_mind(user.mind, TRUE, "Apprentice", "<b>You are an apprentice! Your job is to learn the wizarding arts!</b>"))
		user.mind.assigned_role = "Apprentice"
		to_chat(user, SPAN_NOTICE("With the signing of this paper you agree to become \the [contract_master]'s apprentice in the art of wizardry."))
		user.faction = "Space Wizard"
		wizards.add_antagonist_mind(user.mind, TRUE)
		var/obj/item/spellbook/student/S = new /obj/item/spellbook/student(get_turf(user))
		for(var/additional_spell in additional_spells)
			S.spellbook.spells[additional_spell] = additional_spells[additional_spell]
		user.put_in_hands(S)
		user.add_spell(new /spell/noclothes)
		if(contract_master)
			user.add_spell(new /spell/contract/return_master(contract_master), "const_spell_ready")
		return TRUE
	return FALSE