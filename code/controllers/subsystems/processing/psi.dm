var/global/list/psychic_ranks_to_strings = list("Psionically Sensitive", "Psionically Harmonious", "Psionic Apex", "Limitless")

PROCESSING_SUBSYSTEM_DEF(psi)
	name = "Psionics"
	priority = SS_PRIORITY_PSYCHICS
	flags = SS_BACKGROUND | SS_NO_INIT

	var/checking_nlom = FALSE
	var/last_nlom_awareness_check = 0
	var/completing_nlom = FALSE
	var/complete_nlom_time = 0
	var/list/nlom_votes = list()
	var/list/nlom_voters = list()
	var/list/all_aura_images = list()
	var/list/all_psi_complexes = list()

/datum/controller/subsystem/processing/psi/fire(resumed)
	..()
	if((world.time >= (last_nlom_awareness_check + 30 MINUTES)) && !checking_nlom && !completing_nlom)
		checking_nlom = TRUE
		nlom_votes = list(
			"Calm" = 0,
			"Happy" = 0,
			"Sad" = 0,
			"Fearful" = 0,
			"Angry" = 0,
			"Stressed" = 0,
			"Confused" = 0
		)
		for(var/datum/psi_complexus/PC in all_psi_complexes)
			if(PC.psionic_rank >= PSI_RANK_SENSITIVE)
				to_chat(PC.owner, SPAN_NOTICE(FONT_HUGE("The Nlom field prompts you for your emotional state.")))
				to_chat(PC.owner,
						"<a href='?src=\ref[src];emotion=Calm;voter=[ref(PC)]'>Calm</a> | <a href='?src=\ref[src];emotion=Happy;voter=[ref(PC)]'>Happy</a> | \
						<a href='?src=\ref[src];emotion=Sad;voter=[ref(PC)]'>Sad</a> | <a href='?src=\ref[src];emotion=Fearful;voter=[ref(PC)]'>Fearful</a> | \
						<a href='?src=\ref[src];emotion=Angry;voter=[ref(PC)]'>Angry</a> | <a href='?src=\ref[src];emotion=Stressed;voter=[ref(PC)]'>Stressed</a> | \
						<a href='?src=\ref[src];emotion=Confused;voter=[ref(PC)]'>Confused</a")
		complete_nlom_time = world.time + 2 MINUTES
		completing_nlom = TRUE
	if(completing_nlom && world.time >= complete_nlom_time)
		var/highest_emotion = "Calm"
		for(var/emotion in nlom_votes)
			if(nlom_votes[emotion] > nlom_votes[highest_emotion])
				highest_emotion = emotion
		for(var/datum/psi_complexus/PC in all_psi_complexes)
			if(PC.psionic_rank >= PSI_RANK_SENSITIVE)
				var/static/nlom_to_span = list(
					"Calm" = "good",
					"Happy" = "good",
					"Sad" = "notice",
					"Fearful" = "alien",
					"Angry" = "danger",
					"Stressed" = "warning",
					"Confused" = "cult"
				)
				var/static/nlom_to_chat_text = list(
					"Calm" = "calmness",
					"Happy" = "happiness",
					"Sad" = "sadness",
					"Fearful" = "fear",
					"Angry" = "anger",
					"Stressed" = "stress",
					"Confused" = "confusion"
				)
				if(nlom_votes[highest_emotion] > 0)
					to_chat(PC.owner, SPAN_NOTICE(FONT_HUGE("A sense of <b><span class='[nlom_to_span[highest_emotion]]'>[nlom_to_chat_text[highest_emotion]]</span></b> washes over you.")))
				else
					to_chat(PC.owner, SPAN_WARNING(FONT_HUGE("The Nlom is silent and still. You feel uneasy.")))
			checking_nlom = FALSE
			completing_nlom = FALSE
			last_nlom_awareness_check = world.time
			nlom_votes.Cut()
			nlom_voters.Cut()

/datum/controller/subsystem/processing/psi/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["emotion"])
		var/emotion = href_list["emotion"]
		var/datum/psi_complexus/PC = locate(href_list["voter"])
		if(PC in nlom_voters)
			to_chat(PC.owner, SPAN_WARNING("You have already sent your emotional state to the Nlom."))
			return
		if(emotion in nlom_votes)
			var/base_vote = 1
			var/psi_rank = PC.get_rank()
			if(psi_rank == PSI_RANK_HARMONIOUS)
				base_vote = 2
			else if(psi_rank == PSI_RANK_APEX)
				base_vote = 4
			nlom_votes[emotion] += base_vote
			to_chat(PC.owner, SPAN_NOTICE("You have transmitted your emotional state to the Nlom."))
			nlom_voters |= PC
