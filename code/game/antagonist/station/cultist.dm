var/datum/antagonist/cultist/cult

/proc/iscultist(var/mob/player)
	if(!cult || !player.mind)
		return 0
	if(player.mind in cult.current_antagonists)
		return 1

/proc/iscult(var/mob/test)
	if (test.faction == "cult")
		return 1

	else return iscultist(test)

/datum/antagonist/cultist
	id = MODE_CULTIST
	role_text = "Cultist"
	role_text_plural = "Cultists"
	bantype = "cultist"
	restricted_jobs = list("Chaplain","AI", "Cyborg", "Head of Security", "Captain", "Chief Engineer", "Research Director", "Chief Medical Officer", "Executive Officer", "Operations Manager")
	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Investigator")
	feedback_tag = "cult_objective"
	antag_indicator = "cult"
	welcome_text = "You have a talisman in your possession; one that will help you start the cult on this vessel. Use it well and remember - there are others."
	antag_sound = 'sound/effects/antag_notice/cult_alert.ogg'
	victory_text = "The cult wins! It has succeeded in serving its dark masters!"
	loss_text = "The staff managed to stop the cult!"
	victory_feedback_tag = "win - cult win"
	loss_feedback_tag = "loss - staff stopped the cult"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 6
	initial_spawn_req = 4
	initial_spawn_target = 6
	antaghud_indicator = "hudcultist"
	required_age = 10

	faction = "cult"

	var/allow_narsie = 1
	var/datum/mind/sacrifice_target
	var/list/sacrificed = list()
	var/list/harvested = list()

/datum/antagonist/cultist/New()
	..()
	cult = src

/datum/antagonist/cultist/create_global_objectives()

	if(!..())
		return

	global_objectives = list()
	if(prob(50))
		global_objectives |= new /datum/objective/cult/survive
	else
		global_objectives |= new /datum/objective/cult/eldergod

	var/datum/objective/cult/sacrifice/sacrifice = new()
	sacrifice.find_target()
	sacrifice_target = sacrifice.target
	global_objectives |= sacrifice

/datum/antagonist/cultist/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	var/obj/item/book/tome/T = new(get_turf(player))
	var/list/slots = list(slot_in_backpack, slot_l_store, slot_r_store, slot_belt, slot_l_hand, slot_r_hand)
	player.equip_in_one_of_slots(T, slots, disable_warning = TRUE)

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	to_chat(player.current, "<span class='danger'>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</span>")
	player.memory = ""
	if(show_message)
		player.current.visible_message("<FONT size = 3>[player.current] looks like they just reverted to their old faith!</FONT>")
	if(. && player.current && !istype(player.current, /mob/living/simple_animal/construct))
		player.current.remove_language(LANGUAGE_CULT)
		player.current.remove_language(LANGUAGE_OCCULT)

/datum/antagonist/cultist/add_antagonist(var/datum/mind/player)
	. = ..()
	if(.)
		to_chat(player, "You catch a glimpse of the Realm of Nar-Sie, the Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of That Which Waits. Assist your new compatriots in their dark dealings. Their goals are yours, and yours are theirs. You serve the Dark One above all else. Bring It back.")
		if(player.current && !istype(player.current, /mob/living/simple_animal/construct))
			player.current.add_language(LANGUAGE_CULT)
			player.current.add_language(LANGUAGE_OCCULT)
			player.current.verbs |= /datum/antagonist/cultist/proc/appraise_offering
			player.current.verbs |= /datum/cultist/proc/memorize_rune
			player.current.verbs |= /datum/cultist/proc/forget_rune
			player.current.verbs |= /datum/cultist/proc/scribe_rune
			player.antag_datums[MODE_CULTIST] = new /datum/cultist()


/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player)
	. = ..()

	player.current.verbs -= /datum/antagonist/cultist/proc/appraise_offering
	player.current.verbs -= /datum/cultist/proc/memorize_rune
	player.current.verbs -= /datum/cultist/proc/forget_rune
	player.current.verbs -= /datum/cultist/proc/scribe_rune

/datum/antagonist/cultist/can_become_antag(var/datum/mind/player, ignore_role = 1)
	if(!..())
		return FALSE
	for(var/obj/item/implant/mindshield/L in player.current)
		if(L?.imp_in == player.current)
			return FALSE
	return TRUE

/datum/antagonist/cultist/proc/appraise_offering()
	set name = "Appraise Offering"
	set desc = "Find out if someone close-by can be converted to join the cult, or not."
	set category = "Cultist"

	var/list/targets = list()
	for(var/mob/living/carbon/target in view(5, usr))
		targets |= target
	targets -= usr

	var/mob/living/carbon/target = input(usr,"Who do you believe may be a worthy offering?") as null|anything in targets
	if(!istype(target))
		return

	if(!cult.can_become_antag(target.mind) || jobban_isbanned(target, "cultist") || player_is_antag(target.mind))
		to_chat(usr, SPAN_CULT("You get the sense that [target] would be an unworthy offering."))
	else
		to_chat(usr, SPAN_CULT("You get the sense that your master would be pleased to welcome [target] into the cult."))

/datum/antagonist/cultist/is_obvious_antag(datum/mind/player)
	if(istype(player.current, /mob/living/simple_animal/construct))
		return TRUE
	else if(istype(player.current, /mob/living/simple_animal/shade))
		return TRUE
	return FALSE
