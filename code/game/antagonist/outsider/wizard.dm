var/datum/antagonist/wizard/wizards

/datum/antagonist/wizard
	id = MODE_WIZARD
	role_text = "Space Wizard"
	role_text_plural = "Space Wizards"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "You will find a list of available spells in your spell book. Choose your magic arsenal carefully.<br>In your pockets you will find a teleport scroll. Use it as needed."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_NO_FLAVORTEXT
	antaghud_indicator = "hudwizard"
	required_age = 10

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

	faction = "Space Wizard"

/datum/antagonist/wizard/New()
	..()
	wizards = src

/datum/antagonist/wizard/create_objectives(var/datum/mind/wizard)

	if(!..())
		return

	var/kill
	var/escape
	var/steal
	var/hijack

	switch(rand(1,100))
		if(1 to 30)
			escape = 1
			kill = 1
		if(31 to 60)
			escape = 1
			steal = 1
		if(61 to 99)
			kill = 1
			steal = 1
		else
			hijack = 1

	if(kill)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = wizard
		kill_objective.find_target()
		wizard.objectives |= kill_objective
	if(steal)
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = wizard
		steal_objective.find_target()
		wizard.objectives |= steal_objective
	if(escape)
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = wizard
		wizard.objectives |= survive_objective
	if(hijack)
		var/datum/objective/hijack/hijack_objective = new
		hijack_objective.owner = wizard
		wizard.objectives |= hijack_objective
	return

/datum/antagonist/wizard/update_antag_mob(var/datum/mind/wizard)
	..()
	wizard.store_memory("<B>Remember:</B> do not forget to prepare your spells.")

/datum/antagonist/wizard/set_antag_name(mob/living/player)
	player.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	player.name = player.real_name
	var/newname = sanitize(input(player, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if(newname)
		player.real_name = newname
		player.name = player.real_name
		player.dna.real_name = newname
	if(player.mind)
		player.mind.name = player.name
	// Update any ID cards.
	update_access(player)

/datum/antagonist/wizard/equip(var/mob/living/carbon/human/player)

	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/wizard, FALSE)
	player.equipOutfit(/datum/outfit/admin/wizard, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

/datum/antagonist/wizard/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - wizard killed")
		to_world("<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been killed by the crew! The Space Wizards Federation has been taught a lesson they will not soon forget!</font></span>")


//To batch-remove wizard spells. Linked to mind.dm.
/mob/proc/spellremove()
	for(var/spell/spell_to_remove in src.spell_list)
		remove_spell(spell_to_remove)

obj/item/clothing
	var/wizard_garb = 0

// Does this clothing slot count as wizard garb? (Combines a few checks)
/proc/is_wiz_garb(var/obj/item/clothing/C)
	return C && C.wizard_garb

/*Checks if the wizard is wearing the proper attire.
Made a proc so this is not repeated 14 (or more) times.*/
/mob/proc/wearing_wiz_garb()
	to_chat(src, "Silly creature, you're not a human. Only humans can cast this spell.")
	return 0

// Humans can wear clothes.
/mob/living/carbon/human/wearing_wiz_garb()
	if(!is_wiz_garb(src.wear_suit) && (!src.species.hud || (slot_wear_suit in src.species.hud.equip_slots)))
		to_chat(src, "<span class='warning'>I don't feel strong enough without my robes.</span>")
		return 0
	if(!is_wiz_garb(src.head) && (!species.hud || (slot_head in src.species.hud.equip_slots)))
		to_chat(src, "<span class='warning'>I don't feel strong enough without my headwear.</span>")
		return 0
	return 1
