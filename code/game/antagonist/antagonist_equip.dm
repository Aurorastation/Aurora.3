/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return FALSE

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			player.drop_from_inventory(thing)
			if(thing.loc != player)
				qdel(thing)

	player.species.before_equip(player)

	if(HAS_FLAG(flags, ANTAG_CLEAR_EQUIPMENT) && has_idris_account)
		var/datum/money_account/money_account = SSeconomy.create_account("John Doe", rand(idris_account_min, idris_account_max), null, FALSE)
		if(player.mind)
			var/remembered_info = ""
			remembered_info += "<b>Your account number is:</b> #[money_account.account_number]<br>"
			remembered_info += "<b>Your account pin is:</b> [money_account.remote_access_pin]<br>"
			remembered_info += "<b>Your account funds are:</b> [money_account.money]电<br>"

			if(money_account.transactions.len)
				var/datum/transaction/transaction = money_account.transactions[1]
				remembered_info += "<b>Your account was created:</b> [transaction.time], [transaction.date] at [transaction.source_terminal]<br>"
			player.mind.store_memory(remembered_info)
			player.mind.initial_account = money_account

	return TRUE

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1

/datum/antagonist/proc/get_antag_radio()
	return

/datum/antagonist/proc/give_codewords(mob/living/traitor_mob)
	to_chat(traitor_mob, "<u><b>Your employers/contacts provided you with the following information on how to identify possible allies:</b></u>")
	to_chat(traitor_mob, "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>")
	to_chat(traitor_mob, "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>")
	traitor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	to_chat(traitor_mob, "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")
