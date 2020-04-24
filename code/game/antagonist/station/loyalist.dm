var/datum/antagonist/loyalists/loyalists

/datum/antagonist/loyalists
	id = MODE_LOYALIST
	role_text = "Head Fellow"
	role_text_plural = "The Fellowship"
	bantype = "loyalist"
	feedback_tag = "loyalist_objective"
	antag_indicator = "fellowshiphead"
	welcome_text = "You are one of the Fellowship leaders! Your goal is your choosing but you are a subversion of the Aurora Crew, you must lead your branch of the Fellowship and progress a story. <b>Use the uplink disguised as a station-bounced radio in your backpack to help start your story!</b>"
	victory_text = "The Contendors failed in their goals! You won!"
	loss_text = "The Contendors put an end to your Fellowship is one fell swoop."
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	antaghud_indicator = "fellowship"
	flags = 0

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	// Inround loyalists.
	faction_role_text = "Fellow"
	faction_descriptor = "Fellowship"
	faction_verb = /mob/living/proc/convert_to_loyalist
	faction_welcome = "You have joined a budding fellowship under the forward-thinking lead of a Fellowship leader. Follow their instructions and try to achieve the Fellowships goals."
	faction_indicator = "loyal"
	faction_invisible = 1

	restricted_jobs = list("AI", "Cyborg")
	required_age = 31

/datum/antagonist/loyalists/New()
	..()
	loyalists = src

/datum/antagonist/loyalists/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(!player.mind || player.stat==2 || !(player.mind.assigned_role in command_positions))
			continue
		var/datum/objective/protect/loyal_obj = new
		loyal_obj.target = player.mind
		loyal_obj.explanation_text = "Protect [player.real_name], the [player.mind.assigned_role]."
		global_objectives += loyal_obj

/datum/antagonist/loyalists/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.equip_to_slot_or_del(new /obj/item/device/announcer(player), slot_in_backpack)
	return 1
